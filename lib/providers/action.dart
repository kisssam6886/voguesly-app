import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/core/core.dart';
import 'package:fl_clash/database/database.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/plugins/app.dart';
import 'package:fl_clash/plugins/service.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../voguesly/voguesly_apk_installer.dart';
import '../voguesly/voguesly_auth.dart';
import '../voguesly/voguesly_mac_installer.dart';
import '../voguesly/voguesly_win_installer.dart';

part 'generated/action.g.dart';

@Riverpod(keepAlive: true)
class CommonAction extends _$CommonAction {
  @override
  void build() {}

  void updateStart() {
    ref
        .read(setupActionProvider.notifier)
        .updateStatus(!ref.read(isStartProvider));
  }

  void updateSpeedStatistics() {
    ref
        .read(appSettingProvider.notifier)
        .update((state) => state.copyWith(showTrayTitle: !state.showTrayTitle));
  }

  void updateMode() {
    ref.read(patchClashConfigProvider.notifier).update((state) {
      final index = Mode.values.indexWhere((item) => item == state.mode);
      if (index == -1) return state;
      final nextIndex = index + 1 > Mode.values.length - 1 ? 0 : index + 1;
      return state.copyWith(mode: Mode.values[nextIndex]);
    });
  }

  void updateRunTime() {
    final startTime = ref.read(setupActionProvider.notifier).startTime;
    if (startTime != null) {
      final startTimeStamp = startTime.millisecondsSinceEpoch;
      final nowTimeStamp = DateTime.now().millisecondsSinceEpoch;
      ref.read(runTimeProvider.notifier).value = nowTimeStamp - startTimeStamp;
    } else {
      ref.read(runTimeProvider.notifier).value = null;
    }
  }

  Future<void> updateTraffic() async {
    final onlyStatisticsProxy = ref.read(
      appSettingProvider.select((state) => state.onlyStatisticsProxy),
    );
    final traffic = await coreController.getTraffic(onlyStatisticsProxy);
    ref.read(trafficsProvider.notifier).addTraffic(traffic);
    ref.read(totalTrafficProvider.notifier).value = await coreController
        .getTotalTraffic(onlyStatisticsProxy);
  }

  Future<void> autoCheckUpdate() async {
    if (!ref.read(appSettingProvider).autoCheckUpdate) return;
    final res = await request.checkForUpdate();
    checkUpdateResultHandle(data: res);
  }

  // 「我的」页版本号手动点检查:唔理「不再提示」开关,一定检查+一定显示结果
  // (含「已是最新版」个案),俾 checkUpdateResultHandle 现成嘅 isUser 分支处理。
  Future<void> manualCheckUpdate() async {
    final res = await request.checkForUpdate();
    checkUpdateResultHandle(data: res, isUser: true);
  }

  Future<void> checkUpdateResultHandle({
    Map<String, dynamic>? data,
    bool isUser = false,
  }) async {
    // 网络/服务器异常:唔可以当「已最新」。手动检查先提示网络错,自动检查静默(唔打扰)。
    if (data != null && data['__net_error__'] == true) {
      if (isUser) {
        globalState.showMessage(
          title: currentAppLocalizations.checkUpdate,
          message: TextSpan(text: currentAppLocalizations.vgUpdateCheckNetworkError),
        );
      }
      return;
    }
    if (data != null) {
      final tagName = data['tag_name'];
      final body = data['body'];
      final submits = utils.parseReleaseBody(body);
      final context = globalState.navigatorKey.currentContext!;
      final textTheme = context.textTheme;
      final res = await globalState.showMessage(
        title: currentAppLocalizations.discoverNewVersion,
        message: TextSpan(
          text: '$tagName \n',
          style: textTheme.headlineSmall,
          children: [
            TextSpan(text: '\n', style: textTheme.bodyMedium),
            for (final submit in submits)
              TextSpan(text: '- $submit \n', style: textTheme.bodyMedium),
          ],
        ),
        confirmText: currentAppLocalizations.goDownload,
        cancelText: isUser ? null : currentAppLocalizations.noLongerRemind,
      );
      if (res == true) {
        final downloadUrl = data['download_url'] as String?;
        if (downloadUrl != null && downloadUrl.isNotEmpty) {
          final ver = tagName.toString().replaceFirst('v', '');
          if (system.isAndroid) {
            // app 内下载+安装(免用户手动去浏览器/Downloads揾文件再装)。
            if (context.mounted) {
              showModalBottomSheet(
                context: context,
                showDragHandle: true,
                isScrollControlled: true,
                builder: (_) => ApkUpdateSheet(url: downloadUrl, version: ver),
              );
            }
          } else if (system.isWindows) {
            // Windows:对齐安卓 —— app 内下载 setup.exe + 自动起安装程序,
            // 唔再净开浏览器叫用户自己去 Downloads 揾文件双击(Sam 要求「点击自动装」)。
            if (context.mounted) {
              showModalBottomSheet(
                context: context,
                showDragHandle: true,
                isScrollControlled: true,
                builder: (_) => WinUpdateSheet(url: downloadUrl, version: ver),
              );
            }
          } else {
            // macOS:应用内下载 DMG,先优雅停止核心/TUN 再打开 Finder。
            // Finder 的拖拽仍由用户完成;DMG 无法监听该动作。
            if (context.mounted) {
              showModalBottomSheet(
                context: context,
                showDragHandle: true,
                isScrollControlled: true,
                builder: (_) => MacUpdateSheet(url: downloadUrl, version: ver),
              );
            }
          }
        }
      } else if (!isUser && res == false) {
        ref
            .read(appSettingProvider.notifier)
            .update((state) => state.copyWith(autoCheckUpdate: false));
      }
    } else if (isUser) {
      globalState.showMessage(
        title: currentAppLocalizations.checkUpdate,
        message: TextSpan(text: currentAppLocalizations.checkUpdateError),
      );
    }
  }
}

@Riverpod(keepAlive: true)
class SetupAction extends _$SetupAction {
  Timer? _updateTimer;
  DateTime? startTime;
  int _updateTick = 0;
  int _nativeVerifyFailCount = 0;
  int _desktopTunVerifyFailCount = 0;
  int _desktopProxyVerifyFailCount = 0;
  DateTime? _desktopTunVerificationStartedAt;
  bool _desktopTunRecoveryAttempted = false;
  bool _desktopTunVerifyInFlight = false;

  /// 本次会话内 TUN 已被证实接管不了(授权失败 / 第三方占用 / 路由探测持续失败)。
  /// 置位后 `_requestAdmin` 不再重复尝试 TUN,避免「兜底→重启→又拿 TUN→又失败」死循环。
  /// ⚠️ 只在内存里,不落盘 —— 用户断开重连或重启 App 都会重新尝试 TUN。
  bool _desktopTunProvenBroken = false;

  /// 「系统代理被第三方抢咗」已经提示过一次(TUN 仲喺度接管紧嗰种情况)。
  /// 唔加呢个 flag 就会每 9 秒弹一次,变成骚扰。恢复正常时自动清返。
  bool _systemProxyHijackWarned = false;

  // ── 桌面隧道保活 / 静默断连自愈(2026-08-10)──────────────────────────
  // 背景:校园网 / 企业网 / 部分 CGNAT 会喺连接空闲约 5 分钟后回收 NAT 会话,HY2 亦
  // 有 idle 超时;而现有健康检查只睇本地路由表(utun / Wintun 路由仲喺),睇唔到「路由
  // 还在但整条路已死」呢种静默断连 —— 用户体感就係「放埋电脑几分钟就断,要刷新先返」。
  // 呢个保活每 45s 经隧道打一次 generate_204:
  //   ① 有周期性活动 → 消灭 idle 间隙,直接防止空闲回收(同时覆盖 vless/reality TCP
  //      同 HY2 两条路,唔使靠估到底边条死);
  //   ② 若整条路真係死咗(探活连续失败)→ 做一次受控核心重启自愈。
  // 全程仅桌面 + 已连接;连续 3 次(≈135s)先当真死、最快 90s 一次自愈、连续 3 次自愈
  // 无效即停手只保持探活+日志,最终兜底仍係既有兼容模式。Android 唔行呢套(有自己嘅
  // VpnService 生命周期 + 流量成本考虑)。
  Timer? _desktopKeepaliveTimer;
  bool _desktopKeepaliveInFlight = false;
  int _desktopKeepaliveFailStreak = 0;
  int _desktopKeepaliveRecoveryStreak = 0;
  DateTime? _lastDesktopKeepaliveRecoveryAt;

