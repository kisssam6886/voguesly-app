import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/state.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

/// macOS DMG update flow.
///
/// [2026-09-18 一键更新] dmg 唔再靠用户拖:app 自己 mount → 覆盖自己个 bundle → 重开。
/// 失败先退返旧路(开 Finder 畀用户拖,并先优雅退出免旧进程霸住 TUN)。
enum MacInstallStage { downloading, installing, relaunching, opening, error }

enum MacInstallFormat { dmg, pkg }

class MacInstallState {
  final MacInstallStage stage;
  final MacInstallFormat format;
  final double progress;
  final String? errorMessage;

  const MacInstallState({
    required this.stage,
    this.format = MacInstallFormat.dmg,
    this.progress = 0,
    this.errorMessage,
  });
}

class MacInstaller {
  static MacInstallFormat formatForUrl(String url) {
    final path = Uri.tryParse(url)?.path.toLowerCase() ?? url.toLowerCase();
    return path.endsWith('.pkg') ? MacInstallFormat.pkg : MacInstallFormat.dmg;
  }

  static Future<String> _download(
    String url,
    MacInstallFormat format,
    void Function(double progress) onProgress,
    CancelToken cancelToken,
  ) async {
    final dir = await appPath.homeDirPath;
    final updatesDir = Directory(p.join(dir, 'updates'));
    await updatesDir.create(recursive: true);
    final filename = format == MacInstallFormat.pkg
        ? 'voguesly-update.pkg'
        : 'voguesly-update.dmg';
    final savePath = p.join(updatesDir.path, filename);
    final old = File(savePath);
    if (await old.exists()) {
      try {
        await old.delete();
      } catch (_) {}
    }
    await request.dio.download(
      url,
      savePath,
      cancelToken: cancelToken,
      onReceiveProgress: (received, total) {
        if (total > 0) onProgress(received / total);
      },
    );
    final size = await old.length();
    if (size < 1024 * 1024) {
      throw StateError(currentAppLocalizations.vgInstallerFileIncomplete);
    }
    return savePath;
  }

  /// [2026-09-18 一键更新] dmg:下载 → 自己 mount → 覆盖装返自己个 bundle → 卸载 → 重开新版。
  /// 用户由头到尾只撳一次「一键更新」,进度条 0→100%,之后 app 自动退出再重开(Sam 要求)。
  /// 任何一步失败(冇写入权限 / dmg 内揾唔到 app)→ 退返旧路:开 Finder 畀用户自己拖。
  static Future<void> downloadInstallAndRelaunch({
    required String url,
    required void Function(MacInstallState state) onState,
  }) async {
    final cancelToken = CancelToken();
    final format = formatForUrl(url);
    onState(
      MacInstallState(stage: MacInstallStage.downloading, format: format),
    );
    String? path;
    try {
      path = await _download(
        url,
        format,
        (progress) => onState(
          MacInstallState(
            stage: MacInstallStage.downloading,
            format: format,
            progress: progress,
          ),
        ),
        cancelToken,
      );
    } catch (_) {
      onState(
        MacInstallState(
          stage: MacInstallStage.error,
          format: format,
          errorMessage: currentAppLocalizations.vgDownloadFailedRetryFull,
        ),
      );
      return;
    }
    if (format == MacInstallFormat.dmg) {
      onState(MacInstallState(stage: MacInstallStage.installing, format: format));
      final target = await _installDmgInPlace(path);
      if (target != null) {
        onState(MacInstallState(stage: MacInstallStage.relaunching, format: format));
        // 先排定重开(独立 shell,唔跟本进程一齐死),再走正常退出(停核心/TUN/托盘)。
        await Process.start(
          '/bin/sh',
          ['-c', 'sleep 2; /usr/bin/open -n "\$0"', target],
          mode: ProcessStartMode.detached,
          runInShell: false,
        );
        await Future<void>.delayed(const Duration(milliseconds: 500));
        await globalState.container
            .read(systemActionProvider.notifier)
            .handleExit();
        return;
      }
      commonPrint.log('[update] in-place install failed, fallback to Finder',
          logLevel: LogLevel.warning);
      globalState.showNotifier(currentAppLocalizations.vgInstallFallbackFinder);
    }
    await _openAndExit(path, format, onState);
  }

  /// 旧路(pkg / 自动装失败兜底):开 Finder/Installer,优雅退出,用户自己拖。
  static Future<void> _openAndExit(
    String path,
    MacInstallFormat format,
    void Function(MacInstallState state) onState,
  ) async {
    try {
      onState(MacInstallState(stage: MacInstallStage.opening, format: format));
      await Process.start(
        '/usr/bin/open',
        [path],
        mode: ProcessStartMode.detached,
        runInShell: false,
      );
      await Future<void>.delayed(const Duration(milliseconds: 700));
      await globalState.container
          .read(systemActionProvider.notifier)
          .handleExit();
    } catch (_) {
      onState(
        MacInstallState(
          stage: MacInstallStage.error,
          format: format,
          errorMessage: currentAppLocalizations.vgDownloadFailedRetryFull,
        ),
      );
    }
  }

  /// 而家行紧嘅 bundle 路径(…/Voguesly.app);唔似 .app 就当装喺 /Applications。
  static String _runningAppPath() {
    final exe = Platform.resolvedExecutable; // …/Voguesly.app/Contents/MacOS/Voguesly
    final app = p.dirname(p.dirname(p.dirname(exe)));
    return app.endsWith('.app') ? app : '/Applications/Voguesly.app';
  }

  static Future<ProcessResult> _run(String cmd, List<String> args) =>
      Process.run(cmd, args, runInShell: false);

