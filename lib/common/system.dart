import 'dart:ffi';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:ffi/ffi.dart';
import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/plugins/app.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/widgets/input.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart' show TextSpan;
import 'package:path/path.dart';

class System {
  static System? _instance;

  System._internal();

  factory System() {
    _instance ??= System._internal();
    return _instance!;
  }

  // macOS TUN 提权 helper(SMAppService LaunchDaemon)的 platform channel。
  // 原生侧实现在 macos/Runner/TunHelperManager.swift,只在 macOS 且 helper target 已接入时可用;
  // 未接入前 invoke 会抛 MissingPluginException,authorizeCore 会自动回退旧 osascript 逻辑。
  static const _tunHelperChannel = MethodChannel('voguesly/tunhelper');

  bool get isDesktop => isWindows || isMacOS || isLinux;

  bool get isWindows => Platform.isWindows;

  bool get isMacOS => Platform.isMacOS;

  bool get isAndroid => Platform.isAndroid;

  bool get isLinux => Platform.isLinux;

  Future<int> get version async {
    final deviceInfo = await DeviceInfoPlugin().deviceInfo;
    return switch (Platform.operatingSystem) {
      'macos' => (deviceInfo as MacOsDeviceInfo).majorVersion,
      'android' => (deviceInfo as AndroidDeviceInfo).version.sdkInt,
      'windows' => (deviceInfo as WindowsDeviceInfo).majorVersion,
      String() => 0,
    };
  }

  Future<bool> checkIsAdmin() async {
    // ⚠️ 这里**不能**对空格做转义。`Process.run` 不经 shell,参数是原样传给 stat 的;
    // 原来的 `replaceAll(' ', '\\\\ ')` 会把真实空格变成「反斜杠+空格」两个字符,
    // stat 直接 file-not-found → 恒返 false → TUN 授权永远过不去。
    // 旧的 corePath 在 /Applications/...app/Contents/MacOS/ 下没有空格,所以这个 bug 一直潜伏;
    // 核心搬到 `~/Library/Application Support/` 后路径含空格,会立刻引爆。
    final corePath = appPath.corePath;
    if (system.isWindows) {
      final result = await windows?.checkService();
      return result == WindowsHelperServiceStatus.running;
    } else if (system.isMacOS) {
      final result = await Process.run('stat', ['-f', '%Su:%Sg %Sp', corePath]);
      final output = result.stdout.trim();
      // [TUN-DIAG] 只加诊断,不改判定逻辑。若授权后 corePath 仍在只读的 AppTranslocation/
      // /private/var/folders 路径 => chmod +sx 无效 => 核心非 root => utun 创不成 => 假连接。
      final rawCorePath = appPath.corePath;
      final translocated =
          rawCorePath.contains('AppTranslocation') ||
          rawCorePath.contains('/private/var/folders');
      final isAdminDiag =
          output.startsWith('root:admin') && output.contains('rws');
      commonPrint.log(
        '[TUN-DIAG] checkIsAdmin macOS corePath=$rawCorePath '
        'translocated=$translocated statOutput="$output" isAdmin=$isAdminDiag',
        logLevel: LogLevel.info,
      );
      if (output.startsWith('root:admin') && output.contains('rws')) {
        return true;
      }
      return false;
    } else if (Platform.isLinux) {
      final result = await Process.run('stat', ['-c', '%U:%G %A', corePath]);
      final output = result.stdout.trim();
      if (output.startsWith('root:') && output.contains('rws')) {
        return true;
      }
      return false;
    }
    return true;
  }

  static String _shellEscape(String value) {
    return "'${value.replaceAll("'", "'\\''")}'";
  }

  /// 与 TunHelper (macos/TunHelper/main.swift kCoreRequirement) 保持一致的签名要求:
  /// 必须是 Apple 根信任链下、叶证书 OU == 我们 team 的产物。
  static const _macCoreRequirement =
      'anchor apple generic and certificate leaf[subject.OU] = "236T6T3629"';