  bool get isStart => startTime != null && startTime!.isBeforeNow;

  @override
  void build() {}

  SetupParams get _setupParams {
    final selectedMap = ref.read(selectedMapProvider);
    final testUrl = ref.read(
      appSettingProvider.select((state) => state.testUrl),
    );
    return SetupParams(selectedMap: selectedMap, testUrl: testUrl);
  }

  void fullSetup() {
    if (!ref.read(initProvider)) return;
    ref.read(delayDataSourceProvider.notifier).value = {};
    applyProfile(force: true);
    ref.read(logsProvider.notifier).value = FixedList(500);
    ref.read(requestsProvider.notifier).value = FixedList(500);
  }

  Future<void> _handleStart() async {
    startTime ??= DateTime.now();
    //The local status must be updated when performing the run task
    ref.read(commonActionProvider.notifier).updateRunTime();
    ref.read(commonActionProvider.notifier).updateTraffic();
    if (!ref.read(suspendProvider)) {
      await coreController.startListener();
    }
    _desktopTunVerificationStartedAt ??= DateTime.now();
    _updateTick = 0;
    _nativeVerifyFailCount = 0;
    _desktopTunVerifyFailCount = 0;
    _desktopProxyVerifyFailCount = 0;
    // A profile refresh can call _handleStart again while the core is already
    // running.  Keep one timer only; duplicate timers used to race the TUN
    // probe and make a transient false result look like a sustained failure.
    _updateTimer?.cancel();
    _updateTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      ref.read(commonActionProvider.notifier).updateRunTime();
      ref.read(commonActionProvider.notifier).updateTraffic();
      // updateRunTime() 只靠 Dart 本地 startTime 计时,唔核实 native 是否真系建立咗 VPN
      // (例如权限被拒/核心启动失败时,native 侧从未真正连接,但 UI 会永久停喺「已连接」)。
      // 每 3s 向 native 核实一次真实状态,连续 2 次唔一致先纠正(避免瞬时抖动误判)。
      _updateTick++;
      if (_updateTick % 3 == 0) {
        _verifyNativeConnected();
        _verifyDesktopTunConnected();
        _verifyDesktopSystemProxyConnected();
      }
    });
    _startDesktopKeepalive();
  }

  /// 向 native 核实真实连接状态 + 打印诊断(入 in-app 日志,方便 Sam send 出嚟睇真相)。
  /// ⚠️ 关键:getRunTime 只反映核心 mixed-port running;系统有冇 VPN 接口(hasVpnTransport)
  /// 先係 TUN 真建立嘅信号 —— 「已连接但概览 VPN 无 + 走直连」= 核心起咗但 TUN 未建立。
  Future<void> _verifyNativeConnected() async {
    // ⚠️桌面(macOS/Win/Linux)冇 android VpnService,service.getRunTime() 永返 null,
    // 会令呢个本为 android 设计嘅 guard 误判「核心未 running」→ 自动断开 + 误报。
    // 桌面核心状态由 CoreService(Process + transport connectionCompleter)管,唔用呢个核实。
    if (!Platform.isAndroid) return;
    if (startTime == null) return; // 已经断咗(或已被纠正),唔使核实
    final nativeRunTime = await service?.getRunTime();
    List<ConnectivityResult> conn = const [];
    try {
      conn = await Connectivity().checkConnectivity();
    } catch (_) {}
    final hasVpn = conn.contains(ConnectivityResult.vpn);
    // 诊断日志(入 in-app 日志页):睇 TUN 到底有冇真建立
    commonPrint.log(
      'VPN核实 nativeRunTime=$nativeRunTime hasVpnTransport=$hasVpn conn=$conn',
      logLevel: LogLevel.info,
    );
    // 保守纠正:仅当核心都唔 running(nativeRunTime==null)先纠正,避免误断「已建立但泄漏」情况。
    // hasVpn 只做诊断打印,唔用嚟触发纠正(等睇真 log 先定 native 修法)。
    if (nativeRunTime != null) {
      _nativeVerifyFailCount = 0;
      return;
    }
    _nativeVerifyFailCount++;
    if (_nativeVerifyFailCount < 2) return;
    commonPrint.log(
      'VPN 核心未 running,UI 显示已连接=假,自动纠正',
      logLevel: LogLevel.warning,
    );
    startTime = null;
    _updateTimer?.cancel();
    _updateTimer = null;
    _nativeVerifyFailCount = 0;
    ref.read(runTimeProvider.notifier).value = null;
    globalState.showNotifier(currentAppLocalizations.vgVpnCouldNotConnect);
  }

  Future<void> _verifyDesktopTunConnected() async {
    if (!system.isDesktop || startTime == null) return;
    if (!ref.read(realTunEnableProvider)) return;
    if (_desktopTunVerifyInFlight) return;
    final verificationStartedAt = _desktopTunVerificationStartedAt;
    if (verificationStartedAt == null) return;
    final startupAge = DateTime.now().difference(verificationStartedAt);
    // macOS has to create the utun interface and publish routes after the
    // core listener starts.  Do not disconnect a user during that normal
    // convergence window.
    if (startupAge < const Duration(seconds: 20)) {
      commonPrint.log(
        '[TUN-DIAG] desktop transport startup grace '
        'age=${startupAge.inSeconds}s',
        logLevel: LogLevel.info,
      );
      return;
    }
    _desktopTunVerifyInFlight = true;
    late final bool ok;
    try {
      ok = await system.verifyDesktopTunTransport();
    } finally {
      _desktopTunVerifyInFlight = false;
    }
    // The user may have disconnected while the route probe was in flight.
    // Never let a stale probe tear down the next connection attempt.
    if (startTime == null || !ref.read(realTunEnableProvider)) return;
    commonPrint.log(
      '[TUN-DIAG] desktop transport ok=$ok',
      logLevel: ok ? LogLevel.info : LogLevel.warning,
    );
    if (ok) {
      _desktopTunVerifyFailCount = 0;
      return;
    }
    _desktopTunVerifyFailCount++;
    // Require a sustained failure.  The old three-sample guard stopped the
    // whole client roughly nine seconds after startup, which is exactly the
    // "green for a few seconds, then off" symptom users saw.
    if (_desktopTunVerifyFailCount < 5) return;

    if (!_desktopTunRecoveryAttempted) {
      _desktopTunRecoveryAttempted = true;
      _desktopTunVerifyFailCount = 0;
      commonPrint.log(
        '[TUN-DIAG] desktop transport failed repeatedly; '
        'performing one controlled core/TUN recovery',
        logLevel: LogLevel.warning,
      );
      // Cancel only our own timer/state.  CoreAction.restartCore() performs
      // the full core shutdown/start cycle without touching other VPNs.
      startTime = null;
      _desktopTunVerificationStartedAt = null;
      _updateTimer?.cancel();
      _updateTimer = null;
      ref.read(runTimeProvider.notifier).value = null;
      try {
        await ref.read(coreActionProvider.notifier).restartCore(true);
      } catch (e) {
        commonPrint.log(
          '[TUN-DIAG] controlled recovery failed: $e',
          logLevel: LogLevel.error,
        );
      }
      return;
    }

    _desktopTunVerifyFailCount = 0;
    // ⚠️ 这里**不能**再 handleStop() + shutdown()。
    // 旧实现把核心整个拆掉,而桌面端系统代理又是关的 —— 用户于是一条通路都不剩,
    // 表现就是「全部超时」。正确做法是保住核心,把这次会话降级到兼容模式,
    // 让流量仍然走得通,同时如实告诉用户当前不是整机接管。
    _desktopTunProvenBroken = true;
    ref.read(realTunEnableProvider.notifier).value = false;
    _ensureFallbackTransport(currentAppLocalizations.vgTunTwiceNoTakeover);
    // 带 TUN 配置的核心已经处于不确定状态,重启一次让它干净地以「无 TUN + mixed-port」
    // 起来;此时 _requestAdmin 会看到 _desktopTunProvenBroken 而不再重复索要授权。
    try {
      await ref.read(coreActionProvider.notifier).restartCore(true);
    } catch (e) {
      commonPrint.log(
        '[TUN-DIAG] fallback restart failed: $e',
        logLevel: LogLevel.error,
      );
    }
  }

  /// TUN 接管失败时保证设备仍然有一条可用通路。
  ///
  /// 背景(2026-08-05 根因):旧实现在失败时把 `tun.enable` 持久化写成 false,而桌面端
  /// `systemProxy` 又被迁移强制关掉 —— 两者同时为假时 `proxyState.isStart` 恒为 false,
  /// 核心进程还在跑、mixed-port 还在监听,但操作系统没有任何机制把流量送进去,
  /// 用户看到的就是「全部超时」,后台看到零流量。
  ///
  /// 现在改成:
  /// 1. **不再把失败落盘**。TUN 偏好保持用户的意图,下次连接照常重试(授权弹窗由
  ///    `_authorizeFailedThisSession` 单独限流,不会变成每小时骚扰)。
  /// 2. 若此刻系统代理是关的,**显式打开并明确告知用户**,而不是静默留下一个断网状态。
  ///    这不是「静默降级」:大圆圈会如实显示「已连接 · 系统代理」,仪表盘兼容模式卡片
  ///    同步变为打开,用户一眼看得出当前不是整机接管。
  void _ensureFallbackTransport(String reason) {
    final network = ref.read(networkSettingProvider);
    if (network.systemProxy) {
      globalState.showNotifier(currentAppLocalizations.vgKeptSystemProxyCarrying(reason));
      return;
    }
    ref
        .read(networkSettingProvider.notifier)
        .update((state) => state.copyWith(systemProxy: true));
    commonPrint.log(
      '[TUN-DIAG] fallback: enabled system proxy after TUN failure ($reason)',
      logLevel: LogLevel.warning,
    );
    globalState.showNotifier(
      currentAppLocalizations.vgTempEnabledSystemProxy(reason) +
      currentAppLocalizations.vgCompatModeOnlyProxyAware +
      currentAppLocalizations.vgReopenTunAfterPermission,
    );
  }

  Future<void> _verifyDesktopSystemProxyConnected() async {
    if (!system.isDesktop || startTime == null) return;
    // ⚠️ 唔可以再因为 TUN 开住就跳过呢个校验(旧实现:`if (realTunEnable) return;`)。
    // 实测(Sam Mac mini 2026-08-05):易联界面显示「系统代理(兼容模式)已开启」,
    // 但系统代理实际指住 1082(Shadowrocket 抢咗去)。TUN 一开就唔再校验,
    // 于是呢种「界面话自己接管紧、其实接管紧嘅係第三方」嘅状态永远冇人发现。
    // 呢条正正係 handoff §2.3 要求嘅「外部改动要即刻反映」。
    final network = ref.read(networkSettingProvider);
    if (!network.systemProxy) return;
    final ok = await system.verifyDesktopSystemProxy(
      ref.read(patchClashConfigProvider).mixedPort,
    );
    commonPrint.log(
      '[PROXY-DIAG] desktop system proxy ok=$ok',
      logLevel: ok ? LogLevel.info : LogLevel.warning,
    );
    if (ok) {
      _desktopProxyVerifyFailCount = 0;
      _systemProxyHijackWarned = false;
      return;
    }
    _desktopProxyVerifyFailCount++;
    if (_desktopProxyVerifyFailCount < 3) return;
    _desktopProxyVerifyFailCount = 0;

    // TUN 仲喺度接管紧 = 用户实际上网冇问题,只係兼容模式被人抢咗。
    // 呢种情况**唔可以断开**(旧实现 handleStop() 会连好地地嘅 TUN 一齐杀),
    // 只提示一次就够,唔好每 9 秒烦一次。
    if (ref.read(realTunEnableProvider)) {
      if (_systemProxyHijackWarned) return;
      _systemProxyHijackWarned = true;
      globalState.showNotifier(
        currentAppLocalizations.vgCompatModeTakenOver +
        currentAppLocalizations.vgTrafficStillOnTun +
        currentAppLocalizations.vgQuitOtherProxyToTakeOver,
      );
      return;
    }

    // TUN 都冇喺度 = 真係一条通路都冇,先至值得断开重来。
    await handleStop();
    ref.read(runTimeProvider.notifier).value = null;
    globalState.showNotifier(currentAppLocalizations.vgSystemProxyOccupied);
  }

  /// 启动桌面隧道保活定时器(见字段处说明)。幂等:每次连接/重启都重建单一定时器。
  void _startDesktopKeepalive() {
    if (!system.isDesktop) return;
    _desktopKeepaliveTimer?.cancel();
    _desktopKeepaliveFailStreak = 0;
    // ⚠️ _desktopKeepaliveRecoveryStreak 唔喺度清 —— 佢要跨越自愈重启存活先做到「连续
    // 自愈无效就停手」嘅反死循环;只喺探活成功或用户主动断开(handleStop)先清。
    _desktopKeepaliveTimer = Timer.periodic(
      const Duration(seconds: 45),
      (_) => _desktopKeepaliveTick(),
    );
  }

  Future<void> _desktopKeepaliveTick() async {
    if (!system.isDesktop || startTime == null) return;
    if (_desktopKeepaliveInFlight) return;
    // 启动收敛窗口内唔好探(同 TUN 探测一致,避免建立途中误判成断连)。
    final startedAt = _desktopTunVerificationStartedAt;
    if (startedAt != null &&
        DateTime.now().difference(startedAt) < const Duration(seconds: 20)) {
      return;
    }
    final port = ref.read(patchClashConfigProvider).mixedPort;
    if (port <= 0) return;

    _desktopKeepaliveInFlight = true;
    late final bool ok;
    try {
      ok = await _probeThroughProxy(port);
    } finally {
      _desktopKeepaliveInFlight = false;
    }
    // 探测期间用户可能已断开,唔好用一个 stale 结果触发自愈。
    if (startTime == null) return;

    if (ok) {
      if (_desktopKeepaliveFailStreak > 0 ||
          _desktopKeepaliveRecoveryStreak > 0) {
        commonPrint.log(
          '[KEEPALIVE] 隧道探活恢复正常',
          logLevel: LogLevel.info,
        );
      }
      _desktopKeepaliveFailStreak = 0;
      _desktopKeepaliveRecoveryStreak = 0;
      return;
    }

    _desktopKeepaliveFailStreak++;
    commonPrint.log(
      '[KEEPALIVE] 经隧道探活失败 streak=$_desktopKeepaliveFailStreak',
      logLevel: LogLevel.warning,
    );
    // 需连续 3 次失败(≈135s)先当真死,避开瞬时抖动 / 单次慢探测误判。
    if (_desktopKeepaliveFailStreak < 3) return;

    // 硬限流:最快 90s 一次自愈,避免重启风暴。
    final lastRecovery = _lastDesktopKeepaliveRecoveryAt;
    if (lastRecovery != null &&
        DateTime.now().difference(lastRecovery) < const Duration(seconds: 90)) {
      return;
    }
    // 反死循环:连续自愈都唔见效(冇一次成功探活介入)超过 3 次就唔再重启,只保持
    // 探活 + 日志,交返畀 TUN 探测 / 兼容兜底 / 用户介入,避免无限重启核心。
    if (_desktopKeepaliveRecoveryStreak >= 3) {
      if (_desktopKeepaliveFailStreak == 3) {
        commonPrint.log(
          '[KEEPALIVE] 连续自愈无效,停止自动重启,保持探活等待恢复',
          logLevel: LogLevel.error,
        );
      }
      return;
    }

    _desktopKeepaliveFailStreak = 0;
    _lastDesktopKeepaliveRecoveryAt = DateTime.now();
    _desktopKeepaliveRecoveryStreak++;
    commonPrint.log(
      '[KEEPALIVE] 隧道静默断连,执行一次受控核心重启自愈'
      '(第 $_desktopKeepaliveRecoveryStreak 次)',
      logLevel: LogLevel.warning,
    );
    try {
      // restartCore 单飞(_restartFuture),内部会干净地 shutdown → 重连 → 重跑
      // _handleStart(会重建本定时器);兜底行为(兼容模式)同既有 TUN 自愈一致。
      await ref.read(coreActionProvider.notifier).restartCore(true);
    } catch (e) {
      commonPrint.log(
        '[KEEPALIVE] 自愈重启失败: $e',
        logLevel: LogLevel.error,
      );
    }
  }

  /// 经本地混合端口(即用户当前选中嘅节点路由)打一次轻量 generate_204。
  /// 成功(204/200)= 从设备到节点到公网整条路此刻仲通;超时/异常 = 呢条路已死。
  /// 用 http(免 TLS 握手开销);followRedirects=false;总超时 8s。
  Future<bool> _probeThroughProxy(int port) async {
    HttpClient? client;
    try {
      client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 8);
      client.idleTimeout = const Duration(seconds: 5);
      client.findProxy = (_) => 'PROXY 127.0.0.1:$port';
      final request = await client
          .getUrl(Uri.parse('http://www.gstatic.com/generate_204'))
          .timeout(const Duration(seconds: 8));
      request.followRedirects = false;
      final response =
          await request.close().timeout(const Duration(seconds: 8));
      final code = response.statusCode;
      await response.drain<void>();
      return code == 204 || code == 200;
    } catch (_) {
      return false;
    } finally {
      client?.close(force: true);
    }
  }

  Future _updateStartTime() async {
    startTime = await service?.getRunTime();
  }

  Future handleStop() async {
    startTime = null;
    _updateTimer?.cancel();
    _updateTimer = null;
    _desktopKeepaliveTimer?.cancel();
    _desktopKeepaliveTimer = null;
    _desktopKeepaliveInFlight = false;
    _desktopKeepaliveFailStreak = 0;
    // 用户主动断开 = 一次全新会话,反死循环计数清零(下次连接重新畀满 3 次自愈额度)。
    _desktopKeepaliveRecoveryStreak = 0;
    _lastDesktopKeepaliveRecoveryAt = null;
    _desktopTunVerifyFailCount = 0;
    _desktopProxyVerifyFailCount = 0;
    _desktopTunVerificationStartedAt = null;
    _desktopTunRecoveryAttempted = false;
    _desktopTunVerifyInFlight = false;
    // 用户主动断开 = 一次新嘅开始:清走「本次会话 TUN 已坏」同授权失败标记,
    // 下次点大圆圈会重新尝试 TUN(权限修好之后唔使重开 App 就恢复得到)。
    _desktopTunProvenBroken = false;
    _authorizeFailedThisSession = false;
    await coreController.stopListener();
  }

  Future<void> initStatus() async {
    if (!globalState.needInitStatus) {
      commonPrint.log('init status cancel');
      return;
    }
    commonPrint.log('init status');
    if (system.isAndroid) {
      await _updateStartTime();
    }
    final status = isStart == true
        ? true
        : ref.read(appSettingProvider).autoRun;
    if (status == true) {
      await updateStatus(true, isInit: true);
    } else {
      await applyProfile(force: true);
    }
  }

  Future<void> updateStatus(bool isStart, {bool isInit = false}) async {
    if (isStart) {
      if (system.isDesktop && ref.read(patchClashConfigProvider).tun.enable) {
        final conflict = await system.detectThirdPartyTunnel();
        if (conflict != null) {
          commonPrint.log(
            '[TUN-DIAG] third-party tunnel conflict=$conflict',
            logLevel: LogLevel.warning,
          );
          globalState.showNotifier(currentAppLocalizations.vgOtherProxyRunningCloseFirst(conflict));
          return;
        }
      }
      if (!isInit) {
        final res = await ref
            .read(coreActionProvider.notifier)
            .tryStartCore(true);
        if (res) return;
        if (!ref.read(initProvider)) return;
        await _handleStart();
        applyProfileDebounce(force: true, silence: true);
      } else {
        globalState.needInitStatus = false;
        ref.read(runTimeProvider.notifier).value = 0;
        try {
          await applyProfile(
            force: true,
            preloadInvoke: () async {
              await _handleStart();
            },
          );
        } catch (_) {
          ref.read(runTimeProvider.notifier).value = null;
        }
      }
    } else {
      await handleStop();
      coreController.resetTraffic();
      ref.read(trafficsProvider.notifier).clear();
      ref.read(totalTrafficProvider.notifier).value = const Traffic();
      ref.read(runTimeProvider.notifier).value = null;
      ref.read(checkIpNumProvider.notifier).add();
    }
  }

  Future<void> updateConfigDebounce() async {
    debouncer.call(FunctionTag.updateConfig, () async {
      await globalState.safeRun(() async {
        final updateParams = ref.read(updateParamsProvider);
        final res = await _requestAdmin(updateParams.tun.enable);
        if (res.isError) return;
        final realTunEnable = ref.read(realTunEnableProvider);
        final message = await coreController.updateConfig(
          updateParams.copyWith.tun(enable: realTunEnable),
        );
        if (message.isNotEmpty) throw message;
      });
    });
  }

  void tryCheckIp() {
    final isTimeout = ref.read(
      networkDetectionProvider.select(
        (state) => state.ipInfo == null && state.isLoading == false,
      ),
    );
    if (!isTimeout) return;
    ref.read(checkIpNumProvider.notifier).add();
  }

  void applyProfileDebounce({bool silence = false, bool force = false}) {
    debouncer.call(FunctionTag.applyProfile, (silence, force) {
      applyProfile(silence: silence, force: force);
    }, args: [silence, force]);
  }

  void changeMode(Mode mode) {
    ref
        .read(patchClashConfigProvider.notifier)
        .update((state) => state.copyWith(mode: mode));
    if (mode == Mode.global) {
      ref
          .read(proxiesActionProvider.notifier)
          .updateCurrentGroupName(GroupName.GLOBAL.name);
      // ⚠️ 只切 UI 组名唔够:核心嘅 GLOBAL.now 可能仲係 DIRECT,变成「界面显示全局、
      // 实际由中国 IP 直出」。呢度必须把主选择器递归解析到具体节点再绑定落 GLOBAL。
      repairGlobalBinding();
    }
    ref.read(checkIpNumProvider.notifier).add();
  }

  /// 把一个组名递归解析成「真正可用嘅具体节点」。
  /// 逐层跟 selector/fallback/url-test 嘅 now 往下钻,直到钻到唔再係组为止。
  /// 拒绝 DIRECT / REJECT / 空值;有环就断(depth 上限)。
  String? _resolveConcreteProxy(List<Group> groups, String? name) {
    var current = name;
    for (var depth = 0; depth < 8; depth++) {
      if (current == null || current.isEmpty) return null;
      if (current == 'DIRECT' ||
          current == 'REJECT' ||
          current == 'COMPATIBLE') {
        return null;
      }
      final group = groups.getGroup(current);
      if (group == null) return current; // 唔係组 = 已经係具体节点
      final next = group.now;
      if (next == null || next.isEmpty || next == current) return null;
      current = next;
    }
    return null;
  }

  /// 幂等修复 GLOBAL 绑定:App 启动、订阅刷新、节点失效之后都可以安全再调一次。
  /// 只喺 global 模式下动手;解析唔到可用节点就唔改(唔好静静哋跌返 DIRECT)。
  Future<void> repairGlobalBinding() async {
    final mode = ref.read(patchClashConfigProvider).mode;
    if (mode != Mode.global) return;
    final groups = ref.read(groupsProvider);
    if (groups.isEmpty) return;

    final globalGroup = groups.getGroup(GroupName.GLOBAL.name);
    if (globalGroup == null) return;

    // 主选择器 = 订阅入面第一个 selector 组(易聯 Residential IP),
    // 佢下面可能仲套住宅池等子组,所以要递归解析。
    Group? master;
    for (final g in groups) {
      if (g.name != GroupName.GLOBAL.name && g.type == GroupType.Selector) {
        master = g;
        break;
      }
    }
    final target =
        _resolveConcreteProxy(groups, master?.name) ??
        _resolveConcreteProxy(groups, globalGroup.now);

    if (target == null) {
      commonPrint.log(
        '[MODE-DIAG] global repair failed reason=no-available-proxy',
      );
      return;
    }
    if (globalGroup.now == target) {
      commonPrint.log('[MODE-DIAG] global now=$target (already bound)');
      return;
    }

    commonPrint.log(
      '[MODE-DIAG] mode=global master=${master?.name} resolved=$target '
      'was=${globalGroup.now}',
    );
    await ref
        .read(proxiesActionProvider.notifier)
        .changeProxy(groupName: GroupName.GLOBAL.name, proxyName: target);
    ref
        .read(profilesActionProvider.notifier)
        .updateCurrentSelectedMap(GroupName.GLOBAL.name, target);
  }

  void autoApplyProfile() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      applyProfile();
    });
  }

  Future<void> applyProfile({
    bool silence = false,
    bool force = false,
    FutureOr<void> Function()? preloadInvoke,
  }) async {
    await _setupConfig(
      force: force,
      silence: silence,
      preloadInvoke: preloadInvoke,
      onUpdated: () async {
        await ref.read(proxiesActionProvider.notifier).updateGroups();
        await ref.read(providersProvider.notifier).syncProviders();
        // 订阅刷新 / 配置重载之后节点可能已经换晒名或者消失,GLOBAL 会跌返 DIRECT。
        // 呢度幂等修复一次;唔係 global 模式会即刻 return,零成本。
        await repairGlobalBinding();
      },
    );
  }

  Future<VM2<String, String>> getProfile({
    required SetupState setupState,
    required PatchClashConfig patchConfig,
  }) async {
    final profileId = setupState.profileId;
    if (profileId == null) return const VM2('', '');
    final defaultUA = globalState.packageInfo.ua;
    final networkVM2 = ref.read(
      networkSettingProvider.select(
        (state) => VM2(state.appendSystemDns, state.routeMode),
      ),
    );
    final overrideDns = ref.read(overrideDnsProvider);
    final appendSystemDns = networkVM2.a;
    final routeMode = networkVM2.b;
    final configMap = await coreController.getConfig(profileId);
    String? scriptContent;
    final List<Rule> addedRules = [];
    final List<ProxyGroup> proxyGroups = [];
    final List<Rule> rules = [];
    if (setupState.overwriteType == OverwriteType.script) {
      scriptContent = await setupState.script?.content;
    } else if (setupState.overwriteType == OverwriteType.standard) {
      addedRules.addAll(setupState.addedRules);
    } else {
      proxyGroups.addAll(setupState.proxyGroups);
      rules.addAll(setupState.rules);
    }
    final realPatchConfig = patchConfig.copyWith(
      tun: patchConfig.tun.getRealTun(routeMode),
    );
    Map<String, dynamic> rawConfig = configMap;
    if (scriptContent?.isNotEmpty == true) {
      rawConfig = await handleEvaluate(scriptContent!, rawConfig);
    }
    final directory = await appPath.profilesPath;
    final res = makeRealProfileTask(
      MakeRealProfileState(
        rules: rules,
        proxyGroups: proxyGroups,
        profilesPath: directory,
        profileId: profileId,
        rawConfig: rawConfig,
        realPatchConfig: realPatchConfig,
        overrideDns: overrideDns,
        appendSystemDns: appendSystemDns,
        addedRules: addedRules,
        defaultUA: defaultUA,
      ),
    );
    return res;
  }

  Future<String> getProfileWithId(int profileId) async {
    try {
      final setupState = await ref.read(setupStateProvider(profileId).future);
      final patchClashConfig = ref.read(patchClashConfigProvider);
      final res = await getProfile(
        setupState: setupState,
        patchConfig: patchClashConfig,
      );
      return res.a;
    } catch (e) {
      globalState.showNotifier(e.toString());
    }
    return '';
  }

  /// 本次运行内是否已经授权失败过(用户取消 / chown 被系统拒)。
  ///
  /// 防的是这个死循环:偏好里 tun.enable=true,但 realTunEnable 是内存态、授权失败后
  /// 又被打回 false → 下一次后台 `_setupConfig`(订阅每小时自动更新会触发)条件再次成立
  /// → 再弹一次密码,周而复始。所以后台触发的授权只尝试一次,失败后本次运行不再骚扰用户;
  /// 用户自己去开关 TUN 仍然会重新尝试(走 updateConfigDebounce,不带 auto)。
  bool _authorizeFailedThisSession = false;

  Future<Result<bool>> _requestAdmin(
    bool enableTun, {
    bool auto = false,
  }) async {
    final realTunEnable = ref.read(realTunEnableProvider);
    // [TUN-DIAG] 每次调用(含双弹时的两次)入口状态,便于对齐 checkIsAdmin 日志。
    commonPrint.log(
      '[TUN-DIAG] _requestAdmin enableTun=$enableTun realTunEnable=$realTunEnable '
      'auto=$auto failedThisSession=$_authorizeFailedThisSession',
      logLevel: LogLevel.info,
    );
    if (auto && _authorizeFailedThisSession) {
      ref.read(realTunEnableProvider.notifier).value = false;
      return Result.success(false);
    }
    // 本次会话已证实 TUN 接管不了 —— 直接走兼容模式,唔好再重启一次又攞一次授权,
    // 否则会同 _ensureFallbackTransport 触发嘅 restartCore 组成死循环。
    if (enableTun && system.isDesktop && _desktopTunProvenBroken) {
      ref.read(realTunEnableProvider.notifier).value = false;
      return Result.success(false);
    }
    if (enableTun && system.isDesktop && !ref.read(isStartProvider)) {
      final conflict = await system.detectThirdPartyTunnel();
      if (conflict != null) {
        // 第三方占用系临时状态(用户随时可以关咗对方),所以只标记本次会话,
        // 绝对唔可以把 tun.enable 落盘 —— 旧实现落咗盘,用户照提示关掉对方再连,
        // TUN 偏好已经系 false,永远唔会自动恢复,提示文案变成骗人。
        _desktopTunProvenBroken = true;
        ref.read(realTunEnableProvider.notifier).value = false;
        _ensureFallbackTransport(currentAppLocalizations.vgOtherProxyRunningSkipTun(conflict));
        return Result.success(false);
      }
    }
    if (enableTun != realTunEnable && realTunEnable == false) {
      final code = await system.authorizeCore();
      // [TUN-DIAG] authorizeCore 返回的枚举名(success/none/error)。
      commonPrint.log(
        '[TUN-DIAG] _requestAdmin authorizeCore code=${code.name}',
        logLevel: LogLevel.info,
      );
      switch (code) {
        case AuthorizeCode.success:
          _authorizeFailedThisSession = false;
          // Set the effective flag before restarting. Otherwise the restart's
          // applyProfile re-enters authorizeCore and prompts a second time.
          ref.read(realTunEnableProvider.notifier).value = true;
          await ref.read(coreActionProvider.notifier).restartCore();
          return Result.error('');
        case AuthorizeCode.none:
          _authorizeFailedThisSession = false;
          break;
        case AuthorizeCode.error:
          _authorizeFailedThisSession = true;
          _desktopTunProvenBroken = true;
          enableTun = false;
          ref.read(realTunEnableProvider.notifier).value = false;
          // 授权失败唔好落盘关 TUN(旧实现落咗盘 → 加上迁移强制关咗系统代理 = 断网)。
          // 保住用户嘅 TUN 意图,同时即刻拉起兼容模式顶住,重连/重开 App 会再试 TUN。
          _ensureFallbackTransport(currentAppLocalizations.vgTunNotAuthorized);
          break;
      }
    }
    ref.read(realTunEnableProvider.notifier).value = enableTun;
    return Result.success(enableTun);
  }

  Future<void> _setupConfig({
    bool force = false,
    bool silence = false,
    FutureOr<void> Function()? preloadInvoke,
    FutureOr Function()? onUpdated,
  }) async {
    var profile = ref.read(currentProfileProvider);
    final nextProfile = await profile?.checkAndUpdateAndCopy();
    if (nextProfile != null) {
      profile = nextProfile;
      ref.read(profilesProvider.notifier).put(nextProfile);
    }
    commonPrint.log('setup ===> ${profile?.id}');
    final patchConfig = ref.read(patchClashConfigProvider);
    // auto: true —— 这条路径由订阅自动更新 / 配置重载触发,不是用户主动操作,
    // 授权失败过就不要再每小时弹一次密码。
    final res = await _requestAdmin(patchConfig.tun.enable, auto: true);
    if (res.isError) return;
    final realTunEnable = ref.read(realTunEnableProvider);
    // [TUN-DIAG] 核心配置下发前:期望 TUN vs 实际 realTunEnable。
    // 两者不一致(期望 true / 实际 false)= 授权失败被降级,系统流量入不了 TUN。
    commonPrint.log(
      '[TUN-DIAG] _setupConfig 期望TUN=${patchConfig.tun.enable} '
      '实际realTunEnable=$realTunEnable',
      logLevel: LogLevel.info,
    );
    final realPatchConfig = patchConfig.copyWith.tun(enable: realTunEnable);
    final setupState = await ref.read(setupStateProvider(profile?.id).future);
    if (system.isAndroid) {
      globalState.lastVpnState = ref.read(vpnStateProvider);
      final sharedState = ref.read(sharedStateProvider);
      preferences.saveShareState(sharedState);
    }
    final vm2 = await getProfile(
      setupState: setupState,
      patchConfig: realPatchConfig,
    );
    final yamlString = vm2.a;
    final yamlMd5 = vm2.b;
    if (yamlMd5 == globalState.lastConfigMd5 && force == false) return;
    await globalState.loadingRun(
      () async {
        final configFilePath = await appPath.configFilePath;
        await File(configFilePath).safeWriteAsString(yamlString);
        globalState.lastConfigMd5 = yamlMd5;
        final message = await coreController.setupConfig(
          setupState: setupState,
          params: _setupParams,
          preloadInvoke: preloadInvoke,
        );
        if (message.isNotEmpty && !message.endsWith('is empty')) {
          throw message;
        }
        ref.read(checkIpNumProvider.notifier).add();
        await onUpdated?.call();
      },
      silence: true,
      tag: !silence ? LoadingTag.proxies : null,
    );
  }
}

