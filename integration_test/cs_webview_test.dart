// 在线客服 webview 端到端渲染测试(真 Windows 上跑)。
// 挂载真实 webview_windows 的 Webview widget → initialize() → 导航到线上 cs.html →
// 断言 loadingState 到达 navigationCompleted = 客服页在 WebView2 里真加载出来(非 fallback)。
// 这是「客服窗真渲染」的功能级铁证,跑在 CI 的 windows-latest(有 WebView2 Runtime)。
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:webview_windows/webview_windows.dart' as ww;

// 与 app 内 voguesly_cs.dart 同一套 cs.html(embed=1 = 内嵌模式)。
const String _csUrl = 'https://cs-sg.syk.ccwu.cc/cs.html?embed=1';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('CS webview renders cs.html on real Windows (navigationCompleted)',
      (tester) async {
    final controller = ww.WebviewController();

    // 订阅 loading 状态(在 loadUrl 之前),记录进度。
    final states = <ww.LoadingState>[];
    final navigated = Completer<bool>();
    final sub = controller.loadingState.listen((s) {
      states.add(s);
      debugPrint('CS_SELFTEST loadingState=$s');
      if (s == ww.LoadingState.navigationCompleted && !navigated.isCompleted) {
        navigated.complete(true);
      }
    });

    await controller.initialize();
    debugPrint('CS_SELFTEST initialized=${controller.value.isInitialized}');
    expect(controller.value.isInitialized, isTrue,
        reason: 'webview_windows initialize() failed on real Windows');

    // 挂载真实 Webview widget → 平台视图激活 + 消息泵运行,导航事件才会回来。
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(width: 800, height: 600, child: ww.Webview(controller)),
        ),
      ),
    );
    await tester.pump(const Duration(seconds: 1));

    await controller.loadUrl(_csUrl);

    // 泵事件循环等导航完成(最多 45s)。
    final deadline = DateTime.now().add(const Duration(seconds: 45));
    while (!navigated.isCompleted && DateTime.now().isBefore(deadline)) {
      await tester.pump(const Duration(milliseconds: 500));
    }

    debugPrint('CS_SELFTEST states=$states navigated=${navigated.isCompleted}');
    expect(navigated.isCompleted, isTrue,
        reason:
            'WebView2 navigationCompleted 未触发 —— cs.html 没在客服窗渲染出来 (states=$states)');
    debugPrint('CS_SELFTEST=PASS cs.html rendered in embedded WebView2');

    await sub.cancel();
    await controller.dispose();
  });
}
