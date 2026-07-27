import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'voguesly_api.dart';
import 'voguesly_auth.dart';

/// 易联 · 我的工单(直调 XBoard /user/ticket/*)。
/// 2026-07-27 补:之前只有「反馈问题 / 上传日志」单向提交,用户睇唔到客服有冇回、
/// 亦都冇得跟进,唯有再开多张工单。呢度补返列表 + 详情 + 继续回复 + 关闭。
class VogueslyTicketsPage extends ConsumerStatefulWidget {
  const VogueslyTicketsPage({super.key});

  static void open(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const VogueslyTicketsPage()),
    );
  }

  @override
  ConsumerState<VogueslyTicketsPage> createState() =>
      _VogueslyTicketsPageState();
}

class _VogueslyTicketsPageState extends ConsumerState<VogueslyTicketsPage> {
  bool _loading = true;
  String? _error;
  List<VogueslyTicket> _tickets = const [];

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
    final list = await ref.read(vogueslyApiProvider).fetchTickets(token);
    if (!mounted) return;
    setState(() {
      _tickets = list;
      _loading = false;
    });
  }

  String _date(int? sec) {
    if (sec == null || sec == 0) return '';
    final d = DateTime.fromMillisecondsSinceEpoch(sec * 1000);
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-'
        '${d.day.toString().padLeft(2, '0')} '
        '${d.hour.toString().padLeft(2, '0')}:'
        '${d.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的工单'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: '刷新',
            onPressed: _loading ? null : _load,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: _buildBody(cs),
      ),
    );
  }

  Widget _buildBody(ColorScheme cs) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return _centeredHint(_error!, cs);
    }
    if (_tickets.isEmpty) {
      return _centeredHint(
        '还没有工单\n遇到问题可以在「反馈问题 / 上传日志」提交',
        cs,
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _tickets.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (_, i) {
        final t = _tickets[i];
        return ListTile(
          leading: Icon(
            t.isClosed ? Icons.check_circle_outline : Icons.forum_outlined,
            color: t.isClosed ? cs.outline : cs.primary,
          ),
          title: Text(
            t.subject.isEmpty ? '工单 #${t.id}' : t.subject,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text('#${t.id} · ${_date(t.createdAt)}'),
          trailing: _statusChip(t, cs),
          onTap: () async {
            await _VogueslyTicketDetailPage.open(context, t.id);
            if (mounted) _load();
          },
        );
      },
    );
  }

  Widget _statusChip(VogueslyTicket t, ColorScheme cs) {
    final (String label, Color color) = t.isClosed
        ? ('已关闭', cs.outline)
        : t.waitingReply
            ? ('等待回复', cs.tertiary)
            : ('客服已回', cs.primary);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(label, style: TextStyle(fontSize: 11, color: color)),
    );
  }

  Widget _centeredHint(String text, ColorScheme cs) {
    return ListView(
      children: [
        const SizedBox(height: 120),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(color: cs.onSurfaceVariant),
            ),
          ),
        ),
      ],
    );
  }
}

/// 工单详情:往来消息 + 继续回复 + 关闭。
class _VogueslyTicketDetailPage extends ConsumerStatefulWidget {
  const _VogueslyTicketDetailPage({required this.id});

  final int id;

  static Future<void> open(BuildContext context, int id) {
    return Navigator.of(context).push<void>(
      MaterialPageRoute(builder: (_) => _VogueslyTicketDetailPage(id: id)),
    );
  }

  @override
  ConsumerState<_VogueslyTicketDetailPage> createState() =>
      _VogueslyTicketDetailPageState();
}

class _VogueslyTicketDetailPageState
    extends ConsumerState<_VogueslyTicketDetailPage> {
  final _inputCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  bool _loading = true;
  bool _sending = false;
  VogueslyTicket? _ticket;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _inputCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final token = ref.read(vogueslyAuthProvider).token;
    if (token == null || token.isEmpty) {
      if (mounted) setState(() => _loading = false);
      return;
    }
    final t =
        await ref.read(vogueslyApiProvider).fetchTicketDetail(token, widget.id);
    if (!mounted) return;
    setState(() {
      _ticket = t;
      _loading = false;
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.jumpTo(_scrollCtrl.position.maxScrollExtent);
      }
    });
  }

  Future<void> _send() async {
    final text = _inputCtrl.text.trim();
    if (text.isEmpty || _sending) return;
    final token = ref.read(vogueslyAuthProvider).token;
    if (token == null || token.isEmpty) return;
    setState(() => _sending = true);
    final res = await ref
        .read(vogueslyApiProvider)
        .replyTicket(token, id: widget.id, message: text);
    if (!mounted) return;
    setState(() => _sending = false);
    if (res.ok) {
      _inputCtrl.clear();
      await _load();
    } else {
      // 后端会返「请等待技术工程师回复」呢类真实原因,原样показ俾用户,唔好笼统讲网络异常。
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(res.message)));
    }
  }

  Future<void> _close() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('关闭工单'),
        content: const Text('关闭后就唔可以再回复。确定问题已解决?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('取消')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('关闭工单')),
        ],
      ),
    );
    if (ok != true) return;
    final token = ref.read(vogueslyAuthProvider).token;
    if (token == null || token.isEmpty) return;
    final done = await ref.read(vogueslyApiProvider).closeTicket(token, widget.id);
    if (!mounted) return;
    if (done) {
      await _load();
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('关闭失败，请稍后再试')));
    }
  }

  String _time(int sec) {
    if (sec == 0) return '';
    final d = DateTime.fromMillisecondsSinceEpoch(sec * 1000);
    return '${d.month}-${d.day.toString().padLeft(2, '0')} '
        '${d.hour.toString().padLeft(2, '0')}:'
        '${d.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = _ticket;
    final closed = t?.isClosed ?? false;
    return Scaffold(
      appBar: AppBar(
        title: Text(t?.subject.isNotEmpty == true
            ? t!.subject
            : '工单 #${widget.id}'),
        actions: [
          if (t != null && !closed)
            TextButton(onPressed: _close, child: const Text('关闭工单')),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : (t == null || t.messages.isEmpty)
                    ? Center(
                        child: Text('暂无消息',
                            style: TextStyle(color: cs.onSurfaceVariant)))
                    : ListView.builder(
                        controller: _scrollCtrl,
                        padding: const EdgeInsets.all(12),
                        itemCount: t.messages.length,
                        itemBuilder: (_, i) => _bubble(t.messages[i], cs),
                      ),
          ),
          if (closed)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              color: cs.surfaceContainerHighest,
              child: Text('工单已关闭',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: cs.onSurfaceVariant, fontSize: 13)),
            )
          else
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _inputCtrl,
                        minLines: 1,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          hintText: '继续回复客服…',
                          border: OutlineInputBorder(),
                          isDense: true,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filled(
                      onPressed: _sending ? null : _send,
                      icon: _sending
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child:
                                  CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.send),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _bubble(VogueslyTicketMessage m, ColorScheme cs) {
    final me = m.isMe;
    return Align(
      alignment: me ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: me ? cs.primaryContainer : cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment:
              me ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(m.message, style: const TextStyle(fontSize: 14, height: 1.45)),
            const SizedBox(height: 3),
            Text(
              '${me ? '我' : '客服'} · ${_time(m.createdAt)}',
              style: TextStyle(fontSize: 10, color: cs.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}
