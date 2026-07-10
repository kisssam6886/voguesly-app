import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'voguesly_api.dart';
import 'voguesly_auth.dart';
import 'voguesly_payment.dart';
import 'voguesly_subscription.dart';
import 'voguesly_ui.dart';
import 'voguesly_user_center.dart'; // VogueslyOrdersPage(我的订单入口)

/// 易联 · 原生商城页(照 NinjaDesktop 做法:全原生直调 XBoard API,唔用 webview)。
///
/// 流程:plan/fetch 列套餐 → 点套餐弹「选周期」原生弹窗 → 点周期立即购买 →
///      order/save 下单 → 弹「选支付方式」原生弹窗 → order/checkout
///      (余额直扣 / 跳外部支付宝-微信 + 后台 order/check 轮询到账)。
/// 只有最后真支付先跳外部浏览器,前面全部内嵌原生。
class VogueslyShopPage extends ConsumerStatefulWidget {
  const VogueslyShopPage({super.key});

  static void open(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const VogueslyShopPage()),
    );
  }

  @override
  ConsumerState<VogueslyShopPage> createState() => _VogueslyShopPageState();
}

class _VogueslyShopPageState extends ConsumerState<VogueslyShopPage> {
  bool _loading = true;
  String? _error;
  List<VogueslyPlan> _plans = const [];
  int _balanceCents = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final token = ref.read(vogueslyAuthProvider).token;
    if (token == null || token.isEmpty) {
      setState(() {
        _loading = false;
        _error = '未登录,请先登录';
      });
      return;
    }
    final api = ref.read(vogueslyApiProvider);
    try {
      final results = await Future.wait([
        api.fetchPlans(token),
        api.fetchBalanceCents(token),
      ]);
      if (!mounted) return;
      final plans = results[0] as List<VogueslyPlan>;
      final bal = results[1] as int?;
      setState(() {
        _plans = plans;
        _balanceCents = bal ?? 0;
        _loading = false;
        _error = plans.isEmpty ? '暂无可购买套餐,或网络异常,请下拉重试' : null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = '加载失败:$e';
      });
    }
  }

  String get _balanceText => '¥${(_balanceCents / 100).toStringAsFixed(2)}';

  void _toast(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: vogAppBar(
        context,
        title: '商城',
        actions: [
          IconButton(
            tooltip: '刷新',
            icon: const Icon(Icons.refresh),
            onPressed: _loading ? null : _load,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
          children: [
            // 余额卡
            Card(
              color: cs.primary.withValues(alpha: 0.08),
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                child: Row(
                  children: [
                    Icon(Icons.account_balance_wallet_outlined,
                        color: cs.primary),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('账户余额',
                            style: Theme.of(context).textTheme.bodySmall),
                        const SizedBox(height: 2),
                        Text(_balanceText,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                    color: cs.primary,
                                    fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const Spacer(),
                    Text('管理余额和套餐',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: cs.onSurfaceVariant.withValues(alpha: 0.7))),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            // 我的订单入口(Sam:支付唔成功唔使去 设置→用户中心 咁远揾,商城顶直接入,继续付)。
            Card(
              elevation: 0,
              color: cs.surfaceContainerHighest.withValues(alpha: 0.4),
              child: ListTile(
                leading: Icon(Icons.receipt_long_outlined, color: cs.primary),
                title: const Text('我的订单'),
                subtitle: const Text('查看订单 · 继续未完成的支付'),
                trailing: const Icon(Icons.chevron_right, size: 20),
                onTap: () => VogueslyOrdersPage.open(context),
              ),
            ),
            const SizedBox(height: 18),
            Text('套餐',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            if (_loading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 60),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_error != null && _plans.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 48),
                child: Center(
                  child: Column(
                    children: [
                      const Icon(Icons.inbox_outlined, size: 40),
                      const SizedBox(height: 10),
                      Text(_error!, textAlign: TextAlign.center),
                    ],
                  ),
                ),
              )
            else
              // 响应式:窄屏一列,宽屏两列自适应(桌面窗口够宽时并排)。
              LayoutBuilder(
                builder: (ctx, c) {
                  final cols = c.maxWidth >= 760 ? 2 : 1;
                  const gap = 14.0;
                  final w = (c.maxWidth - gap * (cols - 1)) / cols;
                  return Wrap(
                    spacing: gap,
                    runSpacing: gap,
                    children: _plans
                        .map((p) => SizedBox(width: w, child: _planCard(p)))
                        .toList(),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  /// 套餐卖点副标题:取后端 plan.content(信任锚 + 一句卖点)去 HTML 标签后,
  /// 保留前几行做简洁副标题。空则返 null(唔占位)。
  String? _planSubtitle(VogueslyPlan p) {
    final raw = p.content;
    if (raw == null || raw.trim().isEmpty) return null;
    // 块级/换行标签 → 换行,再剥其余标签,解常见实体。
    final text = raw
        .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'</(p|div|li)>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'<[^>]+>'), '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>');
    final lines = text
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    if (lines.isEmpty) return null;
    // 最多两行(信任锚 + 卖点),避免卡片过长。
    return lines.take(2).join('\n');
  }

  Widget _tag(String text) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: Theme.of(context).textTheme.labelSmall),
    );
  }

  Widget _planCard(VogueslyPlan p) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _openPlanSheet(p),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(p.name,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
              // 卖点副标题(后端 plan.content:🏠 住宅IP · 🧠 直连 · 🔒 纯净 + 卖点)。
              if (_planSubtitle(p) case final sub?) ...[
                const SizedBox(height: 6),
                Text(sub,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: cs.onSurfaceVariant, height: 1.35)),
              ],
              const SizedBox(height: 6),
              Text('${p.periods.length} 个周期可选',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant.withValues(alpha: 0.7))),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _tag('流量 ${p.transferEnableGb} GB'),
                  if (p.speedLimit != null && p.speedLimit! > 0)
                    _tag('限速 ${p.speedLimit} Mbps'),
                  _tag(p.periods.first.durationText == '一次性'
                      ? '一次性'
                      : '时长 ${p.periods.first.durationText}'),
                ],
              ),
              const SizedBox(height: 14),
              Text(p.priceRangeText,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: cs.primary, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => _openPlanSheet(p),
                  icon: const Icon(Icons.shopping_cart_outlined, size: 18),
                  label: const Text('立即购买'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---- 弹窗 1:选周期 ----
  void _openPlanSheet(VogueslyPlan p) {
    final cs = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(p.name,
                  style: Theme.of(ctx)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text('选择购买周期',
                  style: Theme.of(ctx).textTheme.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant.withValues(alpha: 0.7))),
              const SizedBox(height: 14),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: p.periods
                        .map((period) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: _periodCard(p, period),
                            ))
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _periodCard(VogueslyPlan p, VogueslyPlanPeriod period) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      margin: EdgeInsets.zero,
      color: cs.surfaceContainerHigh,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(period.label,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const Spacer(),
                Text(period.priceText,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: cs.primary, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _tag('流量 ${p.transferEnableGb} GB'),
                if (period.days > 0) _tag('时长 ${period.durationText}'),
                if (p.speedLimit != null && p.speedLimit! > 0)
                  _tag('限速 ${p.speedLimit} Mbps'),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => _placeOrder(p, period),
                child: Text('立即购买 ${period.priceText}'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---- 下单 → 弹窗 2:选支付方式 ----
  Future<void> _placeOrder(VogueslyPlan p, VogueslyPlanPeriod period) async {
    final token = ref.read(vogueslyAuthProvider).token;
    if (token == null || token.isEmpty) {
      _toast('未登录');
      return;
    }
    Navigator.of(context).pop(); // 关周期弹窗
    _showBlockingProgress('正在下单…');
    final api = ref.read(vogueslyApiProvider);
    final order = await api.createOrder(token,
        planId: p.id, period: period.key);
    if (mounted) Navigator.of(context, rootNavigator: true).pop(); // 关进度
    if (order.tradeNo == null) {
      _toast(order.error ?? '下单失败');
      return;
    }
    if (!mounted) return;
    // 共享支付流程(同「我的订单·继续支付」一套)。
    await VogueslyPayment.present(
      context: context,
      ref: ref,
      tradeNo: order.tradeNo!,
      priceCents: period.priceCents,
      title: '${p.name} · ${period.label}  ${period.priceText}',
      onPaid: _afterPaid,
    );
  }

  // 支付成功后:刷新账号套餐 + 重导订阅(拉最新节点)+ 刷新商城余额,然后返回主页。
  Future<void> _afterPaid() async {
    try {
      await ref.read(vogueslyAuthProvider.notifier).refreshUser();
    } catch (_) {}
    try {
      // 新套餐/续费后订阅节点会变,重导一次(内部并发互斥,安全)。
      await importVogueslySubscription();
    } catch (_) {}
    if (!mounted) return;
    await _load();
    if (mounted) Navigator.of(context).maybePop();
  }

  void _showBlockingProgress(String msg) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        content: Row(
          children: [
            const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2.5)),
            const SizedBox(width: 18),
            Expanded(child: Text(msg)),
          ],
        ),
      ),
    );
  }
}
