/// 易联 · 本机环境诊断
///
/// 由来:用户机上装咗其他代理软件係常态(Sam 自己部 Mac mini 就有小火箭)。
/// 出现「界面显示已连接、实际上唔到网」嗰阵,以前用户同客服都只能靠猜 —— UI 一切正常、
/// 核心又真係喺度跑,冇任何地方讲得出「而家系统代理其实指住第三方」。
/// 呢个模块专门负责**讲得出到底边个占咗乜**。
///
/// 🚫 铁律:只读、只动自己。
/// 永远唔杀第三方进程、唔改第三方设置。理由(2026-08-05 定案):
///   · 做唔干净 —— 各家实现唔同(小火箭=系统扩展、Tailscale=daemon、Clash Verge=普通 App),
///     写唔出可靠通杀;
///   · 会闯祸 —— Tailscale 可能係用户连公司内网嘅唯一通道,杀咗轻则断内网、重则被当流氓软件。
/// 所以页面上唯一嘅动作按钮 = 重新写一次**易联自己**嘅系统代理设置。
library;

import 'dart:io';

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/enum/enum.dart';

enum DiagLevel { ok, warn, bad, info }

class DiagItem {
  final String title;
  final String value;

  /// 补充说明(点解係咁 / 用户要做乜)。可为空。
  final String? detail;
  final DiagLevel level;

  const DiagItem({
    required this.title,
    required this.value,
    required this.level,
    this.detail,
  });
}

class LocalDiagnosis {
  final List<DiagItem> items;

  /// 一句话结论 —— 用户只睇呢句都应该知自己有冇事。
  final String verdict;
  final DiagLevel level;

  /// 系统代理被第三方接管(决定「重设易联的系统代理」掣要唔要露)。
  final bool systemProxyHijacked;

  const LocalDiagnosis({
    required this.items,
    required this.verdict,
    required this.level,
    this.systemProxyHijacked = false,
  });
}

/// 已知第三方代理 / VPN 软件。key = 进程名或路径入面嘅特征串(小写),value = 显示名。
///
/// ⚠️ 唔好加过于通用嘅词(例如单独一个 'vpn'),会误报到系统组件度,反而吓亲用户。
// ⚠️ 唔可以係 const:value 係要跟语言变嘅显示名(key 係进程名,永远唔翻译)。
Map<String, String> get _knownThirdParty => <String, String>{
  'clash verge': 'Clash Verge',
  'clash-verge': 'Clash Verge',
  'clash for windows': 'Clash for Windows',
  'clashx': 'ClashX',
  'mihomo-party': 'Mihomo Party',
  // 裸 mihomo 内核(自己命令行跑嘅)一样会绑端口。⚠️ 易联自己个核心叫 FlClashCore,
  // 唔叫 mihomo,所以呢条唔会误伤自己。
  'mihomo': currentAppLocalizations.vgMihomoCore,
  'flclash': currentAppLocalizations.vgFlClashOriginal,
  'shadowrocket': currentAppLocalizations.vgShadowrocket,
  'macpackettunnel': currentAppLocalizations.vgShadowrocket,
  'surge': 'Surge',
  'quantumult': 'Quantumult X',
  'stash': 'Stash',
  'loon': 'Loon',
  'v2ray': currentAppLocalizations.vgV2RayFamilyClient,
  'nekoray': 'NekoRay',
  'sing-box': 'sing-box',
  'singbox': 'sing-box',
  'tailscale': 'Tailscale',
  'outline': 'Outline',
  'daed': 'daed',
  'wireguard': 'WireGuard',
  'openvpn': 'OpenVPN',
};

/// 自己人:扫第三方嗰阵要剔走,否则会「检测到 FlClash」—— 其实係易联自己个核心
/// (二进制仍叫 FlClashCore,易联係 FlClash fork)。呢个误报好难解释,必须排除。
/// (`com.follow.clash` = 我哋自己个 tun helper 嘅 bundle id,唔好当第三方 clash。)
const _ourOwn = [
  'voguesly',
  'flclashcore',
  'flclashco', // ⚠️ lsof 默认截 9 字符;虽然已改用 +c 0,呢个前缀留住做兜底
  'com.follow.clash',
  'yilian',
];

