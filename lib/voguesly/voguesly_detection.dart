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

/// 分流路由测试:某服务经当前路由睇到嘅出口 IP(护城河可视化——国际走外国IP、国内走CN)。
class SplitRouteResult {
  final String name;
  final bool domestic; // true=国内服务(应走CN),false=国际(应走外国)
  final String ip;
  final String countryCode;
  final bool ok; // 分流係咪符合预期(国内→CN、国际→非CN)
  const SplitRouteResult({
    required this.name,
    required this.domestic,
    this.ip = '',
    this.countryCode = '',
    this.ok = false,
  });
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
    // ⚠️ /premium 页 813KB,经慢代理下唔完易超时 → 误报。用 stream 边读边匹配,
    // 命中地区信号即中止,唔下成个 813KB(快、稳、慳流量)。
    try {
      final resp = await _dio.get<ResponseBody>(
        'https://www.youtube.com/premium?hl=en',
        options: Options(
          headers: {
            'Cookie': 'SOCS=CAI; PREF=hl=en',
            'Accept-Language': 'en-US,en;q=0.9',
          },
          responseType: ResponseType.stream,
          receiveTimeout: const Duration(seconds: 15),
        ),
      );
      final buf = StringBuffer();
      String region = '';
      await for (final chunk in resp.data!.stream) {
        buf.write(String.fromCharCodes(chunk));
        final s = buf.toString();
        // 命中任一信号即可判定,中止下载。
        if (s.contains('www.google.cn')) {
          return const UnlockResult('YouTube Premium',
              status: UnlockStatus.no, region: 'CN', note: '地区不支持');
        }
        if (s.contains('Premium is not available') ||
            s.contains('not available in your country')) {
          return const UnlockResult('YouTube Premium',
              status: UnlockStatus.no, note: '地区不支持');
        }
        region = RegExp(r'"INNERTUBE_CONTEXT_GL"\s*:\s*"([A-Z]{2})"')
                .firstMatch(s)?.group(1) ??
            RegExp(r'"GL":"([A-Z]{2})"').firstMatch(s)?.group(1) ??
            region;
        // 拎到地区码 + 见到 Premium 信号 → 可用,即刻返(唔使下完)。
        if (region.isNotEmpty && s.contains('ad-free')) {
          return UnlockResult('YouTube Premium',
              status: UnlockStatus.yes, region: region);
        }
        // body 太大,读够 300KB 都未命中否定信号 → 当可用(有地区码用地区码)。
        if (buf.length > 300000) break;
      }
      // 读完/中断:有地区码=可用,否则检测失败。
      if (region.isNotEmpty) {
        return UnlockResult('YouTube Premium',
            status: UnlockStatus.yes, region: region);
      }
      return const UnlockResult('YouTube Premium',
          status: UnlockStatus.error, note: '检测失败');
    } catch (_) {
      return const UnlockResult('YouTube Premium',
          status: UnlockStatus.error, note: '检测失败');
    }
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

  // ⚠️ 旧 bug:用 pgc/view/web/season 元数据端点(基本唔做地区强制)+ 死 season_id →
  // 大陆(6633 已死返-404)恒 No、港澳台(42879 全球可看番)恒 Yes,睇落刚好相反。
  // 正解:用 pgc/player/web/playurl 播放端点(真做地区封锁);ep_id 用 lmc999 实测有效嘅。
  // code:0=可播(Yes)、-10403=地区限制(No)、-404/其余=死ID/检测失败(error,唔当地区限制)。
  Future<UnlockResult> _bili(String name, String epId) async {
    final r = await _probe(
      'https://api.bilibili.com/pgc/player/web/playurl'
      '?qn=0&otype=json&ep_id=$epId&fnval=16&fourk=1'
      '&session=b0f9c5e8f7a34d2e1c6b9a80d5f3e7c2&module=bangumi',
    );
    final code = RegExp(r'"code"\s*:\s*(-?\d+)').firstMatch(r.body)?.group(1);
    if (code == '0') {
      return UnlockResult(name, status: UnlockStatus.yes);
    }
    if (code == '-10403') {
      return UnlockResult(name, status: UnlockStatus.no, note: '地区限制');
    }
    // -404 死 ID / null 超时 / 其余 → 检测失败(唔好伪装成地区限制)。
    return UnlockResult(name, status: UnlockStatus.error, note: '检测失败');
  }

  // ⚠️ep_id 会随授权到期失效,需定期对照 lmc999 刷新。已用 D Band(国内)/9929(美国)/HK relay(香港)三地铁证:
  // 大陆专属 ep_id=307247:国内 code:0(能睇)、美国/香港 -10403 → 大陆区解锁。
  // 港澳台专属 ep_id=183799:香港 code:0(能睇!)、大陆/美国 -10403 → 真·港澳台区解锁。
  //   (⚠️268176 系台湾专属,香港都 -10403,唔啱做港澳台检测)。
  Future<UnlockResult> biliMainland() => _bili('哔哩哔哩大陆', '307247');
  Future<UnlockResult> biliHkMoTw() => _bili('哔哩哔哩港澳台', '183799');

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