@Riverpod(keepAlive: true)
class BackupAction extends _$BackupAction {
  @override
  void build() {}

  Future<String> backup() async {
    final res = await Future.wait([
      database.profilesDao.fileNames().get(),
      database.scriptsDao.fileNames().get(),
    ]);
    final profileFileNames = res[0];
    final scriptFileNames = res[1];
    final configMap = ref.read(configProvider).toJson();
    configMap['version'] = await preferences.getVersion();
    return backupTask(configMap, [...profileFileNames, ...scriptFileNames]);
  }

  Future<void> restore(RestoreOption option) async {
    final restoreDirPath = await appPath.restoreDirPath;
    final restoreDir = Directory(restoreDirPath);
    final restoreStrategy = ref.read(
      appSettingProvider.select((state) => state.restoreStrategy),
    );
    final isOverride = restoreStrategy == RestoreStrategy.override;
    try {
      final migrationData = await restoreTask();
      if (!await restoreDir.exists()) {
        throw currentAppLocalizations.restoreException;
      }
      await database.restore(
        migrationData.profiles,
        migrationData.scripts,
        migrationData.rules,
        migrationData.links,
        migrationData.proxyGroups,
        isOverride: isOverride,
      );
      final configMap = migrationData.configMap;
      if (option == RestoreOption.onlyProfiles || configMap == null) return;
      final config = Config.fromJson(configMap);
      ref.read(patchClashConfigProvider.notifier).value =
          config.patchClashConfig;
      ref.read(appSettingProvider.notifier).value = config.appSettingProps;
      ref.read(currentProfileIdProvider.notifier).value =
          config.currentProfileId;
      ref.read(davSettingProvider.notifier).value = config.davProps;
      ref.read(themeSettingProvider.notifier).value = config.themeProps;
      ref.read(windowSettingProvider.notifier).value = config.windowProps;
      ref.read(vpnSettingProvider.notifier).value = config.vpnProps;
      ref.read(proxiesStyleSettingProvider.notifier).value =
          config.proxiesStyleProps;
      ref.read(overrideDnsProvider.notifier).value = config.overrideDns;
      ref.read(networkSettingProvider.notifier).value = config.networkProps;
      ref.read(hotKeyActionsProvider.notifier).value = config.hotKeyActions;
      return;
    } finally {
      await restoreDir.safeDelete(recursive: true);
    }
  }
}

