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
import 'package:fl_clash/voguesly/voguesly_subscription.dart';
import 'package:fl_clash/voguesly/voguesly_user_center.dart';
import 'package:intl/intl.dart';

/// 侧栏「有新版本」入口用嘅版本号(null = 已係最新 / 未检查到)。
///
/// 独立于 appSetting.autoCheckUpdate 嗰个开关:嗰个开关嘅语义係「唔好弹窗打扰我」,
/// 唔应该顺带令用户**连边度睇更新都揾唔到**。所以呢度做一次静默检查,只喺侧栏亮一个
/// 入口,唔弹任何嘢;用户想更新先撳。呢样先至係 Sam 要嘅「唔使入设置→关于」。
/// ⚠️ riverpod 3 已经移除 StateProvider,手写 Notifier(唔使跑 build_runner,
/// 网络断嗰阵一样改得郁)。
class VogueslyUpdateVersion extends Notifier<String?> {
  @override
  String? build() => null;

  void set(String? value) => state = value;
}

final vogueslyUpdateVersionProvider =
    NotifierProvider<VogueslyUpdateVersion, String?>(
      VogueslyUpdateVersion.new,
    );

class AppStateManager extends ConsumerStatefulWidget {
  final Widget child;

  const AppStateManager({super.key, required this.child});

  @override
  ConsumerState<AppStateManager> createState() => _AppStateManagerState();
}

