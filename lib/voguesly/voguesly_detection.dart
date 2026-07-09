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
      // 持久连接:令延迟预热(第2/3次)复用同 host 连接、省 CONNECT 隧道+TLS 握手。
      persistentConnection: true,
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
        // keep-alive:保持连接池,idle 15s 内复用同 host,预热后第2/3次省握手。
        c.idleTimeout = const Duration(seconds: 15);
        c.maxConnectionsPerHost = 4;
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

  /// 带自定 headers 的探测(如 YouTube 绕同意墙要 Cookie/Accept-Language)。
  Future<({int? status, String body})> _probeWith(
    String url, {
    Map<String, String>? headers,
  }) async {
    try {
      final r = await _dio.get<String>(
        url,
        options: Options(headers: headers),
      );
      return (status: r.statusCode, body: r.data ?? '');
    } catch (_) {
      return (status: null, body: '');
    }
  }

  /// 测某目标延迟(ms)。经当前路由(核心按 Model A 分流:国内直连、国际经节点)。
  /// ⚠️ 旧法只打一次冷连接,量到 TCP+TLS 握手主导 + China→relay→node 长链路,
  /// 国际虚高 5-8 倍(误导)。改预热取 min:先打一次暖连接(丢弃),再打 2 次取最小,
  /// dio keep-alive 复用同 host 连接省握手 → 接近真实稳态 RTT。
  Future<int?> ping(String url) async {
    Future<int?> once() async {
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

    await once(); // 预热:建连+握手,唔计
    int? best;
    for (var i = 0; i < 2; i++) {
      final t = await once();
      if (t != null && (best == null || t < best)) best = t;
    }
    return best;
  }

  static const _blockedForOpenAI = {'CN', 'RU', 'KP', 'IR', 'SY', 'CU', 'HK'};

  Future<UnlockResult> chatgpt() async {
    final r = await _probe('https://chat.openai.com/cdn-cgi/trace');
    if (r.status != 200) {
      return const UnlockResult('ChatGPT', status: UnlockStatus.no);
    }
    final loc = RegExp(r'loc=([A-Z]{2})').firstMatch(r.body)?.group(1) ?? '';
    // 真端点:OpenAI 合规端点直接讲某地区支唔支持(比硬编码黑名单准)。
    final c = await _probe(
        'https://api.openai.com/compliance/cookie_requirements');
    if (c.status != null && c.body.toLowerCase().contains('unsupported_country')) {
      return UnlockResult('ChatGPT', status: UnlockStatus.no, region: loc, note: '地区不支持');
    }
    // 端点拿唔到就退回黑名单兜底。
    if (loc.isNotEmpty && _blockedForOpenAI.contains(loc)) {
      return UnlockResult('ChatGPT', status: UnlockStatus.no, region: loc, note: '地区不支持');
    }
    return UnlockResult('ChatGPT', status: UnlockStatus.yes, region: loc);
  }

  // Anthropic/Claude 不支持地区(补齐至竞品 10 国黑名单)。
  static const _blockedForClaude = {
    'AF', 'BY', 'CN', 'CU', 'HK', 'IR', 'KP', 'MO', 'RU', 'SY'
  };

  Future<UnlockResult> claude() async {
    final r = await _probe('https://claude.ai/cdn-cgi/trace');
    if (r.status == 200) {
      final loc = RegExp(r'loc=([A-Z]{2})').firstMatch(r.body)?.group(1) ?? '';
      if (loc.isNotEmpty && _blockedForClaude.contains(loc)) {
        return UnlockResult('Claude', status: UnlockStatus.no, region: loc, note: '地区限制');
      }
      return UnlockResult('Claude', status: UnlockStatus.yes, region: loc);
    }
    return const UnlockResult('Claude', status: UnlockStatus.no);
  }

  Future<UnlockResult> youtubePremium() async {
    // 带 hl=en + CONSENT cookie 绕欧盟同意墙(否则拿到脏 body 误判)。
    final r = await _probeWith(
      'https://www.youtube.com/premium?hl=en',
      headers: {
        'Cookie': 'CONSENT=YES+cb; YSC=abc; GPS=1',
        'Accept-Language': 'en-US,en;q=0.9',
      },
    );
    if (r.status == null) return const UnlockResult('YouTube Premium', status: UnlockStatus.no);
    if (r.body.contains('Premium is not available') ||
        r.body.contains('not available in your country') ||
        r.body.contains('not available in your region')) {
      return const UnlockResult('YouTube Premium', status: UnlockStatus.no, note: '地区不支持');
    }
    final cc = RegExp(r'"countryCode"\s*:\s*"([A-Z]{2})"').firstMatch(r.body)?.group(1) ??
        RegExp(r'"GL":"([A-Z]{2})"').firstMatch(r.body)?.group(1) ??
        '';
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
    // ⚠️ 旧 bug:disneyplus.com 首页恒含 "/welcome/unavailable" 路由常量,
    // 用 body.contains('unavailable') 会令所有节点恒判「地区限制」(误报,与真实解锁无关)。
    // 正解:关跟随重定向,睇被封地区 Disney 会否 302 到 /welcome/unavailable;
    // 200=可访问=解锁,3xx→/(welcome/)?unavailable=真地区限制。
    try {
      final r = await _dio.get<String>(
        'https://www.disneyplus.com/',
        options: Options(
          followRedirects: false,
          validateStatus: (s) => s != null && s < 500,
        ),
      );
      final code = r.statusCode ?? 0;
      final loc = (r.headers.value('location') ?? '').toLowerCase();
      if (code == 200) {
        return const UnlockResult('Disney+', status: UnlockStatus.yes);
      }
      if (code >= 300 && code < 400 && loc.contains('unavailable')) {
        return const UnlockResult('Disney+',
            status: UnlockStatus.no, note: '地区限制');
      }
      // 3xx 到别处(如登录/地区选择) / 403(Akamai 机器人拦) → 唔当地区限制,标检测失败。
      return const UnlockResult('Disney+',
          status: UnlockStatus.error, note: '检测失败');
    } catch (_) {
      return const UnlockResult('Disney+',
          status: UnlockStatus.error, note: '检测失败');
    }
  }

  Future<UnlockResult> spotify() async {
    // country-selector API 直接出地区码;403/451=地区封禁。
    final r = await _probe(
        'https://www.spotify.com/api/content/v1/country-selector?platform=web&format=json');
    if (r.status == 403 || r.status == 451) {
      return const UnlockResult('Spotify', status: UnlockStatus.no, note: '地区限制');
    }
    if (r.status != null && r.status! >= 200 && r.status! < 400) {
      final cc = RegExp(r'"countryCode"\s*:\s*"([A-Z]{2})"').firstMatch(r.body)?.group(1) ?? '';
      return UnlockResult('Spotify', status: UnlockStatus.yes, region: cc);
    }
    return const UnlockResult('Spotify', status: UnlockStatus.no);
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

  /// 出口 IP:多源 HTTPS 洗牌容错(去旧 HTTP 明文 ip-api.com,防泄漏+防单源失败)。
  /// 每源字段格式唔同,各自 parser;首个成功即返。
  Future<ExitIpInfo?> exitIp() async {
    final sources = <Future<ExitIpInfo?> Function()>[
      () => _ipFrom('https://api.ip.sb/geoip', (j) => ExitIpInfo(
            ip: (j['ip'] ?? '').toString(),
            countryCode: (j['country_code'] ?? '').toString(),
            country: (j['country'] ?? '').toString(),
            city: (j['city'] ?? '').toString(),
            isp: (j['isp'] ?? j['organization'] ?? '').toString(),
          )),
      () => _ipFrom('https://ipapi.co/json/', (j) => ExitIpInfo(
            ip: (j['ip'] ?? '').toString(),
            countryCode: (j['country_code'] ?? '').toString(),
            country: (j['country_name'] ?? '').toString(),
            city: (j['city'] ?? '').toString(),
            isp: (j['org'] ?? '').toString(),
          )),
      () => _ipFrom('https://ipwho.is/', (j) => ExitIpInfo(
            ip: (j['ip'] ?? '').toString(),
            countryCode: (j['country_code'] ?? '').toString(),
            country: (j['country'] ?? '').toString(),
            city: (j['city'] ?? '').toString(),
            isp: ((j['connection'] as Map?)?['isp'] ?? '').toString(),
          )),
    ]..shuffle();
    for (final s in sources) {
      final info = await s();
      if (info != null && info.ip.isNotEmpty) return info;
    }
    return null;
  }

  Future<ExitIpInfo?> _ipFrom(
    String url,
    ExitIpInfo Function(Map<String, dynamic>) parse,
  ) async {
    final r = await _probe(url);
    if (r.status == 200) {
      try {
        return parse(jsonDecode(r.body) as Map<String, dynamic>);
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
  // ⚠️ 用就近 CDN 边缘轻端点(几十字节、边缘命中),量到接近真实 RTT;
  // 唔好用主站根域(google.com/github.com 要完整 TLS 到源站数据中心 → 虚高)。
  static const _intlTargets = {
    'Cloudflare': 'https://cloudflare.com/cdn-cgi/trace', // CF anycast 边缘,最能反映到节点距离
    'Google': 'https://www.gstatic.com/generate_204', // gstatic CDN 204 空 body
    'YouTube': 'https://i.ytimg.com/generate_204', // YouTube 图片 CDN 边缘
    'jsDelivr': 'https://cdn.jsdelivr.net/npm/latency-test@1.0.0/generate_200', // 专为测延迟造
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
              // 手机 2 列起步(600 上 3、900 上 4),卡片紧凑,唔再单列占满版面(Sam 反馈)。
              final cols = c.maxWidth > 900 ? 4 : (c.maxWidth > 600 ? 3 : 2);
              // 2 列窄卡:名 + 徽章约需 aspectRatio 1.7(卡高≈卡宽/1.7);列越多卡越窄要更高。
              final ratio = cols >= 4 ? 2.1 : (cols == 3 ? 1.9 : 1.7);
              return GridView.count(
                crossAxisCount: cols,
                childAspectRatio: ratio,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
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
    final errored = result.status == UnlockStatus.error;
    final color = loading
        ? cs.outline
        : errored
            ? cs.outline // 检测失败=中性灰,唔当解锁失败(红)
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
                    Icon(
                        errored
                            ? Icons.help_outline
                            : (ok ? Icons.check_circle : Icons.cancel),
                        size: 14, color: color),
                    const SizedBox(width: 4),
                    Text(errored ? '检测失败' : (ok ? 'Yes' : 'No'),
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