  /// mount dmg → ditto 到 staging → detach → rm 旧 bundle → mv 入位 → 清 quarantine。
  /// 成功返目标 .app 路径;失败返 null(caller 兜底开 Finder)。
  static Future<String?> _installDmgInPlace(String dmgPath) async {
    final target = _runningAppPath();
    final updatesDir = p.dirname(dmgPath);
    final mnt = p.join(updatesDir, 'mnt-${DateTime.now().millisecondsSinceEpoch}');
    final staging = p.join(updatesDir, 'Voguesly-new.app');
    var mounted = false;
    try {
      await Directory(mnt).create(recursive: true);
      final att = await _run('/usr/bin/hdiutil', [
        'attach', '-nobrowse', '-noverify', '-noautoopen', '-quiet',
        '-mountpoint', mnt, dmgPath,
      ]);
      if (att.exitCode != 0) {
        commonPrint.log('[update] hdiutil attach failed: ${att.stderr}',
            logLevel: LogLevel.warning);
        return null;
      }
      mounted = true;
      final apps = Directory(mnt)
          .listSync()
          .whereType<Directory>()
          .where((d) => d.path.endsWith('.app'))
          .toList();
      if (apps.isEmpty) return null;
      final src = apps.firstWhere(
        (d) => p.basename(d.path) == 'Voguesly.app',
        orElse: () => apps.first,
      );
      final stagingDir = Directory(staging);
      if (await stagingDir.exists()) await stagingDir.delete(recursive: true);
      final cp = await _run('/usr/bin/ditto', [src.path, staging]);
      if (cp.exitCode != 0) return null;
      await _run('/usr/bin/hdiutil', ['detach', mnt, '-force', '-quiet']);
      mounted = false;
      // 写入权限探针:目标父目录写唔到(非 admin 用户装喺 /Applications)就唔好郁,兜底 Finder。
      final parent = Directory(p.dirname(target));
      final probe = File(p.join(parent.path, '.vg-update-probe'));
      try {
        await probe.writeAsString('x');
        await probe.delete();
      } catch (_) {
        return null;
      }
      final old = Directory(target);
      if (await old.exists()) {
        final rm = await _run('/bin/rm', ['-rf', target]);
        if (rm.exitCode != 0) return null;
      }
      final mv = await _run('/bin/mv', [staging, target]);
      if (mv.exitCode != 0) return null;
      await _run('/usr/bin/xattr', ['-dr', 'com.apple.quarantine', target]);
      commonPrint.log('[update] installed new bundle at $target');
      return target;
    } catch (e) {
      commonPrint.log('[update] in-place install error: $e',
          logLevel: LogLevel.warning);
      return null;
    } finally {
      if (mounted) {
        try {
          await _run('/usr/bin/hdiutil', ['detach', mnt, '-force', '-quiet']);
        } catch (_) {}
      }
      try {
        final d = Directory(mnt);
        if (await d.exists()) await d.delete(recursive: true);
      } catch (_) {}
    }
  }
}

class MacUpdateSheet extends StatefulWidget {
  const MacUpdateSheet({super.key, required this.url, required this.version});

  final String url;
  final String version;

  @override
  State<MacUpdateSheet> createState() => _MacUpdateSheetState();
}

class _MacUpdateSheetState extends State<MacUpdateSheet> {
  MacInstallState _state = const MacInstallState(
    stage: MacInstallStage.downloading,
  );

  @override
  void initState() {
    super.initState();
    _start();
  }

  void _start() {
    MacInstaller.downloadInstallAndRelaunch(
      url: widget.url,
      onState: (state) {
        if (mounted) setState(() => _state = state);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_title, style: context.textTheme.titleMedium),
            const SizedBox(height: 6),
            Text(
              currentAppLocalizations.vgVersionNumber(widget.version),
              style: context.textTheme.bodyMedium?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),
            if (_state.stage == MacInstallStage.downloading) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: _state.progress > 0 ? _state.progress : null,
                  minHeight: 6,
                  backgroundColor: cs.surfaceContainerHighest,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${(_state.progress * 100).toStringAsFixed(0)}%',
                style: context.textTheme.bodySmall?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),
            ],
            if (_state.stage == MacInstallStage.installing) ...[
              const LinearProgressIndicator(minHeight: 6),
              const SizedBox(height: 8),
              Text(currentAppLocalizations.vgInstallingUpdate),
            ],
            if (_state.stage == MacInstallStage.relaunching)
              Text(currentAppLocalizations.vgRelaunchingApp),
            if (_state.stage == MacInstallStage.opening)
              Text(
                _state.format == MacInstallFormat.pkg
                    ? currentAppLocalizations.vgPkgOpenedQuitting
                    : currentAppLocalizations.vgDmgOpenedQuitting,
              ),
            if (_state.stage == MacInstallStage.error) ...[
              Text(
                _state.errorMessage ?? currentAppLocalizations.vgDownloadFailedRetryFull,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFFEF4444),
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton(onPressed: _start, child: Text(currentAppLocalizations.vgRetry)),
            ],
          ],
        ),
      ),
    );
  }

  String get _title => switch (_state.stage) {
    MacInstallStage.downloading => currentAppLocalizations.vgDownloadingUpdate,
    MacInstallStage.installing => currentAppLocalizations.vgInstallingUpdate,
    MacInstallStage.relaunching => currentAppLocalizations.vgRelaunchingApp,
    MacInstallStage.opening => currentAppLocalizations.vgPreparingInstall,
    MacInstallStage.error => currentAppLocalizations.vgDownloadFailed,
  };
}