Future<String> _run(String exe, List<String> args) async {
  try {
    final result = await Process.run(
      exe,
      args,
    ).timeout(const Duration(seconds: 6));
    return '${result.stdout}';
  } catch (e) {
    commonPrint.log('[DIAG] $exe 执行失败: $e', logLevel: LogLevel.debug);
    return '';
  }
}

/// 端口有冇人喺度听(跨平台兜底)。只答「有冇」,唔答「係边个」。
Future<bool> _portInUse(int port) async {
  if (port <= 0) return false;
  try {
    final socket = await Socket.connect(
      InternetAddress.loopbackIPv4,
      port,
      timeout: const Duration(milliseconds: 800),
    );
    socket.destroy();
    return true;
  } catch (_) {
    return false;
  }
}

/// 谁在监听某端口(桌面)。返回进程名;识别唔到返 null。
Future<String?> _portOwner(int port) async {
  if (port <= 0) return null;
  if (system.isMacOS || system.isLinux) {
    // ⚠️ 实测(2026-08-05 Sam 机)两个坑,两个都会令诊断讲错嘢:
    //  ① `lsof` **默认把 COMMAND 截到 9 个字符** —— `MacPacketTunnel`→`MacPacket`、
    //     `FlClashCore`→`FlClashCo`。冇 `+c 0` 嘅话,连我哋自己个核心都会认唔返,
    //     反过来报「被其他程序占用」。必须加 `+c 0` 攞全名。
    //  ② 易联核心係 **setuid root** 跑嘅,冇 sudo 嘅 lsof **睇唔到 root 嘅 socket**,
    //     所以正常情况下呢度好可能返 null。呢个唔係故障 —— 下面靠 _portInUse()
    //     嘅 connect 测试做主判据,识别唔到 owner 一律唔当坏。
    final out = await _run('lsof', [
      '-nP',
      '+c',
      '0',
      '-iTCP:$port',
      '-sTCP:LISTEN',
    ]);
    for (final line in out.split('\n').skip(1)) {
      final parts = line.trim().split(RegExp(r'\s+'));
      if (parts.length >= 2 && parts.first.isNotEmpty) return parts.first;
    }
    return null;
  }
  if (system.isWindows) {
    final netstat = await _run('netstat', ['-ano', '-p', 'TCP']);
    for (final line in netstat.split('\n')) {
      if (!line.contains(':$port ') || !line.toUpperCase().contains('LISTENING')) {
        continue;
      }
      final parts = line.trim().split(RegExp(r'\s+'));
      final pid = parts.isNotEmpty ? parts.last : '';
      if (pid.isEmpty) continue;
      final tasks = await _run('tasklist', [
        '/FI',
        'PID eq $pid',
        '/FO',
        'CSV',
        '/NH',
      ]);
      final first = tasks.split('\n').firstWhere(
        (item) => item.trim().isNotEmpty,
        orElse: () => '',
      );
      if (first.isEmpty) continue;
      final name = first.split(',').first.replaceAll('"', '').trim();
      if (name.isNotEmpty) return name;
    }
  }
  return null;
}

/// 由长到短排好嘅 key,畀 _scanThirdParty 用:先试最具体嗰条,命中即停。
/// 唔可以直接遍历 map(Dart map 保持插入次序,'mihomo' 排喺 'mihomo-party' 之后
/// 只係碰啱,加多几条就唔保证)。
final List<String> _thirdPartyKeysLongestFirst = _knownThirdParty.keys.toList()
  ..sort((a, b) => b.length.compareTo(a.length));

bool _isOurs(String name) {
  final lower = name.toLowerCase();
  return _ourOwn.any(lower.contains);
}

