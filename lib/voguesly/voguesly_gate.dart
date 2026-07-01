import 'package:fl_clash/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../pages/pages.dart';
import 'voguesly_api.dart';
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
  // 本次进入已登录态是否经由「持久化恢复」(同账号),用于决定要唔要重导订阅。
  bool _sawRestoring = false;

  // 现役域名订阅(kVogueslyHosts.first 嘅 host)。旧域名(cp.voguesly.com 等已弃用)嘅 profile
  // 唔算,令旧安装升级后强制重导迁到新域名,唔会 restore-skip 继续用旧坏订阅。
  bool get _hasCurrentDomainProfile {
    final host = Uri.parse(kVogueslyHosts.first).host; // cp.samseah.qzz.io
    return ref.read(profilesProvider).any((p) => p.url.contains(host));
  }

  /// 登录后确保订阅就绪。
  /// - 持久化恢复 且 已有订阅 且 **owner token == 当前账号** → 直接用,唔重载(慳 China→HK 十几秒)。
  ///   套餐卡由 auth 恢复时嘅 refreshUser 后台填充;节点过期有 20min 自动更新兜底。
  /// - 否则(全新登录 / 换账号 / owner 失配 / 缺 owner) → 删走旧订阅 + 重导,防串号。
  Future<void> _ensureSubscription({required bool restored}) async {
    if (_importTried) return;
    _importTried = true;
    // ⚠️ 必须校验 owner:只「有 voguesly profile」唔够 —— 磁盘 profile 同当前 token 之间冇身份绑定,
    // 单凭存在就 skip 会令 B 账号复用 A 账号订阅(串号)。
    if (restored &&
        _hasCurrentDomainProfile &&
        await vogueslyProfileOwnedByCurrentToken()) {
      return; // 确属同账号 + 现役域名订阅,免重载
    }
    final ok = await importVogueslySubscription();
    // 导入失败(网络)→ 复位守卫,令下次 rebuild(如 resume/网络恢复/重测)可自动重导,
    // 唔会一次失败就永久停喺空订阅。失败态由 vogueslyImportFailedProvider 反映到连接圈。
    if (!ok) _importTried = false;
  }

  @override
  Widget build(BuildContext context) {
    final status =
        ref.watch(vogueslyAuthProvider.select((s) => s.status));
    // 启动恢复登录态期间显示 splash,唔好闪一下登录页(有持久化 token 嘅用户)。
    if (status == VogueslyAuthStatus.restoring) {
      _sawRestoring = true;
      return const _VogueslySplash();
    }
    if (status != VogueslyAuthStatus.loggedIn) {
      _importTried = false;
      _sawRestoring = false; // 经登录页 = 全新登录,要重导
      return const VogueslyLoginPage();
    }
    final restored = _sawRestoring;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ensureSubscription(restored: restored);
    });
    return const HomePage();
  }
}

/// 启动恢复登录态时嘅过渡画面(通常一闪即过)。
class _VogueslySplash extends StatelessWidget {
  const _VogueslySplash();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
