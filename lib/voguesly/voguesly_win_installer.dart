import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fl_clash/common/common.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

/// Windows app 内自我更新:下载 setup.exe(带进度)→ 直接起系统安装程序(NSIS/Inno)。
/// 对齐安卓体验:用户唔使去浏览器/Downloads 揾文件再双击。macOS 的 dmg 系拖拽安装,
/// 冇静默安装呢回事,仍走 launchUrl 浏览器下载(caller 分流)。
enum WinInstallStage { downloading, launching, error }

class WinInstallState {
  final WinInstallStage stage;
  final double progress; // 0.0-1.0,只喺 downloading 阶段有意义
  final String? errorMessage;

  const WinInstallState({
    required this.stage,
    this.progress = 0,
    this.errorMessage,
  });
}

class WinInstaller {
  static Future<String> _download(
    String url,
    void Function(double progress) onProgress,
    CancelToken cancelToken,
  ) async {
    final dir = await appPath.homeDirPath;
    final updatesDir = Directory(p.join(dir, 'updates'));
    if (!await updatesDir.exists()) {
      await updatesDir.create(recursive: true);
    }
    final savePath = p.join(updatesDir.path, 'voguesly-setup.exe');
    // 旧残留先删,免下载中断留半截 exe 起唔到。
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
        if (total <= 0) return;
        onProgress(received / total);
      },
    );
    return savePath;
  }

  /// 一站式:下载 → 起安装程序(detached,installer 自己管关旧进程/替换文件)。
  static Future<void> downloadAndRun({
    required String url,
    required void Function(WinInstallState state) onState,
  }) async {
    final cancelToken = CancelToken();
    onState(const WinInstallState(stage: WinInstallStage.downloading));
    try {
      final path = await _download(
        url,
        (progress) => onState(
          WinInstallState(
            stage: WinInstallStage.downloading,
            progress: progress,
          ),
        ),
        cancelToken,
      );
      onState(const WinInstallState(stage: WinInstallStage.launching));
      // detached:安装程序独立进程,即使本 app 之后被 installer 关掉都唔影响。
      await Process.start(
        path,
        const [],
        mode: ProcessStartMode.detached,
        runInShell: false,
      );
    } catch (_) {
      onState(
        WinInstallState(
          stage: WinInstallStage.error,
          errorMessage: currentAppLocalizations.vgDownloadFailedRetry,
        ),
      );
    }
  }
}

/// Windows 下载/安装进度弹窗(对齐 ApkUpdateSheet 样式:标题 + 版本号 + 进度条)。
class WinUpdateSheet extends StatefulWidget {
  const WinUpdateSheet({super.key, required this.url, required this.version});

  final String url;
  final String version;

  @override
  State<WinUpdateSheet> createState() => _WinUpdateSheetState();
}

class _WinUpdateSheetState extends State<WinUpdateSheet> {
  WinInstallState _state = const WinInstallState(
    stage: WinInstallStage.downloading,
  );

  @override
  void initState() {
    super.initState();
    _start();
  }

  void _start() {
    WinInstaller.downloadAndRun(
      url: widget.url,
      onState: (state) {
        if (!mounted) return;
        setState(() => _state = state);
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
              style: context.textTheme.bodyMedium
                  ?.copyWith(color: cs.onSurfaceVariant),
            ),
            const SizedBox(height: 20),
            if (_state.stage == WinInstallStage.downloading) ...[
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
                style: context.textTheme.bodySmall
                    ?.copyWith(color: cs.onSurfaceVariant),
              ),
            ],
            if (_state.stage == WinInstallStage.launching) ...[
              Text(
                currentAppLocalizations.vgInstallerStartedHint,
                style: context.textTheme.bodyMedium,
              ),
            ],
            if (_state.stage == WinInstallStage.error) ...[
              Text(
                _state.errorMessage ?? currentAppLocalizations.vgSomethingWentWrongRetry,
                style: context.textTheme.bodyMedium
                    ?.copyWith(color: const Color(0xFFEF4444)),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () {
                  setState(
                    () => _state = const WinInstallState(
                      stage: WinInstallStage.downloading,
                    ),
                  );
                  _start();
                },
                child: Text(currentAppLocalizations.vgRetry),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String get _title {
    switch (_state.stage) {
      case WinInstallStage.downloading:
        return currentAppLocalizations.vgDownloadingUpdate;
      case WinInstallStage.launching:
        return currentAppLocalizations.vgOpeningInstaller;
      case WinInstallStage.error:
        return currentAppLocalizations.vgDownloadFailed;
    }
  }
}
