import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../views/tools.dart' show showVogueslyFeedbackSheet;
import 'voguesly_auth.dart';
import 'voguesly_overlay.dart';

/// 易联 · 在线客服 = 内嵌**共享网页客服页**(app + 网页同一套 cs.html)。
///
/// ⚠️ 只覆盖**右边内容区**(半框,左侧栏保留可点,Sam 要求),由 app_manager 喺内容
/// Expanded 内 Positioned.fill 渲染(bounded 全填 → macOS webview 正常 compositing,唔会
/// 好似浮动小框咁全窗灰)。关闭经 JS channel `VogueslyCS`.postMessage('close')。
class VogueslyCsPanel extends ConsumerStatefulWidget {
  const VogueslyCsPanel({super.key});

  /// 兼容旧调用点(如「我的」联系客服):直接开半框客服。
  static void open(BuildContext context) {
    ProviderScope.containerOf(context, listen: false)
        .read(contentOverlayProvider.notifier)
        .set(ContentOverlay.cs);
  }

  @override
  ConsumerState<VogueslyCsPanel> createState() => _VogueslyCsPanelState();
}

class _VogueslyCsPanelState extends ConsumerState<VogueslyCsPanel> {
  WebViewController? _ctrl;

  @override
  void initState() {
    super.initState();
    final email = ref.read(vogueslyAuthProvider).user?.email ?? '';
    final url = Uri.parse('https://cs-sg.syk.ccwu.cc/cs.html').replace(
      queryParameters: {'embed': '1', if (email.isNotEmpty) 'email': email},
    );
    _ctrl = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel('VogueslyCS', onMessageReceived: (m) {
        if (m.message == 'close') {
          ref.read(contentOverlayProvider.notifier).close();
        } else if (m.message == 'feedback') {
          // 客服页「上传诊断日志」→ 开 app 的反馈/上传日志表单(带设备+近期日志)。
          if (mounted) showVogueslyFeedbackSheet(context);
        } else if (m.message.startsWith('open:')) {
          // 客服页外链(教程 ylink.im/#/docs、下载 dl.ylink.im)开外部浏览器。
          final uri = Uri.tryParse(m.message.substring(5));
          if (uri != null) launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      })
      ..loadRequest(url);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: _ctrl == null
          ? const Center(child: CircularProgressIndicator())
          : WebViewWidget(controller: _ctrl!),
    );
  }
}
