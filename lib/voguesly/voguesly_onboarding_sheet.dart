import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import 'voguesly_api.dart';
import 'voguesly_auth.dart';
import 'voguesly_subscription.dart';

/// 网页套餐页(免费测试 + ¥3.9 验证包均在此购买/查看)。
const String _kPlanUrl = 'https://cp.voguesly.com/#/plan';

/// 全新用户引导:登入但未有套餐时弹出。
/// 可领免费测试 → app 内一键开通(call /user/trial/apply)+自动导入订阅;
/// 已领过 → 引导去网页购买 ¥3.9 验证包。
Future<void> showVogueslyOnboarding(BuildContext context) {
  return showSheet(
    context: context,
    builder: (_) => const AdaptiveSheetScaffold(
      body: _OnboardingBody(),
      title: '开始你的测试',
    ),
  );
}

class _OnboardingBody extends ConsumerStatefulWidget {
  const _OnboardingBody();

  @override
  ConsumerState<_OnboardingBody> createState() => _OnboardingBodyState();
}

class _OnboardingBodyState extends ConsumerState<_OnboardingBody> {
  VogueslyTrialStatus? _status;
  bool _loadingStatus = true;
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchStatus();
  }

  Future<void> _fetchStatus() async {
    final token = ref.read(vogueslyAuthProvider).token;
    if (token == null) {
      if (mounted) setState(() => _loadingStatus = false);
      return;
    }
    final status = await ref.read(vogueslyApiProvider).getTrialStatus(token);
    if (!mounted) return;
    setState(() {
      _status = status;
      _loadingStatus = false;
    });
  }

  /// 一键开通免费测试 → 导入订阅 → 关闭引导。
  Future<void> _applyTrial() async {
    final token = ref.read(vogueslyAuthProvider).token;
    if (token == null) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    final res = await ref.read(vogueslyApiProvider).applyTrial(token);
    if (!mounted) return;
    if (!res.ok) {
      setState(() {
        _busy = false;
        _error = res.message;
      });
      // 后端可能因「已有套餐」拒绝 → 仍尝试导入一次现有订阅
      if (res.message.contains('已有')) await _subscribeAndClose();
      return;
    }
    await _subscribeAndClose();
  }

  /// 已有套餐(或刚开通)→ 拉订阅导入 → 关闭。
  Future<void> _subscribeAndClose() async {
    await ref.read(vogueslyAuthProvider.notifier).refreshUser();
    final ok = await importVogueslySubscription(ref);
    if (!mounted) return;
    setState(() => _busy = false);
    if (ok) {
      Navigator.of(context).pop();
      globalState.showNotifier('✅ 已开通,点中间圆圈即可连接');
    } else {
      setState(() => _error = '订阅导入失败,请稍后在「更新订阅」重试');
    }
  }

  Future<void> _openPlanWeb() async {
    await launchUrl(Uri.parse(_kPlanUrl), mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;
    final status = _status;
    final canTrial = status?.eligible ?? false;
    final hasPaid = status?.hasActivePaidPlan ?? false;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            hasPaid
                ? '你已有套餐'
                : canTrial
                    ? '先免费体验,或购买验证包做完整测试'
                    : '购买验证包开始完整测试',
            style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: 20),
          if (_loadingStatus)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(child: CircularProgressIndicator()),
            )
          else ...[
            // 已有套餐:直接一键订阅
            if (hasPaid)
              _PrimaryOption(
                icon: Icons.bolt_rounded,
                title: '立即一键订阅',
                subtitle: '把你的套餐节点导入并开始使用',
                busy: _busy,
                onTap: _busy ? null : _subscribeAndClose,
              )
            // 可领免费测试:app 内一键开通
            else if (canTrial) ...[
              _PrimaryOption(
                icon: Icons.rocket_launch_rounded,
                title: '立即开通免费测试',
                subtitle: '6 小时 / 500MB,适合快速验证连通性',
                busy: _busy,
                onTap: _busy ? null : _applyTrial,
              ),
              const SizedBox(height: 12),
              _SecondaryOption(
                label: '已领过?购买 ¥3.9 验证包 · 3GB 不限时',
                onTap: _busy ? null : _openPlanWeb,
              ),
            ]
            // 已领过免费测试:引导购买
            else ...[
              _PrimaryOption(
                icon: Icons.shopping_cart_rounded,
                title: '购买 ¥3.9 验证包',
                subtitle: '3GB 不限时,适合完整验证 ChatGPT / Claude 等场景',
                busy: false,
                onTap: _busy ? null : _openPlanWeb,
              ),
              const SizedBox(height: 12),
              _SecondaryOption(
                label: '已购买?刷新订阅',
                onTap: _busy ? null : _subscribeAndClose,
              ),
            ],
            if (_error != null) ...[
              const SizedBox(height: 14),
              Text(
                _error!,
                style: tt.bodySmall?.copyWith(color: cs.error),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

class _PrimaryOption extends StatelessWidget {
  const _PrimaryOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.busy,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool busy;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;
    return Material(
      color: cs.primary,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              busy
                  ? SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: cs.onPrimary,
                      ),
                    )
                  : Icon(icon, color: cs.onPrimary, size: 28),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      busy ? '开通中...' : title,
                      style: tt.titleMedium?.copyWith(
                        color: cs.onPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: tt.bodySmall?.copyWith(
                        color: cs.onPrimary.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SecondaryOption extends StatelessWidget {
  const _SecondaryOption({required this.label, required this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: tt.bodyMedium?.copyWith(color: cs.onSurface),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