  /// 校验将要被抬成 setuid-root 的核心确实是我们签的。失败一律拒绝提权。
  Future<bool> _verifyMacCoreSignature() async {
    try {
      final result = await Process.run('codesign', [
        '--verify',
        '--strict',
        '-R=$_macCoreRequirement',
        appPath.corePath,
      ]);
      final ok = result.exitCode == 0;
      commonPrint.log(
        '[TUN-DIAG] 核心验签 exitCode=${result.exitCode} ok=$ok '
        'stderr="${result.stderr.toString().trim()}"',
        logLevel: ok ? LogLevel.info : LogLevel.error,
      );
      return ok;
    } catch (e) {
      commonPrint.log('核心验签异常: $e', logLevel: LogLevel.error);
      return false;
    }
  }

  Future<AuthorizeCode> authorizeCore() async {
    if (system.isAndroid) {
      return AuthorizeCode.error;
    }
    final isAdmin = await checkIsAdmin();
    if (isAdmin) {
      return AuthorizeCode.none;
    }

    if (system.isWindows) {
      final result = await windows?.registerService();
      if (result == true && await checkIsAdmin()) {
        return AuthorizeCode.success;
      }
      return AuthorizeCode.error;
    }

    if (system.isMacOS) {
      // [TUN-DIAG] 进入 macOS 授权分支时的状态快照(不改逻辑)。
      commonPrint.log(
        '[TUN-DIAG] authorizeCore macOS enter isAdmin=$isAdmin '
        'corePath=${appPath.corePath}',
        logLevel: LogLevel.info,
      );
      // 纵深防线:核心已搬出 app bundle(见 AppPath.corePath 注释),落在用户可写目录。
      // 抬 setuid-root 之前必须验签,确保只有本 team 签名的核心能被提权 —— 否则任何
      // 以当前用户身份跑的进程只要事先把核心换掉,就能骗到一个 root shell(confused deputy)。
      if (!await _verifyMacCoreSignature()) {
        return AuthorizeCode.error;
      }
      // 加法:优先走 root helper(免重复密码)。返回 null = helper 不可用/未接入,回退旧 osascript。
      final helperResult = await _authorizeCoreViaMacHelper();
      if (helperResult != null) {
        return helperResult;
      }
      final escapedPath = _shellEscape(appPath.corePath);
      final shell = 'chown root:admin $escapedPath && chmod +sx $escapedPath';
      final arguments = [
        '-e',
        'do shell script "$shell" with administrator privileges',
      ];
      final result = await Process.run('osascript', arguments);
      // [TUN-DIAG] osascript 执行结果(exitCode + 截断 stderr)。
      final stderrStr = result.stderr.toString();
      commonPrint.log(
        '[TUN-DIAG] authorizeCore osascript exitCode=${result.exitCode} '
        'stderr="${stderrStr.substring(0, stderrStr.length > 300 ? 300 : stderrStr.length)}"',
        logLevel: LogLevel.info,
      );
      // [TUN-DIAG] 关键:授权后再核实一次 setuid 是否真的生效。
      // 若仍 false => translocation/只读路径 chmod 无效(实锤理论)。
      final postAuthIsAdmin = await checkIsAdmin();
      commonPrint.log(
        '[TUN-DIAG] authorizeCore post-auth checkIsAdmin=$postAuthIsAdmin '
        '(若授权后仍 false => 只读/translocation 路径 chmod 无效)',
        logLevel: LogLevel.info,
      );
      if (result.exitCode != 0 || !postAuthIsAdmin) {
        commonPrint.log(
          '[TUN-DIAG] authorizeCore failed post-auth verification',
          logLevel: LogLevel.error,
        );
        return AuthorizeCode.error;
      }
      return AuthorizeCode.success;
    } else if (Platform.isLinux) {
      final shell = Platform.environment['SHELL'] ?? 'bash';
      final password = await globalState.showCommonDialog<String>(
        child: InputDialog(
          obscureText: true,
          title: currentAppLocalizations.pleaseInputAdminPassword,
          value: '',
        ),
      );
      if (password == null || password.isEmpty) {
        return AuthorizeCode.error;
      }
      final escapedPassword = _shellEscape(password);
      final escapedCorePath = _shellEscape(appPath.corePath);
      final arguments = [
        '-c',
        'echo $escapedPassword | sudo -S chown root:root $escapedCorePath && echo $escapedPassword | sudo -S chmod +sx $escapedCorePath',
      ];
      final result = await Process.run(shell, arguments);
      if (result.exitCode != 0) {
        return AuthorizeCode.error;
      }
      return AuthorizeCode.success;
    }
    return AuthorizeCode.error;
  }

