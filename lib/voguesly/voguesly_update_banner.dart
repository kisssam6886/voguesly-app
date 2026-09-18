import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/manager/app_manager.dart' show vogueslyUpdateVersionProvider;
import 'package:fl_clash/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// [2026-09-18 0.9.79 Sam] 有新版本时喺主页顶弹一条**非模态** banner:
/// 「有新版本 x.x.x」+「一键更新」+「稍后」。稍后 = 本次运行唔再弹(下次启动再弹);
/// 一键更新 = 走现成 manualCheckUpdate(弹更新说明 → 一键更新 → 自动装)。
/// 启动时嘅静默检查(app_manager._silentCheckUpdate)负责写 provider,唔再弹模态框打断用户。
class _DismissedTag extends Notifier<String?> {
  @override
  String? build() => null;
  void set(String? v) => state = v;
}

final vogueslyUpdateBannerDismissedProvider =
    NotifierProvider<_DismissedTag, String?>(_DismissedTag.new);

class VogueslyUpdateBanner extends ConsumerWidget {
  const VogueslyUpdateBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tag = ref.watch(vogueslyUpdateVersionProvider);
    final dismissed = ref.watch(vogueslyUpdateBannerDismissedProvider);
    if (tag == null || tag.isEmpty || dismissed == tag) {
      return const SizedBox.shrink();
    }
    final cs = context.colorScheme;
    final l = currentAppLocalizations;
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Material(
        color: cs.primaryContainer,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 10, 8, 10),
          child: Row(
            children: [
              Icon(Icons.system_update_alt_rounded, color: cs.onPrimaryContainer),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  l.vgNewVersionAvailable(tag),
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: cs.onPrimaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              TextButton(
                onPressed: () =>
                    ref.read(vogueslyUpdateBannerDismissedProvider.notifier).set(tag),
                style: TextButton.styleFrom(foregroundColor: cs.onPrimaryContainer),
                child: Text(l.vgUpdateLater),
              ),
              FilledButton(
                onPressed: () =>
                    ref.read(commonActionProvider.notifier).manualCheckUpdate(),
                style: FilledButton.styleFrom(visualDensity: VisualDensity.compact),
                child: Text(context.appLocalizations.goDownload),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