@Riverpod(keepAlive: true)
class CoreAction extends _$CoreAction {
  Future<void>? _restartFuture;

  @override
  void build() {}

  Future<void> initCore() async {
    final isInit = await coreController.isInit;

    final version = ref.read(versionProvider);
    if (!isInit) {
      final res = await coreController.init(version);
      commonPrint.log('init result: $res');
    } else {
      await ref.read(proxiesActionProvider.notifier).updateGroups();
    }
  }

  Future<void> connectCore() async {
    ref.read(coreStatusProvider.notifier).value = CoreStatus.connecting;
    final result = await Future.wait([
      coreController.preload(),
      Future.delayed(const Duration(milliseconds: 300)),
    ]);
    final String message = result[0];
    if (message.isNotEmpty) {
      ref.read(coreStatusProvider.notifier).value = CoreStatus.disconnected;
      globalState.showNotifier(message);
      return;
    }
    ref.read(coreStatusProvider.notifier).value = CoreStatus.connected;
  }

  Future<Result<bool>> requestAdmin(bool enableTun) async {
    final realTunEnable = ref.read(realTunEnableProvider);
    if (enableTun != realTunEnable && realTunEnable == false) {
      final code = await system.authorizeCore();
      switch (code) {
        case AuthorizeCode.success:
          ref.read(realTunEnableProvider.notifier).value = true;
          await restartCore();
          return Result.error('');
        case AuthorizeCode.none:
          break;
        case AuthorizeCode.error:
          enableTun = false;
          break;
      }
    }
    ref.read(realTunEnableProvider.notifier).value = enableTun;
    return Result.success(enableTun);
  }

