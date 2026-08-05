import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/models/models.dart';

class Migration {
  static Migration? _instance;
  late int _oldVersion;

  Migration._internal();

  // v4: desktop stays TUN-first, but the migration must never switch off a
  // working system proxy.  v2/v3 forced systemProxy=false on every desktop
  // install; when TUN then failed to take over (permission, helper, route
  // probe) the user was left with no transport path at all and every request
  // timed out.  v4 only asserts the TUN-first preference and leaves the
  // compatibility fallback exactly as the user had it.
  // Android keeps its platform VPN behaviour.
  // v5: 端口去撞。旧版沿用 Clash 生态默认 7890 / 9090,而 Clash Verge、ClashX、
  // mihomo-party、原版 FlClash 全部都听呢两个;用户机上只要有其中一个,后启动
  // 嗰个就绑唔到端口 → 表现係「显示已连接但上唔到网」,极难排查。
  // v5 把仲係默认值嘅老配置搬去易联专属端口;**用户自己改过嘅唔郁**。
  final currentVersion = 5;

  factory Migration() {
    _instance ??= Migration._internal();
    return _instance!;
  }

  Future<Config> migrationIfNeeded(
    Map<String, Object?>? configMap, {
    required Future<Config> Function(MigrationData data) sync,
  }) async {
    _oldVersion = await preferences.getVersion();
    if (_oldVersion == currentVersion) {
      try {
        return Config.realFromJson(configMap);
      } catch (_) {
        final isV0 = configMap?['proxiesStyle'] != null;
        if (isV0) {
          _oldVersion = 0;
        } else {
          throw 'Local data is damaged. A reset is required to fix this issue.';
        }
      }
    }
    if (_oldVersion < 4 && configMap != null && system.isDesktop) {
      _migrateDesktopConnectionDefaults(configMap);
    }
    if (_oldVersion < 5 && configMap != null) {
      _migrateAwayFromClashDefaultPorts(configMap);
    }
    MigrationData data = MigrationData(configMap: configMap);
    if (_oldVersion == 0 && configMap != null) {
      final clashConfigMap = await preferences.getClashConfigMap();
      if (clashConfigMap != null) {
        configMap['patchClashConfig'] = clashConfigMap;
        await preferences.clearClashConfig();
      }
      data = await _oldToNow(configMap);
    }
    final res = await sync(data);
    await preferences.setVersion(currentVersion);
    return res;
  }

  Future<MigrationData> _oldToNow(Map<String, Object?> configMap) async {
    return oldToNowTask(configMap);
  }

  /// 把仲用紧 Clash 生态默认端口(7890 / 9090)嘅老配置搬去易联专属端口。
  ///
  /// ⚠️ 只搬「仲係旧默认值」嗰啲 —— 用户自己改过嘅端口一律唔郁,否则会覆盖佢
  /// 自己嘅设置(例如佢特登配合第三方工具钉咗某个端口)。
  void _migrateAwayFromClashDefaultPorts(Map<String, Object?> configMap) {
    final patchRaw = configMap['patchClashConfig'];
    if (patchRaw is Map) {
      final patch = Map<String, Object?>.from(patchRaw);
      if (patch['mixed-port'] == 7890) {
        patch['mixed-port'] = defaultMixedPort;
        configMap['patchClashConfig'] = patch;
      }
    }
    // external-controller(9090)刻意唔搬:佢默认关闭、要用户主动开先监听,
    // 撞端口机会低好多;而佢係枚举 @JsonValue,改咗会令旧配置反序列化失败。
  }

  void _migrateDesktopConnectionDefaults(Map<String, Object?> configMap) {
    // ⚠️ 不要在这里关掉 systemProxy。
    // v2/v3 曾经无条件写 network['systemProxy'] = false,把兼容模式当成「旧偏好」清掉;
    // 一旦 TUN 之后接管失败(权限/helper/路由探测),用户就同时失去两条通路 —— 核心还在跑、
    // 端口还在听,但系统没有任何机制把流量送进去,表现就是「全部超时」而后台零流量。
    // TUN 优先是产品方向,但它不该以「先拆掉唯一的安全网」来实现。这里只声明 TUN 优先,
    // 兼容模式保持用户原样;真正的失败兜底交给 SetupAction._ensureFallbackTransport 处理。
    final patchRaw = configMap['patchClashConfig'];
    final patch = patchRaw is Map
        ? Map<String, Object?>.from(patchRaw)
        : <String, Object?>{};
    final tunRaw = patch['tun'];
    final tun = tunRaw is Map
        ? Map<String, Object?>.from(tunRaw)
        : <String, Object?>{};
    tun['enable'] = true;
    patch['tun'] = tun;
    configMap['patchClashConfig'] = patch;
  }
}

final migration = Migration();
