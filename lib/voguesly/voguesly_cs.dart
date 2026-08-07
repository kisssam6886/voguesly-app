import 'dart:io';
import 'package:fl_clash/common/app_localizations.dart';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_windows/webview_windows.dart' as ww;

import '../state.dart' show globalState;
import '../views/tools.dart' show showVogueslyFeedbackSheet;
import 'voguesly_auth.dart';
import 'voguesly_overlay.dart';

/// 客服网页 host(app + 网页共用同一套 cs.html)。
const String _kCsHost = 'https://cs-sg.syk.ccwu.cc/cs.html';

/// 客服页 URL:embed=1 = app 内嵌模式(有关闭桥),embed=0 = 外部浏览器完整页。
Uri _csUri(String email, {required bool embed}) =>
    Uri.parse(_kCsHost).replace(queryParameters: {
      'embed': embed ? '1' : '0',
      if (email.isNotEmpty) 'email': email,
    });

/// 平台分流:
/// - macOS = webview_flutter(WKWebView)内嵌半框 overlay;
/// - **Windows = webview_windows(in-app 嵌入 WebView2 texture,同 overlay 一致)** ——
///   webview_flutter 无 Windows 实现;desktop_webview_window(独立窗)在部分 Windows native crash
///   (0.9.49 试过、0.9.50 revert)。webview_windows 把 WebView2 当 Flutter texture 嵌在内容区,
///   不开独立窗、不占浏览器 tab、更稳;初始化失败(WebView2 runtime 未装等)自动退外部浏览器,不崩。
/// - Linux = 系统浏览器(无成熟 in-app webview)。
bool get _csUseExternalBrowser => !kIsWeb && Platform.isLinux;
bool get _csUseWindowsWebview => !kIsWeb && Platform.isWindows;

/// 注入 VogueslyCS 桥 shim → cs.html/cs.js 原本的 `VogueslyCS.postMessage('close'|'feedback'|'open:…')`
/// 经 WebView2 postMessage 传回 app(webMessage 流),**无需改 cs.html**。
const String _kCsShim =
    'window.VogueslyCS={postMessage:function(m){try{window.chrome.webview.postMessage(String(m));}catch(e){}}};';

/// 用系统默认浏览器打开客服页(Linux 及 Windows WebView2 不可用时兜底)。全程 try/catch 防崩。
Future<void> _launchCsExternal(ProviderContainer container) async {
  try {
    final email = container.read(vogueslyAuthProvider).user?.email ?? '';
    final ok = await launchUrl(
      _csUri(email, embed: false),
      mode: LaunchMode.externalApplication,
    );
    if (!ok) {
      globalState.showNotifier(currentAppLocalizations.vgCannotOpenSupportManually);
    }
  } catch (_) {
    globalState.showNotifier(currentAppLocalizations.vgOpenSupportFailedRetry);
  }
}

/// 易联 · 在线客服 = 内嵌**共享网页客服页**(app + 网页同一套 cs.html)。
///
/// ⚠️ macOS/Windows 只覆盖**右边内容区**(半框,左侧栏保留可点,Sam 要求),由 app_manager 喺内容
/// Expanded 内 Positioned.fill 渲染。关闭经 `VogueslyCS`.postMessage('close')。
class VogueslyCsPanel extends ConsumerStatefulWidget {
  const VogueslyCsPanel({super.key});

  /// 开客服:Linux → 系统浏览器;手机 → 全页 push webview;桌面 macOS/Windows → 半框 overlay。
  static void open(BuildContext context) {
    final container = ProviderScope.containerOf(context, listen: false);
    if (_csUseExternalBrowser) {
      _launchCsExternal(container);
      return;
    }
    final w = MediaQuery.maybeOf(context)?.size.width ?? 0;
    final isMobile = w > 0 && w < 640;
    if (isMobile) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const VogueslyCsPanel()),
      );
      return;
    }
    container.read(contentOverlayProvider.notifier).set(ContentOverlay.cs);
  }

  @override
  ConsumerState<VogueslyCsPanel> createState() => _VogueslyCsPanelState();
}

