import 'dart:io';

import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

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

/// Windows/Linux 走**桌面内嵌 webview 窗口**(desktop_webview_window / WebView2)。
/// webview_flutter **冇桌面(Win/Linux)实现**(windows generated_plugins 只有
/// desktop_webview_window + url_launcher_windows,冇 webview_flutter_windows),
/// widget 内嵌 WebViewController() 会喺运行时抛异常。改用 desktop_webview_window
/// 起一个 app 自己的 WebView2 窗口(唔踢去外部浏览器,Sam 要求「内嵌接手回来」)。
/// macOS 有 WKWebView 实现,保留左侧栏半框 overlay(体验更好),唔行本路径。
bool get _csUseDesktopWebview =>
    !kIsWeb && (Platform.isWindows || Platform.isLinux);

/// 单实例:已开就 bringToForeground,唔重复起窗。
Webview? _desktopCsWebview;

/// JS 桥:cs.html 用 `window.VogueslyCS.postMessage(...)`,桌面 webview 冇呢个对象,
/// 注入 shim 路由到底层 web message channel(WebView2=chrome.webview / WebKit=messageHandlers)。
const String _kCsBridgeJs = r'''
(function(){
  function send(m){
    try{ if(window.chrome && window.chrome.webview && window.chrome.webview.postMessage){ window.chrome.webview.postMessage(String(m)); return; } }catch(e){}
    try{ if(window.webkit && window.webkit.messageHandlers){ var h=window.webkit.messageHandlers; var k=h.VogueslyCS?'VogueslyCS':Object.keys(h)[0]; if(k){ h[k].postMessage(String(m)); return; } } }catch(e){}
  }
  window.VogueslyCS = { postMessage: function(m){ send(m); } };
})();
''';

