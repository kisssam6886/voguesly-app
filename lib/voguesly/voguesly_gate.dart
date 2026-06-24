import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fl_clash/providers/providers.dart';

import '../pages/pages.dart';
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

  /// 登录后自动拉订阅 + 导入(每次登录都做)。
  /// 关键：先删走上一个账号导入的 voguesly 订阅，再导入当前账号并强制设为活动 profile，
  /// 否则 FlClash 的 putProfile 只在「当前无活动 profile」时才切换，会令新账号继续用旧账号订阅(账号串号)。
  Future<void> _ensureSubscription() async {
    if (_importTried) return;
    _importTried = true;
    final url =
        await ref.read(vogueslyAuthProvider.notifier).fetchSubscribeUrl();
    if (!mounted || url == null || url.isEmpty) return;
    final action = ref.read(profilesActionProvider.notifier);
    // 删走之前账号导入的 voguesly 订阅，避免新账号继续用紧旧账号订阅
    final staleIds = ref
        .read(profilesProvider)
        .where((p) => p.url.contains('voguesly'))
        .map((p) => p.id)
        .toList();
    for (final id in staleIds) {
      await action.deleteProfile(id);
    }
    if (!mounted) return;
    // 导入当前账号订阅
    await action.addProfileFormURL(url);
    if (!mounted) return;
    // 强制把当前账号订阅设为活动 profile（防止旧 currentProfileId 残留）
    final imported =
        ref.read(profilesProvider).where((p) => p.url == url).toList();
    if (imported.isNotEmpty) {
      ref.read(currentProfileIdProvider.notifier).value = imported.last.id;
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
