// ignore_for_file: constant_identifier_names

import 'dart:math';
import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:flutter/material.dart';

const appName = '易联 voguesly';
const appHelperService = 'FlClashHelperService';
const coreName = 'clash.meta';
const browserUa =
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36';
const packageName = 'com.follow.clash';
final unixSocketPath = '/tmp/FlClashSocket_${Random().nextInt(10000)}.sock';
final windowsPipeName = '\\\\.\\pipe\\FlClashCore_${Random().nextInt(10000)}';
const helperPort = 47890;
const maxTextScale = 1.4;
const minTextScale = 0.8;
final baseInfoEdgeInsets = EdgeInsets.symmetric(
  vertical: 16.mAp,
  horizontal: 16.mAp,
);
final listHeaderPadding = EdgeInsets.only(
  left: 16.mAp,
  right: 8.mAp,
  top: 24.mAp,
  bottom: 8.mAp,
);
const sheetAppBarHeight = 68.0;

const watchExecution = false;

final defaultTextScaleFactor =
    WidgetsBinding.instance.platformDispatcher.textScaleFactor;
const httpTimeoutDuration = Duration(milliseconds: 5000);
const moreDuration = Duration(milliseconds: 100);
const animateDuration = Duration(milliseconds: 100);
const midDuration = Duration(milliseconds: 200);
const commonDuration = Duration(milliseconds: 300);
const defaultUpdateDuration = Duration(days: 1);
const MMDB = 'GEOIP.metadb';
const ASN = 'ASN.mmdb';
const GEOIP = 'GEOIP.dat';
const GEOSITE = 'GEOSITE.dat';
final double kHeaderHeight = system.isDesktop
    ? !system.isMacOS
          ? 40
          : 28
    : 0;
const profilesDirectoryName = 'profiles';
const localhost = '127.0.0.1';
const clashConfigKey = 'clash_config';
const configKey = 'config';
const double dialogCommonWidth = 300;
// ⚠️ 呢个 fork 已经唔再检查上游 chen08209/FlClash 嘅 release(旧代码打
// api.github.com/repos/chen08209/FlClash/releases/latest,会引导用户去装返
// 原版 FlClash——完全错嘅方向,而且 api.github.com 喺国内冇 VPN 好大机会连唔到)。
// 改用自己域名(cp 面板同 host,登录/订阅都靠佢,已确认国内可达)。
const vogueslyVersionCheckUrl = 'https://cp.samseah.qzz.io/downloads/version.json';
// ⚠️ 保持 9090 唔改:呢个係「外部控制器」开关(ExternalControllerStatus 默认
// close,要用户主动开先监听),撞端口嘅机会远低过 mixed-port;而佢嘅
// @JsonValue 就係 '127.0.0.1:9090',改咗会令旧配置反序列化唔返 —— 风险大过收益。
const defaultExternalController = '127.0.0.1:9090';
const maxMobileWidth = 600;
const maxLaptopWidth = 840;
/// 节点延迟测速 / DIRECT 延迟嘅默认目标。
///
/// ⚠️ **唔好换返 gstatic**(2026-08-10 三点实测,数据见下),旧值 `https://www.gstatic.com/generate_204`
/// 同时坏咗两件事:
///  ① **国内直连唔通** → 测 DIRECT 必然 timeout,界面上「直连」永远显示红,用户以为直连坏咗。
///     实测(Sam 家网,去代理真直连):gstatic 6s 超时;google/generate_204 一样超时。
///  ② **单个 IP,遇到烂路由就虚高** → 界面上节点延迟数字唔可信。实测同一个 gstatic:
///     HK 出口 **627ms**、SG 出口 49ms(相差 12 倍),而 cp.cloudflare 喺两边都係 6-10ms。
///     `voguesly_detection.dart` 早就为咗同一原因唔用 gstatic(嗰度实测过 1055ms ≈ 4× 基线)。
///
/// 拣 `cp.cloudflare.com` 嘅理由:唯一**两边都满足**嘅候选 —— 国内直连通(实测 385ms,
/// 令 DIRECT 有真数字),境外出口又快又稳(HK 6ms / SG 10ms,anycast 多 IP,唔会撞单点烂路由)。
/// 用 http 唔用 https:免 TLS 握手噪音,量到更接近纯 RTT(mihomo 上游默认都係 http 204)。
const defaultTestUrl = 'http://cp.cloudflare.com/generate_204';

/// 旧默认值,只畀迁移逻辑认「呢个係我哋以前钉嘅默认」用,唔好再攞去测速。
const legacyGstaticTestUrl = 'https://www.gstatic.com/generate_204';
final commonFilter = ImageFilter.blur(
  sigmaX: 5,
  sigmaY: 5,
  tileMode: TileMode.clamp,
);

const listEquality = ListEquality();
const navigationItemListEquality = ListEquality<NavigationItem>();
const trackerInfoListEquality = ListEquality<TrackerInfo>();
const stringListEquality = ListEquality<String>();
const intListEquality = ListEquality<int>();
const logListEquality = ListEquality<Log>();
const groupListEquality = ListEquality<Group>();
const ruleListEquality = ListEquality<Rule>();
const scriptListEquality = ListEquality<Script>();
const externalProviderListEquality = ListEquality<ExternalProvider>();
const packageListEquality = ListEquality<Package>();
const profileListEquality = ListEquality<Profile>();
const proxyGroupsEquality = ListEquality<ProxyGroup>();
const hotKeyActionListEquality = ListEquality<HotKeyAction>();
const stringAndStringMapEquality = MapEquality<String, String>();
const stringAndStringMapEntryListEquality =
    ListEquality<MapEntry<String, String>>();
const stringAndStringMapEntryIterableEquality =
    IterableEquality<MapEntry<String, String>>();
const stringAndObjectMapEntryIterableEquality =
    IterableEquality<MapEntry<String, Object?>>();
const delayMapEquality = MapEquality<String, Map<String, int?>>();
const stringSetEquality = SetEquality<String>();
const keyboardModifierListEquality = SetEquality<KeyboardModifier>();

const viewModeColumnsMap = {
  ViewMode.mobile: [2, 1],
  ViewMode.laptop: [3, 2],
  ViewMode.desktop: [4, 3],
};

const proxiesListStoreKey = PageStorageKey<String>('proxies_list');
const toolsStoreKey = PageStorageKey<String>('tools');
const profilesStoreKey = PageStorageKey<String>('profiles');

// 易联品牌主色:voguesly D-v 霓虹紫(#7C5CF6,对齐 D-v icon 同 Ninja 参考风格)。
// Material ColorScheme.fromSeed 会据此铺全局色调。
const defaultPrimaryColor = 0XFF7C5CF6;

double getWidgetHeight(num lines) {
  final space = 14.mAp;
  return max(lines * (80.ap + space) - space, 0);
}

const maxLength = 1000;

const mainIsolate = 'FlClashMainIsolate';

const serviceIsolate = 'FlClashServiceIsolate';

const defaultPrimaryColors = [
  0xFF795548,
  0xFF03A9F4,
  0xFFFFFF00,
  0XFFBBC9CC,
  0XFFABD397,
  defaultPrimaryColor,
  0XFF665390,
];

const scriptTemplate = '''
const main = (config) => {
  return config;
}''';

const backupDatabaseName = 'database.sqlite';
const configJsonName = 'config.json';
