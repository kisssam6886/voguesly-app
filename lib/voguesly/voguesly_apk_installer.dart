import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/plugins/app.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

/// app 内自我更新:下载 apk(带进度)→ 检查/引导「允许安装未知来源」权限 → 起系统安装器。
/// 只喺 Android 生效;其他平台冇 apk 安装呢回事,caller 应该 fallback 用 launchUrl。
enum ApkInstallStage { downloading, needPermission, installing, error }

class ApkInstallState {
  final ApkInstallStage stage;
  final double progress; // 0.0-1.0,只喺 downloading 阶段有意义
  final String? errorMessage;

  const ApkInstallState({
    required this.stage,
    this.progress = 0,
    this.errorMessage,
  });
}

class ApkInstaller {
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
    final savePath = p.join(updatesDir.path, 'voguesly-update.apk');
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

  /// 下载完成后尝试安装;冇权限就返回 false,caller 负责引导去设置页。
  static Future<bool> _tryInstall(String apkPath) async {
    if (app == null) return false;
    final canInstall = await app!.canRequestInstallPackages();
    if (!canInstall) return false;
    return app!.installApk(apkPath);
  }

  /// 一站式:下载 → 有权限就直接装 → 冇权限就把已下载好嘅路径存返嚟,
  /// 等用户去完设置页返嚟后用 [retryInstall] 再试一次,唔使重新下载。
  static String? _lastDownloadedPath;

  static Future<void> downloadAndInstall({
    required String url,
    required void Function(ApkInstallState state) onState,
  }) async {
    final cancelToken = CancelToken();
    onState(const ApkInstallState(stage: ApkInstallStage.downloading));
    try {
      final path = await _download(
        url,
        (progress) => onState(
          ApkInstallState(
            stage: ApkInstallStage.downloading,
            progress: progress,
          ),
        ),
        cancelToken,
      );
      _lastDownloadedPath = path;
      onState(const ApkInstallState(stage: ApkInstallStage.installing));
      final installed = await _tryInstall(path);
      if (!installed) {
        onState(const ApkInstallState(stage: ApkInstallStage.needPermission));
      }
    } catch (_) {
      onState(
        const ApkInstallState(
          stage: ApkInstallStage.error,
          errorMessage: '下载失败,请稍后重试',
        ),
      );
    }
  }

  /// 用户去完「允许安装未知来源」设置页返嚟后调用,唔使重新下载。
  static Future<bool> retryInstall() async {
    if (_lastDownloadedPath == null) return false;
    return _tryInstall(_lastDownloadedPath!);
  }

  static Future<void> requestPermission() async {
    if (app == null) return;
    await app!.requestInstallPackagesPermission();
  }
}

/// 下载/安装进度弹窗(仿 COCODUCK 样式:标题 + 版本号 + 进度条)。
/// 用 [WidgetsBindingObserver] 监听用户从「设置」页返回 app,自动重试安装。
class ApkUpdateSheet extends StatefulWidget {
  const ApkUpdateSheet({super.key, required this.url, required this.version});

  final String url;
  final String version;

  @override
  State<ApkUpdateSheet> createState() => _ApkUpdateSheetState();
}

class _ApkUpdateSheetState extends State<ApkUpdateSheet>
    with WidgetsBindingObserver {
  ApkInstallState _state = const ApkInstallState(
    stage: ApkInstallStage.downloading,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _start();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _start() {
    ApkInstaller.downloadAndInstall(
      url: widget.url,
      onState: (state) {
        if (!mounted) return;
        setState(() => _state = state);
      },
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState lifecycleState) {
    // 用户由「允许安装未知来源」设置页返嚟 app:自动重试安装,唔使佢自己再撳一次。
    if (lifecycleState == AppLifecycleState.resumed &&
        _state.stage == ApkInstallStage.needPermission) {
      ApkInstaller.retryInstall().then((installed) {
        if (!mounted) return;
        if (installed) {
          setState(
            () => _state = const ApkInstallState(
              stage: ApkInstallStage.installing,
            ),
          );
        }
      });
    }
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
            Text(
              _title,
              style: context.textTheme.titleMedium,
            ),
            const SizedBox(height: 6),
            Text(
              '版本号: ${widget.version}',
              style: context.textTheme.bodyMedium
                  ?.copyWith(color: cs.onSurfaceVariant),
            ),
            const SizedBox(height: 20),
            if (_state.stage == ApkInstallStage.downloading) ...[
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
            if (_state.stage == ApkInstallStage.needPermission) ...[
              Text(
                '安装更新需要「允许安装未知来源应用」权限,请去设置开启后返回,会自动继续安装。',
                style: context.textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => ApkInstaller.requestPermission(),
                child: const Text('去设置开启权限'),
              ),
            ],
            if (_state.stage == ApkInstallStage.error) ...[
              Text(
                _state.errorMessage ?? '出错了,请稍后重试',
                style: context.textTheme.bodyMedium
                    ?.copyWith(color: const Color(0xFFEF4444)),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () {
                  setState(
                    () => _state = const ApkInstallState(
                      stage: ApkInstallStage.downloading,
                    ),
                  );
                  _start();
                },
                child: const Text('重试'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String get _title {
    switch (_state.stage) {
      case ApkInstallStage.downloading:
        return '正在下载更新';
      case ApkInstallStage.needPermission:
        return '需要安装权限';
      case ApkInstallStage.installing:
        return '正在打开安装程序…';
      case ApkInstallStage.error:
        return '下载失败';
    }
  }
}