  // macOS:经 root helper 给核心打 setuid。
  // 返回值:
  //   AuthorizeCode.success —— helper 已把核心提权好。
  //   AuthorizeCode.error   —— 需用户在系统设置批准 helper(已弹引导),别再回退弹密码。
  //   null                  —— helper 未接入 / 不可用 / 提权失败,调用方回退旧 osascript 逻辑。
  Future<AuthorizeCode?> _authorizeCoreViaMacHelper() async {
    final corePath = appPath.corePath;
    try {
      // 先确保 daemon 已注册。首次会是 requiresApproval,引导用户去系统设置放行。
      final status = await _tunHelperChannel.invokeMethod<String>('register');
      if (status == 'requiresApproval') {
        await globalState.showMessage(
          title: currentAppLocalizations.tip,
          message: const TextSpan(
            text:
                '需要在「系统设置 → 通用 → 登录项与扩展」允许「易联」的后台项目,'
                '开启后重试即可开启 TUN,之后免密码。',
          ),
        );
        return AuthorizeCode.error;
      }
      if (status == 'unsupported') {
        // macOS <13: SMAppService is unavailable; keep the legacy path.
        return null;
      }
      if (status != 'enabled') {
        // The helper is present but not usable. Falling back to a password
        // prompt on every reconnect is the repeated-authorization bug.
        commonPrint.log(
          'tunhelper register status: $status',
          logLevel: LogLevel.error,
        );
        await globalState.showMessage(
          title: currentAppLocalizations.tip,
          message: const TextSpan(text: '易联后台 TUN 服务未启用，请在系统设置允许易联后台项目后重试。'),
        );
        return AuthorizeCode.error;
      }
      final result = await _tunHelperChannel
          .invokeMethod<Map<Object?, Object?>>('ensureSetuid', {
            'corePath': corePath,
          });
      if (result != null && result['ok'] == true) {
        return await checkIsAdmin()
            ? AuthorizeCode.success
            : AuthorizeCode.error;
      }
      commonPrint.log(
        'tunhelper ensureSetuid failed: ${result?['msg']}',
        logLevel: LogLevel.error,
      );
      return AuthorizeCode.error;
    } on MissingPluginException {
      // helper target 未接入(Xcode GUI 步骤未做)——回退,保证接入前 app 照常可用。
      return null;
    } on PlatformException catch (e) {
      commonPrint.log(
        'tunhelper channel error: ${e.message}',
        logLevel: LogLevel.error,
      );
      return AuthorizeCode.error;
    } catch (e) {
      commonPrint.log(
        'tunhelper unexpected error: $e',
        logLevel: LogLevel.error,
      );
      return AuthorizeCode.error;
    }
  }

  /// Returns a known third-party proxy/TUN process currently running.
  /// We warn instead of killing it: route ownership cannot be safely stolen
  /// from arbitrary VPN/network-extension clients.
  Future<String?> detectThirdPartyTunnel() async {
    if (!isDesktop) return null;
    try {
      final output = isWindows
          ? (await Process.run('tasklist', const [])).stdout.toString()
          : (await Process.run('ps', ['-axo', 'comm='])).stdout.toString();
      const known = [
        'clash verge',
        'clash-verge',
        'clashx',
        'clash meta',
        'mihomo-party',
        'daed',
        'sing-box',
        'singbox',
      ];
      final lower = output.toLowerCase();
      for (final name in known) {
        if (lower.contains(name) && await verifyDesktopTunTransport()) {
          return name;
        }
      }
    } catch (e) {
      commonPrint.log('third-party tunnel detection failed: $e');
    }
    return null;
  }

