import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 易联 · 检测页(护城河可视化)
/// 显式经核心 mixed-port 代理(127.0.0.1:port)探测,绕开有已知问题嘅 _clashDio。
/// 测的是出口节点解锁 + IP 分流,唔系本机。

enum UnlockStatus { yes, no, loading, error }

class UnlockResult {
  final String name;
  final UnlockStatus status;
  final String region;
  final String note;
  const UnlockResult(
    this.name, {
    this.status = UnlockStatus.loading,
    this.region = '',
    this.note = '',
  });
}

class ExitIpInfo {
  final String ip;
  final String countryCode;
  final String country;
  final String city;
  final String isp;
  const ExitIpInfo({
    this.ip = '',
    this.countryCode = '',
    this.country = '',
    this.city = '',
    this.isp = '',
  });
}

/// 延迟测试结果(经当前路由:Model A 下国内直连快、国际经节点)。ms=null → 超时/失败。
class LatencyResult {
  final String name;
  final int? ms;
  const LatencyResult(this.name, this.ms);
}

const _ua =
    'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 '
    '(KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36';

class DetectionService {
  final Dio _dio;
  DetectionService(int mixedPort) : _dio = _makeDio(mixedPort);

  static Dio _makeDio(int port) {
    final dio = Dio(BaseOptions(
      headers: {'User-Agent': _ua},
      responseType: ResponseType.plain,
      validateStatus: (_) => true,
      followRedirects: true,
      connectTimeout: const Duration(seconds: 8),
      receiveTimeout: const Duration(seconds: 8),
      sendTimeout: const Duration(seconds: 8),
    ));
    dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final c = HttpClient();
        c.findProxy = (_) =>
            port > 0 ? 'PROXY 127.0.0.1:$port' : 'DIRECT';
        c.badCertificateCallback = (_, _, _) => true;
        c.connectionTimeout = const Duration(seconds: 8);
        return c;
      },
    );
    return dio;
  }

  Future<({int? status, String body})> _probe(String url) async {
    try {
      final r = await _dio.get<String>(url);
      return (status: r.statusCode, body: r.data ?? '');
    } catch (_) {
      return (status: null, body: '');
    }
  }

  /// 测某目标延迟(ms)。经当前路由(核心按 Model A 分流:国内直连、国际经节点)。
  /// 用轻量资源(favicon/204)量往返;失败/超时返 null。
  Future<int?> ping(String url) async {
    final sw = Stopwatch()..start();
    try {
      await _dio.get<String>(
        url,
        options: Options(
          receiveTimeout: const Duration(seconds: 6),
          sendTimeout: const Duration(seconds: 6),
        ),
      );
      sw.stop();
      return sw.elapsedMilliseconds;
    } catch (_) {
      return null;
    }
  }

  static const _blockedForOpenAI = {'CN', 'RU', 'KP', 'IR', 'SY', 'CU', 'HK'};

  Future<UnlockResult> chatgpt() async {
    final r = await _probe('https://chat.openai.com/cdn-cgi/trace');
    if (r.status == 200) {
      final loc = RegExp(r'loc=([A-Z]{2})').firstMatch(r.body)?.group(1) ?? '';
      if (loc.isNotEmpty && _blockedForOpenAI.contains(loc)) {
        return UnlockResult('ChatGPT', status: UnlockStatus.no, region: loc, note: '地区不支持');
      }
      return UnlockResult('ChatGPT', status: UnlockStatus.yes, region: loc);
    }
    return const UnlockResult('ChatGPT', status: UnlockStatus.no);
  }

  Future<UnlockResult> claude() async {
    final r = await _probe('https://claude.ai/cdn-cgi/trace');
    if (r.status == 200) {
      final loc = RegExp(r'loc=([A-Z]{2})').firstMatch(r.body)?.group(1) ?? '';
      const blocked = {'CN', 'RU', 'KP', 'IR', 'HK'};
      if (loc.isNotEmpty && blocked.contains(loc)) {
        return UnlockResult('Claude', status: UnlockStatus.no, region: loc, note: '地区限制');
      }
      return UnlockResult('Claude', status: UnlockStatus.yes, region: loc);
    }
    return const UnlockResult('Claude', status: UnlockStatus.no);
  }

  Future<UnlockResult> youtubePremium() async {
    final r = await _probe('https://www.youtube.com/premium');
    if (r.status == null) return const UnlockResult('YouTube Premium', status: UnlockStatus.no);
    if (r.body.contains('Premium is not available')) {
      return const UnlockResult('YouTube Premium', status: UnlockStatus.no, note: '地区不支持');
    }
    final cc = RegExp(r'"countryCode"\s*:\s*"([A-Z]{2})"').firstMatch(r.body)?.group(1) ?? '';
    if (cc.isEmpty && r.status != 200) {
      return const UnlockResult('YouTube Premium', status: UnlockStatus.no);
    }
    return UnlockResult('YouTube Premium', status: UnlockStatus.yes, region: cc);
  }

  Future<UnlockResult> netflix() async {
    final r = await _probe('https://www.netflix.com/title/81280792');
    if (r.status == 200) {
      return const UnlockResult('Netflix', status: UnlockStatus.yes, note: '完整解锁');
    }
    if (r.status == 404) {
      return const UnlockResult('Netflix', status: UnlockStatus.yes, note: '仅自制剧');
    }
    return const UnlockResult('Netflix', status: UnlockStatus.no);
  }

  Future<UnlockResult> disney() async {
    final r = await _probe('https://www.disneyplus.com/');
    if ((r.status == 200 || r.status == 301 || r.status == 302) &&
        !r.body.contains('unavailable')) {
      return const UnlockResult('Disney+', status: UnlockStatus.yes);
    }
    return const UnlockResult('Disney+', status: UnlockStatus.no, note: '地区限制');
  }

  Future<UnlockResult> spotify() async {
    final r = await _probe('https://www.spotify.com/');
    final ok = r.status != null && r.status! >= 200 && r.status! < 400;
    return ok
        ? const UnlockResult('Spotify', status: UnlockStatus.yes)
        : const UnlockResult('Spotify', status: UnlockStatus.no);
  }

  Future<UnlockResult> tiktok() async {
    final r = await _probe('https://www.tiktok.com/');
    if (r.status == null) return const UnlockResult('TikTok', status: UnlockStatus.no);
    final region = RegExp(r'"region"\s*:\s*"([A-Z]{2})"').firstMatch(r.body)?.group(1) ?? '';
    return UnlockResult('TikTok', status: UnlockStatus.yes, region: region);
  }

  Future<UnlockResult> _bili(String name, String seasonId) async {
    final r = await _probe(
      'https://api.bilibili.com/pgc/view/web/season?season_id=$seasonId',
    );
    if (r.body.contains('"code":0')) {
      return UnlockResult(name, status: UnlockStatus.yes);
    }
    if (r.body.contains('-10403')) {
      return UnlockResult(name, status: UnlockStatus.no, note: '地区限制');
    }
    return UnlockResult(name, status: UnlockStatus.no);
  }

  Future<UnlockResult> biliMainland() => _bili('哔哩哔哩大陆', '6633');
  Future<UnlockResult> biliHkMoTw() => _bili('哔哩哔哩港澳台', '42879');

  List<Future<UnlockResult> Function()> get all => [
    youtubePremium,
    netflix,
    disney,
    chatgpt,
    claude,
    spotify,
    tiktok,
    biliMainland,
    biliHkMoTw,
  ];

  Future<ExitIpInfo?> exitIp() async {
    final r = await _probe(
      'http://ip-api.com/json/?fields=status,country,countryCode,city,isp,query',
    );
    if (r.status == 200) {
      try {
        final j = jsonDecode(r.body) as Map<String, dynamic>;
        if (j['status'] == 'success') {
          return ExitIpInfo(
            ip: (j['query'] ?? '').toString(),
            countryCode: (j['countryCode'] ?? '').toString(),
            country: (j['country'] ?? '').toString(),
            city: (j['city'] ?? '').toString(),
            isp: (j['isp'] ?? '').toString(),
          );
        }
      } catch (_) {}
    }
    return null;
  }
}