/// 扫本机运行紧嘅第三方代理软件。**净係读进程列表,乜都唔郁。**
Future<List<String>> _scanThirdParty() async {
  if (!system.isDesktop) return const [];
  final output = system.isWindows
      ? await _run('tasklist', const [])
      : await _run('ps', const ['-axo', 'comm=']);
  final found = <String>{};
  for (final rawLine in output.split('\n')) {
    final line = rawLine.toLowerCase();
    if (line.trim().isEmpty || _isOurs(line)) continue;
    // ⚠️ key 之间存在子串关系(例如 'mihomo' ⊂ 'mihomo-party'),
    // 逐条 contains 而唔 break 嘅话,一个 mihomo-party 进程会同时命中两条,
    // 诊断页就会把同一个软件列成「Mihomo Party」+「mihomo 内核」两个,误导用户。
    // 解法:由长到短试,命中最具体嗰条即停(一行 = 一个进程名,唔会有两个软件)。
    for (final key in _thirdPartyKeysLongestFirst) {
      if (line.contains(key)) {
        found.add(_knownThirdParty[key]!);
        break;
      }
    }
  }
  return found.toList()..sort();
}

/// macOS:公网流量行紧边个接口,嗰个接口係咪易联嘅 TUN。
///
/// ⚠️ 判据**唔可以用 `route get default`**。macOS 上 mihomo/sing-tun 係用两条更具体嘅
/// 路由(0.0.0.0/1 + 128.0.0.0/1)覆盖式接管,**从来唔会替换 default**,所以 TUN 完全
/// 正常嗰阵 `route get default` 照样返物理网卡。呢个误判就係 0.9.62–0.9.64 整条断网
/// bug 链嘅源头,唔可以喺诊断页度再犯一次。
Future<({bool ours, String? name, List<String> foreign})> _macTun() async {
  final hits = <String>{};
  for (final destination in const ['1.1.1.1', '8.8.8.8']) {
    final out = await _run('route', ['-n', 'get', destination]);
    final line = out.split('\n').firstWhere(
      (item) => item.trim().startsWith('interface:'),
      orElse: () => '',
    );
    if (line.isEmpty) continue;
    final name = line.split(':').skip(1).join(':').trim();
    if (name.startsWith('utun')) hits.add(name);
  }
  final foreign = <String>[];
  for (final name in hits) {
    final info = await _run('ifconfig', [name]);
    // mihomo TUN 固定攞 198.18.0.0/30。第三方(Tailscale 100.64/10、其他 VPN)一样开
    // utun,单睇接口名会认错,所以用 inet 地址做归属判据。
    if (info.contains('inet 198.18.')) return (ours: true, name: name, foreign: <String>[]);
    foreign.add(name);
  }
  return (ours: false, name: null, foreign: foreign);
}

/// macOS 系统代理而家实际指住边度。返回 'host:port',冇开返 null。
Future<String?> _macSystemProxyTarget() async {
  final out = await _run('/usr/sbin/scutil', const ['--proxy']);
  if (out.isEmpty) return null;
  String? pick(String enableKey, String hostKey, String portKey) {
    final enabled = RegExp('$enableKey\\s*:\\s*1').hasMatch(out);
    if (!enabled) return null;
    final host = RegExp('$hostKey\\s*:\\s*(\\S+)').firstMatch(out)?.group(1);
    final port = RegExp('$portKey\\s*:\\s*(\\d+)').firstMatch(out)?.group(1);
    if (host == null || port == null) return null;
    return '$host:$port';
  }

  return pick('HTTPEnable', 'HTTPProxy', 'HTTPPort') ??
      pick('HTTPSEnable', 'HTTPSProxy', 'HTTPSPort') ??
      pick('SOCKSEnable', 'SOCKSProxy', 'SOCKSPort');
}

Future<String?> _windowsSystemProxyTarget() async {
  const base =
      r'HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings';
  final enabled = await _run('reg', ['query', base, '/v', 'ProxyEnable']);
  if (!enabled.toLowerCase().contains('0x1')) return null;
  final server = await _run('reg', ['query', base, '/v', 'ProxyServer']);
  final match = RegExp(r'ProxyServer\s+REG_SZ\s+(\S+)').firstMatch(server);
  return match?.group(1);
}

