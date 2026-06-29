import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 当前线路卡:显示主组(易聯 Residential IP)选中嘅线路,撳→线路页换。
class CurrentRoute extends ConsumerWidget {
  const CurrentRoute({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = context.colorScheme;
    final groupName = ref.watch(
      proxiesTabStateProvider.select((s) => s.currentGroupName),
    );
    final selected = (groupName == null)
        ? ''
        : (ref.watch(selectedProxyNameProvider(groupName)) ?? '');
    return SizedBox(
      width: double.infinity,
      child: CommonCard(
        onPressed: () {
          ref
              .read(currentPageLabelProvider.notifier)
              .toPage(PageLabel.proxies);
        },
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Icon(Icons.lan_outlined, color: cs.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '当前线路',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 2),
                    EmojiText(
                      selected.isEmpty ? '未选择 · 去选线路' : selected,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.titleSmall,
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: cs.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}