  Future<void> restartCore([bool start = false]) {
    final existing = _restartFuture;
    if (existing != null) return existing;
    final future = _restartCore(start);
    _restartFuture = future;
    return future.whenComplete(() {
      if (identical(_restartFuture, future)) _restartFuture = null;
    });
  }

  Future<void> _restartCore(bool start) async {
    final isDisconnected =
        ref.read(coreStatusProvider) == CoreStatus.disconnected;
    ref.read(coreStatusProvider.notifier).value = CoreStatus.disconnected;
    await coreController.shutdown(!isDisconnected);
    await connectCore();
    await initCore();
    if (start || ref.read(isStartProvider)) {
      await ref
          .read(setupActionProvider.notifier)
          .updateStatus(true, isInit: true);
    } else {
      await ref.read(setupActionProvider.notifier).applyProfile(force: true);
    }
  }

  Future<bool> tryStartCore([bool start = false]) async {
    if (coreController.isCompleted) return false;
    await restartCore(start);
    return true;
  }

  void handleCoreDisconnected() {
    ref.read(coreStatusProvider.notifier).value = CoreStatus.disconnected;
  }
}

@Riverpod(keepAlive: true)
class SystemAction extends _$SystemAction {
  @override
  void build() {}

  Future<List<Package>> getPackages() async {
    if (ref.read(isMobileViewProvider)) {
      await Future.delayed(commonDuration);
    }
    if (ref.read(packagesProvider).isEmpty) {
      ref.read(packagesProvider.notifier).value =
          await app?.getPackages() ?? [];
    }
    return ref.read(packagesProvider);
  }

