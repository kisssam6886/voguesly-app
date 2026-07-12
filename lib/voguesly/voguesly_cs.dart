import 'dart:io';

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

/// Windows/Linux 走**系统默认浏览器**打开客服页。
/// webview_flutter 冇桌面(Win/Linux)实现;desktop_webview_window(WebView2)在部分 Windows
/// 会 **native crash 令整个 app 闪退**(Dart try/catch 兜唔住 native 崩),为上线可靠先回退外部
/// 浏览器(pre-0.9.49 行为,稳定不崩)。内嵌待有 Windows 调试环境再做。macOS 有 WKWebView,
/// 保留左侧栏半框 overlay(体验更好)。
bool get _csUseExternalBrowser =>
    !kIsWeb && (Platform.isWindows || Platform.isLinux);

/// 用系统默认浏览器打开客服页(桌面 Win/Linux)。全程 try/catch 防崩;
/// 失败弹 toast,唔会令点击「无反应」或崩溃。
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
/// Windows/Linux 冇 webview 桌面实现,`open()` 会改行系统浏览器,唔会创建本 widget。
class VogueslyCsPanel extends ConsumerStatefulWidget {
  const VogueslyCsPanel({super.key});

  /// 开客服。桌面 Win/Linux → 系统浏览器(webview 冇实现/会崩,内嵌另议);
  /// 手机端(无 overlay 宿主)→ 全页 push webview;桌面 macOS → 半框 overlay(左侧栏保留可点)。
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
  WebViewController? _ctrl;

  @override
  void initState() {
    super.initState();
    // 防御:即使有其它调用点误喺 Win/Linux 渲染本 widget,亦唔创建 webview(会崩),
    // 改行外部浏览器 + 显示回退卡(下方 build)。
    if (_csUseExternalBrowser) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _launchCsExternal(ProviderScope.containerOf(context, listen: false));
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
    // Win/Linux 或 webview 初始化失败:显示回退卡(可再次点开浏览器),唔崩。
    if (_csUseExternalBrowser || _ctrl == null) {
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
                const Text('在线客服已在浏览器中打开', textAlign: TextAlign.center),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () => _launchCsExternal(
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
