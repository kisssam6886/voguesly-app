import 'package:fl_clash/common/app_localizations.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/views/views.dart';
import 'package:fl_clash/voguesly/voguesly_cs.dart';
import 'package:fl_clash/voguesly/voguesly_detection.dart';
import 'package:fl_clash/voguesly/voguesly_shop.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Navigation {
  static Navigation? _instance;

  List<NavigationItem> getItems({
    bool openLogs = false,
    bool hasProxies = false,
  }) {
    return [
      NavigationItem(
        keep: false,
        icon: const Icon(Icons.space_dashboard),
        label: PageLabel.dashboard,
        builder: (_) =>
            const DashboardView(key: GlobalObjectKey(PageLabel.dashboard)),
      ),
      // 购买套餐 = 商业化核心入口,做顶层 tab(手机底栏+桌面侧栏都露),同宝贝云一致。
      NavigationItem(
        keep: false,
        icon: const Icon(Icons.storefront),
        label: PageLabel.shop,
        builder: (_) =>
            const VogueslyShopPage(key: GlobalObjectKey(PageLabel.shop)),
        modes: [NavigationItemMode.desktop, NavigationItemMode.mobile],
      ),
      NavigationItem(
        icon: const Icon(Icons.travel_explore),
        label: PageLabel.detection,
        builder: (_) => const VogueslyDetectionView(
          key: GlobalObjectKey(PageLabel.detection),
        ),
        modes: [NavigationItemMode.desktop, NavigationItemMode.mobile],
      ),
      NavigationItem(
        icon: const Icon(Icons.article),
        label: PageLabel.proxies,
        builder: (_) =>
            const ProxiesView(key: GlobalObjectKey(PageLabel.proxies)),
        modes: hasProxies
            ? [NavigationItemMode.mobile, NavigationItemMode.desktop]
            : [],
      ),
      // 2026-09-18 Sam:客服好重要(用户反馈入口),升做一级 tab —— 安卓底栏第 5 位、桌面侧栏「在线客服」。
      // 打开嘅就係现有 VogueslyCsPanel(webview),唔另写页。keep:false 免得 webview 长驻后台。
      NavigationItem(
        keep: false,
        icon: const Icon(Icons.support_agent),
        label: PageLabel.support,
        builder: (_) => const VogueslySupportPage(
          key: GlobalObjectKey(PageLabel.support),
        ),
        modes: [NavigationItemMode.desktop, NavigationItemMode.mobile],
      ),
      NavigationItem(
        icon: const Icon(Icons.folder),
        label: PageLabel.profiles,
        builder: (_) =>
            const ProfilesView(key: GlobalObjectKey(PageLabel.profiles)),
        // 消费者唔应见到裸订阅 profile 卡(两张卡好困惑)。侧栏隐藏;更新订阅入口喺「我的」页顶
        // 同账号卡自动处理;管理订阅仍可由「我的」→ 管理订阅 入。
        modes: [],
      ),
      // 请求/连接 = FlClash 工程化调试页,消费者用唔着(Ninja 都冇)。隐藏(modes 清空)。
      NavigationItem(
        icon: const Icon(Icons.view_timeline),
        label: PageLabel.requests,
        builder: (_) =>
            const RequestsView(key: GlobalObjectKey(PageLabel.requests)),
        description: 'requestsDesc',
        modes: [],
      ),
      NavigationItem(
        icon: const Icon(Icons.ballot),
        label: PageLabel.connections,
        builder: (_) =>
            const ConnectionsView(key: GlobalObjectKey(PageLabel.connections)),
        description: 'connectionsDesc',
        modes: [],
      ),
      NavigationItem(
        icon: const Icon(Icons.storage),
        label: PageLabel.resources,
        description: 'resourcesDesc',
        builder: (_) =>
            const ResourcesView(key: GlobalObjectKey(PageLabel.resources)),
        // 外部 provider/geodata 工程页,消费者用唔着。隐藏(连「高级工具」都唔露)。
        modes: [],
      ),
      NavigationItem(
        icon: const Icon(Icons.adb),
        label: PageLabel.logs,
        builder: (_) => const LogsView(key: GlobalObjectKey(PageLabel.logs)),
        description: 'logsDesc',
        // 调试日志页,消费者唔应喺侧栏见到(即使 openLogs 开)。彻底隐藏。
        modes: [],
      ),
      NavigationItem(
        icon: const Icon(Icons.person),
        label: PageLabel.tools,
        builder: (_) => const ToolsView(key: GlobalObjectKey(PageLabel.tools)),
        modes: [NavigationItemMode.desktop, NavigationItemMode.mobile],
      ),
    ];
  }

  Navigation._internal();

  factory Navigation() {
    _instance ??= Navigation._internal();
    return _instance!;
  }
}

final navigation = Navigation();

/// 2026-09-18 Sam 拍板命名:桌面侧栏四字对称,安卓底栏两字。
///   桌面:易联首页 / 购买套餐 / 网络检测 / 切换线路 / 在线客服 / 我的账户
///   安卓:首页 / 套餐 / 检测 / 线路 / 客服 / 我的
/// 桌面直接用各页标题 key(dashboard/shop/detection/support/tools 已改成四字),
/// 只有「线路」因为 `proxies` key 仲有 6 处工程页用紧「线路」两字,桌面另用 vgNavLinesDesktop。
String vogueslyNavLabel(PageLabel label, {required bool desktop}) {
  final l = currentAppLocalizations;
  if (desktop) {
    return switch (label) {
      PageLabel.proxies => l.vgNavLinesDesktop,
      _ => Intl.message(label.name),
    };
  }
  return switch (label) {
    PageLabel.dashboard => l.vgNavHome,
    PageLabel.shop => l.vgNavShop,
    PageLabel.detection => l.vgNavDetect,
    PageLabel.proxies => l.vgNavLines,
    PageLabel.support => l.vgNavSupport,
    PageLabel.tools => l.vgNavMine,
    _ => Intl.message(label.name),
  };
}
