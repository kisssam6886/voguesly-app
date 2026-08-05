import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/models/models.dart';

class Migration {
  static Migration? _instance;
  late int _oldVersion;

  Migration._internal();

  // v3: existing desktop installs are migrated once back to TUN-first. The
  // dashboard may expose system proxy as an explicit compatibility fallback,
  // but an old systemProxy=true preference must not silently choose it for the
  // normal connection circle. Android keeps its platform VPN behaviour.
  final currentVersion = 3;

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
    if (_oldVersion < 3 && configMap != null && system.isDesktop) {
      _migrateDesktopConnectionDefaults(configMap);
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

  void _migrateDesktopConnectionDefaults(Map<String, Object?> configMap) {
    final networkRaw = configMap['networkProps'];
    final network = networkRaw is Map
        ? Map<String, Object?>.from(networkRaw)
        : <String, Object?>{};
    network['systemProxy'] = false;
    configMap['networkProps'] = network;

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
