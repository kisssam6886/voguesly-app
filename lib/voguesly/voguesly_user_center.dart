import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'voguesly_api.dart';
import 'voguesly_auth.dart';
import 'voguesly_invite.dart';
import 'voguesly_payment.dart';
import 'voguesly_shop.dart';
import 'voguesly_subscription.dart';
import 'voguesly_ui.dart';

/// 易联 · 原生用户中心(账号/套餐/余额 + 快捷操作,数据大多来自 vogueslyAuthProvider,免 webview 登录页)。
class VogueslyUserCenterPage extends ConsumerStatefulWidget {
  const VogueslyUserCenterPage({super.key});

  static void open(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const VogueslyUserCenterPage()),
    );
  }

  @override
  ConsumerState<VogueslyUserCenterPage> createState() =>
      _VogueslyUserCenterPageState();
}

class _VogueslyUserCenterPageState
    extends ConsumerState<VogueslyUserCenterPage> {
  int? _balanceCents;

  @override
  void initState() {
    super.initState();
    _loadBalance();
  }

  Future<void> _loadBalance() async {
    final token = ref.read(vogueslyAuthProvider).token;
    if (token == null) return;
    final bal = await ref.read(vogueslyApiProvider).fetchBalanceCents(token);
    if (mounted) setState(() => _balanceCents = bal);
  }

  String _gb(int bytes) {
    if (bytes < 1073741824) return '${(bytes / 1048576).toStringAsFixed(0)} MB';
    return '${(bytes / 1073741824).toStringAsFixed(1)} GB';
  }

  String _expiry(int? expiredAt) {
    if (expiredAt == null || expiredAt == 0) return '长期有效';
    final d = DateTime.fromMillisecondsSinceEpoch(expiredAt * 1000);
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-'
        '${d.day.toString().padLeft(2, '0')}';
  }

  void _toast(String m) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(m), behavior: SnackBarBehavior.floating));
  }

  // 重置订阅:换新订阅 token(旧链接失效),然后重导拉新节点。
  Future<void> _resetSecurity() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (dctx) => AlertDialog(
        title: const Text('重置订阅'),
        content: const Text('重置后旧的订阅链接会立即失效,已导出到其他客户端的需重新导入。确定重置?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dctx, false),
              child: const Text('取消')),
          FilledButton(
              onPressed: () => Navigator.pop(dctx, true),
              child: const Text('重置')),
        ],
      ),
    );
    if (ok != true) return;
    final token = ref.read(vogueslyAuthProvider).token;
    if (token == null) return;
    final res = await ref.read(vogueslyApiProvider).resetSecurity(token);
    if (res.ok) {
      try {
        await importVogueslySubscription();
      } catch (_) {}
    }
    _toast(res.message);
  }

  // 修改密码:旧+新(min 8)+ 确认。
  Future<void> _changePassword() async {
    final oldC = TextEditingController();
    final newC = TextEditingController();
    final new2C = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (dctx) => AlertDialog(
        title: const Text('修改密码'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: oldC,
                obscureText: true,
                decoration: const InputDecoration(labelText: '当前密码')),
            TextField(
                controller: newC,
                obscureText: true,
                decoration: const InputDecoration(labelText: '新密码(至少 8 位)')),
            TextField(
                controller: new2C,
                obscureText: true,
                decoration: const InputDecoration(labelText: '确认新密码')),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dctx, false),
              child: const Text('取消')),
          FilledButton(
              onPressed: () => Navigator.pop(dctx, true),
              child: const Text('确认修改')),
        ],
      ),
    );
    if (ok != true) return;
    final np = newC.text;
    if (np.length < 8) {
      _toast('新密码至少 8 位');
      return;
    }
    if (np != new2C.text) {
      _toast('两次新密码不一致');
      return;
    }
    final token = ref.read(vogueslyAuthProvider).token;
    if (token == null) return;
    final res = await ref.read(vogueslyApiProvider).changePassword(token,
        oldPassword: oldC.text, newPassword: np);
    _toast(res.message);
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (dctx) => AlertDialog(
        title: const Text('退出登录'),
        content: const Text('确定要退出当前账号吗?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dctx).pop(),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(dctx).pop();
              // ⚠️ 先删本账号订阅(防换账号串号),同其余两条登出路径(tools/profiles)一致,再清登录态。
              await clearVogueslyProfiles();
              ref.read(vogueslyAuthProvider.notifier).logout();
              if (context.mounted) Navigator.of(context).maybePop();
            },
            child: const Text('退出'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final user = ref.watch(vogueslyAuthProvider.select((s) => s.user));
    return Scaffold(
      appBar: vogAppBar(context, title: '用户中心'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          // 账号头卡
          Card(
            color: cs.primary.withValues(alpha: 0.08),
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: cs.primary.withValues(alpha: 0.15),
                    child: Icon(Icons.person, color: cs.primary, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user?.email ?? '未登录',
                            style:
                                tt.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 4),
                        Text(
                          user?.planName == null || user!.planName!.isEmpty
                              ? '暂无套餐'
                              : '当前套餐:${user.planName}',
                          style: tt.bodySmall?.copyWith(
                              color: cs.onSurfaceVariant.withValues(alpha: 0.8)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // 三格:余额 / 剩余流量 / 到期
          Row(
            children: [
              Expanded(
                child: _miniCard('账户余额',
                    _balanceCents == null
                        ? '—'
                        : '¥${(_balanceCents! / 100).toStringAsFixed(2)}',
                    Icons.account_balance_wallet_outlined),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _miniCard(
                    '剩余流量',
                    user == null ? '—' : _gb(user.remain),
                    Icons.data_usage_outlined),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _miniCard('到期时间',
                    user == null ? '—' : _expiry(user.expiredAt),
                    Icons.event_outlined),
              ),
            ],
          ),
          const SizedBox(height: 22),
          // 快捷操作
          _actionTile(Icons.storefront_outlined, '购买 / 续费套餐',
              () => VogueslyShopPage.open(context)),
          _actionTile(Icons.receipt_long_outlined, '我的订单',
              () => VogueslyOrdersPage.open(context)),
          _actionTile(Icons.card_giftcard_outlined, '邀请返利',
              () => VogueslyInvitePage.open(context)),
          const Divider(height: 28),
          // 账号安全(从 ylink.im/#/profile 移入原生)
          _actionTile(Icons.lock_reset_outlined, '重置订阅', _resetSecurity),
          _actionTile(Icons.password_outlined, '修改密码', _changePassword),
          const Divider(height: 28),
          _actionTile(Icons.logout, '退出登录', _confirmLogout, danger: true),
        ],
      ),
    );
  }

  Widget _miniCard(String label, String value, IconData icon) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Card(
      elevation: 0,
      color: cs.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 20, color: cs.primary),
            const SizedBox(height: 10),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(value,
                  maxLines: 1,
                  style: tt.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 2),
            Text(label, style: tt.labelSmall),
          ],
        ),
      ),
    );
  }

  Widget _actionTile(IconData icon, String label, VoidCallback onTap,
      {bool danger = false}) {
    final cs = Theme.of(context).colorScheme;
    final color = danger ? cs.error : cs.onSurface;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      leading: Icon(icon, color: danger ? cs.error : cs.primary),
      title: Text(label, style: TextStyle(color: color)),
      trailing: Icon(Icons.chevron_right, color: cs.onSurfaceVariant),
      onTap: onTap,
    );
  }
}