  /// 分流路由测试:
  /// - 国际服务(Cloudflare/ChatGPT/Claude 真喺 CF)→ 用 cdn-cgi/trace 拎出口 IP+loc,验证走外国。
  /// - 国内服务(B站/微博 唔喺 CF)→ 唔可以用 cdn-cgi/trace(旧 bug 恒 404🌐)。改用
  ///   国内可达 IP 回显端点(myip.ipip.net),经直连拎到 CN IP = 分流正确(走本地)。
  static const _splitIntl = [
    ('Cloudflare', 'https://cloudflare.com/cdn-cgi/trace'),
    ('ChatGPT', 'https://chat.openai.com/cdn-cgi/trace'),
    ('Claude', 'https://claude.ai/cdn-cgi/trace'),
  ];

  Future<SplitRouteResult> _splitIntlOne(String name, String url) async {
    final r = await _probe(url);
    if (r.status == 200) {
      final ip = RegExp(r'ip=([0-9a-fA-F:.]+)').firstMatch(r.body)?.group(1) ?? '';
      final loc = RegExp(r'loc=([A-Z]{2})').firstMatch(r.body)?.group(1) ?? '';
      // 国际分流正确:出口≠CN 且拎到 loc(经节点走外国)。
      final ok = loc.isNotEmpty && loc != 'CN';
      return SplitRouteResult(
          name: name, domestic: false, ip: ip, countryCode: loc, ok: ok);
    }
    return SplitRouteResult(name: name, domestic: false);
  }

  /// 国内分流验证:测国内站(哔哩哔哩 API)经当前路由能否快速连通。
  /// ⚠️唔用 myip.ipip.net 判 IP(会被分流规则误导:该域名若走代理会返美国IP → 误判)。
  /// 国内站直连(Model A: bilibili→DIRECT)→ 快速返 200 = 分流正确走本地(绿 🇨🇳)。
  Future<SplitRouteResult> _splitDomestic() async {
    final sw = Stopwatch()..start();
    final r = await _probe('https://api.bilibili.com/x/web-interface/zone');
    sw.stop();
    // 能连通(bilibili API 200)= 国内路由通=直连 work。哔哩哔哩喺国内直连先快返。
    final ok = r.status == 200;
    return SplitRouteResult(
        name: '哔哩哔哩', domestic: true,
        ip: ok ? '${sw.elapsedMilliseconds}ms' : '',
        countryCode: ok ? 'CN' : '',
        ok: ok);
  }

  Future<List<SplitRouteResult>> splitTest() async {
    final results = await Future.wait([
      ..._splitIntl.map((t) => _splitIntlOne(t.$1, t.$2)),
      _splitDomestic(),
    ]);
    return results;
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
  List<SplitRouteResult> _split = const [];

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
    svc.splitTest().then((v) {
      if (mounted) setState(() => _split = v);
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
            Padding(
              padding: const EdgeInsets.only(top: 2, bottom: 10),
              child: Text('国际服务走外国出口、国内服务走本地 —— 智能分流实时验证',
                  style: TextStyle(fontSize: 12.5, color: cs.onSurfaceVariant)),
            ),
            _IpCard(ip: _ip, loading: _ipLoading, cs: cs),
            if (_split.isNotEmpty) ...[
              const SizedBox(height: 12),
              _SplitCard(items: _split, cs: cs),
            ],
          ],
        ),
      ),
    );
  }
}

/// 分流路由可视化:逐服务出口 IP + 国旗,国际→外国、国内→CN,一眼见分流 work(护城河)。
class _SplitCard extends StatelessWidget {
  final List<SplitRouteResult> items;
  final ColorScheme cs;
  const _SplitCard({required this.items, required this.cs});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          for (final s in items) _row(s),
        ],
      ),
    );
  }

  Widget _row(SplitRouteResult s) {
    final ok = s.ok;
    final okColor = ok ? const Color(0xFF16A34A) : const Color(0xFFDC2626);
    final flag = s.countryCode.isEmpty
        ? '🌐'
        : '${countryCodeToEmoji(s.countryCode)} ${s.countryCode}';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(ok ? Icons.check_circle : Icons.error_outline,
              size: 16, color: okColor),
          const SizedBox(width: 8),
          Text(s.name,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5)),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(s.domestic ? '国内' : '国际',
                style: TextStyle(fontSize: 10.5, color: cs.onSurfaceVariant)),
          ),
          const Spacer(),
          Text(flag,
              style: TextStyle(
                  fontSize: 12,
                  fontFeatures: const [],
                  color: cs.onSurface,
                  fontFamily: 'monospace')),
        ],
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