String countryCodeToEmoji(String code) {
  final c = code.toUpperCase();
  if (c.length != 2) return '🌐';
  final a = c.codeUnitAt(0) - 0x41 + 0x1F1E6;
  final b = c.codeUnitAt(1) - 0x41 + 0x1F1E6;
  if (a < 0x1F1E6 || b < 0x1F1E6) return '🌐';
  return String.fromCharCode(a) + String.fromCharCode(b);
}

// ===================== 检测页 UI =====================

class VogueslyDetectionView extends ConsumerStatefulWidget {
  const VogueslyDetectionView({super.key});

  @override
  ConsumerState<VogueslyDetectionView> createState() =>
      _VogueslyDetectionViewState();
}

class _VogueslyDetectionViewState extends ConsumerState<VogueslyDetectionView> {
  List<UnlockResult> _results = const [];
  ExitIpInfo? _ip;
  bool _running = false;
  bool _ipLoading = false;
  List<LatencyResult> _domestic = const [];
  List<LatencyResult> _intl = const [];

  static const _names = [
    'YouTube Premium', 'Netflix', 'Disney+', 'ChatGPT', 'Claude',
    'Spotify', 'TikTok', '哔哩哔哩大陆', '哔哩哔哩港澳台',
  ];

  // 延迟测试目标(轻量资源)。国内=期望直连快(绿);国际=经节点(橙)。
  static const _domesticTargets = {
    '百度': 'https://www.baidu.com/favicon.ico',
    '淘宝': 'https://www.taobao.com/favicon.ico',
    '哔哩哔哩': 'https://www.bilibili.com/favicon.ico',
    '微信': 'https://res.wx.qq.com/a/wx_fed/assets/res/NTI4MWU5.ico',
    '抖音': 'https://www.douyin.com/favicon.ico',
  };
  static const _intlTargets = {
    'Google': 'https://www.google.com/generate_204',
    'YouTube': 'https://www.youtube.com/favicon.ico',
    'GitHub': 'https://github.com/favicon.ico',
    'Cloudflare': 'https://www.cloudflare.com/favicon.ico',
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ⚠️ 必须 guard mounted:postFrame 触发时 widget 可能已 dispose(切页/持久化恢复),
      // 未 guard 直接用 ref → State.context 为 null → 「Null check ... null value」崩溃 → 黑屏。
      if (mounted) _runAll();
    });
  }

  Future<void> _runAll() async {
    if (!mounted || _running) return;
    final mixedPort = ref.read(
      patchClashConfigProvider.select((s) => s.mixedPort),
    );
    final svc = DetectionService(mixedPort);
    final checks = svc.all;
    setState(() {
      _running = true;
      _ipLoading = true;
      _results = List.generate(
        checks.length,
        // 防御:将来 all/_names 数量失配唔会 RangeError 崩检测页。
        (i) => UnlockResult(
          i < _names.length ? _names[i] : '检测项',
          status: UnlockStatus.loading,
        ),
      );
    });
    svc.exitIp().then((v) {
      if (mounted) setState(() { _ip = v; _ipLoading = false; });
    });
    for (var i = 0; i < checks.length; i++) {
      final res = await checks[i]();
      if (!mounted) return;
      setState(() {
        final next = [..._results];
        next[i] = res;
        _results = next;
      });
    }
    await _runLatency(svc);
    if (mounted) setState(() => _running = false);
  }

  // 延迟测试:两组并发量往返,量完各组一次性刷新(避免 loading 时 null 误显「超时」)。
  Future<void> _runLatency(DetectionService svc) async {
    if (!mounted) return;
    setState(() {
      _domestic = const [];
      _intl = const [];
    });
    final dom = await Future.wait(_domesticTargets.entries
        .map((e) async => LatencyResult(e.key, await svc.ping(e.value))));
    if (mounted) setState(() => _domestic = dom);
    final intl = await Future.wait(_intlTargets.entries
        .map((e) async => LatencyResult(e.key, await svc.ping(e.value))));
    if (mounted) setState(() => _intl = intl);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('检测'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FilledButton.tonalIcon(
              onPressed: _running ? null : _runAll,
              icon: _running
                  ? const SizedBox(
                      width: 16, height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.refresh, size: 18),
              label: const Text('全部检测'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('解锁检测',
                style: Theme.of(context).textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            LayoutBuilder(builder: (_, c) {
              final cols = c.maxWidth > 900 ? 3 : (c.maxWidth > 560 ? 2 : 1);
              return GridView.count(
                crossAxisCount: cols,
                childAspectRatio: 2.6,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: _results
                    .map((r) => _UnlockCard(result: r))
                    .toList(),
              );
            }),
            const SizedBox(height: 24),
            Text('延迟测试',
                style: Theme.of(context).textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text('国内应直连(快),国际经节点。数值越低越好。',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: cs.onSurfaceVariant.withValues(alpha: 0.7))),
            const SizedBox(height: 12),
            LayoutBuilder(builder: (_, c) {
              final twoCol = c.maxWidth > 640;
              final domestic = _LatencyGroup(
                  title: '国内',
                  accent: const Color(0xFF16A34A), // 绿
                  results: _domestic);
              final intl = _LatencyGroup(
                  title: '国际',
                  accent: const Color(0xFFF59E0B), // 橙
                  results: _intl);
              if (twoCol) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: domestic),
                    const SizedBox(width: 12),
                    Expanded(child: intl),
                  ],
                );
              }
              return Column(
                children: [domestic, const SizedBox(height: 12), intl],
              );
            }),
            const SizedBox(height: 24),
            Text('IP 分流测试',
                style: Theme.of(context).textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            _IpCard(ip: _ip, loading: _ipLoading, cs: cs),
          ],
        ),
      ),
    );
  }
}