/// 开桌面内嵌客服窗口(Win/Linux)。WebView2 不可用则回退系统浏览器,全程 try/catch 防崩。
Future<void> _openCsDesktopWebview(ProviderContainer container) async {
  final email = container.read(vogueslyAuthProvider).user?.email ?? '';
  try {
    // 已开 → 拉到前台,唔重复起窗。
    final existing = _desktopCsWebview;
    if (existing != null) {
      await existing.bringToForeground();
      return;
    }
    if (!await WebviewWindow.isWebviewAvailable()) {
      // 冇 WebView2 运行时(极少数旧 Win)→ 回退外部浏览器,唔卡死。
      await _launchCsExternal(container);
      return;
    }
    final webview = await WebviewWindow.create(
      configuration: CreateConfiguration(
        title: '易联 · 在线客服',
        windowWidth: 460,
        windowHeight: 720,
        titleBarTopPadding: Platform.isMacOS ? 24 : 0,
      ),
    );
    _desktopCsWebview = webview;
    webview.addScriptToExecuteOnDocumentCreated(_kCsBridgeJs);
    webview.addOnWebMessageReceivedCallback((raw) {
      // WebView2 可能连引号一齐带 → 去掉首尾引号。
      var m = raw.trim();
      if (m.length >= 2 && m.startsWith('"') && m.endsWith('"')) {
        m = m.substring(1, m.length - 1);
      }
      if (m == 'close') {
        webview.close();
      } else if (m == 'feedback') {
        final ctx = globalState.navigatorKey.currentContext;
        if (ctx != null) showVogueslyFeedbackSheet(ctx);
      } else if (m.startsWith('open:')) {
        final uri = Uri.tryParse(m.substring(5));
        if (uri != null) {
          launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      }
    });
    // 窗口关闭 → 清单实例引用,下次可重开。
    webview.onClose.whenComplete(() {
      if (identical(_desktopCsWebview, webview)) _desktopCsWebview = null;
    });
    webview.launch(_csUri(email, embed: true).toString());
  } catch (_) {
    _desktopCsWebview = null;
    // 内嵌 webview 起窗失败 → 回退外部浏览器,唔令点击「无反应」或崩溃。
    await _launchCsExternal(container);
  }
}

/// 用系统默认浏览器打开客服页(桌面内嵌 webview 不可用时的回退)。
Future<void> _launchCsExternal(ProviderContainer container) async {
  try {
    final email = container.read(vogueslyAuthProvider).user?.email ?? '';
    final ok = await launchUrl(
      _csUri(email, embed: false),
      mode: LaunchMode.externalApplication,
    );
    if (!ok) {
      globalState.showNotifier('打不开客服,请手动访问客服页');
    }
  } catch (_) {
    globalState.showNotifier('打开客服失败,请稍后重试');
  }
}

/// 易联 · 在线客服 = 内嵌**共享网页客服页**(app + 网页同一套 cs.html)。
///
/// ⚠️ macOS 只覆盖**右边内容区**(半框,左侧栏保留可点,Sam 要求),由 app_manager 喺内容
/// Expanded 内 Positioned.fill 渲染。关闭经 JS channel `VogueslyCS`.postMessage('close')。
///
/// Windows/Linux 走 desktop_webview_window(WebView2)独立内嵌窗口,`open()` 直接起窗,
/// 唔创建本 widget。
class VogueslyCsPanel extends ConsumerStatefulWidget {
  const VogueslyCsPanel({super.key});

  /// 开客服。桌面 Win/Linux → desktop_webview_window 内嵌窗口(唔踢外部浏览器);
  /// 手机端(无 overlay 宿主)→ 全页 push webview;桌面 macOS → 半框 overlay(左侧栏保留可点)。
  static void open(BuildContext context) {
    final container = ProviderScope.containerOf(context, listen: false);
    if (_csUseDesktopWebview) {
      _openCsDesktopWebview(container);
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
  WebViewController? _ctrl;

  @override
  void initState() {
    super.initState();
    // 防御:即使有其它调用点误喺 Win/Linux 渲染本 widget,亦唔创建 webview_flutter(会崩),
    // 改行 desktop_webview_window 内嵌窗口 + 显示回退卡(下方 build)。
    if (_csUseDesktopWebview) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _openCsDesktopWebview(ProviderScope.containerOf(context, listen: false));
      });
      return;
    }
    try {
      final email = ref.read(vogueslyAuthProvider).user?.email ?? '';
      _ctrl = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..addJavaScriptChannel('VogueslyCS', onMessageReceived: (m) {
          if (m.message == 'close') {
            // 桌面 overlay 走 provider close;手机全页 push 走 Navigator.pop。
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              ref.read(contentOverlayProvider.notifier).close();
            }
          } else if (m.message == 'feedback') {
            // 客服页「上传诊断日志」→ 开 app 的反馈/上传日志表单(带设备+近期日志)。
            if (mounted) showVogueslyFeedbackSheet(context);
          } else if (m.message.startsWith('open:')) {
            // 客服页外链(教程 ylink.im/#/docs、下载 dl.ylink.im)开外部浏览器。
            final uri = Uri.tryParse(m.message.substring(5));
            if (uri != null) {
              launchUrl(uri, mode: LaunchMode.externalApplication);
            }
          }
        })
        ..loadRequest(_csUri(email, embed: true));
    } catch (_) {
      // 兜底:任何平台 webview 初始化异常都唔崩,交 build 显示回退卡。
      _ctrl = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Win/Linux 或 webview 初始化失败:显示回退卡(可再次点开内嵌窗口),唔崩。
    if (_csUseDesktopWebview || _ctrl == null) {
      return Container(
        color: Theme.of(context).colorScheme.surface,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.support_agent_outlined, size: 40),
                const SizedBox(height: 12),
                const Text('在线客服已打开', textAlign: TextAlign.center),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () => _openCsDesktopWebview(
                    ProviderScope.containerOf(context, listen: false),
                  ),
                  icon: const Icon(Icons.open_in_new, size: 18),
                  label: const Text('重新打开客服'),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: WebViewWidget(controller: _ctrl!),
    );
  }
}
