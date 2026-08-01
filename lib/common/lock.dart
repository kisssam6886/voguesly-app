import 'dart:async';
import 'dart:io';

import 'package:fl_clash/common/common.dart';

class SingleInstanceLock {
  static SingleInstanceLock? _instance;
  RandomAccessFile? _accessFile;

  SingleInstanceLock._internal();

  factory SingleInstanceLock() {
    _instance ??= SingleInstanceLock._internal();
    return _instance!;
  }

  Future<bool> acquire() async {
    try {
      final lockFilePath = await appPath.lockFilePath;
      final lockFile = File(lockFilePath);
      await lockFile.create();
      _accessFile = await lockFile.open(mode: FileMode.write);
      await _accessFile?.lock();
      return true;
    } catch (_) {
      return false;
    }
  }
}

final singleInstanceLock = SingleInstanceLock();

/// Serializes asynchronous lifecycle operations without allowing one failed
/// operation to poison the queue for all later calls.
///
/// This is deliberately small and dependency-free because it is used by the
/// core/TUN lifecycle on every desktop target.  A second click while an
/// operation is in flight waits for the first one instead of starting a
/// competing helper/core restart.
class AsyncLock {
  Future<void> _tail = Future.value();

  Future<T> run<T>(Future<T> Function() action) {
    final previous = _tail;
    final done = Completer<void>();
    _tail = done.future;

    return previous.then((_) async {
      try {
        return await action();
      } finally {
        if (!done.isCompleted) done.complete();
      }
    });
  }
}