/// 延迟测试分组卡(国内=绿 / 国际=橙 标题;每行目标+ms,颜色点按延迟档)。
class _LatencyGroup extends StatelessWidget {
  final String title;
  final Color accent;
  final List<LatencyResult> results;
  const _LatencyGroup(
      {required this.title, required this.accent, required this.results});

  Color _dot(int? ms) {
    if (ms == null) return const Color(0xFFEF4444); // 红:超时
    if (ms < 300) return const Color(0xFF16A34A); // 绿:快
    if (ms < 800) return const Color(0xFFF59E0B); // 橙:一般
    return const Color(0xFFEF4444); // 红:慢
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Card(
      elevation: 0,
      color: cs.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration:
                      BoxDecoration(color: accent, shape: BoxShape.circle),
                ),
                const SizedBox(width: 8),
                Text(title,
                    style: tt.titleSmall?.copyWith(
                        color: accent, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            if (results.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2)),
                    SizedBox(width: 10),
                    Text('测试中…'),
                  ],
                ),
              )
            else
              ...results.map((r) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      children: [
                        Expanded(child: Text(r.name, style: tt.bodyMedium)),
                        Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                              color: _dot(r.ms), shape: BoxShape.circle),
                        ),
                        Text(
                          r.ms == null ? '超时' : '${r.ms} ms',
                          style: tt.bodyMedium?.copyWith(
                              color: _dot(r.ms), fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  )),
          ],
        ),
      ),
    );
  }
}

