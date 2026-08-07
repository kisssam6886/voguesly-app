import 'package:flutter/material.dart';
import 'package:fl_clash/common/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'voguesly_api.dart';
import 'voguesly_auth.dart';
import 'voguesly_ui.dart';

/// 易联 · 原生流量明细(直调 XBoard /user/stat/getTrafficLog,唔用 webview)。
/// 顶部汇总当月总上/下行 + 合计,下面每日列表带占比条。
class VogueslyStatPage extends ConsumerStatefulWidget {
  const VogueslyStatPage({super.key});

  static void open(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const VogueslyStatPage()),
    );
  }

  @override
  ConsumerState<VogueslyStatPage> createState() => _VogueslyStatPageState();
}

class _VogueslyStatPageState extends ConsumerState<VogueslyStatPage> {
  bool _loading = true;
  String? _error;
  List<VogueslyTrafficLog> _logs = const [];

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
        _error = currentAppLocalizations.vgNotSignedIn;
      });
      return;
    }
    final logs = await ref.read(vogueslyApiProvider).fetchTrafficLog(token);
    if (!mounted) return;
    setState(() {
      _logs = logs;
      _loading = false;
    });
  }

  // 字节 → 人类可读(自动 B/KB/MB/GB)。
  String _fmtBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1048576) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1073741824) return '${(bytes / 1048576).toStringAsFixed(1)} MB';
    return '${(bytes / 1073741824).toStringAsFixed(2)} GB';
  }

  String _date(int sec) {
    if (sec == 0) return '';
    final d = DateTime.fromMillisecondsSinceEpoch(sec * 1000);
    return '${d.month.toString().padLeft(2, '0')}-'
        '${d.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    var totalU = 0;
    var totalD = 0;
    var maxDay = 0;
    for (final l in _logs) {
      totalU += l.u;
      totalD += l.d;
      if (l.total > maxDay) maxDay = l.total;
    }
    return Scaffold(
      appBar: vogAppBar(
        context,
        title: currentAppLocalizations.vgDataUsage,
        actions: [
          IconButton(
            tooltip: currentAppLocalizations.vgRefresh,
            icon: const Icon(Icons.refresh),
            onPressed: _loading ? null : _load,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : (_error != null && _logs.isEmpty)
                ? ListView(
                    children: [
                      const SizedBox(height: 120),
                      const Icon(Icons.data_usage_outlined, size: 44),
                      const SizedBox(height: 12),
                      Center(child: Text(_error!)),
                    ],
                  )
                : ListView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                    children: [
                      // 汇总:总上行 / 总下行 / 合计
                      Row(
                        children: [
                          Expanded(
                            child: _statCard(
                              icon: Icons.upload_outlined,
                              label: currentAppLocalizations.vgTotalUpload,
                              value: _fmtBytes(totalU),
                              color: cs.tertiary,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _statCard(
                              icon: Icons.download_outlined,
                              label: currentAppLocalizations.vgTotalDownload,
                              value: _fmtBytes(totalD),
                              color: cs.primary,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _statCard(
                              icon: Icons.data_usage_outlined,
                              label: currentAppLocalizations.vgTotal,
                              value: _fmtBytes(totalU + totalD),
                              color: cs.secondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(currentAppLocalizations.vgDailyUsageThisMonth,
                          style: tt.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      if (_logs.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 48),
                          child: Center(
                            child: Text(currentAppLocalizations.vgNoUsageThisMonth,
                                style: tt.bodyMedium?.copyWith(
                                    color: cs.onSurfaceVariant)),
                          ),
                        )
                      else
                        for (final l in _logs)
                          _dayRow(l, maxDay, cs, tt),
                    ],
                  ),
      ),
    );
  }

  Widget _dayRow(VogueslyTrafficLog l, int maxDay, ColorScheme cs,
      TextTheme tt) {
    final ratio = maxDay <= 0 ? 0.0 : (l.total / maxDay).clamp(0.0, 1.0);
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 44,
                child: Text(_date(l.recordAt),
                    style: tt.bodySmall
                        ?.copyWith(fontWeight: FontWeight.w600)),
              ),
              const SizedBox(width: 8),
              Icon(Icons.arrow_upward, size: 12, color: cs.tertiary),
              const SizedBox(width: 2),
              Text(_fmtBytes(l.u),
                  style: tt.bodySmall
                      ?.copyWith(color: cs.onSurfaceVariant)),
              const SizedBox(width: 12),
              Icon(Icons.arrow_downward, size: 12, color: cs.primary),
              const SizedBox(width: 2),
              Text(_fmtBytes(l.d),
                  style: tt.bodySmall
                      ?.copyWith(color: cs.onSurfaceVariant)),
              const Spacer(),
              Text(_fmtBytes(l.total),
                  style: tt.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold, color: cs.onSurface)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 6,
              backgroundColor: cs.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(cs.primary),
            ),
          ),
        ],
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(height: 10),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(value,
                  maxLines: 1,
                  style: tt.titleMedium
                      ?.copyWith(color: color, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 2),
            Text(label, style: tt.labelSmall),
          ],
        ),
      ),
    );
  }
}
