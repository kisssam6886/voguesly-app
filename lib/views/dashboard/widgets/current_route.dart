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
    // 有订阅但 now 未就绪(核心载入中 / 主组 select 默认走第一项 url-test「快线」)→
    // 唔好显示「未选择」吓人(其实连得到):显示「自动选择中…」。
    final hasProfile = ref.watch(
      profilesProvider.select((s) => s.isNotEmpty),
    );
    final routeText = selected.isNotEmpty
        ? selected
        : (hasProfile ? '自动选择中…' : '未选择 · 去选线路');
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
                      routeText,
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