/// 我的订单页(原生,GET /user/order/fetch)。Sam:之前有订单查唔到,加返一级入口。
class VogueslyOrdersPage extends ConsumerStatefulWidget {
  const VogueslyOrdersPage({super.key});

  static void open(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const VogueslyOrdersPage()),
    );
  }

  @override
  ConsumerState<VogueslyOrdersPage> createState() => _VogueslyOrdersPageState();
}

class _VogueslyOrdersPageState extends ConsumerState<VogueslyOrdersPage> {
  bool _loading = true;
  List<VogueslyOrder> _orders = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final token = ref.read(vogueslyAuthProvider).token;
    if (token == null) {
      if (mounted) setState(() => _loading = false);
      return;
    }
    final orders = await ref.read(vogueslyApiProvider).fetchOrders(token);
    if (!mounted) return;
    setState(() {
      _orders = orders;
      _loading = false;
    });
  }

  Color _statusColor(int status) {
    switch (status) {
      case 3:
        return const Color(0xFF16A34A); // 已完成 绿
      case 0:
      case 1:
        return const Color(0xFFF59E0B); // 待支付/开通中 橙
      default:
        return Theme.of(context).colorScheme.onSurfaceVariant; // 取消/退款 灰
    }
  }

  String _date(int sec) {
    if (sec == 0) return '';
    final d = DateTime.fromMillisecondsSinceEpoch(sec * 1000);
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-'
        '${d.day.toString().padLeft(2, '0')} '
        '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
  }

  // 待支付订单继续支付(共享支付流程)。到账后刷新列表。
  Future<void> _continuePay(VogueslyOrder o) async {
    await VogueslyPayment.present(
      context: context,
      ref: ref,
      tradeNo: o.tradeNo,
      priceCents: o.totalCents,
      title: '${o.planName}  ${o.amountText}',
      onPaid: _load,
    );
  }

  Future<void> _cancel(VogueslyOrder o) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (dctx) => AlertDialog(
        title: const Text('取消订单'),
        content: Text('确定取消订单「${o.planName}」?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dctx).pop(false),
            child: const Text('返回'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dctx).pop(true),
            child: const Text('取消订单'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    final token = ref.read(vogueslyAuthProvider).token;
    if (token == null) return;
    final done = await ref.read(vogueslyApiProvider).cancelOrder(token, o.tradeNo);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(done ? '订单已取消' : '取消失败,请稍后重试'),
          behavior: SnackBarBehavior.floating),
    );
    if (done) _load();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Scaffold(
      appBar: vogAppBar(
        context,
        title: '我的订单',
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
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _orders.isEmpty
                ? ListView(
                    children: const [
                      SizedBox(height: 120),
                      Icon(Icons.receipt_long_outlined, size: 44),
                      SizedBox(height: 12),
                      Center(child: Text('暂无订单记录')),
                    ],
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _orders.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (_, i) {
                      final o = _orders[i];
                      return Card(
                        elevation: 0,
                        color: cs.surfaceContainerHighest,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(o.planName,
                                        style: tt.titleSmall?.copyWith(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Text(o.amountText,
                                      style: tt.titleMedium?.copyWith(
                                          color: cs.primary,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: _statusColor(o.status)
                                          .withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(o.statusText,
                                        style: tt.labelSmall?.copyWith(
                                            color: _statusColor(o.status),
                                            fontWeight: FontWeight.w600)),
                                  ),
                                  const Spacer(),
                                  Text(_date(o.createdAt),
                                      style: tt.bodySmall?.copyWith(
                                          color: cs.onSurfaceVariant
                                              .withValues(alpha: 0.7))),
                                ],
                              ),
                              if (o.tradeNo.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text('订单号:${o.tradeNo}',
                                    style: tt.bodySmall?.copyWith(
                                        color: cs.onSurfaceVariant
                                            .withValues(alpha: 0.6))),
                              ],
                              // 待支付订单:可继续支付 / 取消(Sam:之前只显示状态,唔畀操作)。
                              if (o.status == 0) ...[
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: FilledButton(
                                        onPressed: () => _continuePay(o),
                                        child: const Text('继续支付'),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    OutlinedButton(
                                      onPressed: () => _cancel(o),
                                      child: const Text('取消订单'),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
