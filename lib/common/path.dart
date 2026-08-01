import 'dart:async';
import 'dart:io';

import 'package:fl_clash/common/common.dart';
import 'package:crypto/crypto.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class AppPath {
  static AppPath? _instance;
  Completer<Directory> dataDir = Completer();
  Completer<Directory> downloadDir = Completer();
  Completer<Directory> tempDir = Completer();
  Completer<Directory> cacheDir = Completer();
  late String appDirPath;

  /// dataDir 解析后的同步快照 —— corePath 是同步 getter,拿不到 Future。
  String? _dataDirPath;

  AppPath._internal() {
    appDirPath = join(dirname(Platform.resolvedExecutable));
    getApplicationSupportDirectory().then((value) {
      _dataDirPath = value.path;
      dataDir.complete(value);
    });
    getTemporaryDirectory().then((value) {
      tempDir.complete(value);
    });
    getDownloadsDirectory().then((value) {
      downloadDir.complete(value);
    });
    getApplicationCacheDirectory().then((value) {
      cacheDir.complete(value);
    });
  }

  factory AppPath() {
    _instance ??= AppPath._internal();
    return _instance!;
  }

  String get executableExtension {
    return system.isWindows ? '.exe' : '';
  }

  String get executableDirPath {
    final currentExecutablePath = Platform.resolvedExecutable;
    return dirname(currentExecutablePath);
  }

  /// App bundle / 安装目录内自带的核心(签名产物,视为只读母本)。
  String get bundledCorePath {
    return join(executableDirPath, 'FlClashCore$executableExtension');
  }

  /// 实际拿来跑的核心路径。
  ///
  /// ⚠️ macOS 26 起,已公证签名的 app bundle 受「App 管理」保护:bundle 内的文件
  /// **连 root 都改不了**(实测 `sudo chown root:admin <bundle内核心>` →
  /// `Operation not permitted`,而同一条命令对 Application Support 下的文件成功)。
  /// 后果:`authorizeCore()` 的 `chown+chmod +s` 永远失败 → `checkIsAdmin()` 永远
  /// false → 每次 `_setupConfig`(含每小时订阅自动更新)都重新弹一次管理员密码,
  /// 而 TUN 仍被降级成 false。所以 macOS 改从 Application Support 下的副本执行,
  /// 该目录不受此保护,setuid 打得上、且一次授权长期有效。
  ///
  /// 副本由 [provisionExternalCore] 在 app 启动时铺好;若尚未就绪则回退到 bundle 内
  /// 路径(至少能把核心跑起来,只是 TUN 授权仍会失败)。
  String get corePath {
    if (system.isMacOS && _dataDirPath != null) {
      return join(_dataDirPath!, 'FlClashCore');
    }
    return bundledCorePath;
  }

  /// macOS 专用:把 bundle 内的核心铺到 Application Support 供执行。
  ///
  /// 只在「不存在」或「与 bundle 母本对不上」时才复制(核心 ~100MB,不能每次启动都搬)。
  /// 用母本 SHA-256 戳做比对,避免只靠 mtime 导致无谓替换并清掉 setuid。
  /// 复制走 `.new` + rename 原子替换,
  /// 避免旧核心进程仍在跑时写入报 ETXTBSY。
  ///
  /// 复制必然清掉 setuid 位(内核行为),所以只有核心内容真正更新时才需要重新授权一次。
  Future<void> provisionExternalCore() async {
    if (!system.isMacOS) return;
    try {
      final dir = await dataDir.future;
      _dataDirPath = dir.path;
      final src = File(bundledCorePath);
      if (!await src.exists()) {
        commonPrint.log('provisionExternalCore: bundle 内核心不存在,跳过');
        return;
      }
      final dstPath = join(dir.path, 'FlClashCore');
      final stampFile = File('$dstPath.stamp');
      final digest = await sha256.bind(src.openRead()).first;
      final stamp = digest.toString();
      if (await File(dstPath).exists() &&
          await stampFile.exists() &&
          (await stampFile.readAsString()).trim() == stamp) {
        return;
      }
      final tmpPath = '$dstPath.new';
      await File(tmpPath).delete().catchError((_) => File(tmpPath));
      // 优先用 APFS clonefile(`cp -c`):瞬时完成、不额外占 100MB 磁盘。
      // 非 APFS 卷会失败,回退到普通字节复制。
      final clone = await Process.run('cp', ['-c', bundledCorePath, tmpPath]);
      if (clone.exitCode != 0) {
        await src.copy(tmpPath);
      }
      await Process.run('chmod', ['755', tmpPath]);
      await File(tmpPath).rename(dstPath);
      await stampFile.writeAsString(stamp);
      commonPrint.log('provisionExternalCore: 已铺设核心 → $dstPath');
    } catch (e) {
      commonPrint.log('provisionExternalCore failed: $e');
    }
  }

  String get helperPath {
    return join(executableDirPath, '$appHelperService$executableExtension');
  }

  Future<String> get downloadDirPath async {
    final directory = await downloadDir.future;
    return directory.path;
  }

  Future<String> get homeDirPath async {
    final directory = await dataDir.future;
    return directory.path;
  }

  Future<String> get databasePath async {
    final mHomeDirPath = await homeDirPath;
    return join(mHomeDirPath, 'database.sqlite');
  }

  Future<String> get backupFilePath async {
    final mHomeDirPath = await homeDirPath;
    return join(mHomeDirPath, 'backup.zip');
  }

  Future<String> get restoreDirPath async {
    final mHomeDirPath = await homeDirPath;
    return join(mHomeDirPath, 'restore');
  }

  Future<String> get tempFilePath async {
    final mTempDir = await tempDir.future;
    return join(mTempDir.path, 'temp${utils.id}');
  }

  Future<String> get lockFilePath async {
    final homeDirPath = await appPath.homeDirPath;
    return join(homeDirPath, 'FlClash.lock');
  }

  Future<String> get configFilePath async {
    final mHomeDirPath = await homeDirPath;
    return join(mHomeDirPath, 'config.yaml');
  }

  Future<String> get sharedFilePath async {
    final mHomeDirPath = await homeDirPath;
    return join(mHomeDirPath, 'shared.json');
  }

  Future<String> get sharedPreferencesPath async {
    final directory = await dataDir.future;
    return join(directory.path, 'shared_preferences.json');
  }

  Future<String> get profilesPath async {
    final directory = await dataDir.future;
    return join(directory.path, profilesDirectoryName);
  }

  Future<String> getProfilePath(String fileName) async {
    return join(await profilesPath, '$fileName.yaml');
  }

  Future<String> get scriptsDirPath async {
    final path = await homeDirPath;
    return join(path, 'scripts');
  }

  Future<String> getScriptPath(String fileName) async {
    final path = await scriptsDirPath;
    return join(path, '$fileName.js');
  }

  Future<String> getIconsCacheDir() async {
    final directory = await cacheDir.future;
    return join(directory.path, 'icons');
  }

  Future<String> getProvidersRootPath() async {
    final directory = await profilesPath;
    return join(directory, 'providers');
  }

  Future<String> getProvidersDirPath(String id) async {
    final directory = await profilesPath;
    return join(directory, 'providers', id);
  }

  Future<String> getProvidersFilePath(
    String id,
    String type,
    String url,
  ) async {
    final directory = await profilesPath;
    return join(directory, 'providers', id, type, url.toMd5());
  }

  Future<String> get tempPath async {
    final directory = await tempDir.future;
    return directory.path;
  }
}

final appPath = AppPath();