  Future<void> handleExit([bool needSave = false]) async {
    Future.delayed(const Duration(seconds: 3), () {
      system.exit();
    });
    try {
      await Future.wait([
        if (needSave) preferences.saveConfig(ref.read(configProvider)),
        if (macOS != null) macOS!.updateDns(true),
        if (proxy != null) proxy!.stopProxy(),
        if (tray != null) tray!.destroy(),
      ]);
      await window?.close();
      await coreController.destroy();
      commonPrint.log('exit');
    } finally {
      system.exit();
    }
  }

  Future<void> handleBackOrExit() async {
    if (ref.read(backBlockProvider)) return;
    if (ref.read(appSettingProvider).minimizeOnExit) {
      if (system.isDesktop) {
        await preferences.saveConfig(ref.read(configProvider));
      }
      await system.back();
    } else {
      await handleExit();
    }
  }

  Future<void> updateVisible() async {
    final visible = await window?.isVisible;
    if (visible != null && !visible) {
      window?.show();
    } else {
      window?.hide();
    }
  }

  void updateTun() {
    ref
        .read(patchClashConfigProvider.notifier)
        .update((state) => state.copyWith.tun(enable: !state.tun.enable));
  }

  void updateSystemProxy() {
    ref
        .read(networkSettingProvider.notifier)
        .update((state) => state.copyWith(systemProxy: !state.systemProxy));
  }