class _AppStateManagerState extends ConsumerState<AppStateManager>
    with WidgetsBindingObserver {
  /// 上次真正查过更新嘅时间。用嚟节流,避免回前台好频繁时不停打后端。
  DateTime? _lastUpdateCheckAt;

  /// 静默检查新版本,只写 provider 畀侧栏亮入口,**唔弹任何窗**。
  /// 失败一律静默(唔可以因为检查更新失败就打扰用户)。
  ///
  /// ⚠️ 之前净係喺 initState 调一次 —— 桌面用户 app 长开唔重启,就永远唔会再查,
  /// 出咗新版都要自己去撳「检查更新」先见到。所以回前台(resumed)亦要查一次。
  /// [delay] 启动时等几秒避开其他启动请求;回前台唔使等。
  Future<void> _silentCheckUpdate({
    Duration delay = const Duration(seconds: 5),
  }) async {
    final now = DateTime.now();
    if (_lastUpdateCheckAt != null &&
        now.difference(_lastUpdateCheckAt!) < const Duration(hours: 1)) {
      return; // 1 小时内查过就唔再查
    }
    _lastUpdateCheckAt = now; // 先占位,避免并发重入
    if (delay > Duration.zero) await Future.delayed(delay);
    if (!mounted) return;
    try {
      final res = await request.checkForUpdate();
      if (!mounted || res == null) return;
      // checkForUpdate 内部已经做咗版本比较,有返回 = 真係有新版;
      // __net_error__ 係网络异常标记,唔当有更新。
      if (res['__net_error__'] == true) {
        _lastUpdateCheckAt = null; // 网络问题唔算查过,下次回前台再试
        return;
      }
      final tag = res['tag_name'] as String?;
      if (tag == null || tag.isEmpty) return;
      ref.read(vogueslyUpdateVersionProvider.notifier).set(tag);
    } catch (_) {
      _lastUpdateCheckAt = null; // 同上:异常唔算查过
      // 静默:侧栏唔亮入口就算,唔好因为呢个 feature 影响正常使用。
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _silentCheckUpdate();
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
        // 回前台顺手查下有冇新版(内部 1 小时节流)。桌面用户长开唔重启,
        // 冇呢句就只有启动嗰次会查,新版本推唔到佢哋手上。
        _silentCheckUpdate(delay: Duration.zero);
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

  /// 侧栏「更新订阅」:拉最新节点+规则。有本账号订阅就 in-place 刷新(同「我的」页一致,
  /// 保留选中);无订阅则走一键导入。结果弹 toast。
  Future<void> _updateSubscription(WidgetRef ref) async {
    final vog = ref.read(profilesProvider).where(isVogueslyProfile);
    final ok = vog.isEmpty
        ? await importVogueslySubscription()
        : await ref
            .read(profilesActionProvider.notifier)
            .refreshVogueslyProfile(vog.first, showLoading: true);
    globalState.showNotifier(ok ? '订阅已更新' : '更新失败,请稍后重试');
  }

  /// 侧栏「登出」:确认后关半框 overlay → 先删本账号订阅(防换账号串号)→ 清登录态。
  /// 与 tools.dart / profiles.dart 登出共用同一清理逻辑,杜绝匹配器漂移。
  Future<void> _confirmLogout(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('退出登录'),
        content: const Text('确定退出当前账户?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('退出'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    ref.read(contentOverlayProvider.notifier).close();
    await clearVogueslyProfiles();
    ref.read(vogueslyAuthProvider.notifier).logout();
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
    final updateVersion = ref.watch(vogueslyUpdateVersionProvider);
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
                        width: 196,
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
                          // 「购买套餐」已升为顶层 nav tab(上方),此处不再重复。
                          // 「更新订阅」升一级入口(Sam 要求常驻好找):复用「我的」页同一
                          // refreshVogueslyProfile / importVogueslySubscription 逻辑,拉最新节点+规则。
                          _SidebarLink(
                            icon: Icons.cloud_sync_outlined,
                            label: '更新订阅',
                            showLabel: showLabel,
                            onTap: () => _updateSubscription(ref),
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
                            // Win/Linux 无 webview 桌面实现 → open() 改行系统浏览器(防崩);
                            // macOS 仍走半框 overlay。
                            onTap: () => VogueslyCsPanel.open(context),
                          ),
                          // 「检查更新」**常驻**。
                          // ⚠️ 2026-08-05 初版写成 `if (updateVersion != null)` 先出现,
                          // 结果係:已经喺最新版嘅用户(即大多数)**永远见唔到呢个入口**,
                          // 连「想手动查一次」都做唔到,亦无从知道功能有冇喺度行 —— Sam 第一时间
                          // 就问「点解冇」。呢个係错嘅设计:入口应该常驻,状态先至变。
                          // 平时 = 「检查更新」普通样式;静默检查到新版 = 高亮 +「有新版本 x.x.x」。
                          // 两种状态撳落去都係行现成嘅 manualCheckUpdate(有新版弹版本说明+下载,
                          // 冇新版弹「已是最新」),唔另开一套更新流程免得行为唔一致。
                          _SidebarLink(
                            icon: Icons.system_update_alt_rounded,
                            label: updateVersion != null
                                ? '有新版本 $updateVersion'
                                : '检查更新',
                            showLabel: showLabel,
                            highlight: updateVersion != null,
                            onTap: () => ref
                                .read(commonActionProvider.notifier)
                                .manualCheckUpdate(),
                          ),
                          const SizedBox(height: 12),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // 登出:钉喺侧栏最底(scroll 之外常显),红色次要样式,同功能项用分隔线分开。
                // 多账号用户唔使深入「设置」揾退出。复用 tools/profiles 同一清理(防串号)。
                // 宽度 196 同上方 nav 列对齐(showLabel 恒真,唔用三元免 dead_code)。
                SizedBox(
                  width: 196,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Divider(height: 1, indent: 12, endIndent: 12),
                      const SizedBox(height: 4),
                      _SidebarLink(
                        icon: Icons.logout,
                        label: '登出',
                        showLabel: showLabel,
                        danger: true,
                        onTap: () => _confirmLogout(context, ref),
                      ),
                      const SizedBox(height: 10),
                    ],
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
  final bool danger; // 危险/次要样式(登出):红色文字图标,同功能项区分
  final bool highlight; // 主动引导样式(有新版本):主色 + 加粗,平时唔用
  final VoidCallback onTap;
  const _SidebarLink({
    required this.icon,
    required this.label,
    required this.showLabel,
    required this.onTap,
    this.selected = false,
    this.danger = false,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final color = danger
        ? cs.error
        : highlight
        ? cs.primary
        : (selected ? cs.onSecondaryContainer : cs.onSurfaceVariant);
    void open() => onTap();
    if (showLabel) {
      // 左对齐(对齐顶部 NavigationRail 图标 ~22px):Align(centerLeft) 撑满宽再靠左,
      // 内容 Row 用 mainAxisSize.min。⚠️ 唔用 Expanded/SizedBox(infinity)(会 unbounded 宽黑屏)。
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Material(
            color: selected
                ? cs.secondaryContainer
                : highlight
                // 有新版本:淡主色底,喺一列灰字入面一眼睇到,但唔会抢过大圆圈。
                ? cs.primary.withValues(alpha: 0.12)
                : Colors.transparent,
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
                            fontWeight: (selected || highlight)
                                ? FontWeight.w700
                                : FontWeight.w500)),
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
