import 'dart:async';

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/core/controller.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/manager/window_manager.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/voguesly/voguesly_auth.dart';
import 'package:fl_clash/state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_clash/voguesly/voguesly_cs.dart';
import 'package:fl_clash/voguesly/voguesly_invite.dart';
import 'package:fl_clash/voguesly/voguesly_notice.dart';
import 'package:fl_clash/voguesly/voguesly_overlay.dart';
import 'package:fl_clash/voguesly/voguesly_shop.dart';
import 'package:fl_clash/voguesly/voguesly_stat.dart';
import 'package:fl_clash/voguesly/voguesly_user_center.dart';
import 'package:intl/intl.dart';

class AppStateManager extends ConsumerStatefulWidget {
  final Widget child;

  const AppStateManager({super.key, required this.child});

  @override
  ConsumerState<AppStateManager> createState() => _AppStateManagerState();
}

class _AppStateManagerState extends ConsumerState<AppStateManager>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    ref.listenManual(checkIpProvider, (prev, next) {
      if (prev != next && next.a && next.c) {
        ref.read(networkDetectionProvider.notifier).startCheck();
      }
    });
    ref.listenManual(configProvider, (prev, next) {
      if (prev != next) {
        globalState.container
            .read(storeActionProvider.notifier)
            .savePreferencesDebounce();
      }
    });
    ref.listenManual(needUpdateGroupsProvider, (prev, next) {
      if (prev != next) {
        globalState.container
            .read(proxiesActionProvider.notifier)
            .updateGroupsDebounce();
      }
    });
    ref.listenManual(suspendProvider, (prev, next) {
      final isStart = ref.read(isStartProvider);
      if (prev != next && isStart) {
        debouncer.call(FunctionTag.suspend, () async {
          if (next == true) {
            await coreController.stopListener();
          } else {
            await coreController.startListener();
          }
          ref.read(checkIpNumProvider.notifier).add();
        });
      }
    });
    if (system.isMacOS) {
      ref.listenManual(autoSetSystemDnsStateProvider, (prev, next) async {
        if (prev == next) {
          return;
        }
        if (next.a == true && next.b == true) {
          macOS?.updateDns(false);
        } else {
          macOS?.updateDns(true);
        }
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    commonPrint.log('$state');
    if (state == AppLifecycleState.resumed) {
      permissions.check();
      render?.resume();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final ref = globalState.container;
        ref.read(setupActionProvider.notifier).tryCheckIp();
        // 回前台刷新套餐/流量(连接中配额被消耗,账号卡数字会冻结);未登录时 refreshUser 自身 no-op。
        ref.read(vogueslyAuthProvider.notifier).refreshUser();
        if (system.isAndroid) {
          ref.read(coreActionProvider.notifier).tryStartCore();
        }
      });
    }
  }

  @override
  void didChangePlatformBrightness() {
    globalState.container.read(themeActionProvider.notifier).updateBrightness();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerHover: (_) {
        render?.resume();
      },
      child: widget.child,
    );
  }
}

class AppEnvManager extends StatelessWidget {
  final Widget child;

  const AppEnvManager({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      if (globalState.isPre) {
        return Banner(
          message: 'DEBUG',
          location: BannerLocation.topEnd,
          child: child,
        );
      }
    }
    // PRE 预发布角标已去除(上架前品牌化,唔畀用户见到工程化标记)。
    return child;
  }
}

class AppSidebarContainer extends ConsumerWidget {
  final Widget child;

  const AppSidebarContainer({super.key, required this.child});

  // Widget _buildLoading() {
  //   return Consumer(
  //     builder: (_, ref, _) {
  //       final loading = ref.watch(loadingProvider);
  //       final isMobileView = ref.watch(isMobileViewProvider);
  //       return loading && !isMobileView
  //           ? RotatedBox(
  //               quarterTurns: 1,
  //               child: const LinearProgressIndicator(),
  //             )
  //           : Container();
  //     },
  //   );
  // }

  Widget _buildBackground({
    required BuildContext context,
    required Widget child,
  }) {
    return Material(color: context.colorScheme.surfaceContainer, child: child);
    // if (!system.isMacOS) {
    //   return Material(
    //     color: context.colorScheme.surfaceContainer,
    //     child: child,
    //   );
    // }
    // return child;
    // return TransparentMacOSSidebar(
    //   child: Material(color: Colors.transparent, child: child),
    // );
  }

