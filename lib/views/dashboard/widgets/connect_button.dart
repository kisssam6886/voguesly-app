import 'dart:async';

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  bool isStart = false;
  bool _connecting = false;
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
    if (!hasProfile) return;
    if (isStart) {
      // 断开
      _toggleCore(false);
      return;
    }
    // 开启:3-2-1 倒计时 + 真连接
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
    // 连接超时保护:15s 仲未连上(isStartProvider 冇变 true),退出「正在开启」中间态。
    Future.delayed(const Duration(seconds: 15), () {
      if (mounted && _connecting && !isStart) {
        setState(() => _connecting = false);
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
    final suspend = ref.watch(suspendProvider);
    final cs = context.colorScheme;
    final connecting = _connecting && !isStart;

    // 配色
    final Color fill;
    final Color fg;
    if (isStart) {
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
        ? '请先添加订阅'
        : suspend
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
                // 脉冲动效(只喺未连+空闲时)
                if (!isStart && !connecting)
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
                      color: (isStart ? _green : cs.primary)
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
                      else if (connecting)
                        SizedBox(
                          width: 34,
                          height: 34,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: fg,
                          ),
                        )
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
          child: isStart
              ? Consumer(
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
                )
              : null,
        ),
      ],
    );
  }
}
