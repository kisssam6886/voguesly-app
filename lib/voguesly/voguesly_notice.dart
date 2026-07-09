import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'voguesly_api.dart';
import 'voguesly_auth.dart';
import 'voguesly_ui.dart';

/// 易联 · 原生公告中心(直调 XBoard /user/notice/fetch,唔用 webview)。
class VogueslyNoticePage extends ConsumerStatefulWidget {
  const VogueslyNoticePage({super.key});

  static void open(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const VogueslyNoticePage()),
    );
  }

  @override
  ConsumerState<VogueslyNoticePage> createState() => _VogueslyNoticePageState();
}

class _VogueslyNoticePageState extends ConsumerState<VogueslyNoticePage> {
  bool _loading = true;
  String? _error;
  List<VogueslyNotice> _notices = const [];
  final Set<int> _expanded = {};

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
    final notices = await ref.read(vogueslyApiProvider).fetchNotices(token);
    if (!mounted) return;
    setState(() {
      _notices = notices;
      _loading = false;
    });
  }

  String _date(int? sec) {
    if (sec == null || sec == 0) return '';
    final d = DateTime.fromMillisecondsSinceEpoch(sec * 1000);
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-'
        '${d.day.toString().padLeft(2, '0')}';
  }

  // 无 flutter_html 依赖:把公告 HTML 简易转纯文本(块级标签换行 + 去标签 + 解基础实体)。
  static String _htmlToText(String html) {
    var s = html;
    s = s.replaceAll(RegExp(r'<\s*br\s*/?\s*>', caseSensitive: false), '\n');
    s = s.replaceAll(
        RegExp(r'</\s*(p|div|li|h[1-6]|tr)\s*>', caseSensitive: false), '\n');
    s = s.replaceAll(RegExp(r'<\s*li[^>]*>', caseSensitive: false), '• ');
    s = s.replaceAll(RegExp(r'<[^>]+>'), ''); // 去剩余标签
    s = s
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'");
    // 收敛连续空行,去首尾空白。
    s = s.replaceAll(RegExp(r'\n{3,}'), '\n\n');
    return s.trim();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Scaffold(
      appBar: vogAppBar(
        context,
        title: '公告中心',
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
            : (_error != null && _notices.isEmpty)
                ? ListView(
                    children: [
                      const SizedBox(height: 120),
                      const Icon(Icons.campaign_outlined, size: 44),
                      const SizedBox(height: 12),
                      Center(child: Text(_error!)),
                    ],
                  )
                : _notices.isEmpty
                    ? ListView(
                        children: const [
                          SizedBox(height: 120),
                          Icon(Icons.campaign_outlined, size: 44),
                          SizedBox(height: 12),
                          Center(child: Text('暂无公告')),
                        ],
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: _notices.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemBuilder: (_, i) {
                          final n = _notices[i];
                          final expanded = _expanded.contains(n.id);
                          final body = _htmlToText(n.content);
                          return Card(
                            elevation: 0,
                            color: cs.surfaceContainerHighest,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(Icons.campaign_outlined,
                                          size: 20, color: cs.primary),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          n.title,
                                          style: tt.titleSmall?.copyWith(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (_date(n.createdAt).isNotEmpty) ...[
                                    const SizedBox(height: 6),
                                    Text(
                                      _date(n.createdAt),
                                      style: tt.bodySmall?.copyWith(
                                          color: cs.onSurfaceVariant
                                              .withValues(alpha: 0.7)),
                                    ),
                                  ],
                                  if (n.tags.isNotEmpty) ...[
                                    const SizedBox(height: 8),
                                    Wrap(
                                      spacing: 6,
                                      runSpacing: 6,
                                      children: [
                                        for (final t in n.tags)
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: cs.primary
                                                  .withValues(alpha: 0.12),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Text(t,
                                                style: tt.labelSmall?.copyWith(
                                                    color: cs.primary,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                          ),
                                      ],
                                    ),
                                  ],
                                  if (body.isNotEmpty) ...[
                                    const SizedBox(height: 10),
                                    Text(
                                      body,
                                      maxLines: expanded ? null : 4,
                                      overflow: expanded
                                          ? TextOverflow.visible
                                          : TextOverflow.ellipsis,
                                      style: tt.bodyMedium?.copyWith(
                                          color: cs.onSurfaceVariant, height: 1.5),
                                    ),
                                    // 长文提供展开/收起。
                                    if (body.length > 120)
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                              padding: EdgeInsets.zero,
                                              minimumSize: const Size(0, 32),
                                              tapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap),
                                          onPressed: () => setState(() {
                                            if (expanded) {
                                              _expanded.remove(n.id);
                                            } else {
                                              _expanded.add(n.id);
                                            }
                                          }),
                                          child: Text(expanded ? '收起' : '展开全文'),
                                        ),
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
