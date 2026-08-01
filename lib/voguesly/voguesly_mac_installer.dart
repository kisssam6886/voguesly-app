import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/state.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

/// macOS DMG update flow.
///
/// A DMG cannot observe Finder's drag-to-Applications gesture.  We therefore
/// download and open it in-app, stop our core/TUN cleanly, and exit the old
/// process before the user performs the drag.  This prevents the old process
/// from retaining the TUN while the new bundle is installed.
enum MacInstallStage { downloading, opening, error }

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
      throw StateError('安装包文件不完整');
    }
    return savePath;
  }

  static Future<void> downloadOpenAndExit({
    required String url,
    required void Function(MacInstallState state) onState,
  }) async {
    final cancelToken = CancelToken();
    final format = formatForUrl(url);
    onState(
      MacInstallState(stage: MacInstallStage.downloading, format: format),
    );
    try {
      final path = await _download(
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
      onState(MacInstallState(stage: MacInstallStage.opening, format: format));
      await Process.start(
        '/usr/bin/open',
        [path],
        mode: ProcessStartMode.detached,
        runInShell: false,
      );
      // Give Finder/Installer a moment to open before shutting down. The
      // actual mount/install remains under macOS's normal signed flow.
      await Future<void>.delayed(const Duration(milliseconds: 700));
      await globalState.container
          .read(systemActionProvider.notifier)
          .handleExit();
    } catch (_) {
      onState(
        MacInstallState(
          stage: MacInstallStage.error,
          format: format,
          errorMessage: '下载失败，请稍后重试',
        ),
      );
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
    MacInstaller.downloadOpenAndExit(
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
              '版本号: ${widget.version}',
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
            if (_state.stage == MacInstallStage.opening)
              Text(
                _state.format == MacInstallFormat.pkg
                    ? 'PKG 安装器已打开，易联正在安全退出。请按系统提示授权，安装器会覆盖 Applications 中的旧版本。'
                    : 'DMG 已打开，易联正在安全退出。请把新版本拖入 Applications 覆盖旧版本。',
              ),
            if (_state.stage == MacInstallStage.error) ...[
              Text(
                _state.errorMessage ?? '下载失败，请稍后重试',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFFEF4444),
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton(onPressed: _start, child: const Text('重试')),
            ],
          ],
        ),
      ),
    );
  }

  String get _title => switch (_state.stage) {
    MacInstallStage.downloading => '正在下载更新',
    MacInstallStage.opening => '正在准备安装…',
    MacInstallStage.error => '下载失败',
  };
}
