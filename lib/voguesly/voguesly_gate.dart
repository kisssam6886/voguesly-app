import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../pages/pages.dart';
import '../providers/action.dart';
import 'voguesly_auth.dart';
import 'voguesly_login_page.dart';

/// 登录门: 未登录 -> 登录页; 已登录 -> 自动导入订阅 + 进主界面。
/// 替换 application.dart 原本的 `const HomePage()`。
class VogueslyGate extends ConsumerStatefulWidget {
  const VogueslyGate({super.key});

  @override
  ConsumerState<VogueslyGate> createState() => _VogueslyGateState();
}

class _VogueslyGateState extends ConsumerState<VogueslyGate> {
  bool _importTried = false;

  /// 登录后自动拉订阅 + 导入(只做一次)。复用已有的 addProfileFormURL。
  Future<void> _ensureSubscription() async {
    if (_importTried) return;
    _importTried = true;
    final url =
        await ref.read(vogueslyAuthProvider.notifier).fetchSubscribeUrl();
    if (!mounted) return;
    if (url != null && url.isNotEmpty) {
      await ref.read(profilesActionProvider.notifier).addProfileFormURL(url);
    }
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