  void updateAutoLaunch() {
    ref
        .read(appSettingProvider.notifier)
        .update((state) => state.copyWith(autoLaunch: !state.autoLaunch));
  }

  Future<void> updateTray() async {
    tray?.update(
      trayState: ref.read(trayStateProvider),
      traffic: ref.read(
        trafficsProvider.select(
          (state) => state.list.safeLast(const Traffic()),
        ),
      ),
    );
  }

  Future<void> updateLocalIp() async {
    ref.read(localIpProvider.notifier).value = null;
    await Future.delayed(commonDuration);
    ref.read(localIpProvider.notifier).value = await utils.getLocalIpAddress();
  }
}

@Riverpod(keepAlive: true)
class StoreAction extends _$StoreAction {
  @override
  void build() {}

  Future<void> shakingStore() async {
    final profileIds = ref.read(
      profilesProvider.select((state) => state.map((item) => item.id)),
    );
    final scriptIds = await ref.read(
      scriptsProvider.future.select(
        (state) async => (await state).map((item) => item.id),
      ),
    );
    final pathsToDelete = await shakingProfileTask(VM2(profileIds, scriptIds));
    if (pathsToDelete.isNotEmpty) {
      final deleteFutures = pathsToDelete.map((path) async {
        try {
          final res = await coreController.deleteFile(path);
          if (res.isNotEmpty) throw res;
        } catch (e) {
          rethrow;
        }
      });
      await Future.wait(deleteFutures);
    }
  }

  void savePreferencesDebounce() {
    debouncer.call(FunctionTag.savePreferences, () async {
      await preferences.saveConfig(ref.read(configProvider));
    });
  }

  Future handleClear() async {
    await preferences.clearPreferences();
    commonPrint.log('clear preferences');
    await database.close();
    await File(await appPath.databasePath).safeDelete(recursive: true);
    final homeDir = Directory(await appPath.profilesPath);
    await for (final file in homeDir.list(recursive: true)) {
      await coreController.deleteFile(file.path);
    }
    await preferences.clearPreferences();
    ref.read(systemActionProvider.notifier).handleExit(false);
  }
}

@Riverpod(keepAlive: true)
class ThemeAction extends _$ThemeAction {
  @override
  void build() {}

  void updateBrightness() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(systemBrightnessProvider.notifier).value =
          WidgetsBinding.instance.platformDispatcher.platformBrightness;
    });
  }

  void updateViewSize(Size size) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(viewSizeProvider.notifier).value = size;
    });
  }
}

@Riverpod(keepAlive: true)
class ProxiesAction extends _$ProxiesAction {
  @override
  void build() {}

  void updateGroupsDebounce([Duration? duration]) {
    debouncer.call(FunctionTag.updateGroups, updateGroups, duration: duration);
  }

  void changeProxyDebounce(String groupName, String proxyName) {
    debouncer.call(FunctionTag.changeProxy, (
      String groupName,
      String proxyName,
    ) async {
      await changeProxy(groupName: groupName, proxyName: proxyName);
      updateGroupsDebounce();
    }, args: [groupName, proxyName]);
  }

  Future<void> updateGroups() async {
    try {
      commonPrint.log('updateGroups');
      ref.read(groupsProvider.notifier).value = await retry(
        task: () async {
          final sortType = ref.read(
            proxiesStyleSettingProvider.select((state) => state.sortType),
          );
          final delayMap = ref.read(delayDataSourceProvider);
          final testUrl = ref.read(
            appSettingProvider.select((state) => state.testUrl),
          );
          final selectedMap = ref.read(
            currentProfileProvider.select((state) => state?.selectedMap ?? {}),
          );
          return coreController.getProxiesGroups(
            selectedMap: selectedMap,
            sortType: sortType,
            delayMap: delayMap,
            defaultTestUrl: testUrl,
          );
        },
        retryIf: (res) => res.isEmpty,
      );
    } catch (e) {
      commonPrint.log('updateGroups error: $e');
      ref.read(groupsProvider.notifier).value = [];
    }
  }

  void updateCurrentGroupName(String groupName) {
    final profile = ref.read(currentProfileProvider);
    if (profile == null || profile.currentGroupName == groupName) return;
    ref
        .read(profilesProvider.notifier)
        .put(profile.copyWith(currentGroupName: groupName));
  }

  void updateCurrentUnfoldSet(Set<String> value) {
    final currentProfile = ref.read(currentProfileProvider);
    if (currentProfile == null) return;
    ref
        .read(profilesProvider.notifier)
        .put(currentProfile.copyWith(unfoldSet: value));
  }

  void setDelay(Delay delay) {
    ref.read(delayDataSourceProvider.notifier).setDelay(delay);
  }

  Future<void> changeProxy({
    required String groupName,
    required String proxyName,
  }) async {
    await coreController.changeProxy(
      ChangeProxyParams(groupName: groupName, proxyName: proxyName),
    );
    if (ref.read(appSettingProvider).closeConnections) {
      await coreController.closeConnections();
    } else {
      await coreController.resetConnections();
    }
    ref.read(checkIpNumProvider.notifier).add();
  }

