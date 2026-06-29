import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 仪表盘大圆圈连接掣:未连=灰圈「点击连接」,已连=绿圈「已连接」,下方实时速度。
/// 复用 setupActionProvider.updateStatus 嘅连接逻辑(同原 StartButton)。
class ConnectButton extends ConsumerStatefulWidget {
  const ConnectButton({super.key});

  @override
  ConsumerState<ConnectButton> createState() => _ConnectButtonState();
}

class _ConnectButtonState extends ConsumerState<ConnectButton> {
  static const _green = Color(0xFF22C55E);
  bool isStart = false;

  @override
  void initState() {
    super.initState();
    isStart = ref.read(isStartProvider);
    ref.listenManual(isStartProvider, (prev, next) {
      if (next != isStart && mounted) setState(() => isStart = next);
    }, fireImmediately: true);
  }

  void _toggle() {
    setState(() => isStart = !isStart);
    debouncer.call(FunctionTag.updateStatus, () {
      globalState.container
          .read(setupActionProvider.notifier)
          .updateStatus(isStart, isInit: !ref.read(initProvider));
    }, duration: commonDuration);
  }

  @override
  Widget build(BuildContext context) {
    final hasProfile = ref.watch(
      profilesProvider.select((state) => state.isNotEmpty),
    );
    final suspend = ref.watch(suspendProvider);
    final cs = context.colorScheme;
    final connected = isStart;
    final accent = connected ? _green : cs.primary;
    final statusText = !hasProfile
        ? '请先添加订阅'
        : suspend
            ? context.appLocalizations.suspended
            : (connected ? '已连接' : '点击连接');
    return Column(
      children: [
        const SizedBox(height: 8),
        GestureDetector(
          onTap: hasProfile ? _toggle : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: accent.withValues(alpha: connected ? 0.16 : 0.10),
              border: Border.all(
                color: accent.withValues(alpha: 0.55),
                width: 2,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.power_settings_new, size: 46, color: accent),
                const SizedBox(height: 8),
                Text(
                  statusText,
                  style: context.textTheme.titleMedium?.copyWith(
                    color: accent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 18,
          child: connected
              ? Consumer(
                  builder: (_, ref, _) {
                    final t = ref.watch(
                      trafficsProvider.select(
                        (s) => s.list.safeLast(const Traffic()),
                      ),
                    );
                    return Text(
                      '实时  ↓ ${Traffic(down: t.down).speedText}  ·  ↑ ${Traffic(up: t.up).speedText}',
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
