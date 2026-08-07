import 'dart:math';

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

/// 切去「全局」时弹一次说明:全局会覆盖智能分流,IP 检测站只会见到手选嗰条线路。
/// 唔提示嘅话,用户手选咗机房线路再去 ping0/ipinfo 测,会误以为「买咗住宅 IP 但显示机房」。
/// 只喺 rule → global 嗰刻弹,切返 rule 或者本来就 global 都唔骚扰。
Future<void> showGlobalModeNoticeIfNeeded(
  BuildContext context,
  Mode from,
  Mode to,
) async {
  if (to != Mode.global || from == Mode.global) return;
  if (!context.mounted) return;
  await showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(currentAppLocalizations.vgSwitchedToGlobal),
      content: Text(
        currentAppLocalizations.vgGlobalModeDialog1 +
        currentAppLocalizations.vgGlobalModeDialog2 +
        currentAppLocalizations.vgGlobalModeDialog3 +
        currentAppLocalizations.vgGlobalModeDialog4,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: Text(currentAppLocalizations.vgGotIt),
        ),
      ],
    ),
  );
}

class OutboundMode extends StatelessWidget {
  const OutboundMode({super.key});

  void _handleChangeMode(BuildContext context, Mode from, Mode mode) {
    globalState.container.read(setupActionProvider.notifier).changeMode(mode);
    showGlobalModeNoticeIfNeeded(context, from, mode);
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = context.appLocalizations;
    final height = getWidgetHeight(2);
    return SizedBox(
      height: height,
      child: Consumer(
        builder: (_, ref, _) {
          final mode = ref.watch(
            patchClashConfigProvider.select((state) => state.mode),
          );
          return Theme(
            data: Theme.of(context).copyWith(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
            ),
            child: CommonCard(
              onPressed: () {},
              info: Info(
                label: appLocalizations.outboundMode,
                iconData: Icons.call_split_sharp,
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 12),
                child: RadioGroup<Mode>(
                  groupValue: mode,
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    _handleChangeMode(context, mode, value);
                  },
                  child: LayoutBuilder(
                    builder: (_, constraints) {
                      final maxHeight = constraints.maxHeight;
                      return Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // 隐藏「直连」= 裸奔模式(会显绿但流量唔走节点),消费者唔应该点到。
                          for (final item
                              in Mode.values.where((m) => m != Mode.direct))
                            ListItem.radio(
                              horizontalTitleGap: 8,
                              tileTitleAlignment: ListTileTitleAlignment.center,
                              minTileHeight: min(
                                maxHeight / 3,
                                globalState.measure.bodyMediumHeight + 16,
                              ),
                              minVerticalPadding: 0,
                              padding: EdgeInsets.only(
                                left: 12.ap,
                                right: 16.ap,
                              ),
                              delegate: RadioDelegate(
                                onTab: () {
                                  _handleChangeMode(context, mode, item);
                                },
                                value: item,
                              ),
                              title: Text(
                                Intl.message(item.name),
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.toSoftBold,
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class OutboundModeV2 extends StatelessWidget {
  const OutboundModeV2({super.key});

  void _handleChangeMode(BuildContext context, Mode from, Mode mode) {
    globalState.container.read(setupActionProvider.notifier).changeMode(mode);
    showGlobalModeNoticeIfNeeded(context, from, mode);
  }

  Color _getTextColor(BuildContext context, Mode mode) {
    return switch (mode) {
      Mode.rule => context.colorScheme.onSecondaryContainer,
      Mode.global => context.colorScheme.onPrimaryContainer,
      Mode.direct => context.colorScheme.onTertiaryContainer,
    };
  }

  @override
  Widget build(BuildContext context) {
    final height = getWidgetHeight(1);
    return SizedBox(
      height: height,
      child: CommonCard(
        child: Consumer(
          builder: (_, ref, _) {
            final mode = ref.watch(
              patchClashConfigProvider.select((state) => state.mode),
            );
            final thumbColor = switch (mode) {
              Mode.rule => context.colorScheme.secondaryContainer,
              Mode.global => globalState.theme.darken3PrimaryContainer,
              Mode.direct => context.colorScheme.tertiaryContainer,
            };
            return LayoutBuilder(
              builder: (_, constraints) {
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        constraints: const BoxConstraints.expand(),
                        child: CommonTabBar<Mode>(
                          children: Map.fromEntries(
                            // 隐藏「直连」裸奔模式(同上)。
                            Mode.values.where((m) => m != Mode.direct).map(
                              (item) => MapEntry(
                                item,
                                Container(
                                  clipBehavior: Clip.antiAlias,
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(),
                                  height: height - 8.ap - 24,
                                  padding: const EdgeInsets.all(4),
                                  child: Text(
                                    Intl.message(item.name),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.adjustSize(1)
                                        .copyWith(
                                          color: item == mode
                                              ? _getTextColor(context, item)
                                              : null,
                                        ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          groupValue: mode,
                          onValueChanged: (value) {
                            if (value == null) {
                              return;
                            }
                            _handleChangeMode(context, mode, value);
                          },
                          thumbColor: thumbColor,
                        ),
                      ),
                    ),
                    Container(
                      color: thumbColor.opacity50,
                      height: 8.ap,
                      width: constraints.maxWidth,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      // child: Row(
                      //   children: [
                      //     Container(
                      //       width: (constraints.maxWidth - 32) / 3,
                      //       height: 3,
                      //       decoration: BoxDecoration(
                      //         color: _getTextColor(context, mode),
                      //         borderRadius: BorderRadius.circular(2),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
