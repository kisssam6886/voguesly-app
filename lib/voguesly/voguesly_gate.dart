import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../pages/pages.dart';
import 'voguesly_auth.dart';
import 'voguesly_login_page.dart';
import 'voguesly_subscription.dart';

/// 登录门: 未登录 -> 登录页; 已登录 -> 自动导入订阅 + 进主界面。
/// 替换 application.dart 原本的 `const HomePage()`。
class VogueslyGate extends ConsumerStatefulWidget {
  const VogueslyGate({super.key});

  @override
  ConsumerState<VogueslyGate> createState() => _VogueslyGateState();
}

class _VogueslyGateState extends ConsumerState<VogueslyGate> {
  bool _importTried = false;

  /// 登录后自动拉订阅 + 导入(每次登录都做)。
  /// 关键：先删走上一个账号导入的 voguesly 订阅，再导入当前账号并强制设为活动 profile，
  /// 否则 FlClash 的 putProfile 只在「当前无活动 profile」时才切换，会令新账号继续用旧账号订阅(账号串号)。
  Future<void> _ensureSubscription() async {
    if (_importTried) return;
    _importTried = true;
    // 导入逻辑抽到 importVogueslySubscription(免费测试开通后亦复用)。
    await importVogueslySubscription(ref);
  }

  @override
  Widget build(BuildContext context) {
    final loggedIn =
        ref.watch(vogueslyAuthProvider.select((s) => s.isLoggedIn));
    if (!loggedIn) {
      _importTried = false;
      return const VogueslyLoginPage();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ensureSubscription();
    });
    return const HomePage();
  }
}