  Future<String> updateProvider(
    ExternalProvider provider, {
    bool showLoading = false,
  }) async {
    try {
      if (showLoading) {
        ref.read(isUpdatingProvider(provider.updatingKey).notifier).value =
            true;
      }
      final message = await coreController.updateExternalProvider(
        providerName: provider.name,
      );
      if (message.isNotEmpty) return message;
      ref
          .read(providersProvider.notifier)
          .setProvider(await coreController.getExternalProvider(provider.name));
      return '';
    } finally {
      ref.read(isUpdatingProvider(provider.updatingKey).notifier).value = false;
    }
  }
}

@Riverpod(keepAlive: true)
class ProfilesAction extends _$ProfilesAction {
  @override
  void build() {}

  void updateCurrentSelectedMap(String groupName, String proxyName) {
    final currentProfile = ref.read(currentProfileProvider);
    if (currentProfile != null &&
        currentProfile.selectedMap[groupName] != proxyName) {
      final selectedMap = Map<String, String>.from(currentProfile.selectedMap)
        ..[groupName] = proxyName;
      ref
          .read(profilesProvider.notifier)
          .put(currentProfile.copyWith(selectedMap: selectedMap));
    }
  }

  Future<void> deleteProfile(int id) async {
    ref.read(profilesProvider.notifier).del(id);
    clearEffect(id);
    final currentProfileId = ref.read(currentProfileIdProvider);
    if (currentProfileId == id) {
      final profiles = ref.read(profilesProvider);
      if (profiles.isNotEmpty) {
        final updateId = profiles.first.id;
        ref.read(currentProfileIdProvider.notifier).value = updateId;
      } else {
        ref.read(currentProfileIdProvider.notifier).value = null;
        ref.read(setupActionProvider.notifier).updateStatus(false);
      }
    }
  }

  Future<void> autoUpdateProfiles() async {
    for (final profile in ref.read(profilesProvider)) {
      if (!profile.autoUpdate) continue;
      final isNotNeedUpdate = profile.lastUpdateDate
          ?.add(profile.autoUpdateDuration)
          .isBeforeNow;
      if (isNotNeedUpdate == false || profile.type == ProfileType.file) {
        continue;
      }
      try {
        // voguesly 订阅走我哋自家 dio(cp 被封时核心 _clashDio 直连必失败,后台静默更新唔到节点);
        // 判定同 voguesly_subscription.isVogueslyProfile 一致(此处 inline 避免 providers→voguesly 反向依赖)。
        final isVoguesly =
            profile.url.contains('ylink') ||
            profile.url.contains('samseah') ||
            profile.url.contains('qzz.io') ||
            profile.url.contains('ccwu') ||
            profile.url.contains('voguesly') ||
            profile.url.contains('corelane') ||
            profile.url.contains('octolink');
        if (isVoguesly) {
          await refreshVogueslyProfile(profile);
        } else {
          await updateProfile(profile);
        }
      } catch (e) {
        commonPrint.log(e.toString(), logLevel: LogLevel.warning);
      }
    }
  }

  void putProfile(Profile profile) {
    ref.read(profilesProvider.notifier).put(profile);
    if (ref.read(currentProfileIdProvider) != null) return;
    ref.read(currentProfileIdProvider.notifier).value = profile.id;
  }

  Future<void> updateProfiles() async {
    for (final profile in ref.read(profilesProvider)) {
      if (profile.type == ProfileType.file) continue;
      await updateProfile(profile);
    }
  }

  Future<void> updateProfile(
    Profile profile, {
    bool showLoading = false,
  }) async {
    try {
      if (showLoading) {
        ref.read(isUpdatingProvider(profile.updatingKey).notifier).value = true;
      }
      ref.read(profilesProvider.notifier).put(profile);
      final newProfile = await profile.update();
      ref.read(profilesProvider.notifier).put(newProfile);
      if (profile.id == ref.read(currentProfileIdProvider)) {
        ref
            .read(setupActionProvider.notifier)
            .applyProfileDebounce(silence: true);
      }
    } finally {
      ref.read(isUpdatingProvider(profile.updatingKey).notifier).value = false;
    }
  }

  /// 用 voguesly 自家 dio 更新订阅(主 cp 失败自动轮 fallback 镜像),绕开 FlClash 核心
  /// _clashDio(后者直打 cp.voguesly.com,China→HK 瞬断会抛「未知网络错误」/connection reset)。
  /// 返回是否成功。
  Future<bool> refreshVogueslyProfile(
    Profile profile, {
    bool showLoading = false,
  }) async {
    try {
      if (showLoading) {
        ref.read(isUpdatingProvider(profile.updatingKey).notifier).value = true;
      }
      final fetched = await ref
          .read(vogueslyApiProvider)
          .fetchSubscribeBytes(profile.url);
      if (fetched == null) return false;
      final updated = await profile
          .copyWith(url: fetched.url)
          .saveFile(fetched.bytes);
      ref.read(profilesProvider.notifier).put(updated);
      if (updated.id == ref.read(currentProfileIdProvider)) {
        // ⚠️修复(2026-07-13):更新订阅写了新盘却不重载运行核心=节点/规则(iCloud等)全不生效。
        // 两个原因叠加:①setupStateProvider(id) 按 id 缓存解析态,saveFile 写同一 id 的新内容
        //   不会令其失效→getProfile 仍用旧解析态生成旧配置;②旧的 applyProfileDebounce(silence:true)
        //   force=false 会被 _setupConfig 的 `yamlMd5==lastConfigMd5 && force==false` 短路(L526)。
        // 修法:先失效 setupState 缓存令其重解析新文件,再 force:true 强制重载核心。
        ref.invalidate(setupStateProvider(updated.id));
        await ref
            .read(setupActionProvider.notifier)
            .applyProfile(force: true, silence: true);
      }
      return true;
    } catch (_) {
      return false;
    } finally {
      ref.read(isUpdatingProvider(profile.updatingKey).notifier).value = false;
    }
  }

  Future<void> addProfileFormFile() async {
    final platformFile = await globalState.safeRun(picker.pickerFile);
    final bytes = platformFile?.bytes;
    if (bytes == null) return;
    globalState.navigatorKey.currentState?.popUntil((route) => route.isFirst);
    ref.read(currentPageLabelProvider.notifier).toProfiles();
    final profile = await globalState.loadingRun(
      tag: LoadingTag.profiles,
      () async {
        return Profile.normal(label: platformFile?.name).saveFile(bytes);
      },
      title: currentAppLocalizations.addProfile,
    );
    if (profile != null) {
      putProfile(profile);
    }
  }

  Future<void> addProfileFormURL(String url) async {
    if (globalState.navigatorKey.currentState?.canPop() ?? false) {
      globalState.navigatorKey.currentState?.popUntil((route) => route.isFirst);
    }
    ref.read(currentPageLabelProvider.notifier).value = PageLabel.profiles;
    final profile = await globalState.loadingRun(
      tag: LoadingTag.profiles,
      () async {
        return Profile.normal(url: url).update();
      },
      title: currentAppLocalizations.addProfile,
    );
    if (profile != null) {
      putProfile(profile);
    }
  }

  void setProfileAndAutoApply(Profile profile) {
    ref.read(profilesProvider.notifier).put(profile);
    if (profile.id == ref.read(currentProfileIdProvider)) {
      ref.read(setupActionProvider.notifier).applyProfileDebounce();
    }
  }

  Future<void> addProfileFormQrCode() async {
    final url = await globalState.safeRun(picker.pickerConfigQRCode);
    if (url == null) return;
    addProfileFormURL(url);
  }

  void reorder(List<Profile> profiles) {
    ref.read(profilesProvider.notifier).reorder(profiles);
  }

  Future<void> clearEffect(int profileId) async {
    final profilePath = await appPath.getProfilePath(profileId.toString());
    final providersDirPath = await appPath.getProvidersDirPath(
      profileId.toString(),
    );
    final profileFile = File(profilePath);
    final isExists = await profileFile.exists();
    if (isExists) {
      await profileFile.safeDelete(recursive: true);
    }
    await coreController.deleteFile(providersDirPath);
  }
}