  /// Best-effort device-level TUN probe used for truthful desktop status.
  /// Mihomo desktop TUN should own the default route; if it does not, the
  /// green connected state is unsafe.
  Future<bool> verifyDesktopTunTransport() async {
    if (!isDesktop) return true;
    try {
      if (isMacOS) {
        final result = await Process.run('route', ['-n', 'get', 'default']);
        final line = result.stdout
            .toString()
            .split('\n')
            .firstWhere(
              (item) => item.trim().startsWith('interface:'),
              orElse: () => '',
            );
        final interfaceName = line.split(':').skip(1).join(':').trim();
        return interfaceName.startsWith('utun');
      }
      if (isWindows) {
        final result = await Process.run('route', ['print', '-4']);
        final output = result.stdout.toString();
        // Mihomo's default Wintun route is normally in the 198.18/16 test
        // network.  A missing route means the core process alone is not proof
        // that the device is actually tunneled.
        return output.contains('198.18.') || output.contains('198.19.');
      }
    } catch (e) {
      commonPrint.log(
        'desktop TUN probe failed: $e',
        logLevel: LogLevel.warning,
      );
      return false;
    }
    return true;
  }

  /// Best-effort check that the desktop system proxy is actually enabled and
  /// points at this core's mixed port. The setting provider is only intent;
  /// this probes the OS state so a green connection cannot hide a failed
  /// networksetup/registry write.
  Future<bool> verifyDesktopSystemProxy(int port) async {
    if (!isDesktop) return true;
    try {
      if (isMacOS) {
        final result = await Process.run('/usr/sbin/scutil', ['--proxy']);
        if (result.exitCode != 0) return false;
        final output = result.stdout.toString();
        final enabled = RegExp(
          r'(HTTPEnable|HTTPSEnable|SOCKSEnable)\s*:\s*1',
        ).hasMatch(output);
        if (!enabled) return false;
        return RegExp(
          r'(HTTPPort|HTTPSPort|SOCKSPort)\s*:\s*' + port.toString(),
        ).hasMatch(output);
      }
      if (isWindows) {
        final base = [
          r'HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings',
        ];
        final enabledResult = await Process.run('reg', [
          'query',
          ...base,
          '/v',
          'ProxyEnable',
        ]);
        final enabledOutput = enabledResult.stdout.toString().toLowerCase();
        if (enabledResult.exitCode != 0 || !enabledOutput.contains('0x1')) {
          return false;
        }
        final serverResult = await Process.run('reg', [
          'query',
          ...base,
          '/v',
          'ProxyServer',
        ]);
        final server = serverResult.stdout.toString().toLowerCase();
        return serverResult.exitCode == 0 &&
            (server.contains(':$port') || server.contains(port.toString()));
      }
    } catch (e) {
      commonPrint.log(
        'desktop system proxy probe failed: $e',
        logLevel: LogLevel.warning,
      );
      return false;
    }
    return true;
  }

  Future<void> back() async {
    await app?.moveTaskToBack();
    await window?.hide();
  }

  Future<void> exit() async {
    if (system.isAndroid) {
      await SystemNavigator.pop();
    }
    await window?.close();
    window?.forceExit();
  }
}

final system = System();

class Windows {
  static Windows? _instance;
  late DynamicLibrary _shell32;

  Windows._internal() {
    _shell32 = DynamicLibrary.open('shell32.dll');
  }

  factory Windows() {
    _instance ??= Windows._internal();
    return _instance!;
  }

