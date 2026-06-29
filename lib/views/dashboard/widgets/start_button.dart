import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 连接按钮:为普通用户做成明显嘅「点击连接」extended FAB(原 FlClash 停咗只得一个 play icon,太隐蔽)。
/// 停=主色「点击连接」+电源 icon;连=计时 + 暂停 icon。
class StartButton extends ConsumerStatefulWidget {
  const StartButton({super.key});

  @override
  ConsumerState<StartButton> createState() => _StartButtonState();
}

class _StartButtonState extends ConsumerState<StartButton> {
  bool isStart = false;

  @override
  void initState() {
    super.initState();
    isStart = ref.read(isStartProvider);
    ref.listenManual(isStartProvider, (prev, next) {
      if (next != isStart && mounted) {
        setState(() => isStart = next);
      }
    }, fireImmediately: true);
  }

  void handleSwitchStart() {
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
    if (!hasProfile) {
      return Container();
    }
    final suspend = ref.watch(suspendProvider);
    final cs = context.colorScheme;
    final appLocalizations = context.appLocalizations;
    final runTime = ref.watch(runTimeProvider);
    final label = suspend
        ? appLocalizations.suspended
        : (isStart ? utils.getTimeText(runTime) : '点击连接');
    return RepaintBoundary(
      child: FloatingActionButton.extended(
        heroTag: null,
        materialTapTargetSize: MaterialTapTargetSize.padded,
        backgroundColor: isStart ? cs.primaryContainer : cs.primary,
        foregroundColor: isStart ? cs.onPrimaryContainer : cs.onPrimary,
        onPressed: handleSwitchStart,
        icon: Icon(isStart ? Icons.pause_rounded : Icons.power_settings_new),
        label: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.visible,
          style: context.textTheme.titleMedium?.copyWith(
            color: isStart ? cs.onPrimaryContainer : cs.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
