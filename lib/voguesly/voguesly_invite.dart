import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'voguesly_api.dart';
import 'voguesly_auth.dart';
import 'voguesly_ui.dart';

/// 易联 · 原生邀请返利页(照商城做法,直调 XBoard /user/invite/*,唔用 webview)。
class VogueslyInvitePage extends ConsumerStatefulWidget {
  const VogueslyInvitePage({super.key});

  static void open(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const VogueslyInvitePage()),
    );
  }

  @override
  ConsumerState<VogueslyInvitePage> createState() => _VogueslyInvitePageState();
}

class _VogueslyInvitePageState extends ConsumerState<VogueslyInvitePage> {
  bool _loading = true;
  String? _error;
  VogueslyInviteData? _data;

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
        _error = '未登录';
      });
      return;
    }
    final api = ref.read(vogueslyApiProvider);
    var data = await api.fetchInviteData(token);
    // 未有邀请码 → 生成一个再拉。
    if (data != null && (data.firstCode == null)) {
      final ok = await api.generateInviteCode(token);
      if (ok) data = await api.fetchInviteData(token);
    }
    if (!mounted) return;
    setState(() {
      _data = data;
      _loading = false;
      _error = data == null ? '加载失败,请下拉重试' : null;
    });
  }

  String get _inviteLink {
    final code = _data?.firstCode;
    return code == null ? '' : 'https://ylink.im/#/register?code=$code';
  }

  void _copy(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$label已复制'), behavior: SnackBarBehavior.floating),
    );
  }

  String _yuan(int cents) => '¥${(cents / 100).toStringAsFixed(2)}';

  void _toast(String m) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(m), behavior: SnackBarBehavior.floating));
  }

  // 佣金划转到余额(默认全部)。
  Future<void> _transfer() async {
    final avail = _data?.commissionCents ?? 0;
    final ctrl = TextEditingController(text: (avail / 100).toStringAsFixed(2));
    final ok = await showDialog<bool>(
      context: context,
      builder: (dctx) => AlertDialog(
        title: const Text('划转到余额'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('可用佣金:${_yuan(avail)}'),
            const SizedBox(height: 10),
            TextField(
              controller: ctrl,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                  labelText: '划转金额(元)', prefixText: '¥'),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dctx, false),
              child: const Text('取消')),
          FilledButton(
              onPressed: () => Navigator.pop(dctx, true),
              child: const Text('划转')),
        ],
      ),
    );
    if (ok != true) return;
    final cents = ((double.tryParse(ctrl.text) ?? 0) * 100).round();
    if (cents <= 0 || cents > avail) {
      _toast('金额无效');
      return;
    }
    final token = ref.read(vogueslyAuthProvider).token;
    if (token == null) return;
    final res =
        await ref.read(vogueslyApiProvider).transferCommission(token, cents);
    _toast(res.message);
    if (res.ok) _load();
  }

  // 提现:选方式 + 填收款账号(建工单,客服处理)。
  Future<void> _withdraw() async {
    final methodC = TextEditingController(text: '支付宝');
    final accountC = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (dctx) => AlertDialog(
        title: const Text('提现申请'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('可用佣金:${_yuan(_data?.commissionCents ?? 0)}'),
            const SizedBox(height: 10),
            TextField(
                controller: methodC,
                decoration: const InputDecoration(
                    labelText: '提现方式(支付宝 / 微信 / USDT)')),
            TextField(
                controller: accountC,
                decoration: const InputDecoration(labelText: '收款账号')),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dctx, false),
              child: const Text('取消')),
          FilledButton(
              onPressed: () => Navigator.pop(dctx, true),
              child: const Text('提交')),
        ],
      ),
    );
    if (ok != true) return;
    if (accountC.text.trim().isEmpty) {
      _toast('请填写收款账号');
      return;
    }
    final token = ref.read(vogueslyAuthProvider).token;
    if (token == null) return;
    final res = await ref.read(vogueslyApiProvider).withdraw(token,
        method: methodC.text.trim(), account: accountC.text.trim());
    _toast(res.message);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final code = _data?.firstCode;
    return Scaffold(
      appBar: vogAppBar(
        context,
        title: '邀请返利',
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
            : ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                children: [
                  if (_error != null && _data == null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 48),
                      child: Center(child: Text(_error!)),
                    )
                  else ...[
                    // 佣金 + 邀请人数 两卡并排
                    Row(
                      children: [
                        Expanded(
                          child: _statCard(
                            icon: Icons.savings_outlined,
                            label: '可用佣金',
                            value: _yuan(_data?.commissionCents ?? 0),
                            color: cs.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _statCard(
                            icon: Icons.group_outlined,
                            label: '已邀请',
                            value: '${_data?.inviteCount ?? 0} 人',
                            color: cs.tertiary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // 佣金操作:划转到余额(原生)/ 提现(原生工单)。从 ylink.im/#/invite 移入。
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: (_data?.commissionCents ?? 0) > 0
                                ? _transfer
                                : null,
                            icon: const Icon(Icons.swap_horiz, size: 18),
                            label: const Text('划转到余额'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: (_data?.commissionCents ?? 0) > 0
                                ? _withdraw
                                : null,
                            icon: const Icon(Icons.account_balance, size: 18),
                            label: const Text('提现'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text('我的邀请码',
                        style: tt.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    // 邀请码大字 + 复制
                    Card(
                      color: cs.primary.withValues(alpha: 0.08),
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 18, 12, 18),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                code ?? '—',
                                style: tt.headlineSmall?.copyWith(
                                    color: cs.primary,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2),
                              ),
                            ),
                            if (code != null)
                              TextButton.icon(
                                onPressed: () => _copy(code, '邀请码'),
                                icon: const Icon(Icons.copy, size: 18),
                                label: const Text('复制'),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text('邀请链接',
                        style: tt.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Card(
                      elevation: 0,
                      color: cs.surfaceContainerHighest,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SelectableText(
                              _inviteLink.isEmpty ? '—' : _inviteLink,
                              maxLines: 2,
                              style: tt.bodyMedium,
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: FilledButton.icon(
                                onPressed: _inviteLink.isEmpty
                                    ? null
                                    : () => _copy(_inviteLink, '邀请链接'),
                                icon: const Icon(Icons.link, size: 18),
                                label: const Text('复制邀请链接'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '好友通过你的链接注册并购买套餐,你可获得返利佣金。佣金可用于抵扣续费。',
                      style: tt.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant.withValues(alpha: 0.7)),
                    ),
                  ],
                ],
              ),
      ),
    );
  }

  Widget _statCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    final tt = Theme.of(context).textTheme;
    return Card(
      elevation: 0,
      color: color.withValues(alpha: 0.08),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 10),
            Text(value,
                style: tt.headlineSmall
                    ?.copyWith(color: color, fontWeight: FontWeight.bold)),
            const SizedBox(height: 2),
            Text(label, style: tt.bodySmall),
          ],
        ),
      ),
    );
  }
}