  bool runas(String command, String arguments) {
    final commandPtr = command.toNativeUtf16();
    final argumentsPtr = arguments.toNativeUtf16();
    final operationPtr = 'runas'.toNativeUtf16();

    final shellExecute = _shell32
        .lookupFunction<
          Int32 Function(
            Pointer<Utf16> hwnd,
            Pointer<Utf16> lpOperation,
            Pointer<Utf16> lpFile,
            Pointer<Utf16> lpParameters,
            Pointer<Utf16> lpDirectory,
            Int32 nShowCmd,
          ),
          int Function(
            Pointer<Utf16> hwnd,
            Pointer<Utf16> lpOperation,
            Pointer<Utf16> lpFile,
            Pointer<Utf16> lpParameters,
            Pointer<Utf16> lpDirectory,
            int nShowCmd,
          )
        >('ShellExecuteW');

    final result = shellExecute(
      nullptr,
      operationPtr,
      commandPtr,
      argumentsPtr,
      nullptr,
      1,
    );

    calloc.free(commandPtr);
    calloc.free(argumentsPtr);
    calloc.free(operationPtr);

    commonPrint.log(
      'windows runas: $command $arguments resultCode:$result',
      logLevel: LogLevel.warning,
    );

    if (result <= 32) {
      return false;
    }
    return true;
  }

  // Future<void> _killProcess(int port) async {
  //   final result = await Process.run('netstat', ['-ano']);
  //   final lines = result.stdout.toString().trim().split('\n');
  //   for (final line in lines) {
  //     if (!line.contains(':$port') || !line.contains('LISTENING')) {
  //       continue;
  //     }
  //     final parts = line.trim().split(RegExp(r'\s+'));
  //     final pid = int.tryParse(parts.last);
  //     if (pid != null) {
  //      await Process.run('taskkill', ['/PID', pid.toString(), '/F']);
  //     }
  //   }
  // }

  Future<WindowsHelperServiceStatus> checkService() async {
    // final qcResult = await Process.run('sc', ['qc', appHelperService]);
    // final qcOutput = qcResult.stdout.toString();
    // if (qcResult.exitCode != 0 || !qcOutput.contains(appPath.helperPath)) {
    //   return WindowsHelperServiceStatus.none;
    // }
    final result = await Process.run('sc', ['query', appHelperService]);
    if (result.exitCode != 0) {
      return WindowsHelperServiceStatus.none;
    }
    final output = result.stdout.toString();
    if (output.contains('RUNNING') && await request.pingHelper()) {
      return WindowsHelperServiceStatus.running;
    }
    return WindowsHelperServiceStatus.presence;
  }

  Future<bool> registerService() async {
    final status = await checkService();

    if (status == WindowsHelperServiceStatus.running) {
      return true;
    }

    final command = [
      '/c',
      if (status == WindowsHelperServiceStatus.presence) ...[
        'taskkill',
        '/F',
        '/IM',
        '$appHelperService.exe'
            ' & '
            'sc',
        'delete',
        appHelperService,
        '&',
      ],
      'sc',
      'create',
      appHelperService,
      'binPath= "${appPath.helperPath}"',
      'start= auto',
      '&&',
      'sc',
      'start',
      appHelperService,
    ].join(' ');

    final res = runas('cmd.exe', command);

    await Future.delayed(const Duration(milliseconds: 300));
    final retryStatus = await retry(
      task: checkService,
      maxAttempts: 5,
      retryIf: (status) => status != WindowsHelperServiceStatus.running,
      delay: const Duration(seconds: 1),
    );
    return res && retryStatus == WindowsHelperServiceStatus.running;
  }