/// 跑一次完整本机诊断。
///
/// [mixedPort] 易联核心听紧嘅本地混合端口;[coreRunning] 核心係咪已启动;
/// [tunPreferred] 用户设置入面有冇开虚拟网卡。
Future<LocalDiagnosis> diagnoseLocal({
  required int mixedPort,
  required bool coreRunning,
  required bool tunPreferred,
}) async {
  final items = <DiagItem>[];

  if (!coreRunning) {
    return LocalDiagnosis(
      items: [],
      verdict: currentAppLocalizations.vgNotConnectedTapCircle,
      level: DiagLevel.info,
    );
  }

  // ── Android:唔使(亦冇权限)扫其他 App,但要讲清楚点解唔会静默冲突 ──────────
  if (system.isAndroid) {
    final listening = await _portInUse(mixedPort);
    items.add(DiagItem(
      title: currentAppLocalizations.vgVirtualNicVpn,
      value: currentAppLocalizations.vgVogueslyInControl,
      level: DiagLevel.ok,
      detail: currentAppLocalizations.vgAndroidOneVpnHint +
          currentAppLocalizations.vgAndroidOneVpnHint2,
    ));
    items.add(DiagItem(
      title: currentAppLocalizations.vgLocalPortNum(mixedPort),
      value: listening ? currentAppLocalizations.vgListening : currentAppLocalizations.vgNotListening,
      level: listening ? DiagLevel.ok : DiagLevel.warn,
      detail: listening
          ? null
          : currentAppLocalizations.vgPortMaybeTakenAndroid +
              currentAppLocalizations.vgPortMaybeTakenAndroid2,
    ));
    return LocalDiagnosis(
      items: items,
      verdict: listening ? currentAppLocalizations.vgLocalEnvOk : currentAppLocalizations.vgOnlineButChecksAffected,
      level: listening ? DiagLevel.ok : DiagLevel.warn,
    );
  }

  if (!system.isDesktop) {
    return LocalDiagnosis(
      items: [],
      verdict: currentAppLocalizations.vgPlatformNoLocalDiag,
      level: DiagLevel.info,
    );
  }

  // ── 桌面 ────────────────────────────────────────────────────────────────
  final thirdParty = await _scanThirdParty();

  // ① 虚拟网卡(主路径)
  var tunOurs = false;
  if (system.isMacOS) {
    final tun = await _macTun();
    tunOurs = tun.ours;
    items.add(DiagItem(
      title: currentAppLocalizations.vgVirtualNicTun,
      value: tunOurs ? currentAppLocalizations.vgVogueslyInControlWith(tun.name ?? '') : (tunPreferred ? currentAppLocalizations.vgNotInControl : currentAppLocalizations.vgNotEnabled),
      level: tunOurs
          ? DiagLevel.ok
          : (tunPreferred ? DiagLevel.bad : DiagLevel.info),
      detail: tunOurs
          ? currentAppLocalizations.vgPublicTrafficOnOurTun
          : tun.foreign.isNotEmpty
              ? currentAppLocalizations.vgPublicTrafficOnOtherTun(tun.foreign.join('、')) +
                  currentAppLocalizations.vgLikelyAnotherVpnTookRoute
              : (tunPreferred
                  ? currentAppLocalizations.vgTunOnButNoUtun
                  : currentAppLocalizations.vgTunOffUsingCompatMode),
    ));
  } else {
    final route = await _run('route', const ['print', '-4']);
    tunOurs = route.contains('198.18.') || route.contains('198.19.');
    items.add(DiagItem(
      title: currentAppLocalizations.vgVirtualNicTun,
      value: tunOurs ? currentAppLocalizations.vgVogueslyInControl : (tunPreferred ? currentAppLocalizations.vgNotInControl : currentAppLocalizations.vgNotEnabled),
      level: tunOurs
          ? DiagLevel.ok
          : (tunPreferred ? DiagLevel.bad : DiagLevel.info),
      detail: tunOurs
          ? currentAppLocalizations.vgRouteTableSeesOurTun
          : (tunPreferred
              ? currentAppLocalizations.vgTunOnButNotInRouteTable
              : currentAppLocalizations.vgTunOffUsingCompatMode),
    ));
  }

  // ② 系统代理(兼容路径)—— 全机得一份设置,谁后写谁赢,呢度只讲真话
  final target = system.isMacOS
      ? await _macSystemProxyTarget()
      : await _windowsSystemProxyTarget();
  final ours = target != null &&
      (target.endsWith(':$mixedPort') || target.contains(':$mixedPort'));
  final hijacked = target != null && !ours;
  items.add(DiagItem(
    title: currentAppLocalizations.vgSystemProxy,
    value: target == null
        ? currentAppLocalizations.vgNotEnabled
        : (ours ? currentAppLocalizations.vgPointsToVogueslyWith(target) : currentAppLocalizations.vgTakenByOtherAppWith(target)),
    level: target == null
        ? DiagLevel.info
        : (ours ? DiagLevel.ok : DiagLevel.warn),
    detail: hijacked
        ? currentAppLocalizations.vgSystemProxySingleSlot(target, mixedPort) +
            (tunOurs
                ? currentAppLocalizations.vgTunUnaffectedNote
                : currentAppLocalizations.vgTunAlsoNotInControlNote)
        : null,
  ));

  // ③ 本地端口 —— 「显示已连接但上唔到网」最难查嗰种
  final owner = await _portOwner(mixedPort);
  final inUse = owner != null || await _portInUse(mixedPort);
  final portOurs = owner == null ? inUse : _isOurs(owner);
  items.add(DiagItem(
    title: currentAppLocalizations.vgLocalPortNum(mixedPort),
    value: !inUse
        ? currentAppLocalizations.vgNotListening
        : (portOurs ? currentAppLocalizations.vgVogueslyListening : currentAppLocalizations.vgTakenByOtherProcessWith(owner ?? '')),
    level: !inUse
        ? DiagLevel.bad
        : (portOurs ? DiagLevel.ok : DiagLevel.bad),
    detail: portOurs
        ? null
        : (!inUse
            ? currentAppLocalizations.vgCoreFailedToBindPort
            : currentAppLocalizations.vgPortHeldByOther(owner ?? '', mixedPort) +
                currentAppLocalizations.vgPortHeldByOther2),
  ));

  // ④ 同场运行嘅其他代理软件 —— 纯提示,唔当错
  items.add(DiagItem(
    title: currentAppLocalizations.vgRunningAlongside,
    value: thirdParty.isEmpty ? currentAppLocalizations.vgNoOtherProxyDetected : thirdParty.join('、'),
    level: DiagLevel.info,
    detail: thirdParty.isEmpty
        ? null
        : currentAppLocalizations.vgCoexistFine,
  ));

  // ── 一句话结论 ──────────────────────────────────────────────────────────
  final hasTransport = tunOurs || ours;
  final portBlocked = inUse && !portOurs;
  final String verdict;
  final DiagLevel level;
  if (portBlocked) {
    verdict = currentAppLocalizations.vgLocalPortHeldSuggestChange(owner ?? '');
    level = DiagLevel.bad;
  } else if (!hasTransport) {
    verdict = currentAppLocalizations.vgNoPathCarryingTraffic;
    level = DiagLevel.bad;
  } else if (hijacked) {
    verdict = currentAppLocalizations.vgOnlineViaTunProxyTaken;
    level = DiagLevel.warn;
  } else {
    verdict = currentAppLocalizations.vgLocalEnvOkInControl(tunOurs
        ? currentAppLocalizations.vgVirtualNic
        : currentAppLocalizations.vgSystemProxy);
    level = DiagLevel.ok;
  }

  return LocalDiagnosis(
    items: items,
    verdict: verdict,
    level: level,
    systemProxyHijacked: hijacked,
  );
}
