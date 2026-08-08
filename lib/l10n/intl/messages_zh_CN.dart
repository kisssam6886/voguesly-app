// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a zh_CN locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'zh_CN';

  static String m0(count) => "${count} 天前";

  static String m1(label) => "确定删除选中的${label}吗？";

  static String m2(label) => "确定删除当前${label}吗？";

  static String m3(label) => "${label}详情";

  static String m4(label) => "${label}不能为空";

  static String m5(label) => "${label}当前已存在";

  static String m6(count) => "${count} 小时前";

  static String m7(target) => "${target} 是一个无效的策略";

  static String m8(proxyName) => "${proxyName} 是一个无效的代理";

  static String m9(providerName) => "${providerName} 是一个无效的代理集";

  static String m10(subRule) => "${subRule} 是一个无效的SUB_RULE";

  static String m11(appName) =>
      "1. 打开 系统设置 > 隐私与安全性\n2. 选择 定位服务\n3. 在右侧列表中找到并勾选 ${appName}\n\n完成设置后，返回应用即可正常使用。感谢您的配合。";

  static String m12(count) => "${count} 分钟前";

  static String m13(count) => "${count} 个月前";

  static String m14(label) => "暂无${label}";

  static String m15(label) => "${label}必须为数字";

  static String m16(label) => "${label} 必须在 1024 到 49151 之间";

  static String m17(count) => "已选择 ${count} 项";

  static String m18(label) => "${label}必须为URL";

  static String m19(p0) => "开通失败: ${p0}";

  static String m20(p0) => "可用佣金:${p0}";

  static String m21(p0) => "立即购买 ${p0}";

  static String m22(p0) => "确定取消订单「${p0}」?";

  static String m23(p0) => "${p0}已复制";

  static String m24(p0) => "当前余额:${p0}";

  static String m25(p0) => "当前套餐: ${p0} · ";

  static String m26(p0) => "当前套餐:${p0}";

  static String m27(p0, p1, p2) => "设备: ${p0} ${p1} · Android ${p2}";

  static String m28(p0) => "时长 ${p0}";

  static String m29(p0) => "${p0}已过期";

  static String m30(p0, p1) => "${p0}\\n\\n=== 诊断信息(自动附带) ===\\n${p1}";

  static String m31(p0) => "${p0} 起";

  static String m32(p0) => "${p0}；已保持「系统代理（兼容模式）」承载流量";

  static String m33(p0) => "上次更新 · 今天 ${p0}";

  static String m34(p0, p1) => "上次更新 · ${p0} ${p1}";

  static String m35(p0) => "加载失败:${p0}";

  static String m36(p0, p1) => "加载失败:${p0}(code ${p1})";

  static String m37(p0) => "本机环境正常，易联正以${p0}接管中。";

  static String m38(p0) => "本机端口被 ${p0} 占用，易联核心可能无法绑定 —— 建议改用另一个端口。";

  static String m39(p0) => "本地端口 ${p0}";

  static String m40(p0) => "${p0} 个周期可选";

  static String m41(p0) => "${p0} 天";

  static String m42(p0) => "${p0} 个月";

  static String m43(p0) => "${p0} 人";

  static String m44(p0) => "${p0} 年";

  static String m45(p0) => "网络异常: ${p0}";

  static String m46(p0) => "有新版本 ${p0}";

  static String m47(p0) => "下单失败: ${p0}";

  static String m48(p0) => "订单号:${p0}";

  static String m49(p0) => "检测到其他代理正在运行(${p0})，请先关闭后再连接易联";

  static String m50(p0) => "检测到其他代理正在运行(${p0})，本次暂不启用易联 TUN";

  static String m51(p0) => "支付发起失败: ${p0}";

  static String m52(p0) => "套餐可同时连接 ${p0} 台设备；";

  static String m53(p0) => "指向易联 · ${p0}";

  static String m54(p0, p1) =>
      "${p0} 占用了 ${p1}，导致易联核心无法绑定 —— 这正是「界面显示已连接但上不了网」";

  static String m55(p0) => "公网流量正在走 ${p0}，但不是易联的虚拟网卡 ——";

  static String m56(p0) => "发送失败: ${p0}";

  static String m57(p0) => "限速 ${p0} Mbps";

  static String m58(p0) => "提交失败: ${p0}";

  static String m59(p0) => "${p0}（兼容模式）";

  static String m60(p0, p1) => "系统代理全机只有一份设置，后写者胜 —— 当前指向 ${p0}，不是易联的 ${p1}。";

  static String m61(p0) => "被其他软件接管 · ${p0}";

  static String m62(p0) => "被其他程序占用 · ${p0}";

  static String m63(p0) => "轻触断开  ·  ${p0}";

  static String m64(p0) => "${p0}；已临时启用「系统代理（兼容模式）」保证上网。";

  static String m65(p0) => "工单 #${p0}";

  static String m66(p0) => "流量 ${p0} GB";

  static String m67(p0) => "${p0}（设备接管）";

  static String m68(p0, p1) => "版本: ${p0}+${p1}";

  static String m69(p0) => "版本号: ${p0}";

  static String m70(p0) => "v${p0} · 点击检查更新";

  static String m71(p0) => "易联接管中 · ${p0}";

  static String m72(p0) => "WebView 初始化失败:${p0}";

  static String m73(count) => "${count} 年前";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "about": MessageLookupByLibrary.simpleMessage("关于"),
    "accessControl": MessageLookupByLibrary.simpleMessage("访问控制"),
    "accessControlAllowDesc": MessageLookupByLibrary.simpleMessage(
      "只允许选中应用进入VPN",
    ),
    "accessControlDesc": MessageLookupByLibrary.simpleMessage("配置应用访问代理"),
    "accessControlNotAllowDesc": MessageLookupByLibrary.simpleMessage(
      "选中应用将会被排除在VPN之外",
    ),
    "accessControlSettings": MessageLookupByLibrary.simpleMessage("访问控制设置"),
    "account": MessageLookupByLibrary.simpleMessage("账号"),
    "action": MessageLookupByLibrary.simpleMessage("操作"),
    "action_mode": MessageLookupByLibrary.simpleMessage("切换模式"),
    "action_proxy": MessageLookupByLibrary.simpleMessage("系统代理"),
    "action_start": MessageLookupByLibrary.simpleMessage("启动/停止"),
    "action_tun": MessageLookupByLibrary.simpleMessage("虚拟网卡"),
    "action_view": MessageLookupByLibrary.simpleMessage("显示/隐藏"),
    "add": MessageLookupByLibrary.simpleMessage("添加"),
    "addProfile": MessageLookupByLibrary.simpleMessage("添加配置"),
    "addProxies": MessageLookupByLibrary.simpleMessage("添加代理"),
    "addProxyGroup": MessageLookupByLibrary.simpleMessage("添加策略组"),
    "addProxyProviders": MessageLookupByLibrary.simpleMessage("添加代理集"),
    "addRule": MessageLookupByLibrary.simpleMessage("添加规则"),
    "addSsid": MessageLookupByLibrary.simpleMessage("添加SSID"),
    "addedRules": MessageLookupByLibrary.simpleMessage("附加规则"),
    "additionalParameters": MessageLookupByLibrary.simpleMessage("附加参数"),
    "address": MessageLookupByLibrary.simpleMessage("地址"),
    "addressHelp": MessageLookupByLibrary.simpleMessage("WebDAV服务器地址"),
    "addressTip": MessageLookupByLibrary.simpleMessage("请输入有效的WebDAV地址"),
    "advancedConfig": MessageLookupByLibrary.simpleMessage("进阶配置"),
    "advancedConfigDesc": MessageLookupByLibrary.simpleMessage("提供多样化配置"),
    "advancedTools": MessageLookupByLibrary.simpleMessage("进阶"),
    "agree": MessageLookupByLibrary.simpleMessage("同意"),
    "allowBypass": MessageLookupByLibrary.simpleMessage("允许应用绕过VPN"),
    "allowBypassDesc": MessageLookupByLibrary.simpleMessage("开启后部分应用可绕过VPN"),
    "allowLan": MessageLookupByLibrary.simpleMessage("局域网代理"),
    "allowLanDesc": MessageLookupByLibrary.simpleMessage("允许通过局域网访问代理"),
    "app": MessageLookupByLibrary.simpleMessage("应用"),
    "appAccessControl": MessageLookupByLibrary.simpleMessage("应用访问控制"),
    "appendSystemDns": MessageLookupByLibrary.simpleMessage("追加系统DNS"),
    "appendSystemDnsTip": MessageLookupByLibrary.simpleMessage("强制为配置附加系统DNS"),
    "application": MessageLookupByLibrary.simpleMessage("应用程序"),
    "applicationDesc": MessageLookupByLibrary.simpleMessage("修改应用程序相关设置"),
    "authorized": MessageLookupByLibrary.simpleMessage("已授权"),
    "auto": MessageLookupByLibrary.simpleMessage("自动"),
    "autoCheckUpdate": MessageLookupByLibrary.simpleMessage("自动检查更新"),
    "autoCheckUpdateDesc": MessageLookupByLibrary.simpleMessage("应用启动时自动检查更新"),
    "autoCloseConnections": MessageLookupByLibrary.simpleMessage("自动关闭连接"),
    "autoCloseConnectionsDesc": MessageLookupByLibrary.simpleMessage(
      "切换节点后自动关闭连接",
    ),
    "autoLaunch": MessageLookupByLibrary.simpleMessage("自启动"),
    "autoLaunchDesc": MessageLookupByLibrary.simpleMessage("跟随系统自启动"),
    "autoRun": MessageLookupByLibrary.simpleMessage("自动运行"),
    "autoRunDesc": MessageLookupByLibrary.simpleMessage("应用打开时自动运行"),
    "autoSetSystemDns": MessageLookupByLibrary.simpleMessage("自动设置系统DNS"),
    "autoUpdate": MessageLookupByLibrary.simpleMessage("自动更新"),
    "autoUpdateInterval": MessageLookupByLibrary.simpleMessage("自动更新间隔（分钟）"),
    "backup": MessageLookupByLibrary.simpleMessage("备份"),
    "backupAndRestore": MessageLookupByLibrary.simpleMessage("备份与恢复"),
    "backupAndRestoreDesc": MessageLookupByLibrary.simpleMessage(
      "通过WebDAV或者文件同步数据",
    ),
    "backupSuccess": MessageLookupByLibrary.simpleMessage("备份成功"),
    "basicConfig": MessageLookupByLibrary.simpleMessage("基本配置"),
    "basicConfigDesc": MessageLookupByLibrary.simpleMessage("全局修改基本配置"),
    "basicInfo": MessageLookupByLibrary.simpleMessage("基础信息"),
    "basicStrategy": MessageLookupByLibrary.simpleMessage("基础策略"),
    "batteryOptimizationDesc": MessageLookupByLibrary.simpleMessage(
      "为保证后台运行，请关闭本应用的电池优化。点击前往设置。",
    ),
    "batteryOptimizationStatusTip": MessageLookupByLibrary.simpleMessage(
      "受系统影响，不代表一定准确",
    ),
    "bind": MessageLookupByLibrary.simpleMessage("绑定"),
    "blacklistMode": MessageLookupByLibrary.simpleMessage("黑名单模式"),
    "bypassDomain": MessageLookupByLibrary.simpleMessage("排除域名"),
    "bypassDomainDesc": MessageLookupByLibrary.simpleMessage("仅在系统代理启用时生效"),
    "cacheCorrupt": MessageLookupByLibrary.simpleMessage("缓存已损坏，是否清空？"),
    "cancel": MessageLookupByLibrary.simpleMessage("取消"),
    "cancelSelectAll": MessageLookupByLibrary.simpleMessage("取消全选"),
    "checkUpdate": MessageLookupByLibrary.simpleMessage("检查更新"),
    "checkUpdateError": MessageLookupByLibrary.simpleMessage("当前应用已经是最新版了"),
    "clearData": MessageLookupByLibrary.simpleMessage("清除数据"),
    "clipboardExport": MessageLookupByLibrary.simpleMessage("导出剪贴板"),
    "clipboardImport": MessageLookupByLibrary.simpleMessage("剪贴板导入"),
    "color": MessageLookupByLibrary.simpleMessage("颜色"),
    "colorSchemes": MessageLookupByLibrary.simpleMessage("配色方案"),
    "columns": MessageLookupByLibrary.simpleMessage("列数"),
    "compatible": MessageLookupByLibrary.simpleMessage("兼容模式"),
    "configDataDetected": MessageLookupByLibrary.simpleMessage("检测到配置中存在数据"),
    "confirm": MessageLookupByLibrary.simpleMessage("确定"),
    "confirmClearAllData": MessageLookupByLibrary.simpleMessage("确定要清除所有数据？"),
    "confirmDeleteProxyGroup": MessageLookupByLibrary.simpleMessage(
      "确定要删除当前策略组吗？",
    ),
    "confirmExitWindow": MessageLookupByLibrary.simpleMessage("确定要退出当前窗口吗?"),
    "confirmForceCrashCore": MessageLookupByLibrary.simpleMessage("确定要强制崩溃核心？"),
    "confirmOverwriteTip": MessageLookupByLibrary.simpleMessage("确定后将会覆盖已有数据"),
    "connected": MessageLookupByLibrary.simpleMessage("已连接"),
    "connecting": MessageLookupByLibrary.simpleMessage("连接中..."),
    "connection": MessageLookupByLibrary.simpleMessage("连接"),
    "connections": MessageLookupByLibrary.simpleMessage("连接"),
    "connectionsDesc": MessageLookupByLibrary.simpleMessage("查看当前连接数据"),
    "connectivity": MessageLookupByLibrary.simpleMessage("连通性："),
    "content": MessageLookupByLibrary.simpleMessage("内容"),
    "contentNotEmpty": MessageLookupByLibrary.simpleMessage("内容不能为空"),
    "contentScheme": MessageLookupByLibrary.simpleMessage("内容主题"),
    "controlGlobalAddedRules": MessageLookupByLibrary.simpleMessage("控制全局附加规则"),
    "copy": MessageLookupByLibrary.simpleMessage("复制"),
    "copyEnvVar": MessageLookupByLibrary.simpleMessage("复制环境变量"),
    "copyLink": MessageLookupByLibrary.simpleMessage("复制链接"),
    "copySuccess": MessageLookupByLibrary.simpleMessage("复制成功"),
    "core": MessageLookupByLibrary.simpleMessage("内核"),
    "coreStatus": MessageLookupByLibrary.simpleMessage("核心状态"),
    "country": MessageLookupByLibrary.simpleMessage("区域"),
    "crashTest": MessageLookupByLibrary.simpleMessage("崩溃测试"),
    "crashlytics": MessageLookupByLibrary.simpleMessage("崩溃分析"),
    "crashlyticsTip": MessageLookupByLibrary.simpleMessage(
      "开启后，应用崩溃时自动上传不包含敏感信息的崩溃日志",
    ),
    "create": MessageLookupByLibrary.simpleMessage("创建"),
    "createProfile": MessageLookupByLibrary.simpleMessage("创建配置"),
    "creationTime": MessageLookupByLibrary.simpleMessage("创建时间"),
    "custom": MessageLookupByLibrary.simpleMessage("自定义"),
    "cut": MessageLookupByLibrary.simpleMessage("剪切"),
    "dark": MessageLookupByLibrary.simpleMessage("深色"),
    "dashboard": MessageLookupByLibrary.simpleMessage("仪表盘"),
    "dataChangedSave": MessageLookupByLibrary.simpleMessage("检测到数据有更改，是否保存"),
    "dataCollectionContent": MessageLookupByLibrary.simpleMessage(
      "本应用使用 Firebase Crashlytics 收集崩溃信息以改进应用稳定性。\n收集的数据包括设备信息和崩溃详情，不包含个人敏感数据。\n您可以在设置中关闭此功能。",
    ),
    "dataCollectionTip": MessageLookupByLibrary.simpleMessage("数据收集说明"),
    "daysAgo": m0,
    "defaultNameserver": MessageLookupByLibrary.simpleMessage("默认域名服务器"),
    "defaultNameserverDesc": MessageLookupByLibrary.simpleMessage("用于解析DNS服务器"),
    "defaultText": MessageLookupByLibrary.simpleMessage("默认"),
    "delay": MessageLookupByLibrary.simpleMessage("延迟"),
    "delayTest": MessageLookupByLibrary.simpleMessage("延迟测试"),
    "delete": MessageLookupByLibrary.simpleMessage("删除"),
    "deleteMultipTip": m1,
    "deleteTip": m2,
    "desc": MessageLookupByLibrary.simpleMessage(
      "基于ClashMeta的多平台代理客户端，简单易用，开源无广告。",
    ),
    "destination": MessageLookupByLibrary.simpleMessage("目标地址"),
    "destinationGeoIP": MessageLookupByLibrary.simpleMessage("目标地理定位"),
    "destinationIPASN": MessageLookupByLibrary.simpleMessage("目标IP ASN"),
    "details": m3,
    "detection": MessageLookupByLibrary.simpleMessage("检测"),
    "detectionTip": MessageLookupByLibrary.simpleMessage("依赖第三方api，仅供参考"),
    "developerMode": MessageLookupByLibrary.simpleMessage("开发者模式"),
    "developerModeEnableTip": MessageLookupByLibrary.simpleMessage("开发者模式已启用。"),
    "direct": MessageLookupByLibrary.simpleMessage("直连"),
    "disableUDP": MessageLookupByLibrary.simpleMessage("禁用UDP"),
    "disclaimer": MessageLookupByLibrary.simpleMessage("免责声明"),
    "disclaimerDesc": MessageLookupByLibrary.simpleMessage(
      "本软件仅供学习交流、科研等非商业性质的用途，严禁将本软件用于商业目的。如有任何商业行为，均与本软件无关。",
    ),
    "disconnected": MessageLookupByLibrary.simpleMessage("已断开"),
    "discoverNewVersion": MessageLookupByLibrary.simpleMessage("发现新版本"),
    "dnsDesc": MessageLookupByLibrary.simpleMessage("更新DNS相关设置"),
    "dnsHijacking": MessageLookupByLibrary.simpleMessage("DNS劫持"),
    "dnsMode": MessageLookupByLibrary.simpleMessage("DNS模式"),
    "doYouWantToPass": MessageLookupByLibrary.simpleMessage("是否要通过"),
    "domain": MessageLookupByLibrary.simpleMessage("域名"),
    "download": MessageLookupByLibrary.simpleMessage("下载"),
    "edit": MessageLookupByLibrary.simpleMessage("编辑"),
    "editGlobalRules": MessageLookupByLibrary.simpleMessage("编辑全局规则"),
    "editProxy": MessageLookupByLibrary.simpleMessage("编辑代理"),
    "editProxyGroup": MessageLookupByLibrary.simpleMessage("编辑策略组"),
    "editRule": MessageLookupByLibrary.simpleMessage("编辑规则"),
    "editSsid": MessageLookupByLibrary.simpleMessage("编辑SSID"),
    "emptyTip": m4,
    "en": MessageLookupByLibrary.simpleMessage("英语"),
    "entries": MessageLookupByLibrary.simpleMessage("个条目"),
    "exclude": MessageLookupByLibrary.simpleMessage("从最近任务中隐藏"),
    "excludeDesc": MessageLookupByLibrary.simpleMessage("应用在后台时,从最近任务中隐藏应用"),
    "excludeProxyFilter": MessageLookupByLibrary.simpleMessage("排除节点过滤器"),
    "excludeSsids": MessageLookupByLibrary.simpleMessage("排除SSIDs"),
    "excludeSsidsDesc": MessageLookupByLibrary.simpleMessage(
      "连接到被排除SSID的WIFI时，将会自动切换应用运行状态",
    ),
    "excludeType": MessageLookupByLibrary.simpleMessage("排除类型"),
    "existsTip": m5,
    "exit": MessageLookupByLibrary.simpleMessage("退出"),
    "expand": MessageLookupByLibrary.simpleMessage("标准"),
    "expectedStatus": MessageLookupByLibrary.simpleMessage("预期状态"),
    "exportFile": MessageLookupByLibrary.simpleMessage("导出文件"),
    "exportLogs": MessageLookupByLibrary.simpleMessage("导出日志"),
    "exportSuccess": MessageLookupByLibrary.simpleMessage("导出成功"),
    "expressiveScheme": MessageLookupByLibrary.simpleMessage("表现力"),
    "externalController": MessageLookupByLibrary.simpleMessage("外部控制器"),
    "externalControllerDesc": MessageLookupByLibrary.simpleMessage(
      "开启后将可以通过9090端口控制Clash内核",
    ),
    "externalFetch": MessageLookupByLibrary.simpleMessage("外部获取"),
    "externalLink": MessageLookupByLibrary.simpleMessage("外部链接"),
    "fakeipFilter": MessageLookupByLibrary.simpleMessage("Fakeip过滤"),
    "fakeipRange": MessageLookupByLibrary.simpleMessage("Fakeip范围"),
    "fallback": MessageLookupByLibrary.simpleMessage("Fallback"),
    "fallbackDesc": MessageLookupByLibrary.simpleMessage("一般情况下使用境外DNS"),
    "fallbackFilter": MessageLookupByLibrary.simpleMessage("Fallback过滤"),
    "fidelityScheme": MessageLookupByLibrary.simpleMessage("高保真"),
    "file": MessageLookupByLibrary.simpleMessage("文件"),
    "fileDesc": MessageLookupByLibrary.simpleMessage("直接上传配置文件"),
    "fileIsUpdate": MessageLookupByLibrary.simpleMessage("文件有修改，是否保存修改"),
    "findProcessMode": MessageLookupByLibrary.simpleMessage("查找进程"),
    "findProcessModeDesc": MessageLookupByLibrary.simpleMessage("开启后会有一定性能损耗"),
    "fontFamily": MessageLookupByLibrary.simpleMessage("字体"),
    "forceRestartCoreTip": MessageLookupByLibrary.simpleMessage("您确定要强制重启核心吗？"),
    "fruitSaladScheme": MessageLookupByLibrary.simpleMessage("果缤纷"),
    "general": MessageLookupByLibrary.simpleMessage("常规"),
    "geodataLoader": MessageLookupByLibrary.simpleMessage("Geo低内存模式"),
    "geodataLoaderDesc": MessageLookupByLibrary.simpleMessage("开启将使用Geo低内存加载器"),
    "geoipCode": MessageLookupByLibrary.simpleMessage("Geoip代码"),
    "global": MessageLookupByLibrary.simpleMessage("全局"),
    "go": MessageLookupByLibrary.simpleMessage("前往"),
    "goDownload": MessageLookupByLibrary.simpleMessage("前往下载"),
    "goToConfigureScript": MessageLookupByLibrary.simpleMessage("前往配置脚本"),
    "hasCacheChange": MessageLookupByLibrary.simpleMessage("是否缓存修改"),
    "hideFromList": MessageLookupByLibrary.simpleMessage("从列表中隐藏"),
    "host": MessageLookupByLibrary.simpleMessage("主机"),
    "hostsDesc": MessageLookupByLibrary.simpleMessage("追加Hosts"),
    "hotkeyConflict": MessageLookupByLibrary.simpleMessage("快捷键冲突"),
    "hotkeyManagement": MessageLookupByLibrary.simpleMessage("快捷键管理"),
    "hotkeyManagementDesc": MessageLookupByLibrary.simpleMessage("使用键盘控制应用程序"),
    "hoursAgo": m6,
    "icon": MessageLookupByLibrary.simpleMessage("图片"),
    "iconRecords": MessageLookupByLibrary.simpleMessage("图标记录"),
    "iconStyle": MessageLookupByLibrary.simpleMessage("图标样式"),
    "iconUrl": MessageLookupByLibrary.simpleMessage("图标链接"),
    "ignoreBatteryOptimization": MessageLookupByLibrary.simpleMessage("忽略电池优化"),
    "import": MessageLookupByLibrary.simpleMessage("导入"),
    "importFile": MessageLookupByLibrary.simpleMessage("通过文件导入"),
    "importFromURL": MessageLookupByLibrary.simpleMessage("从URL导入"),
    "importUrl": MessageLookupByLibrary.simpleMessage("通过URL导入"),
    "includeAllProxies": MessageLookupByLibrary.simpleMessage("包含所有代理"),
    "includeAllProxiesTip": MessageLookupByLibrary.simpleMessage(
      "引入不包含策略组的所有代理，可在下方额外添加策略组",
    ),
    "includeAllProxyProviders": MessageLookupByLibrary.simpleMessage("包含所有代理集"),
    "includeAllProxyProvidersTip": MessageLookupByLibrary.simpleMessage(
      "开启后将覆盖引入的代理集",
    ),
    "infiniteTime": MessageLookupByLibrary.simpleMessage("长期有效"),
    "init": MessageLookupByLibrary.simpleMessage("初始化"),
    "inputCorrectHotkey": MessageLookupByLibrary.simpleMessage("请输入正确的快捷键"),
    "inputProxyGroupName": MessageLookupByLibrary.simpleMessage("输入策略组名称"),
    "inputRuleContent": MessageLookupByLibrary.simpleMessage("输入规则内容"),
    "intelligentSelected": MessageLookupByLibrary.simpleMessage("智能选择"),
    "internet": MessageLookupByLibrary.simpleMessage("互联网"),
    "interval": MessageLookupByLibrary.simpleMessage("间隔"),
    "intranetIP": MessageLookupByLibrary.simpleMessage("内网 IP"),
    "invalidBackupFile": MessageLookupByLibrary.simpleMessage("无效备份文件"),
    "invalidPolicy": m7,
    "invalidProxy": m8,
    "invalidProxyProvider": m9,
    "invalidSubRule": m10,
    "ipcidr": MessageLookupByLibrary.simpleMessage("IP/掩码"),
    "ipv6Desc": MessageLookupByLibrary.simpleMessage("开启后将可以接收IPv6流量"),
    "ipv6InboundDesc": MessageLookupByLibrary.simpleMessage("允许IPv6入站"),
    "ja": MessageLookupByLibrary.simpleMessage("日语"),
    "justNow": MessageLookupByLibrary.simpleMessage("刚刚"),
    "keepAliveIntervalDesc": MessageLookupByLibrary.simpleMessage("TCP保持活动间隔"),
    "key": MessageLookupByLibrary.simpleMessage("键"),
    "language": MessageLookupByLibrary.simpleMessage("语言"),
    "layout": MessageLookupByLibrary.simpleMessage("布局"),
    "light": MessageLookupByLibrary.simpleMessage("浅色"),
    "list": MessageLookupByLibrary.simpleMessage("列表"),
    "listen": MessageLookupByLibrary.simpleMessage("监听"),
    "loadTest": MessageLookupByLibrary.simpleMessage("加载测试"),
    "loading": MessageLookupByLibrary.simpleMessage("加载中..."),
    "local": MessageLookupByLibrary.simpleMessage("本地"),
    "localBackupDesc": MessageLookupByLibrary.simpleMessage("备份数据到本地"),
    "locationPermission": MessageLookupByLibrary.simpleMessage("位置权限"),
    "locationPermissionDeniedMessage": MessageLookupByLibrary.simpleMessage(
      "位置权限已被拒绝，无法获取当前 Wi-Fi 名称。请前往系统设置手动开启位置权限。",
    ),
    "locationPermissionDesc": MessageLookupByLibrary.simpleMessage(
      "根据系统要求，获取Wi-Fi名称需要您授予位置权限。",
    ),
    "locationPermissionGuide": m11,
    "locationPermissionRequired": MessageLookupByLibrary.simpleMessage(
      "需要位置权限",
    ),
    "log": MessageLookupByLibrary.simpleMessage("日志"),
    "logLevel": MessageLookupByLibrary.simpleMessage("日志等级"),
    "logcat": MessageLookupByLibrary.simpleMessage("日志捕获"),
    "logcatDesc": MessageLookupByLibrary.simpleMessage("禁用将会隐藏日志入口"),
    "logs": MessageLookupByLibrary.simpleMessage("日志"),
    "logsDesc": MessageLookupByLibrary.simpleMessage("日志捕获记录"),
    "logsTest": MessageLookupByLibrary.simpleMessage("日志测试"),
    "loopback": MessageLookupByLibrary.simpleMessage("回环解锁工具"),
    "loopbackDesc": MessageLookupByLibrary.simpleMessage("用于UWP回环解锁"),
    "loose": MessageLookupByLibrary.simpleMessage("宽松"),
    "matchSourceIp": MessageLookupByLibrary.simpleMessage("匹配来源IP"),
    "maxFailedTimes": MessageLookupByLibrary.simpleMessage("最大失败次数"),
    "memoryInfo": MessageLookupByLibrary.simpleMessage("内存信息"),
    "messageTest": MessageLookupByLibrary.simpleMessage("消息测试"),
    "messageTestTip": MessageLookupByLibrary.simpleMessage("这是一条消息。"),
    "min": MessageLookupByLibrary.simpleMessage("最小"),
    "minimizeOnExit": MessageLookupByLibrary.simpleMessage("退出时最小化"),
    "minimizeOnExitDesc": MessageLookupByLibrary.simpleMessage("修改系统默认退出事件"),
    "minutesAgo": m12,
    "mixedPort": MessageLookupByLibrary.simpleMessage("混合端口"),
    "mode": MessageLookupByLibrary.simpleMessage("模式"),
    "monochromeScheme": MessageLookupByLibrary.simpleMessage("单色"),
    "monthsAgo": m13,
    "more": MessageLookupByLibrary.simpleMessage("更多"),
    "name": MessageLookupByLibrary.simpleMessage("名称"),
    "nameserver": MessageLookupByLibrary.simpleMessage("域名服务器"),
    "nameserverDesc": MessageLookupByLibrary.simpleMessage("用于解析域名"),
    "nameserverPolicy": MessageLookupByLibrary.simpleMessage("域名服务器策略"),
    "nameserverPolicyDesc": MessageLookupByLibrary.simpleMessage("指定对应域名服务器策略"),
    "network": MessageLookupByLibrary.simpleMessage("网络"),
    "networkDesc": MessageLookupByLibrary.simpleMessage("修改网络相关设置"),
    "networkDetection": MessageLookupByLibrary.simpleMessage("网络检测"),
    "networkException": MessageLookupByLibrary.simpleMessage("网络异常，请检查连接后重试"),
    "networkSpeed": MessageLookupByLibrary.simpleMessage("网络速度"),
    "networkType": MessageLookupByLibrary.simpleMessage("网络类型"),
    "neutralScheme": MessageLookupByLibrary.simpleMessage("中性"),
    "noData": MessageLookupByLibrary.simpleMessage("暂无数据"),
    "noHotKey": MessageLookupByLibrary.simpleMessage("暂无快捷键"),
    "noInfo": MessageLookupByLibrary.simpleMessage("暂无信息"),
    "noLongerRemind": MessageLookupByLibrary.simpleMessage("不再提示"),
    "noNetwork": MessageLookupByLibrary.simpleMessage("无网络"),
    "noNetworkApp": MessageLookupByLibrary.simpleMessage("无网络应用"),
    "noRecords": MessageLookupByLibrary.simpleMessage("暂无记录"),
    "noResolve": MessageLookupByLibrary.simpleMessage("不解析IP"),
    "noResolveHostname": MessageLookupByLibrary.simpleMessage("不解析主机名"),
    "none": MessageLookupByLibrary.simpleMessage("无"),
    "notSelectedTip": MessageLookupByLibrary.simpleMessage("当前代理组无法选中"),
    "nullProfileDesc": MessageLookupByLibrary.simpleMessage("没有配置文件,请先添加配置文件"),
    "nullTip": m14,
    "numberTip": m15,
    "onDemand": MessageLookupByLibrary.simpleMessage("按需运行"),
    "onDemandDesc": MessageLookupByLibrary.simpleMessage("配置程序特定场景运行状态"),
    "onlyIcon": MessageLookupByLibrary.simpleMessage("仅图标"),
    "onlyStatisticsProxy": MessageLookupByLibrary.simpleMessage("仅统计代理"),
    "onlyStatisticsProxyDesc": MessageLookupByLibrary.simpleMessage(
      "开启后，将只统计代理流量",
    ),
    "optional": MessageLookupByLibrary.simpleMessage("可选"),
    "options": MessageLookupByLibrary.simpleMessage("选项"),
    "other": MessageLookupByLibrary.simpleMessage("其他"),
    "otherContributors": MessageLookupByLibrary.simpleMessage("其他贡献者"),
    "outboundMode": MessageLookupByLibrary.simpleMessage("出站模式"),
    "override": MessageLookupByLibrary.simpleMessage("覆写"),
    "overrideDns": MessageLookupByLibrary.simpleMessage("覆写DNS"),
    "overrideDnsDesc": MessageLookupByLibrary.simpleMessage("开启后将覆盖配置中的DNS选项"),
    "overrideMode": MessageLookupByLibrary.simpleMessage("覆写模式"),
    "overrideScript": MessageLookupByLibrary.simpleMessage("覆写脚本"),
    "overwriteTypeCustom": MessageLookupByLibrary.simpleMessage("自定义"),
    "overwriteTypeCustomDesc": MessageLookupByLibrary.simpleMessage(
      "自定义模式，支持完全自定义修改代理组以及规则",
    ),
    "palette": MessageLookupByLibrary.simpleMessage("调色板"),
    "password": MessageLookupByLibrary.simpleMessage("密码"),
    "paste": MessageLookupByLibrary.simpleMessage("粘贴"),
    "pleaseBindWebDAV": MessageLookupByLibrary.simpleMessage("请绑定WebDAV"),
    "pleaseEnterScriptName": MessageLookupByLibrary.simpleMessage("请输入脚本名称"),
    "pleaseInputAdminPassword": MessageLookupByLibrary.simpleMessage(
      "请输入管理员密码",
    ),
    "pleaseUploadValidQrcode": MessageLookupByLibrary.simpleMessage(
      "请上传有效的二维码",
    ),
    "port": MessageLookupByLibrary.simpleMessage("端口"),
    "portConflictTip": MessageLookupByLibrary.simpleMessage("请输入不同的端口"),
    "portTip": m16,
    "preferH3Desc": MessageLookupByLibrary.simpleMessage("优先使用DOH的http/3"),
    "prerequisites": MessageLookupByLibrary.simpleMessage("前置条件"),
    "pressKeyboard": MessageLookupByLibrary.simpleMessage("请按下按键"),
    "preview": MessageLookupByLibrary.simpleMessage("预览"),
    "process": MessageLookupByLibrary.simpleMessage("进程"),
    "profile": MessageLookupByLibrary.simpleMessage("配置"),
    "profileAutoUpdateIntervalInvalidValidationDesc":
        MessageLookupByLibrary.simpleMessage("请输入有效间隔时间格式"),
    "profileAutoUpdateIntervalNullValidationDesc":
        MessageLookupByLibrary.simpleMessage("请输入自动更新间隔时间"),
    "profileHasUpdate": MessageLookupByLibrary.simpleMessage(
      "配置文件已经修改,是否关闭自动更新 ",
    ),
    "profileNameNullValidationDesc": MessageLookupByLibrary.simpleMessage(
      "请输入配置名称",
    ),
    "profileUrlInvalidValidationDesc": MessageLookupByLibrary.simpleMessage(
      "请输入有效配置URL",
    ),
    "profileUrlNullValidationDesc": MessageLookupByLibrary.simpleMessage(
      "请输入配置URL",
    ),
    "profiles": MessageLookupByLibrary.simpleMessage("我的订阅"),
    "profilesSort": MessageLookupByLibrary.simpleMessage("配置排序"),
    "project": MessageLookupByLibrary.simpleMessage("项目"),
    "providers": MessageLookupByLibrary.simpleMessage("提供者"),
    "proxies": MessageLookupByLibrary.simpleMessage("线路"),
    "proxiesEmpty": MessageLookupByLibrary.simpleMessage("代理为空"),
    "proxyChains": MessageLookupByLibrary.simpleMessage("代理链"),
    "proxyDetectedAbnormal": MessageLookupByLibrary.simpleMessage(
      "检测到选中的代理存在异常",
    ),
    "proxyFilter": MessageLookupByLibrary.simpleMessage("节点过滤器"),
    "proxyGroup": MessageLookupByLibrary.simpleMessage("策略组"),
    "proxyGroupDetectedAbnormal": MessageLookupByLibrary.simpleMessage(
      "检测到当前策略组异常",
    ),
    "proxyGroupEmpty": MessageLookupByLibrary.simpleMessage("策略组为空"),
    "proxyGroupNameDuplicate": MessageLookupByLibrary.simpleMessage("策略组名称重复"),
    "proxyGroupNameEmpty": MessageLookupByLibrary.simpleMessage("策略组名称不能为空"),
    "proxyNameserver": MessageLookupByLibrary.simpleMessage("代理域名服务器"),
    "proxyNameserverDesc": MessageLookupByLibrary.simpleMessage("用于解析代理节点的域名"),
    "proxyPort": MessageLookupByLibrary.simpleMessage("代理端口"),
    "proxyProviderDetectedAbnormal": MessageLookupByLibrary.simpleMessage(
      "检测到选中的代理集存在异常",
    ),
    "proxyProviders": MessageLookupByLibrary.simpleMessage("代理集"),
    "proxyProvidersEmpty": MessageLookupByLibrary.simpleMessage("代理集为空"),
    "proxyProvidersNotEmpty": MessageLookupByLibrary.simpleMessage("代理集不能为空"),
    "proxyType": MessageLookupByLibrary.simpleMessage("代理类型"),
    "pruneCache": MessageLookupByLibrary.simpleMessage("修剪缓存"),
    "pureBlackMode": MessageLookupByLibrary.simpleMessage("纯黑模式"),
    "qrcode": MessageLookupByLibrary.simpleMessage("二维码"),
    "qrcodeDesc": MessageLookupByLibrary.simpleMessage("扫描二维码获取配置文件"),
    "quickFill": MessageLookupByLibrary.simpleMessage("一键填入"),
    "rainbowScheme": MessageLookupByLibrary.simpleMessage("彩虹"),
    "redirPort": MessageLookupByLibrary.simpleMessage("Redir端口"),
    "redo": MessageLookupByLibrary.simpleMessage("重做"),
    "remote": MessageLookupByLibrary.simpleMessage("远程"),
    "remoteBackupDesc": MessageLookupByLibrary.simpleMessage("备份数据到WebDAV"),
    "remoteDestination": MessageLookupByLibrary.simpleMessage("远程目标"),
    "remove": MessageLookupByLibrary.simpleMessage("移除"),
    "rename": MessageLookupByLibrary.simpleMessage("重命名"),
    "request": MessageLookupByLibrary.simpleMessage("请求"),
    "requests": MessageLookupByLibrary.simpleMessage("请求"),
    "requestsDesc": MessageLookupByLibrary.simpleMessage("查看最近请求记录"),
    "reset": MessageLookupByLibrary.simpleMessage("重置"),
    "resetPageChangesTip": MessageLookupByLibrary.simpleMessage(
      "当前页面存在更改，确定重置吗？",
    ),
    "resetTip": MessageLookupByLibrary.simpleMessage("确定要重置吗?"),
    "resources": MessageLookupByLibrary.simpleMessage("资源"),
    "resourcesDesc": MessageLookupByLibrary.simpleMessage("外部资源相关信息"),
    "respectRules": MessageLookupByLibrary.simpleMessage("遵守规则"),
    "respectRulesDesc": MessageLookupByLibrary.simpleMessage(
      "DNS连接跟随rules,需配置proxy-server-nameserver",
    ),
    "restart": MessageLookupByLibrary.simpleMessage("重启"),
    "restartCoreTip": MessageLookupByLibrary.simpleMessage("您确定要重启核心吗？"),
    "restore": MessageLookupByLibrary.simpleMessage("恢复"),
    "restoreAllData": MessageLookupByLibrary.simpleMessage("恢复所有数据"),
    "restoreException": MessageLookupByLibrary.simpleMessage("恢复异常"),
    "restoreFromFileDesc": MessageLookupByLibrary.simpleMessage("通过文件恢复数据"),
    "restoreFromWebDAVDesc": MessageLookupByLibrary.simpleMessage(
      "通过WebDAV恢复数据",
    ),
    "restoreOnlyConfig": MessageLookupByLibrary.simpleMessage("仅恢复配置文件"),
    "restoreStrategy": MessageLookupByLibrary.simpleMessage("恢复策略"),
    "restoreStrategy_compatible": MessageLookupByLibrary.simpleMessage("兼容"),
    "restoreStrategy_override": MessageLookupByLibrary.simpleMessage("覆盖"),
    "restoreSuccess": MessageLookupByLibrary.simpleMessage("恢复成功"),
    "routeAddress": MessageLookupByLibrary.simpleMessage("路由地址"),
    "routeAddressDesc": MessageLookupByLibrary.simpleMessage("配置监听路由地址"),
    "routeMode": MessageLookupByLibrary.simpleMessage("路由模式"),
    "routeMode_bypassPrivate": MessageLookupByLibrary.simpleMessage("绕过私有路由地址"),
    "routeMode_config": MessageLookupByLibrary.simpleMessage("使用配置"),
    "ru": MessageLookupByLibrary.simpleMessage("俄语"),
    "rule": MessageLookupByLibrary.simpleMessage("规则"),
    "ruleActionAndDesc": MessageLookupByLibrary.simpleMessage("逻辑规则 AND"),
    "ruleActionDomainDesc": MessageLookupByLibrary.simpleMessage("匹配完整域名"),
    "ruleActionDomainKeywordDesc": MessageLookupByLibrary.simpleMessage(
      "匹配域名关键字",
    ),
    "ruleActionDomainRegexDesc": MessageLookupByLibrary.simpleMessage(
      "通配符匹配，仅支持*和?通配符",
    ),
    "ruleActionDomainSuffixDesc": MessageLookupByLibrary.simpleMessage(
      "匹配域名后缀",
    ),
    "ruleActionDscpDesc": MessageLookupByLibrary.simpleMessage(
      "匹配DSCP标记 (仅限 tproxy udp 入站)",
    ),
    "ruleActionDstPortDesc": MessageLookupByLibrary.simpleMessage("匹配请求目标端口范围"),
    "ruleActionGeoipDesc": MessageLookupByLibrary.simpleMessage("匹配 IP 所属国家代码"),
    "ruleActionGeositeDesc": MessageLookupByLibrary.simpleMessage(
      "匹配 Geosite 内的域名",
    ),
    "ruleActionInNameDesc": MessageLookupByLibrary.simpleMessage("匹配入站名称"),
    "ruleActionInPortDesc": MessageLookupByLibrary.simpleMessage("匹配入站端口"),
    "ruleActionInTypeDesc": MessageLookupByLibrary.simpleMessage("匹配入站类型"),
    "ruleActionInUserDesc": MessageLookupByLibrary.simpleMessage(
      "匹配入站用户名，支持使用 / 分隔多个用户名",
    ),
    "ruleActionIpAsnDesc": MessageLookupByLibrary.simpleMessage("匹配 IP 所属 ASN"),
    "ruleActionIpCidr6Desc": MessageLookupByLibrary.simpleMessage(
      "匹配 IP 地址范围, IP-CIDR6 只是一个别名",
    ),
    "ruleActionIpCidrDesc": MessageLookupByLibrary.simpleMessage("匹配 IP 地址范围"),
    "ruleActionIpSuffixDesc": MessageLookupByLibrary.simpleMessage(
      "匹配 IP 后缀范围",
    ),
    "ruleActionMatchDesc": MessageLookupByLibrary.simpleMessage("匹配所有请求，无需条件"),
    "ruleActionNetworkDesc": MessageLookupByLibrary.simpleMessage("匹配TCP或者UDP"),
    "ruleActionNotDesc": MessageLookupByLibrary.simpleMessage("逻辑规则 NOT"),
    "ruleActionOrDesc": MessageLookupByLibrary.simpleMessage("逻辑规则 OR"),
    "ruleActionProcessNameDesc": MessageLookupByLibrary.simpleMessage(
      "使用进程匹配，在Android平台可以匹配包名",
    ),
    "ruleActionProcessNameRegexDesc": MessageLookupByLibrary.simpleMessage(
      "使用进程名称正则表达式匹配，在Android平台可以匹配包名",
    ),
    "ruleActionProcessPathDesc": MessageLookupByLibrary.simpleMessage(
      "使用完整进程路径匹配",
    ),
    "ruleActionProcessPathRegexDesc": MessageLookupByLibrary.simpleMessage(
      "使用进程路径正则表达式匹配",
    ),
    "ruleActionRuleSetDesc": MessageLookupByLibrary.simpleMessage(
      "引用规则集合，需配置rule-providers",
    ),
    "ruleActionSrcGeoipDesc": MessageLookupByLibrary.simpleMessage(
      "匹配来源 IP 所属国家代码",
    ),
    "ruleActionSrcIpAsnDesc": MessageLookupByLibrary.simpleMessage(
      "匹配来源 IP 所属 ASN",
    ),
    "ruleActionSrcIpCidrDesc": MessageLookupByLibrary.simpleMessage(
      "匹配来源 IP 地址范围",
    ),
    "ruleActionSrcIpSuffixDesc": MessageLookupByLibrary.simpleMessage(
      "匹配来源 IP 后缀范围",
    ),
    "ruleActionSrcPortDesc": MessageLookupByLibrary.simpleMessage("匹配请求来源端口范围"),
    "ruleActionSubRuleDesc": MessageLookupByLibrary.simpleMessage(
      "匹配至子规则,需要注意括号的使用",
    ),
    "ruleActionUidDesc": MessageLookupByLibrary.simpleMessage(
      "匹配 Linux USER ID",
    ),
    "ruleEmpty": MessageLookupByLibrary.simpleMessage("规则为空"),
    "ruleName": MessageLookupByLibrary.simpleMessage("规则名称"),
    "ruleProviders": MessageLookupByLibrary.simpleMessage("规则集"),
    "ruleSet": MessageLookupByLibrary.simpleMessage("规则集"),
    "ruleTarget": MessageLookupByLibrary.simpleMessage("规则目标"),
    "save": MessageLookupByLibrary.simpleMessage("保存"),
    "saveChanges": MessageLookupByLibrary.simpleMessage("是否保存更改？"),
    "script": MessageLookupByLibrary.simpleMessage("脚本"),
    "scriptModeDesc": MessageLookupByLibrary.simpleMessage(
      "脚本模式，使用外部扩展脚本，提供一键覆写配置的能力",
    ),
    "search": MessageLookupByLibrary.simpleMessage("搜索"),
    "seconds": MessageLookupByLibrary.simpleMessage("秒"),
    "selectAll": MessageLookupByLibrary.simpleMessage("全选"),
    "selectProxies": MessageLookupByLibrary.simpleMessage("选择代理"),
    "selectProxyProviders": MessageLookupByLibrary.simpleMessage("选择代理集"),
    "selectRuleSet": MessageLookupByLibrary.simpleMessage("请选择规则集"),
    "selectSplitStrategy": MessageLookupByLibrary.simpleMessage("请选择分流策略"),
    "selectSubRule": MessageLookupByLibrary.simpleMessage("请选择子规则"),
    "selected": MessageLookupByLibrary.simpleMessage("已选择"),
    "selectedCountTitle": m17,
    "settings": MessageLookupByLibrary.simpleMessage("设置"),
    "shop": MessageLookupByLibrary.simpleMessage("商城"),
    "show": MessageLookupByLibrary.simpleMessage("显示"),
    "shrink": MessageLookupByLibrary.simpleMessage("紧凑"),
    "silentLaunch": MessageLookupByLibrary.simpleMessage("静默启动"),
    "silentLaunchDesc": MessageLookupByLibrary.simpleMessage("后台启动"),
    "size": MessageLookupByLibrary.simpleMessage("尺寸"),
    "socksPort": MessageLookupByLibrary.simpleMessage("Socks端口"),
    "sort": MessageLookupByLibrary.simpleMessage("排序"),
    "source": MessageLookupByLibrary.simpleMessage("来源"),
    "sourceIp": MessageLookupByLibrary.simpleMessage("源IP"),
    "specialProxy": MessageLookupByLibrary.simpleMessage("特殊代理"),
    "specialRules": MessageLookupByLibrary.simpleMessage("特殊规则"),
    "speedStatistics": MessageLookupByLibrary.simpleMessage("网速统计"),
    "splitStrategy": MessageLookupByLibrary.simpleMessage("分流策略"),
    "splitStrategyNotEmpty": MessageLookupByLibrary.simpleMessage("分流策略不能为空"),
    "ssidsEmpty": MessageLookupByLibrary.simpleMessage("SSIDs为空"),
    "stackMode": MessageLookupByLibrary.simpleMessage("栈模式"),
    "standard": MessageLookupByLibrary.simpleMessage("标准"),
    "standardModeDesc": MessageLookupByLibrary.simpleMessage(
      "标准模式，覆写基本配置，提供简单追加规则能力",
    ),
    "start": MessageLookupByLibrary.simpleMessage("启动"),
    "startVpn": MessageLookupByLibrary.simpleMessage("正在启动VPN..."),
    "status": MessageLookupByLibrary.simpleMessage("状态"),
    "statusDesc": MessageLookupByLibrary.simpleMessage("关闭后将使用系统DNS"),
    "stop": MessageLookupByLibrary.simpleMessage("暂停"),
    "stopVpn": MessageLookupByLibrary.simpleMessage("正在停止VPN..."),
    "style": MessageLookupByLibrary.simpleMessage("风格"),
    "subRule": MessageLookupByLibrary.simpleMessage("子规则"),
    "subRuleEmpty": MessageLookupByLibrary.simpleMessage("子规则为空"),
    "subRuleNotEmpty": MessageLookupByLibrary.simpleMessage("子规则不能为空"),
    "submit": MessageLookupByLibrary.simpleMessage("提交"),
    "suspended": MessageLookupByLibrary.simpleMessage("挂起中..."),
    "sync": MessageLookupByLibrary.simpleMessage("同步"),
    "system": MessageLookupByLibrary.simpleMessage("系统"),
    "systemApp": MessageLookupByLibrary.simpleMessage("系统应用"),
    "systemProxy": MessageLookupByLibrary.simpleMessage("系统代理"),
    "systemProxyDesc": MessageLookupByLibrary.simpleMessage("设置系统代理"),
    "tab": MessageLookupByLibrary.simpleMessage("标签页"),
    "tabAnimation": MessageLookupByLibrary.simpleMessage("选项卡动画"),
    "tabAnimationDesc": MessageLookupByLibrary.simpleMessage("仅在移动视图中有效"),
    "tapToAuthorize": MessageLookupByLibrary.simpleMessage("点击授权"),
    "tcpConcurrent": MessageLookupByLibrary.simpleMessage("TCP并发"),
    "tcpConcurrentDesc": MessageLookupByLibrary.simpleMessage("开启后允许TCP并发"),
    "testInterval": MessageLookupByLibrary.simpleMessage("测试间隔"),
    "testUrl": MessageLookupByLibrary.simpleMessage("测速链接"),
    "testWhenUsed": MessageLookupByLibrary.simpleMessage("使用时测试"),
    "textScale": MessageLookupByLibrary.simpleMessage("文本缩放"),
    "theme": MessageLookupByLibrary.simpleMessage("主题"),
    "themeColor": MessageLookupByLibrary.simpleMessage("主题色彩"),
    "themeDesc": MessageLookupByLibrary.simpleMessage("设置深色模式，调整色彩"),
    "themeMode": MessageLookupByLibrary.simpleMessage("主题模式"),
    "tight": MessageLookupByLibrary.simpleMessage("紧凑"),
    "time": MessageLookupByLibrary.simpleMessage("时间"),
    "timeout": MessageLookupByLibrary.simpleMessage("超时"),
    "tip": MessageLookupByLibrary.simpleMessage("提示"),
    "toggle": MessageLookupByLibrary.simpleMessage("切换"),
    "tonalSpotScheme": MessageLookupByLibrary.simpleMessage("调性点缀"),
    "tools": MessageLookupByLibrary.simpleMessage("我的"),
    "tproxyPort": MessageLookupByLibrary.simpleMessage("Tproxy端口"),
    "trafficUsage": MessageLookupByLibrary.simpleMessage("流量统计"),
    "tun": MessageLookupByLibrary.simpleMessage("虚拟网卡"),
    "tunDesc": MessageLookupByLibrary.simpleMessage(
      "开启后 Telegram、部分游戏和 App 才能用（首次需输入密码授权）；不开只有浏览器等能上网",
    ),
    "turnOff": MessageLookupByLibrary.simpleMessage("关闭"),
    "turnOn": MessageLookupByLibrary.simpleMessage("开启"),
    "undo": MessageLookupByLibrary.simpleMessage("撤销"),
    "unifiedDelay": MessageLookupByLibrary.simpleMessage("统一延迟"),
    "unifiedDelayDesc": MessageLookupByLibrary.simpleMessage("去除握手等额外延迟"),
    "unknown": MessageLookupByLibrary.simpleMessage("未知"),
    "unknownNetworkError": MessageLookupByLibrary.simpleMessage("未知网络错误"),
    "unnamed": MessageLookupByLibrary.simpleMessage("未命名"),
    "update": MessageLookupByLibrary.simpleMessage("更新"),
    "updateSubscription": MessageLookupByLibrary.simpleMessage("更新订阅"),
    "upload": MessageLookupByLibrary.simpleMessage("上传"),
    "url": MessageLookupByLibrary.simpleMessage("URL"),
    "urlDesc": MessageLookupByLibrary.simpleMessage("通过URL获取配置文件"),
    "urlTip": m18,
    "useHosts": MessageLookupByLibrary.simpleMessage("使用Hosts"),
    "useSystemHosts": MessageLookupByLibrary.simpleMessage("使用系统Hosts"),
    "value": MessageLookupByLibrary.simpleMessage("值"),
    "vgAboutTagline": MessageLookupByLibrary.simpleMessage(
      "易联 voguesly · 美国住宅 IP 代理\\n稳定连接 ChatGPT、Claude、OKX 等全球服务",
    ),
    "vgAccelerationMode": MessageLookupByLibrary.simpleMessage("加速模式"),
    "vgAccelerationSkipped": MessageLookupByLibrary.simpleMessage("已跳过加速"),
    "vgAccountBalance": MessageLookupByLibrary.simpleMessage("账户余额"),
    "vgActionFailedRetry": MessageLookupByLibrary.simpleMessage("操作失败，请稍后重试"),
    "vgActivateFailedRetry": MessageLookupByLibrary.simpleMessage("开通失败,请稍后再试"),
    "vgActivateFailedWith": m19,
    "vgActivateFreeTrialNow": MessageLookupByLibrary.simpleMessage("立即开通免费测试"),
    "vgActivatedImportFailed": MessageLookupByLibrary.simpleMessage(
      "已开通，但订阅导入失败（可能是网络瞬断）。点下面「重试导入」即可。",
    ),
    "vgActivatedTapCircle": MessageLookupByLibrary.simpleMessage(
      "✅ 已开通，点中间圆圈即可连接",
    ),
    "vgActivatingEllipsis": MessageLookupByLibrary.simpleMessage("开通中..."),
    "vgAlipay": MessageLookupByLibrary.simpleMessage("支付宝"),
    "vgAllEndpointsUnreachable": MessageLookupByLibrary.simpleMessage(
      "所有入口均不可达",
    ),
    "vgAllowLoginItemHint": MessageLookupByLibrary.simpleMessage(
      "需要在「系统设置 → 通用 → 登录项与扩展」允许「易联」的后台项目,",
    ),
    "vgAllowLoginItemHint2": MessageLookupByLibrary.simpleMessage(
      "开启后返回易联再点一次 TUN 即可，之后免密码。",
    ),
    "vgAlreadyBoughtRefresh": MessageLookupByLibrary.simpleMessage("已购买?刷新订阅"),
    "vgAlreadyClaimedBuyStarter": MessageLookupByLibrary.simpleMessage(
      "已领过?购买 ¥3.9 验证包 · 3GB 不限时",
    ),
    "vgAlreadyHave": MessageLookupByLibrary.simpleMessage("已有"),
    "vgAlreadyHaveAccount": MessageLookupByLibrary.simpleMessage("已有账户?"),
    "vgAndroidOneVpnHint": MessageLookupByLibrary.simpleMessage(
      "Android 同一时间只允许一个 VPN 运行。开启易联时，系统会自动停止其他 VPN",
    ),
    "vgAndroidOneVpnHint2": MessageLookupByLibrary.simpleMessage(
      "并弹窗询问你 —— 所以不会出现「两个都以为自己在运行」的静默冲突。",
    ),
    "vgAnnouncements": MessageLookupByLibrary.simpleMessage("公告中心"),
    "vgAnnouncementsSubtitle": MessageLookupByLibrary.simpleMessage(
      "最新公告与维护通知",
    ),
    "vgAppFeedbackLogs": MessageLookupByLibrary.simpleMessage("App 反馈 / 日志"),
    "vgAutoSelecting": MessageLookupByLibrary.simpleMessage("自动选择中…"),
    "vgAvailableCommission": MessageLookupByLibrary.simpleMessage("可用佣金"),
    "vgAvailableCommissionWith": m20,
    "vgBack": MessageLookupByLibrary.simpleMessage("返回"),
    "vgBaidu": MessageLookupByLibrary.simpleMessage("百度"),
    "vgBalance": MessageLookupByLibrary.simpleMessage("余额"),
    "vgBiliHkMoTw": MessageLookupByLibrary.simpleMessage("哔哩哔哩港澳台"),
    "vgBiliMainland": MessageLookupByLibrary.simpleMessage("哔哩哔哩大陆"),
    "vgBilibili": MessageLookupByLibrary.simpleMessage("哔哩哔哩"),
    "vgBuyNow": MessageLookupByLibrary.simpleMessage("立即购买"),
    "vgBuyNowWith": m21,
    "vgBuyOrRenew": MessageLookupByLibrary.simpleMessage("购买 / 续费"),
    "vgBuyOrRenewPlan": MessageLookupByLibrary.simpleMessage("购买 / 续费套餐"),
    "vgBuyRenewShort": MessageLookupByLibrary.simpleMessage("购买/续费"),
    "vgBuyStarterForFullTest": MessageLookupByLibrary.simpleMessage(
      "购买验证包开始完整测试",
    ),
    "vgBuyStarterPack": MessageLookupByLibrary.simpleMessage("购买 ¥3.9 验证包"),
    "vgCancel": MessageLookupByLibrary.simpleMessage("取消"),
    "vgCancelFailedRetry": MessageLookupByLibrary.simpleMessage("取消失败,请稍后重试"),
    "vgCancelOrder": MessageLookupByLibrary.simpleMessage("取消订单"),
    "vgCancelOrderConfirm": m22,
    "vgCannotOpenBrowser": MessageLookupByLibrary.simpleMessage("无法打开浏览器"),
    "vgCannotOpenSupportManually": MessageLookupByLibrary.simpleMessage(
      "打不开客服,请手动访问客服页",
    ),
    "vgChangeFailedCheckOldPassword": MessageLookupByLibrary.simpleMessage(
      "修改失败(检查旧密码)",
    ),
    "vgChangePassword": MessageLookupByLibrary.simpleMessage("修改密码"),
    "vgChargingEllipsis": MessageLookupByLibrary.simpleMessage("正在扣款…"),
    "vgCheck": MessageLookupByLibrary.simpleMessage("检测"),
    "vgCheckAll": MessageLookupByLibrary.simpleMessage("全部检测"),
    "vgCheckFailed": MessageLookupByLibrary.simpleMessage("检测失败"),
    "vgCheckFailedConnectFirst": MessageLookupByLibrary.simpleMessage(
      "检测失败,请先连接后重试",
    ),
    "vgCheckForUpdate": MessageLookupByLibrary.simpleMessage("检查更新"),
    "vgCheckItem": MessageLookupByLibrary.simpleMessage("检测项"),
    "vgCheckingLocalEnv": MessageLookupByLibrary.simpleMessage("正在检测本机环境…"),
    "vgChooseBillingCycle": MessageLookupByLibrary.simpleMessage("选择购买周期"),
    "vgChoosePaymentMethod": MessageLookupByLibrary.simpleMessage("选择支付方式"),
    "vgCity": MessageLookupByLibrary.simpleMessage("城市"),
    "vgCloseFailedRetry": MessageLookupByLibrary.simpleMessage("关闭失败，请稍后再试"),
    "vgCloseTicket": MessageLookupByLibrary.simpleMessage("关闭工单"),
    "vgCloseTicketConfirm": MessageLookupByLibrary.simpleMessage(
      "关闭后就不能再回复。确定问题已解决？",
    ),
    "vgCodeSent": MessageLookupByLibrary.simpleMessage("验证码已发送"),
    "vgCoexistFine": MessageLookupByLibrary.simpleMessage(
      "易联不会去干预它们（有些可能是你连公司内网的通道）。只要上面三项正常，共存没有问题。",
    ),
    "vgCollapse": MessageLookupByLibrary.simpleMessage("收起"),
    "vgCompatModeOnlyProxyAware": MessageLookupByLibrary.simpleMessage(
      "注意:兼容模式只接管遵循系统代理的应用,Telegram 等可能仍不通;",
    ),
    "vgCompatModeTakenOver": MessageLookupByLibrary.simpleMessage(
      "「系统代理（兼容模式）」已被其他代理程序接管，易联的兼容模式当前不生效。",
    ),
    "vgConfigParseFailed": MessageLookupByLibrary.simpleMessage(
      "配置解析失败，请更新订阅或联系客服",
    ),
    "vgConfirmChange": MessageLookupByLibrary.simpleMessage("确认修改"),
    "vgConfirmNewPassword": MessageLookupByLibrary.simpleMessage("确认新密码"),
    "vgConnectTimeoutRetry": MessageLookupByLibrary.simpleMessage("连接超时，请稍后重试"),
    "vgConnectTimeoutTryAnotherRoute": MessageLookupByLibrary.simpleMessage(
      "连接超时，请检查网络，或在「当前线路」换一条线路再试",
    ),
    "vgConnected": MessageLookupByLibrary.simpleMessage("已连接"),
    "vgContactSupport": MessageLookupByLibrary.simpleMessage("联系客服"),
    "vgContinuePayment": MessageLookupByLibrary.simpleMessage("继续支付"),
    "vgCopiedSuffix": m23,
    "vgCopy": MessageLookupByLibrary.simpleMessage("复制"),
    "vgCopyReferralLink": MessageLookupByLibrary.simpleMessage("复制邀请链接"),
    "vgCoreFailedToBindPort": MessageLookupByLibrary.simpleMessage(
      "易联核心未能成功绑定端口。",
    ),
    "vgCountryRegion": MessageLookupByLibrary.simpleMessage("国家/地区"),
    "vgCreateAccount": MessageLookupByLibrary.simpleMessage("创建账户"),
    "vgCreditCard": MessageLookupByLibrary.simpleMessage("信用卡"),
    "vgCurrentBalanceWith": m24,
    "vgCurrentPassword": MessageLookupByLibrary.simpleMessage("当前密码"),
    "vgCurrentPlanPrefixWith": m25,
    "vgCurrentPlanWith": m26,
    "vgCurrentRoute": MessageLookupByLibrary.simpleMessage("当前线路"),
    "vgDailyUsageThisMonth": MessageLookupByLibrary.simpleMessage("当月每日用量"),
    "vgDataExhaustedRenew": MessageLookupByLibrary.simpleMessage("流量已用尽 · 请续费"),
    "vgDataUsage": MessageLookupByLibrary.simpleMessage("流量明细"),
    "vgDataUsageSubtitle": MessageLookupByLibrary.simpleMessage("逐日流量使用记录"),
    "vgDeviceInfoWith": m27,
    "vgDeviceLimitHint": MessageLookupByLibrary.simpleMessage(
      "若提示连接超限，请先完全退出其他客户端再重连",
    ),
    "vgDirectModeSummary": MessageLookupByLibrary.simpleMessage(
      "⚠️ 直连模式 · 未加速,流量未走节点(不安全)",
    ),
    "vgDmgOpenedQuitting": MessageLookupByLibrary.simpleMessage(
      "DMG 已打开，易联正在安全退出。请把新版本拖入 Applications 覆盖旧版本。",
    ),
    "vgDomestic": MessageLookupByLibrary.simpleMessage("国内"),
    "vgDoneOrClose": MessageLookupByLibrary.simpleMessage("我已完成/关闭"),
    "vgDouyin": MessageLookupByLibrary.simpleMessage("抖音"),
    "vgDownloadFailed": MessageLookupByLibrary.simpleMessage("下载失败"),
    "vgDownloadFailedRetry": MessageLookupByLibrary.simpleMessage("下载失败,请稍后重试"),
    "vgDownloadFailedRetryFull": MessageLookupByLibrary.simpleMessage(
      "下载失败，请稍后重试",
    ),
    "vgDownloadingUpdate": MessageLookupByLibrary.simpleMessage("正在下载更新"),
    "vgDurationWith": m28,
    "vgEmail": MessageLookupByLibrary.simpleMessage("邮箱"),
    "vgEmailCode": MessageLookupByLibrary.simpleMessage("邮箱验证码"),
    "vgEmptyResponseRetry": MessageLookupByLibrary.simpleMessage("返回为空, 请重试"),
    "vgEncrypted": MessageLookupByLibrary.simpleMessage("加密"),
    "vgEnterCode": MessageLookupByLibrary.simpleMessage("请输入验证码"),
    "vgEnterCredentials": MessageLookupByLibrary.simpleMessage("请输入您的凭据继续"),
    "vgEnterPassword": MessageLookupByLibrary.simpleMessage("请输入密码"),
    "vgEnterPayoutAccount": MessageLookupByLibrary.simpleMessage("请填写收款账号"),
    "vgEnterValidEmail": MessageLookupByLibrary.simpleMessage("请输入有效邮箱"),
    "vgEnterValidEmailFirst": MessageLookupByLibrary.simpleMessage("请先输入有效邮箱"),
    "vgExit": MessageLookupByLibrary.simpleMessage("退出"),
    "vgExpandFullText": MessageLookupByLibrary.simpleMessage("展开全文"),
    "vgExpiredRenew": MessageLookupByLibrary.simpleMessage("已过期 · 请续费"),
    "vgExpiredSuffix": m29,
    "vgExpiryDate": MessageLookupByLibrary.simpleMessage("到期时间"),
    "vgFeedbackBodyWith": m30,
    "vgFeedbackHint": MessageLookupByLibrary.simpleMessage(
      "请描述你遇到的问题，我们会自动附上设备信息和近期日志帮你定位。",
    ),
    "vgFeedbackPlaceholder": MessageLookupByLibrary.simpleMessage(
      "例如：连接后打不开网页 / 某个节点连不上…",
    ),
    "vgFlClashOriginal": MessageLookupByLibrary.simpleMessage("FlClash(原版)"),
    "vgForgotPassword": MessageLookupByLibrary.simpleMessage("忘记密码?"),
    "vgFreeTrialActivated": MessageLookupByLibrary.simpleMessage("免费测试已开通"),
    "vgFreeTrialImportToConnect": MessageLookupByLibrary.simpleMessage(
      "免费测试已开通,导入节点即可连接",
    ),
    "vgFromPrice": m31,
    "vgGlobalAccelDesc1": MessageLookupByLibrary.simpleMessage(
      "所有流量都走你选的那一条线路，不再自动分流。",
    ),
    "vgGlobalAccelDesc2": MessageLookupByLibrary.simpleMessage(
      "若选了机房线路，IP 检测会显示机房 IP；",
    ),
    "vgGlobalAccelDesc3": MessageLookupByLibrary.simpleMessage(
      "需要住宅 IP 请在「线路」选住宅节点，或用智能分流。",
    ),
    "vgGlobalAcceleration": MessageLookupByLibrary.simpleMessage("全局加速"),
    "vgGlobalModeDialog1": MessageLookupByLibrary.simpleMessage(
      "全局模式下，所有流量都走你在「线路」选的那一条，不再按 AI／银行／",
    ),
    "vgGlobalModeDialog2": MessageLookupByLibrary.simpleMessage(
      "国内网站自动分流。\\n\\n",
    ),
    "vgGlobalModeDialog3": MessageLookupByLibrary.simpleMessage(
      "如果选的是机房线路，IP 检测网站会显示机房 IP。需要美国住宅 IP，",
    ),
    "vgGlobalModeDialog4": MessageLookupByLibrary.simpleMessage(
      "请在「线路」选住宅节点，或切回智能分流。",
    ),
    "vgGlobalModeSummary": MessageLookupByLibrary.simpleMessage(
      "全局加速 · 全部走所选线路，IP 跟随该线路",
    ),
    "vgGoSignIn": MessageLookupByLibrary.simpleMessage("去登录"),
    "vgGoogleSignInFailedNetwork": MessageLookupByLibrary.simpleMessage(
      "Google 登录失败,请检查网络后重试",
    ),
    "vgGoogleSignInFailedRetry": MessageLookupByLibrary.simpleMessage(
      "Google 登录失败,请重试",
    ),
    "vgGotIt": MessageLookupByLibrary.simpleMessage("知道了"),
    "vgHalfYearly": MessageLookupByLibrary.simpleMessage("半年付"),
    "vgImportPlanNodesStart": MessageLookupByLibrary.simpleMessage(
      "把你的套餐节点导入并开始使用",
    ),
    "vgInstallPermissionNeeded": MessageLookupByLibrary.simpleMessage("需要安装权限"),
    "vgInstallerFileIncomplete": MessageLookupByLibrary.simpleMessage(
      "安装包文件不完整",
    ),
    "vgInstallerStartedHint": MessageLookupByLibrary.simpleMessage(
      "安装程序已启动,请按提示完成安装(会自动替换旧版本)。",
    ),
    "vgInsufficientBalance": MessageLookupByLibrary.simpleMessage("余额不足"),
    "vgInternational": MessageLookupByLibrary.simpleMessage("国际"),
    "vgInvalidAmount": MessageLookupByLibrary.simpleMessage("金额无效"),
    "vgInvited": MessageLookupByLibrary.simpleMessage("已邀请"),
    "vgIpAddress": MessageLookupByLibrary.simpleMessage("IP 地址"),
    "vgKeptSystemProxyCarrying": m32,
    "vgLastUpdatedTodayWith": m33,
    "vgLastUpdatedWith": m34,
    "vgLatencyHint": MessageLookupByLibrary.simpleMessage(
      "国内应直连(快),国际经节点。数值越低越好。",
    ),
    "vgLatencyTest": MessageLookupByLibrary.simpleMessage("延迟测试"),
    "vgLikelyAnotherVpnTookRoute": MessageLookupByLibrary.simpleMessage(
      "很可能是另一个 VPN 抢了默认路由。",
    ),
    "vgListening": MessageLookupByLibrary.simpleMessage("监听中"),
    "vgLiveChat": MessageLookupByLibrary.simpleMessage("在线客服"),
    "vgLiveChatOpenedInBrowser": MessageLookupByLibrary.simpleMessage(
      "在线客服已在浏览器中打开",
    ),
    "vgLiveChatUnavailableUseBrowser": MessageLookupByLibrary.simpleMessage(
      "在线客服暂时打不开,可用浏览器打开",
    ),
    "vgLoadFailedPullToRetry": MessageLookupByLibrary.simpleMessage(
      "加载失败,请下拉重试",
    ),
    "vgLoadFailedTapRetry": MessageLookupByLibrary.simpleMessage("载入失败·点我重试"),
    "vgLoadFailedWith": m35,
    "vgLoadFailedWithCode": m36,
    "vgLoadingAccount": MessageLookupByLibrary.simpleMessage("正在载入账号…"),
    "vgLoadingEllipsis": MessageLookupByLibrary.simpleMessage("载入中…"),
    "vgLoadingPlan": MessageLookupByLibrary.simpleMessage("正在载入套餐…"),
    "vgLoadingSubscription": MessageLookupByLibrary.simpleMessage("正在载入订阅…"),
    "vgLocalEnvHint": MessageLookupByLibrary.simpleMessage(
      "装了其他代理软件？这里说明当前哪一条通路正在工作、哪个程序占用了什么。",
    ),
    "vgLocalEnvOk": MessageLookupByLibrary.simpleMessage("本机环境正常。"),
    "vgLocalEnvOkInControl": m37,
    "vgLocalEnvironment": MessageLookupByLibrary.simpleMessage("本机环境"),
    "vgLocalPortHeldSuggestChange": m38,
    "vgLocalPortNum": m39,
    "vgLogOut": MessageLookupByLibrary.simpleMessage("登出"),
    "vgMacDnsHintDesc": MessageLookupByLibrary.simpleMessage(
      "仅 macOS TUN 运行时临时加入易联 DNS，断开或退出后自动恢复；系统代理模式不修改 DNS",
    ),
    "vgManageBalanceAndPlan": MessageLookupByLibrary.simpleMessage("管理余额和套餐"),
    "vgManageSubscription": MessageLookupByLibrary.simpleMessage("管理订阅"),
    "vgMe": MessageLookupByLibrary.simpleMessage("我"),
    "vgMihomoCore": MessageLookupByLibrary.simpleMessage("mihomo 内核"),
    "vgMonthly": MessageLookupByLibrary.simpleMessage("月付"),
    "vgMyOrders": MessageLookupByLibrary.simpleMessage("我的订单"),
    "vgMyReferralCode": MessageLookupByLibrary.simpleMessage("我的邀请码"),
    "vgMySubscription": MessageLookupByLibrary.simpleMessage("我的订阅"),
    "vgMyTickets": MessageLookupByLibrary.simpleMessage("我的工单"),
    "vgMyTicketsSubtitle": MessageLookupByLibrary.simpleMessage("查看客服回复、继续跟进"),
    "vgNBillingCycles": m40,
    "vgNDays": m41,
    "vgNMonths": m42,
    "vgNPeople": m43,
    "vgNYears": m44,
    "vgNeedUnknownSourcesPermission": MessageLookupByLibrary.simpleMessage(
      "安装更新需要「允许安装未知来源应用」权限,请去设置开启后返回,会自动继续安装。",
    ),
    "vgNetUnstableRetry": MessageLookupByLibrary.simpleMessage(
      "网络不稳定，请检查网络后重试",
    ),
    "vgNetworkErrorWith": m45,
    "vgNetworkSkippedDirect": MessageLookupByLibrary.simpleMessage(
      "当前网络已跳过加速 · 走直连",
    ),
    "vgNetworkUnavailableRetry": MessageLookupByLibrary.simpleMessage(
      "网络不可用,请检查网络连接后重试",
    ),
    "vgNetworkUnstableNoPlanInfo": MessageLookupByLibrary.simpleMessage(
      "网络不稳，暂时取不到套餐信息",
    ),
    "vgNetworkUnstableTapRetry": MessageLookupByLibrary.simpleMessage(
      "网络不稳，点我重试",
    ),
    "vgNewPasswordMin8": MessageLookupByLibrary.simpleMessage("新密码(至少 8 位)"),
    "vgNewPasswordTooShort": MessageLookupByLibrary.simpleMessage("新密码至少 8 位"),
    "vgNewVersionAvailable": m46,
    "vgNoAccountYet": MessageLookupByLibrary.simpleMessage("还没有账户?"),
    "vgNoAnnouncements": MessageLookupByLibrary.simpleMessage("暂无公告"),
    "vgNoExpiry": MessageLookupByLibrary.simpleMessage("长期有效"),
    "vgNoMessages": MessageLookupByLibrary.simpleMessage("暂无消息"),
    "vgNoOrders": MessageLookupByLibrary.simpleMessage("暂无订单记录"),
    "vgNoOtherProxyDetected": MessageLookupByLibrary.simpleMessage(
      "未检测到其他代理软件",
    ),
    "vgNoPathCarryingTraffic": MessageLookupByLibrary.simpleMessage(
      "当前没有任何一条通路在接管流量，你应该是上不了网。请尝试重新连接。",
    ),
    "vgNoPlan": MessageLookupByLibrary.simpleMessage("暂无套餐"),
    "vgNoPlansAvailable": MessageLookupByLibrary.simpleMessage(
      "暂无可购买套餐,或网络异常,请下拉重试",
    ),
    "vgNoRouteSelected": MessageLookupByLibrary.simpleMessage("未选择 · 去选线路"),
    "vgNoSubscriptionImported": MessageLookupByLibrary.simpleMessage(
      "未导入订阅 · 进入管理页导入",
    ),
    "vgNoTicketsHint": MessageLookupByLibrary.simpleMessage(
      "还没有工单\\n遇到问题可以在「反馈问题 / 上传日志」提交",
    ),
    "vgNoUsageThisMonth": MessageLookupByLibrary.simpleMessage("本月暂无流量记录"),
    "vgNotChecked": MessageLookupByLibrary.simpleMessage("未检测"),
    "vgNotConnectedTapCircle": MessageLookupByLibrary.simpleMessage(
      "易联未连接。请先点首页的大圆圈连接，再返回检测。",
    ),
    "vgNotEnabled": MessageLookupByLibrary.simpleMessage("未开启"),
    "vgNotInControl": MessageLookupByLibrary.simpleMessage("未接管"),
    "vgNotListening": MessageLookupByLibrary.simpleMessage("未监听"),
    "vgNotSignedIn": MessageLookupByLibrary.simpleMessage("未登录"),
    "vgNotSignedInPleaseSignIn": MessageLookupByLibrary.simpleMessage(
      "未登录,请先登录",
    ),
    "vgOauthSuccessHtmlBody": MessageLookupByLibrary.simpleMessage(
      "<p style=\"opacity:.7;margin:0\">请返回 Voguesly 应用继续</p></div>",
    ),
    "vgOauthSuccessHtmlHead": MessageLookupByLibrary.simpleMessage(
      "<div><h2 style=\"margin:0 0 8px;font-weight:600\">登录成功</h2>",
    ),
    "vgOfficialSite": MessageLookupByLibrary.simpleMessage("官网"),
    "vgOneTapTrialInApp": MessageLookupByLibrary.simpleMessage("app内一键体验"),
    "vgOneTime": MessageLookupByLibrary.simpleMessage("一次性"),
    "vgOneYear": MessageLookupByLibrary.simpleMessage("1 年"),
    "vgOnlineButChecksAffected": MessageLookupByLibrary.simpleMessage(
      "上网正常；检测功能可能受端口占用影响。",
    ),
    "vgOnlinePayment": MessageLookupByLibrary.simpleMessage("在线支付"),
    "vgOnlineViaTunProxyTaken": MessageLookupByLibrary.simpleMessage(
      "上网正常 —— 易联正在走虚拟网卡。系统代理被其他软件占用，但不影响你上网。",
    ),
    "vgOpenPayment": MessageLookupByLibrary.simpleMessage("打开支付"),
    "vgOpenSettingsToGrant": MessageLookupByLibrary.simpleMessage("去设置开启权限"),
    "vgOpenSupportFailedRetry": MessageLookupByLibrary.simpleMessage(
      "打开客服失败,请稍后重试",
    ),
    "vgOpenSupportInBrowser": MessageLookupByLibrary.simpleMessage("用浏览器打开客服"),
    "vgOpenSystemSettings": MessageLookupByLibrary.simpleMessage("打开系统设置"),
    "vgOpeningInstaller": MessageLookupByLibrary.simpleMessage("正在打开安装程序…"),
    "vgOr": MessageLookupByLibrary.simpleMessage("或"),
    "vgOrderActivating": MessageLookupByLibrary.simpleMessage("开通中"),
    "vgOrderCancelled": MessageLookupByLibrary.simpleMessage("已取消"),
    "vgOrderCancelledToast": MessageLookupByLibrary.simpleMessage("订单已取消"),
    "vgOrderCompleted": MessageLookupByLibrary.simpleMessage("已完成"),
    "vgOrderFailed": MessageLookupByLibrary.simpleMessage("下单失败"),
    "vgOrderFailedRetry": MessageLookupByLibrary.simpleMessage("下单失败,请稍后再试"),
    "vgOrderFailedWith": m47,
    "vgOrderNoWith": m48,
    "vgOrderPendingPayment": MessageLookupByLibrary.simpleMessage("待支付"),
    "vgOrderRefunded": MessageLookupByLibrary.simpleMessage("已退款"),
    "vgOriginalsOnly": MessageLookupByLibrary.simpleMessage("仅自制剧"),
    "vgOtherProxyRunningCloseFirst": m49,
    "vgOtherProxyRunningSkipTun": m50,
    "vgPassword": MessageLookupByLibrary.simpleMessage("密码"),
    "vgPasswordChanged": MessageLookupByLibrary.simpleMessage("密码已修改"),
    "vgPasswordsDoNotMatch": MessageLookupByLibrary.simpleMessage("两次新密码不一致"),
    "vgPayHereOrScanHint": MessageLookupByLibrary.simpleMessage(
      "本机点下方「打开支付」直接付款，\\n或用其他设备扫码。完成后自动到账。",
    ),
    "vgPayWithBalance": MessageLookupByLibrary.simpleMessage("余额支付"),
    "vgPaymentOpenedInBrowserHint": MessageLookupByLibrary.simpleMessage(
      "已在浏览器打开支付页面。\\n完成支付后本页会自动到账。",
    ),
    "vgPaymentStartFailed": MessageLookupByLibrary.simpleMessage("支付发起失败"),
    "vgPaymentStartFailedWith": m51,
    "vgPaymentSuccessActivated": MessageLookupByLibrary.simpleMessage(
      "支付成功,套餐已开通",
    ),
    "vgPayoutAccount": MessageLookupByLibrary.simpleMessage("收款账号"),
    "vgPkgOpenedQuitting": MessageLookupByLibrary.simpleMessage(
      "PKG 安装器已打开，易联正在安全退出。请按系统提示授权，安装器会覆盖 Applications 中的旧版本。",
    ),
    "vgPlacingOrder": MessageLookupByLibrary.simpleMessage("正在下单…"),
    "vgPlan": MessageLookupByLibrary.simpleMessage("套餐"),
    "vgPlanDeviceLimitWith": m52,
    "vgPlatformNoLocalDiag": MessageLookupByLibrary.simpleMessage(
      "当前平台不支持本机环境诊断。",
    ),
    "vgPointsToVogueslyWith": m53,
    "vgPortHeldByOther": m54,
    "vgPortHeldByOther2": MessageLookupByLibrary.simpleMessage(
      "这种最难查的故障。可以在「设置 → 网络」改用一个没人使用的端口。",
    ),
    "vgPortMaybeTakenAndroid": MessageLookupByLibrary.simpleMessage(
      "端口可能被另一个代理 App 占用。在 Android 上这不影响上网（易联走 VPN 通道），",
    ),
    "vgPortMaybeTakenAndroid2": MessageLookupByLibrary.simpleMessage(
      "但会令本页的解锁／延迟检测量不到数据。",
    ),
    "vgPreparingInstall": MessageLookupByLibrary.simpleMessage("正在准备安装…"),
    "vgPublicTrafficOnOtherTun": m55,
    "vgPublicTrafficOnOurTun": MessageLookupByLibrary.simpleMessage(
      "公网流量正在走易联的虚拟网卡。这是主路径，不依赖系统代理。",
    ),
    "vgPurchaseSuccessActivated": MessageLookupByLibrary.simpleMessage(
      "购买成功,套餐已开通",
    ),
    "vgQuarterly": MessageLookupByLibrary.simpleMessage("季付"),
    "vgQuitOtherProxyToTakeOver": MessageLookupByLibrary.simpleMessage(
      "如需易联接管系统代理，请先退出其他代理软件再重新连接。",
    ),
    "vgRecentLogsHeader": MessageLookupByLibrary.simpleMessage("--- 近期日志 ---"),
    "vgRecheck": MessageLookupByLibrary.simpleMessage("重新检测"),
    "vgReferralCode": MessageLookupByLibrary.simpleMessage("邀请码"),
    "vgReferralCodeDiscount": MessageLookupByLibrary.simpleMessage("填邀请码注册有优惠"),
    "vgReferralCodeOptional": MessageLookupByLibrary.simpleMessage("邀请码（选填）"),
    "vgReferralExplain": MessageLookupByLibrary.simpleMessage(
      "好友通过你的链接注册并购买套餐,你可获得返利佣金。佣金可用于抵扣续费。",
    ),
    "vgReferralLink": MessageLookupByLibrary.simpleMessage("邀请链接"),
    "vgReferralRewards": MessageLookupByLibrary.simpleMessage("邀请返利"),
    "vgReferralSubtitle": MessageLookupByLibrary.simpleMessage("邀请好友、查看佣金、提现"),
    "vgRefetchPlanAndTrial": MessageLookupByLibrary.simpleMessage(
      "重新获取套餐与免费测试资格",
    ),
    "vgRefresh": MessageLookupByLibrary.simpleMessage("刷新"),
    "vgRegionBlocked": MessageLookupByLibrary.simpleMessage("地区封禁"),
    "vgRegionNotSupported": MessageLookupByLibrary.simpleMessage("地区不支持"),
    "vgRegionRestricted": MessageLookupByLibrary.simpleMessage("地区限制"),
    "vgRemainingData": MessageLookupByLibrary.simpleMessage("剩余流量"),
    "vgRememberMe": MessageLookupByLibrary.simpleMessage("记住我"),
    "vgReopenPayment": MessageLookupByLibrary.simpleMessage("重新打开支付"),
    "vgReopenTunAfterPermission": MessageLookupByLibrary.simpleMessage(
      "修好权限后可在仪表盘重新打开「虚拟网卡（设备接管）」。",
    ),
    "vgReplyToSupport": MessageLookupByLibrary.simpleMessage("继续回复客服…"),
    "vgReportIssueSubtitle": MessageLookupByLibrary.simpleMessage(
      "一键把日志发给客服，帮你快速定位",
    ),
    "vgReportIssueUploadLogs": MessageLookupByLibrary.simpleMessage(
      "反馈问题 / 上传日志",
    ),
    "vgReset": MessageLookupByLibrary.simpleMessage("重置"),
    "vgResetFailed": MessageLookupByLibrary.simpleMessage("重置失败"),
    "vgResetProxyHint": MessageLookupByLibrary.simpleMessage(
      "只会重写易联自己的设置,不会关闭或修改你其他的代理软件。",
    ),
    "vgResetSubscription": MessageLookupByLibrary.simpleMessage("重置订阅"),
    "vgResetSubscriptionConfirm": MessageLookupByLibrary.simpleMessage(
      "重置后旧的订阅链接会立即失效,已导出到其他客户端的需重新导入。确定重置?",
    ),
    "vgResetVogueslySystemProxy": MessageLookupByLibrary.simpleMessage(
      "重设易联的系统代理",
    ),
    "vgResidentialIpProfile": MessageLookupByLibrary.simpleMessage("易联 住宅 IP"),
    "vgRetry": MessageLookupByLibrary.simpleMessage("重试"),
    "vgRetryImportSubscription": MessageLookupByLibrary.simpleMessage("重试导入订阅"),
    "vgRouteTableSeesOurTun": MessageLookupByLibrary.simpleMessage(
      "路由表中可见易联的虚拟网卡。这是主路径，不依赖系统代理。",
    ),
    "vgRuleModeSummary": MessageLookupByLibrary.simpleMessage(
      "智能分流 · AI/银行走住宅，国内直连（推荐）",
    ),
    "vgRunningAlongside": MessageLookupByLibrary.simpleMessage("同场运行"),
    "vgRunningFromDmgHint": MessageLookupByLibrary.simpleMessage(
      "当前是从 DMG 磁盘映像直接运行易联。请先把易联拖入 Applications，",
    ),
    "vgRunningFromDmgHint2": MessageLookupByLibrary.simpleMessage(
      "再从 Applications 打开；从 DMG 直接运行无法启用 TUN 后台服务。",
    ),
    "vgScanToPay": MessageLookupByLibrary.simpleMessage("扫码支付"),
    "vgScanWithPhoneHint": MessageLookupByLibrary.simpleMessage(
      "请用手机支付宝 / 微信扫码支付。\\n完成后本页会自动到账。",
    ),
    "vgSend": MessageLookupByLibrary.simpleMessage("发送"),
    "vgSendFailedRetry": MessageLookupByLibrary.simpleMessage("发送失败,请稍后再试"),
    "vgSendFailedRetryComma": MessageLookupByLibrary.simpleMessage(
      "发送失败，请稍后再试",
    ),
    "vgSendFailedWith": m56,
    "vgSent": MessageLookupByLibrary.simpleMessage("已发送"),
    "vgSessionExpiredSignInAgain": MessageLookupByLibrary.simpleMessage(
      "登录已失效,请重新登录",
    ),
    "vgShadowrocket": MessageLookupByLibrary.simpleMessage("Shadowrocket(小火箭)"),
    "vgSignIn": MessageLookupByLibrary.simpleMessage("登录"),
    "vgSignInAccount": MessageLookupByLibrary.simpleMessage("登录账户"),
    "vgSignInBeforeFeedback": MessageLookupByLibrary.simpleMessage("请先登录再反馈"),
    "vgSignInFailed": MessageLookupByLibrary.simpleMessage("登录失败"),
    "vgSignInWithGoogle": MessageLookupByLibrary.simpleMessage("使用 Google 登录"),
    "vgSignOut": MessageLookupByLibrary.simpleMessage("退出登录"),
    "vgSignOutAccount": MessageLookupByLibrary.simpleMessage("登出账号"),
    "vgSignOutAccountConfirm": MessageLookupByLibrary.simpleMessage(
      "确定登出当前账号？登出后需要重新登录。",
    ),
    "vgSignOutConfirm": MessageLookupByLibrary.simpleMessage("确定要退出当前账号吗？"),
    "vgSignOutConfirmShort": MessageLookupByLibrary.simpleMessage("确定退出当前账户?"),
    "vgSignUp": MessageLookupByLibrary.simpleMessage("注册"),
    "vgSignUpAutoConnect": MessageLookupByLibrary.simpleMessage("注册即自动连接节点"),
    "vgSignUpFailed": MessageLookupByLibrary.simpleMessage("注册失败"),
    "vgSignUpWithGoogle": MessageLookupByLibrary.simpleMessage("使用 Google 注册"),
    "vgSignedInLoadingPlan": MessageLookupByLibrary.simpleMessage(
      "账号已登录 · 套餐加载中…",
    ),
    "vgSixDigitCode": MessageLookupByLibrary.simpleMessage("6 位验证码"),
    "vgSmartRoutingDesc1": MessageLookupByLibrary.simpleMessage(
      "AI、银行、支付自动走美国住宅 IP；国内网站直连更快，",
    ),
    "vgSmartRoutingDesc2": MessageLookupByLibrary.simpleMessage(
      "看片下载走机房节省住宅流量。IP 检测会显示住宅 IP。",
    ),
    "vgSmartRoutingRecommended": MessageLookupByLibrary.simpleMessage(
      "智能分流（推荐）",
    ),
    "vgSomethingWentWrongRetry": MessageLookupByLibrary.simpleMessage(
      "出错了,请稍后重试",
    ),
    "vgSpeedLimitNMbps": m57,
    "vgSplitRouteHint": MessageLookupByLibrary.simpleMessage(
      "国际服务走外国出口、国内服务走本地 —— 智能分流实时验证",
    ),
    "vgSplitRouteTest": MessageLookupByLibrary.simpleMessage("IP 分流测试"),
    "vgStartYourTest": MessageLookupByLibrary.simpleMessage("开始你的测试"),
    "vgStarterPackSpecs": MessageLookupByLibrary.simpleMessage(
      "3GB 不限时,适合完整验证 ChatGPT / Claude 等场景",
    ),
    "vgStarting": MessageLookupByLibrary.simpleMessage("正在开启"),
    "vgStartingPaymentEllipsis": MessageLookupByLibrary.simpleMessage(
      "正在发起支付…",
    ),
    "vgStore": MessageLookupByLibrary.simpleMessage("商城"),
    "vgSubmit": MessageLookupByLibrary.simpleMessage("提交"),
    "vgSubmitFailedRetry": MessageLookupByLibrary.simpleMessage("提交失败，请稍后再试"),
    "vgSubmitFailedWith": m58,
    "vgSubmitToSupport": MessageLookupByLibrary.simpleMessage("提交给客服"),
    "vgSubmittedSupportWillFollowUp": MessageLookupByLibrary.simpleMessage(
      "已提交，客服会尽快跟进",
    ),
    "vgSubmitting": MessageLookupByLibrary.simpleMessage("提交中…"),
    "vgSubscribeNow": MessageLookupByLibrary.simpleMessage("立即一键订阅"),
    "vgSubscriptionImportFailedRetry": MessageLookupByLibrary.simpleMessage(
      "订阅导入失败,请稍后重试。",
    ),
    "vgSubscriptionResetFetching": MessageLookupByLibrary.simpleMessage(
      "订阅已重置,正在拉取新节点…",
    ),
    "vgSubscriptionUpdated": MessageLookupByLibrary.simpleMessage("订阅已更新"),
    "vgSupport": MessageLookupByLibrary.simpleMessage("客服"),
    "vgSwitchedToGlobal": MessageLookupByLibrary.simpleMessage("已切换到全局加速"),
    "vgSystemProxy": MessageLookupByLibrary.simpleMessage("系统代理"),
    "vgSystemProxyCompat": m59,
    "vgSystemProxyCompatDesc": MessageLookupByLibrary.simpleMessage(
      "仅接管支持系统代理的应用；Telegram 等应用可能仍需要 TUN",
    ),
    "vgSystemProxyOccupied": MessageLookupByLibrary.simpleMessage(
      "系统代理未能接管流量，可能被其他代理软件占用；请退出其他代理软件后重试",
    ),
    "vgSystemProxySingleSlot": m60,
    "vgTakenByOtherAppWith": m61,
    "vgTakenByOtherProcessWith": m62,
    "vgTaobao": MessageLookupByLibrary.simpleMessage("淘宝"),
    "vgTapBelowToFetchNodes": MessageLookupByLibrary.simpleMessage(
      "点下方按钮拉取最新节点",
    ),
    "vgTapToActivate": MessageLookupByLibrary.simpleMessage("点我开通"),
    "vgTapToConnect": MessageLookupByLibrary.simpleMessage("点击连接"),
    "vgTapToDisconnectWith": m63,
    "vgTelegramSupport": MessageLookupByLibrary.simpleMessage("Telegram 客服"),
    "vgTempEnabledSystemProxy": m64,
    "vgTesting": MessageLookupByLibrary.simpleMessage("测试中…"),
    "vgThreeYearly": MessageLookupByLibrary.simpleMessage("三年付"),
    "vgTicketAwaitingReply": MessageLookupByLibrary.simpleMessage("等待回复"),
    "vgTicketClosed": MessageLookupByLibrary.simpleMessage("已关闭"),
    "vgTicketIsClosed": MessageLookupByLibrary.simpleMessage("工单已关闭"),
    "vgTicketNumber": m65,
    "vgTicketSupportReplied": MessageLookupByLibrary.simpleMessage("客服已回"),
    "vgTimeout": MessageLookupByLibrary.simpleMessage("超时"),
    "vgTotal": MessageLookupByLibrary.simpleMessage("合计"),
    "vgTotalDownload": MessageLookupByLibrary.simpleMessage("总下行"),
    "vgTotalUpload": MessageLookupByLibrary.simpleMessage("总上行"),
    "vgTrafficNGb": m66,
    "vgTrafficStillOnTun": MessageLookupByLibrary.simpleMessage(
      "设备流量仍由易联的虚拟网卡承载，上网不受影响；",
    ),
    "vgTransfer": MessageLookupByLibrary.simpleMessage("划转"),
    "vgTransferAmountYuan": MessageLookupByLibrary.simpleMessage("划转金额(元)"),
    "vgTransferFailed": MessageLookupByLibrary.simpleMessage("划转失败"),
    "vgTransferToBalance": MessageLookupByLibrary.simpleMessage("划转到余额"),
    "vgTransferredToBalance": MessageLookupByLibrary.simpleMessage("已划转到余额"),
    "vgTrialSpecs": MessageLookupByLibrary.simpleMessage(
      "6 小时 / 500MB,适合快速验证连通性",
    ),
    "vgTryFreeOrBuyStarter": MessageLookupByLibrary.simpleMessage(
      "先免费体验,或购买验证包做完整测试",
    ),
    "vgTunAlsoNotInControlNote": MessageLookupByLibrary.simpleMessage(
      "而虚拟网卡也没有接管，所以现在可能真的上不了网。",
    ),
    "vgTunDeviceWide": m67,
    "vgTunDeviceWideDesc": MessageLookupByLibrary.simpleMessage(
      "接管整台设备流量；需关闭其他 VPN，并完成系统权限授权",
    ),
    "vgTunNotAuthorized": MessageLookupByLibrary.simpleMessage(
      "TUN 授权未通过，暂时无法接管整机流量",
    ),
    "vgTunOffUsingCompatMode": MessageLookupByLibrary.simpleMessage(
      "你未开启虚拟网卡，当前正在使用系统代理兼容模式。",
    ),
    "vgTunOnButNoUtun": MessageLookupByLibrary.simpleMessage(
      "设置中已开启虚拟网卡，但公网流量并未走 utun。可能是授权未完成。",
    ),
    "vgTunOnButNotInRouteTable": MessageLookupByLibrary.simpleMessage(
      "设置中已开启虚拟网卡，但路由表中看不到。可能是后台服务尚未安装。",
    ),
    "vgTunPlusSystemProxy": MessageLookupByLibrary.simpleMessage("TUN + 系统代理"),
    "vgTunServiceNeedsReauth": MessageLookupByLibrary.simpleMessage(
      "易联的后台 TUN 服务需要重新授权。请在「系统设置 → 通用 → 登录项与扩展」",
    ),
    "vgTunServiceNeedsReauth2": MessageLookupByLibrary.simpleMessage(
      "中允许「易联」的后台项目，然后回到易联再点一次连接。",
    ),
    "vgTunServiceNotEnabled": MessageLookupByLibrary.simpleMessage(
      "易联后台 TUN 服务未启用，请在系统设置允许易联后台项目后重试。",
    ),
    "vgTunTwiceNoTakeover": MessageLookupByLibrary.simpleMessage(
      "TUN 连续两次启动仍未能接管系统流量",
    ),
    "vgTunUnaffectedNote": MessageLookupByLibrary.simpleMessage(
      "你的上网**不受影响**，因为易联正在走虚拟网卡。",
    ),
    "vgTurnOnVoguesly": MessageLookupByLibrary.simpleMessage("开启易联"),
    "vgTwoYearly": MessageLookupByLibrary.simpleMessage("两年付"),
    "vgUnknown": MessageLookupByLibrary.simpleMessage("未知"),
    "vgUnlockCheck": MessageLookupByLibrary.simpleMessage("解锁检测"),
    "vgUpdateCheckNetworkError": MessageLookupByLibrary.simpleMessage(
      "网络异常，暂时检查不到更新，请检查网络后重试",
    ),
    "vgUpdateFailedRetry": MessageLookupByLibrary.simpleMessage("更新失败,请稍后重试"),
    "vgUpdateSubscription": MessageLookupByLibrary.simpleMessage("更新订阅"),
    "vgUpdateSubscriptionFailed": MessageLookupByLibrary.simpleMessage(
      "更新订阅失败,请稍后重试",
    ),
    "vgUpdating": MessageLookupByLibrary.simpleMessage("更新中…"),
    "vgUserCenter": MessageLookupByLibrary.simpleMessage("用户中心"),
    "vgUserCenterSubtitle": MessageLookupByLibrary.simpleMessage(
      "余额、订单、重置订阅、修改密码",
    ),
    "vgV2RayFamilyClient": MessageLookupByLibrary.simpleMessage("V2Ray 系客户端"),
    "vgVersionBuildWith": m68,
    "vgVersionLabel": MessageLookupByLibrary.simpleMessage("版本"),
    "vgVersionNumber": m69,
    "vgVersionTapToCheck": m70,
    "vgViewLogs": MessageLookupByLibrary.simpleMessage("查看日志"),
    "vgViewLogsSubtitle": MessageLookupByLibrary.simpleMessage("实时连接日志，排查问题用"),
    "vgViewOrdersResumePayment": MessageLookupByLibrary.simpleMessage(
      "查看订单 · 继续未完成的支付",
    ),
    "vgVirtualNic": MessageLookupByLibrary.simpleMessage("虚拟网卡"),
    "vgVirtualNicTun": MessageLookupByLibrary.simpleMessage("虚拟网卡(TUN)"),
    "vgVirtualNicVpn": MessageLookupByLibrary.simpleMessage("虚拟网卡(VPN)"),
    "vgVogueslyInControl": MessageLookupByLibrary.simpleMessage("易联接管中"),
    "vgVogueslyInControlWith": m71,
    "vgVogueslyListening": MessageLookupByLibrary.simpleMessage("易联正在监听"),
    "vgVpnCouldNotConnect": MessageLookupByLibrary.simpleMessage(
      "VPN 未能建立连接(可能权限被拒或系统限制),请重新连接",
    ),
    "vgWaitingForPayment": MessageLookupByLibrary.simpleMessage("等待支付到账"),
    "vgWeChat": MessageLookupByLibrary.simpleMessage("微信"),
    "vgWebViewInitFailed": m72,
    "vgWithdraw": MessageLookupByLibrary.simpleMessage("提现"),
    "vgWithdrawFailed": MessageLookupByLibrary.simpleMessage("提现失败"),
    "vgWithdrawMethod": MessageLookupByLibrary.simpleMessage(
      "提现方式(支付宝 / 微信 / USDT)",
    ),
    "vgWithdrawRequest": MessageLookupByLibrary.simpleMessage("提现申请"),
    "vgWithdrawSubmitted": MessageLookupByLibrary.simpleMessage(
      "提现申请已提交,客服会尽快处理",
    ),
    "vgWrongEmailOrPassword": MessageLookupByLibrary.simpleMessage("邮箱或密码错误"),
    "vgYearly": MessageLookupByLibrary.simpleMessage("年付"),
    "vgYouAlreadyHavePlan": MessageLookupByLibrary.simpleMessage("你已有套餐"),
    "vibrantScheme": MessageLookupByLibrary.simpleMessage("活力"),
    "view": MessageLookupByLibrary.simpleMessage("查看"),
    "vogChooseAvatar": MessageLookupByLibrary.simpleMessage("选择头像"),
    "vogExpiry": MessageLookupByLibrary.simpleMessage("到期"),
    "vogMyAccount": MessageLookupByLibrary.simpleMessage("易聯 账号"),
    "vogNotLoggedIn": MessageLookupByLibrary.simpleMessage("未登录"),
    "vogPermanent": MessageLookupByLibrary.simpleMessage("长期有效"),
    "vogRemainTotal": MessageLookupByLibrary.simpleMessage("剩余 / 共"),
    "vpnConfigChangeDetected": MessageLookupByLibrary.simpleMessage(
      "检测到VPN相关配置改动",
    ),
    "vpnEnableDesc": MessageLookupByLibrary.simpleMessage(
      "通过VpnService自动路由系统所有流量",
    ),
    "vpnTip": MessageLookupByLibrary.simpleMessage("重启VPN后改变生效"),
    "webDAVConfiguration": MessageLookupByLibrary.simpleMessage("WebDAV配置"),
    "whitelistMode": MessageLookupByLibrary.simpleMessage("白名单模式"),
    "yearsAgo": m73,
    "zh_CN": MessageLookupByLibrary.simpleMessage("中文简体"),
  };
}