  Future<bool> registerTask(String appName) async {
    final taskXml =
        '''
<?xml version="1.0" encoding="UTF-16"?>
<Task version="1.3" xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task">
  <Principals>
    <Principal id="Author">
      <LogonType>InteractiveToken</LogonType>
      <RunLevel>HighestAvailable</RunLevel>
    </Principal>
  </Principals>
  <Triggers>
    <LogonTrigger/>
  </Triggers>
  <Settings>
    <MultipleInstancesPolicy>Parallel</MultipleInstancesPolicy>
    <DisallowStartIfOnBatteries>false</DisallowStartIfOnBatteries>
    <StopIfGoingOnBatteries>false</StopIfGoingOnBatteries>
    <AllowHardTerminate>false</AllowHardTerminate>
    <StartWhenAvailable>false</StartWhenAvailable>
    <RunOnlyIfNetworkAvailable>false</RunOnlyIfNetworkAvailable>
    <IdleSettings>
      <StopOnIdleEnd>false</StopOnIdleEnd>
      <RestartOnIdle>false</RestartOnIdle>
    </IdleSettings>
    <AllowStartOnDemand>true</AllowStartOnDemand>
    <Enabled>true</Enabled>
    <Hidden>false</Hidden>
    <RunOnlyIfIdle>false</RunOnlyIfIdle>
    <WakeToRun>false</WakeToRun>
    <ExecutionTimeLimit>PT72H</ExecutionTimeLimit>
    <Priority>7</Priority>
  </Settings>
  <Actions Context="Author">
    <Exec>
      <Command>"${Platform.resolvedExecutable}"</Command>
    </Exec>
  </Actions>
</Task>''';
    final taskPath = join(await appPath.tempPath, 'task.xml');
    await File(taskPath).create(recursive: true);
    await File(
      taskPath,
    ).writeAsBytes(taskXml.encodeUtf16LeWithBom, flush: true);
    final commandLine = [
      '/Create',
      '/TN',
      appName,
      '/XML',
      '%s',
      '/F',
    ].join(' ');
    return runas('schtasks', commandLine.replaceFirst('%s', taskPath));
  }
}

final windows = system.isWindows ? Windows() : null;

class MacOS {
  static MacOS? _instance;

  List<String>? originDns;

  MacOS._internal();

  factory MacOS() {
    _instance ??= MacOS._internal();
    return _instance!;
  }

  Future<String?> get defaultServiceName async {
    final result = await Process.run('route', ['-n', 'get', 'default']);
    final output = result.stdout.toString();
    final deviceLine = output
        .split('\n')
        .firstWhere((s) => s.contains('interface:'), orElse: () => '');
    final lineSplits = deviceLine.trim().split(' ');
    if (lineSplits.length != 2) {
      return null;
    }
    final device = lineSplits[1];
    final serviceResult = await Process.run('networksetup', [
      '-listnetworkserviceorder',
    ]);
    final serviceResultOutput = serviceResult.stdout.toString();
    final currentService = serviceResultOutput
        .split('\n\n')
        .firstWhere((s) => s.contains('Device: $device'), orElse: () => '');
    if (currentService.isEmpty) {
      return null;
    }
    final currentServiceNameLine = currentService
        .split('\n')
        .firstWhere(
          (line) => RegExp(r'^\(\d+\).*').hasMatch(line),
          orElse: () => '',
        );
    final currentServiceNameLineSplits = currentServiceNameLine.trim().split(
      ' ',
    );
    if (currentServiceNameLineSplits.length < 2) {
      return null;
    }
    return currentServiceNameLineSplits[1];
  }

  Future<List<String>?> get systemDns async {
    final deviceServiceName = await defaultServiceName;
    if (deviceServiceName == null) {
      return null;
    }
    final result = await Process.run('networksetup', [
      '-getdnsservers',
      deviceServiceName,
    ]);
    final output = result.stdout.toString().trim();
    if (output.startsWith("There aren't any DNS Servers set on")) {
      originDns = [];
    } else {
      originDns = output.split('\n');
    }
    return originDns;
  }

  Future<void> updateDns(bool restore) async {
    final serviceName = await defaultServiceName;
    if (serviceName == null) {
      return;
    }
    List<String>? nextDns;
    if (restore) {
      nextDns = originDns;
    } else {
      final originDns = await systemDns;
      if (originDns == null) {
        return;
      }
      const needAddDns = '223.5.5.5';
      if (originDns.contains(needAddDns)) {
        return;
      }
      nextDns = List.from(originDns)..add(needAddDns);
    }
    if (nextDns == null) {
      return;
    }
    await Process.run('networksetup', [
      '-setdnsservers',
      serviceName,
      if (nextDns.isNotEmpty) ...nextDns,
      if (nextDns.isEmpty) 'Empty',
    ]);
  }
}

final macOS = system.isMacOS ? MacOS() : null;