class _UnlockCard extends StatelessWidget {
  final UnlockResult result;
  const _UnlockCard({required this.result});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final loading = result.status == UnlockStatus.loading;
    final ok = result.status == UnlockStatus.yes;
    final color = loading
        ? cs.outline
        : (ok ? const Color(0xFF16A34A) : const Color(0xFFDC2626));
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(14),
        border: Border(left: BorderSide(color: color, width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(result.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.w700)),
          Row(
            children: [
              if (loading)
                const SizedBox(
                    width: 16, height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2))
              else
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(ok ? Icons.check_circle : Icons.cancel,
                        size: 14, color: color),
                    const SizedBox(width: 4),
                    Text(ok ? 'Yes' : 'No',
                        style: TextStyle(
                            color: color, fontWeight: FontWeight.w700, fontSize: 12)),
                  ]),
                ),
              const SizedBox(width: 8),
              if (result.region.isNotEmpty)
                Text('${countryCodeToEmoji(result.region)} ${result.region}',
                    style: const TextStyle(fontSize: 12)),
              if (result.note.isNotEmpty) ...[
                const SizedBox(width: 6),
                Flexible(
                  child: Text(result.note,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 11, color: cs.onSurfaceVariant)),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _IpCard extends StatelessWidget {
  final ExitIpInfo? ip;
  final bool loading;
  final ColorScheme cs;
  const _IpCard({required this.ip, required this.loading, required this.cs});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(14),
      ),
      child: loading
          ? const Center(child: Padding(
              padding: EdgeInsets.all(8), child: CircularProgressIndicator()))
          : ip == null
              ? Text('检测失败,请先连接后重试',
                  style: TextStyle(color: cs.onSurfaceVariant))
              : Wrap(
                  spacing: 28, runSpacing: 14,
                  children: [
                    _kv('IP 地址', ip!.ip.isEmpty ? '-' : ip!.ip),
                    _kv('国家/地区',
                        '${countryCodeToEmoji(ip!.countryCode)} ${ip!.country}'),
                    _kv('城市', ip!.city.isEmpty ? '-' : ip!.city),
                    _kv('ISP', ip!.isp.isEmpty ? '-' : ip!.isp),
                  ],
                ),
    );
  }

  Widget _kv(String k, String v) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(k, style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant)),
          const SizedBox(height: 3),
          Text(v, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      );
}
