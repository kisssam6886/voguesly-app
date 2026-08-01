import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/core/core.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/core.dart';

import 'interface.dart';
import 'transport.dart';

class CoreService extends CoreHandlerInterface {
  static CoreService? _instance;

  late final IPCCoreTransport _transport;

  Completer<bool> _shutdownCompleter = Completer();

  final Map<String, Completer> _callbackCompleterMap = {};

  Process? _process;
  final AsyncLock _lifecycleLock = AsyncLock();
  Future<void>? _startFuture;

  factory CoreService() {
    _instance ??= CoreService._internal();
    return _instance!;
  }

  CoreService._internal() {
    _transport = IPCCoreTransport(
      address: system.isWindows ? windowsPipeName : unixSocketPath,
    );
    _initServer();
  }

  Future<void> handleResult(ActionResult result) async {
    final completer = _callbackCompleterMap[result.id];
    final data = await parasResult(result);
    if (result.id?.isEmpty == true) {
      coreEventManager.sendEvent(CoreEvent.fromJson(result.data));
    }
    if (completer?.isCompleted == true) {
      return;
    }
    completer?.complete(data);
  }

  Future<void> _initServer() async {
    await _transport.init();

    _transport.onDisconnect = () {
      _handleInvokeCrashEvent();
      if (!_shutdownCompleter.isCompleted) {
        _shutdownCompleter.complete(true);
      }
    };

    _transport.dataStream
        .transform(uint8ListToListIntConverter)
        .transform(utf8.decoder)
        .listen(
          (data) async {
            try {
              final dataJson = await data.trim().commonToJSON<dynamic>();
              handleResult(ActionResult.fromJson(dataJson));
            } catch (e) {
              commonPrint.log(
                'Failed to parse transport data: $e',
                logLevel: LogLevel.error,
              );
            }
          },
          onError: (error) {
            commonPrint.log(
              'Transport data stream error: $error',
              logLevel: LogLevel.error,
            );
          },
        );
  }

  void _handleInvokeCrashEvent() {
    coreEventManager.sendEvent(
      const CoreEvent(type: CoreEventType.crash, data: 'core done'),
    );
  }

  Future<void> start() {
    final existing = _startFuture;
    if (existing != null) return existing;
    final future = _lifecycleLock.run(_startImpl);
    _startFuture = future;
    return future.whenComplete(() {
      if (identical(_startFuture, future)) _startFuture = null;
    });
  }

  Future<void> _startImpl() async {
    if (_process != null) {
      // A stale process after a crash must be torn down before the next start.
      // Concurrent callers are coalesced by _startFuture, so this does not
      // create a second helper/TUN cycle.
      await _shutdownImpl(false);
    }
    if (system.isWindows && await system.checkIsAdmin()) {
      final isSuccess = await request.startCoreByHelper(_transport.address);
      if (isSuccess) {
        await _transport.connectionCompleter.future;
        return;
      }
    }
    // [TUN-DIAG] 核心启动前:打印核心路径 + 属主/权限位(看 setuid rws 有冇)。
    // 仅 macOS —— `stat -f` 是 BSD 格式,Linux 的 `stat -f` 语义不同、Windows 无 stat。
    if (system.isMacOS) {
      final corePathForStart = appPath.corePath;
      final statResult = await Process.run('stat', [
        '-f',
        '%Su:%Sg %Sp',
        corePathForStart,
      ]);
      commonPrint.log(
        '[TUN-DIAG] core start corePath=$corePathForStart '
        'stat="${statResult.stdout.toString().trim()}"',
        logLevel: LogLevel.info,
      );
    }
    try {
      _process = await Process.start(appPath.corePath, [_transport.address]);
    } catch (e) {
      commonPrint.log(
        'Failed to start core process: $e',
        logLevel: LogLevel.error,
      );
      _handleInvokeCrashEvent();
      return;
    }
    _process?.stdout.listen((_) {});
    _process?.stderr.listen((e) {
      final error = utf8.decode(e);
      if (error.isNotEmpty) {
        commonPrint.log(error, logLevel: LogLevel.warning);
      }
    });
    await _transport.connectionCompleter.future;
  }

  @override
  FutureOr<bool> destroy() async {
    await shutdown(false);
    await _transport.close();
    return true;
  }

  Future<void> sendMessage(String message) async {
    await _transport.connectionCompleter.future;
    _transport.send(message);
  }

  @override
  Future<bool> shutdown(bool isUser) =>
      _lifecycleLock.run(() => _shutdownImpl(isUser));

  Future<bool> _shutdownImpl(bool isUser) async {
    _shutdownCompleter = Completer();
    if (system.isWindows) {
      await request.stopCoreByHelper();
    }
    _transport.disconnected();
    _process?.kill();
    _process = null;
    _clearCompleter();
    if (isUser) {
      return _shutdownCompleter.future;
    } else {
      return true;
    }
  }

  void _clearCompleter() {
    for (final completer in _callbackCompleterMap.values) {
      completer.safeCompleter(null);
    }
  }

  @override
  Future<String> preload() async {
    await start();
    return '';
  }

  @override
  Future<T?> invoke<T>({
    required ActionMethod method,
    dynamic data,
    Duration? timeout,
  }) async {
    final id = '${method.name}#${utils.id}';
    _callbackCompleterMap[id] = Completer<T?>();
    sendMessage(json.encode(Action(id: id, method: method, data: data)));
    return (_callbackCompleterMap[id] as Completer<T?>).future.withTimeout(
      timeout: timeout,
      onLast: () {
        final completer = _callbackCompleterMap[id];
        completer?.safeCompleter(null);
        _callbackCompleterMap.remove(id);
      },
      tag: id,
      onTimeout: () => null,
    );
  }

  @override
  Completer get completer => _transport.connectionCompleter;
}

final coreService = system.isDesktop ? CoreService() : null;
