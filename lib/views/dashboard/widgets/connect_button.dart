import 'dart:async';

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../voguesly/voguesly_onboarding_sheet.dart';
import '../../../voguesly/voguesly_subscription.dart';

/// 仪表盘大圆圈连接掣(消费者向):
/// 未连=白底醒目圈「开启易联」+ 脉冲动效;撳后 3-2-1 倒计时;已连=绿圈「已连接·轻触断开」。
/// 连接逻辑复用 setupActionProvider.updateStatus(同原 StartButton)。
class ConnectButton extends ConsumerStatefulWidget {
  const ConnectButton({super.key});

  @override
  ConsumerState<ConnectButton> createState() => _ConnectButtonState();
}

class _ConnectButtonState extends ConsumerState<ConnectButton>
    with SingleTickerProviderStateMixin {
  static const _green = Color(0xFF22C55E);
  static const _amber = Color(0xFFF59E0B); // 已连但被排除SSID旁路(suspend):唔显绿,警示直连
  bool isStart = false;
  bool _connecting = false; // 仅控制 3-2-1 倒计时显示(只活 ~1.8s)
  bool _attempting = false; // 本次连接尝试仍在进行(未连上/未取消):供 15s 超时判定
  int _count = 0;
  Timer? _timer;
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
    isStart = ref.read(isStartProvider);
    ref.listenManual(isStartProvider, (prev, next) {
      if (!mounted) return;
      // 只同步真实状态;「正在开启」中间态(3-2-1)由倒计时管,唔畀连接太快冲走个倒计时。
      if (next) _attempting = false; // 已连上 → 本次尝试结束
      setState(() => isStart = next);
    }, fireImmediately: true);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulse.dispose();
    super.dispose();
  }

  void _onTap(bool hasProfile) {
    if (!hasProfile) {
      // 正在载入订阅时唔好弹引导(避免有套餐用户启动期误开引导)。
      if (ref.read(vogueslyImportingProvider)) return;
      // 网络导入失败(≠未开通)→ 点圆圈重试导入,唔好当未开通弹引导。
      if (ref.read(vogueslyImportFailedProvider)) {
        importVogueslySubscription();
        return;
      }
      // 未有套餐/订阅:弹引导卡(免费测试一键开通 / 购买验证包),唔好净系冷冰冰禁用。
      showVogueslyOnboarding(context);
      return;
    }
    if (isStart) {
      // 断开:先 cancel 倒计时 + 清中间态,免倒计时未行完就断开令圆圈卡喺「正在开启」。
      _timer?.cancel();
      _attempting = false;
      if (_connecting) {
        setState(() {
          _connecting = false;
          _count = 0;
        });
      }
      _toggleCore(false);
      return;
    }
    // 开启:3-2-1 倒计时 + 真连接
    _attempting = true;
    setState(() {
      _connecting = true;
      _count = 3;
    });
    _toggleCore(true);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 600), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      if (_count <= 1) {
        // 倒计时 3-2-1 行足,先退出中间态显示真实状态(已连接/失败)。
        t.cancel();
        setState(() => _connecting = false);
      } else {
        setState(() => _count--);
      }
    });
    // 连接超时保护:15s 仍未连上(本次尝试仍在进行 + isStart 冇变 true)→ 明确提示。
    // ⚠️ 用 _attempting(活到连上/断开/超时)而非 _connecting(倒计时 ~1.8s 就清),否则永远唔触发。
    Future.delayed(const Duration(seconds: 15), () {
      if (mounted && _attempting && !isStart) {
        _attempting = false;
        if (_connecting) setState(() => _connecting = false);
        globalState.showNotifier('连接超时,请检查网络,或喺「当前线路」换一条线路再试');
      }
    });
  }

  void _toggleCore(bool start) {
    // 唔做乐观更新:isStart 由 isStartProvider 监听器做唯一真相源,确保 UI 同实际连接状态一致。
    debouncer.call(FunctionTag.updateStatus, () {
      globalState.container
          .read(setupActionProvider.notifier)
          .updateStatus(start, isInit: !ref.read(initProvider));
    }, duration: commonDuration);
  }

  @override
  Widget build(BuildContext context) {
    final hasProfile = ref.watch(
      profilesProvider.select((state) => state.isNotEmpty),
    );
    // China→HK 拉订阅通常十几秒;载入期显示「正在载入订阅」而非误显示「点我开通」。
    final importing = ref.watch(vogueslyImportingProvider) && !hasProfile;
    // 网络导入失败(≠未开通套餐):空 profile 态显「载入失败·点我重试」而非「点我开通」。
    final importFailed =
        ref.watch(vogueslyImportFailedProvider) && !hasProfile && !importing;
    final suspend = ref.watch(suspendProvider);
    // 已连接但被排除SSID旁路(suspend)→ 流量实际走直连,圆圈唔可以显示「已连接·绿色」。
    final bypassed = isStart && suspend;
    final cs = context.colorScheme;
    // 倒计时期间(_connecting)就显示「正在开启 3-2-1」,唔好因为连接太快(isStart变true)
    // 而提早绕过倒计时;倒计时行足由 timer 清 _connecting 先显示真实状态。
    final connecting = _connecting;

    // 配色
    final Color fill;
    final Color fg;
    if (bypassed) {
      fill = _amber;
      fg = Colors.white;
    } else if (isStart) {
      fill = _green;
      fg = Colors.white;
    } else if (connecting) {
      fill = cs.primary;
      fg = cs.onPrimary;
    } else {
      fill = Colors.white;
      fg = cs.primary;
    }
    final title = !hasProfile
        ? (importing
            ? '正在载入订阅…'
            : importFailed
                ? '载入失败·点我重试'
                : '点我开通')
        : bypassed
            ? context.appLocalizations.suspended
            : isStart
                ? '已连接'
                : connecting
                    ? '正在开启'
                    : '开启易联';

    return Column(
      children: [
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _onTap(hasProfile),
          behavior: HitTestBehavior.opaque,
          child: SizedBox(
            width: 200,
            height: 188,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // 脉冲动效(只喺未连+空闲时;载入/载入失败时唔脉冲,改显示 spinner/重试图标)
                if (!isStart && !connecting && !importing && !importFailed)
                  AnimatedBuilder(
                    animation: _pulse,
                    builder: (_, _) {
                      final v = _pulse.value;
                      return Container(
                        width: 150 + 56 * v,
                        height: 150 + 56 * v,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: cs.primary.withValues(alpha: 0.18 * (1 - v)),
                        ),
                      );
                    },
                  ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: fill,
                    border: Border.all(
                      color: (bypassed
                              ? _amber
                              : isStart
                                  ? _green
                                  : cs.primary)
                          .withValues(alpha: 0.5),
                      width: 3,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (connecting && _count > 0)
                        Text(
                          '$_count',
                          style: context.textTheme.displaySmall?.copyWith(
                            color: fg,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      else if (connecting || importing)
                        SizedBox(
                          width: 34,
                          height: 34,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: fg,
                          ),
                        )
                      else if (importFailed)
                        Icon(Icons.refresh_rounded, size: 52, color: fg)
                      else
                        Icon(Icons.power_settings_new_rounded,
                            size: 52, color: fg),
                      const SizedBox(height: 6),
                      Text(
                        title,
                        style: context.textTheme.titleMedium?.copyWith(
                          color: fg,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // 已连接:轻触断开提示 + 实时速度;未连:留白
        SizedBox(
          height: 20,
          child: !isStart
              ? null
              : bypassed
                  ? Text(
                      '当前网络已跳过加速 · 走直连',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: _amber,
                      ),
                    )
                  : Consumer(
                      builder: (_, ref, _) {
                        final t = ref.watch(
                          trafficsProvider.select(
                            (s) => s.list.safeLast(const Traffic()),
                          ),
                        );
                        return Text(
                          '轻触断开  ·  ${t.speedText}',
                          style: context.textTheme.bodySmall?.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }
}