  void _updateSideBarWidth(WidgetRef ref, double contentWidth) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(sideWidthProvider.notifier).value =
          ref.read(viewSizeProvider.select((state) => state.width)) -
          contentWidth;
    });
  }

  void _handleToPage(PageLabel pageLabel) {
    // 切换主菜单时关闭半框 overlay(否则 overlay 仲盖住新页,用户点咗但见唔到)。
    globalState.container.read(contentOverlayProvider.notifier).close();
    // 点 nav 跳返该页第一级(设置深入几级后再点「设置」直接返顶,唔使逐级返回)。
    final ctx = GlobalObjectKey(pageLabel).currentContext;
    final nav = ctx == null ? null : Navigator.maybeOf(ctx);
    nav?.popUntil((r) => r.isFirst);
    globalState.container
        .read(currentPageLabelProvider.notifier)
        .toPage(pageLabel);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigationState = ref.watch(navigationStateProvider);
    final navigationItems = navigationState.navigationItems;
    final isMobileView = navigationState.viewMode == ViewMode.mobile;
    if (isMobileView) {
      return child;
    }
    final currentIndex = navigationState.currentIndex;
    final overlay = ref.watch(contentOverlayProvider);
    // 侧栏常显文字(Sam 要求:图标一定加文字,唔好净图标)。
    const showLabel = true;
    return Row(
      children: [
        _buildBackground(
          context: context,
          child: SafeArea(
            child: Column(
              // ⚠️ 必须 center:呢个 Column 系 content-sized(宽度由最阔子=NavigationRail 决定),
              // 用 stretch/SizedBox(infinity) 会喺宽度未定阶段畀子 unbounded 宽 → invalid matrix 黑屏。
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (system.isMacOS) const SizedBox(height: 22),
                const SizedBox(height: 10),
                // 品牌:D-v 图标 +(展开时)Voguesly 易联
                const ClipRect(child: AppIcon()),
                if (showLabel) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Voguesly',
                    style: context.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: context.colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    '易联',
                    style: context.textTheme.labelSmall?.copyWith(
                      color: context.colorScheme.primary,
                      letterSpacing: 2,
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                // ⚠️ 顶部导航 + 底部菜单(购买/邀请/用户中心/客服)合并成**单一可滚动列表**:
                // 拉窄窗口时整条一齐滚,唔会两组重叠割裂(Sam 反馈)。
                Expanded(
                  child: ScrollConfiguration(
                    behavior: HiddenBarScrollBehavior(),
                    child: SingleChildScrollView(
                      // ⚠️ 固定宽度锚定:侧栏 Column 系 content-sized,冇呢个 stretch 会畀子 unbounded 宽→黑屏。
                      child: SizedBox(
                        width: showLabel ? 196 : 58,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                          for (var i = 0; i < navigationItems.length; i++)
                            _SidebarNavRow(
                              icon: navigationItems[i].icon,
                              label: Intl.message(navigationItems[i].label.name),
                              selected: i == currentIndex,
                              showLabel: showLabel,
                              onTap: () =>
                                  _handleToPage(navigationItems[i].label),
                            ),
                          const SizedBox(height: 8),
                          const Divider(height: 1, indent: 12, endIndent: 12),
                          const SizedBox(height: 8),
                          // 底部快捷:全部**半框**(只覆盖右边内容区,左侧栏保留可点)。
                          _SidebarLink(
                            icon: Icons.storefront_outlined,
                            label: '购买套餐',
                            showLabel: showLabel,
                            selected: overlay == ContentOverlay.shop,
                            onTap: () => ref
                                .read(contentOverlayProvider.notifier)
                                .set(ContentOverlay.shop),
                          ),
                          _SidebarLink(
                            icon: Icons.card_giftcard_outlined,
                            label: '邀请返利',
                            showLabel: showLabel,
                            selected: overlay == ContentOverlay.invite,
                            onTap: () => ref
                                .read(contentOverlayProvider.notifier)
                                .set(ContentOverlay.invite),
                          ),
                          _SidebarLink(
                            icon: Icons.account_circle_outlined,
                            label: '用户中心',
                            showLabel: showLabel,
                            selected: overlay == ContentOverlay.userCenter,
                            onTap: () => ref
                                .read(contentOverlayProvider.notifier)
                                .set(ContentOverlay.userCenter),
                          ),
                          _SidebarLink(
                            icon: Icons.campaign_outlined,
                            label: '公告中心',
                            showLabel: showLabel,
                            selected: overlay == ContentOverlay.notice,
                            onTap: () => ref
                                .read(contentOverlayProvider.notifier)
                                .set(ContentOverlay.notice),
                          ),
                          _SidebarLink(
                            icon: Icons.data_usage_outlined,
                            label: '流量明细',
                            showLabel: showLabel,
                            selected: overlay == ContentOverlay.stat,
                            onTap: () => ref
                                .read(contentOverlayProvider.notifier)
                                .set(ContentOverlay.stat),
                          ),
                          _SidebarLink(
                            icon: Icons.support_agent_outlined,
                            label: '在线客服',
                            showLabel: showLabel,
                            selected: overlay == ContentOverlay.cs,
                            onTap: () => ref
                                .read(contentOverlayProvider.notifier)
                                .set(ContentOverlay.cs),
                          ),
                          const SizedBox(height: 12),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: ClipRect(
            // 半框:购买套餐/邀请/用户中心/客服 都只覆盖右边内容区,左侧栏保留可点(Sam 要求)。
            child: Stack(
              children: [
                LayoutBuilder(
                  builder: (_, constraints) {
                    _updateSideBarWidth(ref, constraints.maxWidth);
                    return child;
                  },
                ),
                if (overlay != ContentOverlay.none)
                  Positioned.fill(
                    child: ContentOverlayScope(
                      close: () =>
                          ref.read(contentOverlayProvider.notifier).close(),
                      child: switch (overlay) {
                        ContentOverlay.shop => const VogueslyShopPage(),
                        ContentOverlay.invite => const VogueslyInvitePage(),
                        ContentOverlay.userCenter =>
                          const VogueslyUserCenterPage(),
                        ContentOverlay.cs => const VogueslyCsPanel(),
                        ContentOverlay.notice => const VogueslyNoticePage(),
                        ContentOverlay.stat => const VogueslyStatPage(),
                        ContentOverlay.none => const SizedBox.shrink(),
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SidebarLink extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool showLabel;
  final bool selected; // 半框 overlay 打开时高亮对应项
  final VoidCallback onTap;
  const _SidebarLink({
    required this.icon,
    required this.label,
    required this.showLabel,
    required this.onTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final color = selected ? cs.onSecondaryContainer : cs.onSurfaceVariant;
    void open() => onTap();
    if (showLabel) {
      // 左对齐(对齐顶部 NavigationRail 图标 ~22px):Align(centerLeft) 撑满宽再靠左,
      // 内容 Row 用 mainAxisSize.min。⚠️ 唔用 Expanded/SizedBox(infinity)(会 unbounded 宽黑屏)。
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Material(
            color: selected ? cs.secondaryContainer : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: open,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 14, 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: 22, color: color),
                    const SizedBox(width: 14),
                    Text(label,
                        style: context.textTheme.labelLarge?.copyWith(
                            color: color,
                            fontWeight:
                                selected ? FontWeight.w700 : FontWeight.w500)),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
    return IconButton(
      tooltip: label,
      onPressed: open,
      icon: Icon(icon, size: 22, color: color),
    );
  }
}

/// 侧栏顶部导航行(带选中态)。同底部 _SidebarLink 一齐放喺单一滚动列表,防拉窄重叠。
class _SidebarNavRow extends StatelessWidget {
  final Widget icon; // navigationItems 的 icon 系 Widget
  final String label;
  final bool selected;
  final bool showLabel;
  final VoidCallback onTap;
  const _SidebarNavRow({
    required this.icon,
    required this.label,
    required this.selected,
    required this.showLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final fg = selected ? cs.onSecondaryContainer : cs.onSurfaceVariant;
    final content = Padding(
      padding: EdgeInsets.symmetric(
          horizontal: 14, vertical: showLabel ? 11 : 9),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconTheme.merge(
            data: IconThemeData(size: 22, color: fg),
            child: icon,
          ),
          if (showLabel) ...[
            const SizedBox(width: 14),
            Text(label,
                style: context.textTheme.labelLarge?.copyWith(
                    color: fg,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500)),
          ],
        ],
      ),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
      child: Material(
        color: selected ? cs.secondaryContainer : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: showLabel
              ? Align(alignment: Alignment.centerLeft, child: content)
              : Center(child: content),
        ),
      ),
    );
  }
}