class _VogueslyCsPanelState extends ConsumerState<VogueslyCsPanel> {
  WebViewController? _ctrl; // webview_flutter(macOS/mobile)
  ww.WebviewController? _winCtrl; // webview_windows(Windows)
  bool _winReady = false;
  bool _winFailed = false;

  @override
  void initState() {
    super.initState();
    if (_csUseExternalBrowser) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _launchCsExternal(ProviderScope.containerOf(context, listen: false));
      });
      return;
    }
    if (_csUseWindowsWebview) {
      _initWindowsWebview();
      return;
    }
    try {
      final email = ref.read(vogueslyAuthProvider).user?.email ?? '';
      _ctrl = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..addJavaScriptChannel('VogueslyCS', onMessageReceived: (m) {
          _handleCsMessage(m.message);
        })
        ..loadRequest(_csUri(email, embed: true));
    } catch (_) {
      // 任何平台 webview 初始化异常都唔崩,交 build 显示回退卡。
      _ctrl = null;
    }
  }

  /// Windows:in-app WebView2。注入 VogueslyCS shim + 监听 webMessage;
  /// 初始化失败(WebView2 runtime 未装等)→ 退外部浏览器,全程 try/catch 不崩。
  Future<void> _initWindowsWebview() async {
    try {
      final email = ref.read(vogueslyAuthProvider).user?.email ?? '';
      final c = ww.WebviewController();
      await c.initialize();
      await c.addScriptToExecuteOnDocumentCreated(_kCsShim);
      c.webMessage.listen((message) {
        _handleCsMessage(message is String ? message : message.toString());
      });
      await c.loadUrl(_csUri(email, embed: true).toString());
      if (!mounted) {
        await c.dispose();
        return;
      }
      setState(() {
        _winCtrl = c;
        _winReady = true;
      });
    } catch (_) {
      if (mounted) setState(() => _winFailed = true);
      _launchCsExternal(ProviderScope.containerOf(context, listen: false));
    }
  }

  void _handleCsMessage(String message) {
    if (message == 'close') {
      // 桌面 overlay 走 provider close;手机全页 push 走 Navigator.pop。
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      } else {
        ref.read(contentOverlayProvider.notifier).close();
      }
    } else if (message == 'feedback') {
      if (mounted) showVogueslyFeedbackSheet(context);
    } else if (message.startsWith('open:')) {
      final uri = Uri.tryParse(message.substring(5));
      if (uri != null) {
        launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }
  }

  @override
  void dispose() {
    _winCtrl?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final surface = Theme.of(context).colorScheme.surface;
    // Windows:WebView2 就绪 → 内嵌;初始化中 → loading;失败 → 回退卡(下方)。
    if (_csUseWindowsWebview && _winReady && _winCtrl != null) {
      return Container(color: surface, child: ww.Webview(_winCtrl!));
    }
    if (_csUseWindowsWebview && !_winFailed) {
      return Container(
        color: surface,
        child: const Center(child: CircularProgressIndicator()),
      );
    }
    // Linux / Windows WebView2 失败 / webview_flutter 初始化失败:回退卡,唔崩。
    if (_csUseExternalBrowser || _csUseWindowsWebview || _ctrl == null) {
      return Container(
        color: surface,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.support_agent_outlined, size: 40),
                const SizedBox(height: 12),
                Text(
                  _csUseWindowsWebview ? currentAppLocalizations.vgLiveChatUnavailableUseBrowser : currentAppLocalizations.vgLiveChatOpenedInBrowser,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () => _launchCsExternal(
                    ProviderScope.containerOf(context, listen: false),
                  ),
                  icon: const Icon(Icons.open_in_new, size: 18),
                  label: Text(currentAppLocalizations.vgOpenSupportInBrowser),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return Container(
      color: surface,
      child: WebViewWidget(controller: _ctrl!),
    );
  }
}
