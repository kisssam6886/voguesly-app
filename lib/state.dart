import 'dart:async';
import 'dart:io';

import 'package:animations/animations.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:fl_clash/common/theme.dart';
import 'package:fl_clash/widgets/dialog.dart';
import 'package:fl_clash/widgets/list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_color_utilities/palettes/core_palette.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:url_launcher/url_launcher.dart';

import 'common/common.dart';
import 'database/database.dart';
import 'enum/enum.dart';
import 'l10n/l10n.dart';
import 'models/models.dart';
import 'providers/providers.dart';

/// 把原始异常(SocketException/DioException 英文堆栈)翻译成消费者友好文案。
String _friendlyError(Object e) {
  final s = e.toString().toLowerCase();
  if (s.contains('socket') ||
      s.contains('failed host lookup') ||
      s.contains('connection') ||
      s.contains('handshake') ||
      s.contains('network is unreachable')) {
    return '网络不稳定，请检查网络后重试';
  }
  if (s.contains('timeout') || s.contains('timed out')) {
    return '连接超时，请稍后重试';
  }
  if (s.contains('format') ||
      s.contains('validate') ||
      s.contains('yaml') ||
      s.contains('parse')) {
    return '配置解析失败，请更新订阅或联系客服';
  }
  return '操作失败，请稍后重试';
}

class GlobalState {
  static GlobalState? _instance;
  final navigatorKey = GlobalKey<NavigatorState>();
  bool isPre = true;
  late final String coreSHA256;
  late final PackageInfo packageInfo;
  Function? updateCurrentDelayDebounce;
  late Measure measure;
  late CommonTheme theme;
  late Color accentColor;
  late ProviderContainer container;
  bool needInitStatus = true;

  // ignore: deprecated_member_use
  CorePalette? corePalette;
  String? lastConfigMd5;
  VpnState? lastVpnState;
  bool isAttach = false;

  GlobalState._internal();

  factory GlobalState() {
    _instance ??= GlobalState._internal();
    return _instance!;
  }

  Future<ProviderContainer> init(int version) async {
    coreSHA256 = const String.fromEnvironment('CORE_SHA256');
    isPre = const String.fromEnvironment('APP_ENV') != 'stable';
    await _initDynamicColor();
    // macOS:核心必须先铺到 Application Support 才能拿到可 setuid 的 corePath,
    // 且要早于任何 checkIsAdmin / 核心启动。详见 AppPath.corePath 注释。
    await appPath.provisionExternalCore();
    return _initData(version);
  }

  Future<void> _initDynamicColor() async {
    try {
      corePalette = await DynamicColorPlugin.getCorePalette();
      accentColor =
          await DynamicColorPlugin.getAccentColor() ??
          const Color(defaultPrimaryColor);
    } catch (_) {}
  }

  String get ua => container
      .read(patchClashConfigProvider.select((state) => state.globalUa))
      .takeFirstValid([packageInfo.ua]);

  BuildContext get _context => navigatorKey.currentContext!;

  Future<ProviderContainer> _initData(int version) async {
    final appState = AppState(
      brightness: WidgetsBinding.instance.platformDispatcher.platformBrightness,
      version: version,
      viewSize: Size.zero,
      requests: FixedList(maxLength),
      logs: FixedList(maxLength),
      traffics: FixedList(30),
      totalTraffic: const Traffic(),
      systemUiOverlayStyle: const SystemUiOverlayStyle(),
    );
    final appStateOverrides = buildAppStateOverrides(appState);
    packageInfo = await PackageInfo.fromPlatform();
    final configMap = await preferences.getConfigMap();
    var config = await migration.migrationIfNeeded(
      configMap,
      sync: (data) async {
        final newConfigMap = data.configMap;
        final config = Config.realFromJson(newConfigMap);
        await Future.wait([
          database.restore(
            data.profiles,
            data.scripts,
            data.rules,
            data.links,
            data.proxyGroups,
          ),
          preferences.saveConfig(config),
        ]);
        return config;
      },
    );
    // New desktop installs start in the same TUN-first mode as migrated
    // installs. Android keeps its platform VPN defaults unchanged.
    if (configMap == null && system.isDesktop) {
      config = config.copyWith(
        networkProps: config.networkProps.copyWith(systemProxy: false),
        patchClashConfig: config.patchClashConfig.copyWith(
          tun: config.patchClashConfig.tun.copyWith(enable: true),
        ),
      );
      await preferences.saveConfig(config);
    }
    // ⚠️修复(2026-07-14): Apple 域名(icloud/App Store 等)必须经 doh.pub 直接解析。
    // 病根:默认 dns 的 fallback-filter(geoip-code:CN)会把 Apple 返回的非 CN 正确 IP
    // (如 icloud.com→17.253.144.10)当成污染,转去 fallback DoT(tls://8.8.4.4);而 DoT/UDP53
    // 在国内家网被封 → DNS 超时 → iCloud/App Store 打不开(apple.com 因返回 CN CDN 反而正常)。
    // nameserver-policy 命中即用、不进 fallback-filter,故把整个 Apple 家族钉到 doh.pub。
    // 每次启动强制合并,令已持久化的旧 dns 配置(overrideDns 用户)也自动修好。
    {
      const appleDohPolicy = <String, String>{
        'geosite:apple': 'https://doh.pub/dns-query',
        '+.icloud.com': 'https://doh.pub/dns-query',
        '+.icloud-content.com': 'https://doh.pub/dns-query',
        '+.apple.com': 'https://doh.pub/dns-query',
        '+.mzstatic.com': 'https://doh.pub/dns-query',
        '+.cdn-apple.com': 'https://doh.pub/dns-query',
        '+.apple-cloudkit.com': 'https://doh.pub/dns-query',
        // reddit(2026-07-15 实测):家网 DNS 把 www.reddit.com 投毒成 69.171.235.22(Facebook 的 IP,
        // 真身是 reddit.map.fastly.net)。浏览器优先 HTTP/3 直打那个假 IP → 卡死打不开;
        // curl 走 TCP 靠 SNI 嗅探仍能被核心认出域名,所以只测 curl 看不出来(踩过)。
        // 钉 doh.pub 拿真 IP;另在订阅规则里禁了 reddit 的 QUIC 逼浏览器回退 TCP。
        '+.reddit.com': 'https://doh.pub/dns-query',
        '+.redd.it': 'https://doh.pub/dns-query',
        '+.redditstatic.com': 'https://doh.pub/dns-query',
        '+.redditmedia.com': 'https://doh.pub/dns-query',
        // zonefoundry.dev(2026-07-20 实测):自家站托管喺香港(104.245.40.48)。国内 DNS 解析
        // 得到非 CN 的港 IP → geoip-CN fallback-filter 当被污染 → 转去问被封的海外 DoT
        // (tls://8.8.4.4 / 1.1.1.1)→ 解析超时 → 站完全打不开。同 Apple/reddit 一样钉 doh.pub。
        '+.zonefoundry.dev': 'https://doh.pub/dns-query',
        // ⚠️⚠️ 易联自己嘅域名(2026-08-07 实测,同一个坑第 6 次)。
        // 之前钉过 Apple / reddit / zonefoundry,**独独漏咗自己**。
        // 实测五个自家 Web 域名全部解析到非 CN,即係全部会中 geoip-CN 陷阱:
        //   ylink.im→104.21.x(US) · dl.ylink.im→161.118.x(SG) · voguesly.com→172.67.x(US)
        //   cp.samseah.qzz.io→104.21.x(US) · cs-sg.syk.ccwu.cc→104.21.x(US)
        // 症状极隐蔽:核心日志只讲 "dns resolve failed: context deadline exceeded",
        // 而绕过 TUN 走物理网卡完全正常 → 好易误判成「域名被墙」(我就误判过)。
        // 触发条件 = 客户端重启令 DNS 缓存清空;缓存未过期时一切正常,所以会「突然」出事。
        // ⚠️ 影响面 = 面板 / 下载站 / 客服,即係用户注册、装客户端、求助嘅必经入口。
        // ⚠️ 节点域名唔使钉:佢哋由 proxy-server-nameserver 独立解析,唔经 fallback-filter。
        '+.ylink.im': 'https://doh.pub/dns-query',
        '+.voguesly.com': 'https://doh.pub/dns-query',
        '+.samseah.qzz.io': 'https://doh.pub/dns-query',
        '+.syk.ccwu.cc': 'https://doh.pub/dns-query',
        '+.ccwu.cc': 'https://doh.pub/dns-query',
      };
      final dns = config.patchClashConfig.dns;
      final mergedPolicy = {...dns.nameserverPolicy, ...appleDohPolicy};
      config = config.copyWith(
        patchClashConfig: config.patchClashConfig.copyWith(
          dns: dns.copyWith(nameserverPolicy: mergedPolicy),
        ),
      );
    }
    final configOverrides = buildConfigOverrides(config);
    container = ProviderContainer(
      overrides: [...appStateOverrides, ...configOverrides],
    );
    final profiles = await database.profilesDao.query().get();
    container.read(profilesProvider.notifier).setAndReorder(profiles);
    await AppLocalizations.load(
      utils.getLocaleForString(config.appSettingProps.locale) ??
          WidgetsBinding.instance.platformDispatcher.locale,
    );
    await window?.init(version, config.windowProps);
    return container;
  }

  Future<T?> loadingRun<T>(
    FutureOr<T> Function() futureFunction, {
    String? title,
    required LoadingTag? tag,
    bool silence = false,
  }) async {
    return globalState.safeRun(
      futureFunction,
      silence: silence,
      title: title,
      onStart: () {
        if (tag != null) {
          container.read(loadingProvider(tag).notifier).start();
        }
      },
      onEnd: () {
        if (tag != null) {
          container.read(loadingProvider(tag).notifier).stop();
        }
      },
    );
  }

  Future<T?> safeRun<T>(
    FutureOr<T> Function() futureFunction, {
    String? title,
    VoidCallback? onStart,
    VoidCallback? onEnd,
    bool silence = true,
  }) async {
    try {
      onStart?.call();
      return await futureFunction();
    } catch (e, s) {
      commonPrint.log('$title ===> $e, $s', logLevel: LogLevel.warning);
      // 原始异常(SocketException/DioException 英文堆栈)入 log 就够;弹俾用户嘅要翻译成友好文案。
      final friendly = _friendlyError(e);
      if (silence) {
        showNotifier(friendly);
      } else {
        showMessage(
          title: title ?? currentAppLocalizations.tip,
          message: TextSpan(text: friendly),
        );
      }
      return null;
    } finally {
      onEnd?.call();
    }
  }

  Future<bool?> showMessage({
    required InlineSpan message,
    BuildContext? context,
    String? title,
    String? confirmText,
    String? cancelText,
    bool cancelable = true,
    bool? dismissible,
  }) async {
    return showCommonDialog<bool>(
      context: context,
      dismissible: dismissible,
      child: Builder(
        builder: (context) {
          final appLocalizations = context.appLocalizations;
          return CommonDialog(
            title: title ?? appLocalizations.tip,
            actions: [
              if (cancelable)
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(cancelText ?? appLocalizations.cancel),
                ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text(confirmText ?? appLocalizations.confirm),
              ),
            ],
            child: Container(
              width: 300,
              constraints: const BoxConstraints(maxHeight: 200),
              child: SingleChildScrollView(
                child: SelectableText.rich(
                  TextSpan(
                    style: Theme.of(context).textTheme.labelLarge,
                    children: [message],
                  ),
                  style: const TextStyle(overflow: TextOverflow.visible),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<bool?> showAllUpdatingMessagesDialog(
    List<UpdatingMessage> messages,
  ) async {
    return showCommonDialog<bool>(
      child: Builder(
        builder: (context) {
          final appLocalizations = currentAppLocalizations;
          return CommonDialog(
            padding: EdgeInsets.zero,
            title: appLocalizations.tip,
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text(appLocalizations.confirm),
              ),
            ],
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              constraints: const BoxConstraints(maxHeight: 200),
              child: ListView.separated(
                itemBuilder: (_, index) {
                  final message = messages[index];
                  return ListItem(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    title: Text(message.label),
                    subtitle: Text(message.message),
                  );
                },
                itemCount: messages.length,
                separatorBuilder: (_, _) => const Divider(height: 0),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<T?> showCommonDialog<T>({
    required Widget child,
    BuildContext? context,
    bool? dismissible,
    bool filter = true,
  }) async {
    return showModal<T>(
      useRootNavigator: false,
      context: context ?? globalState.navigatorKey.currentContext!,
      configuration: FadeScaleTransitionConfiguration(
        barrierColor: Colors.black38,
        barrierDismissible: dismissible ?? true,
      ),
      builder: (_) => child,
      filter: filter ? commonFilter : null,
    );
  }

  void showNotifier(String text, {MessageActionState? actionState}) {
    if (text.isEmpty) {
      return;
    }
    navigatorKey.currentContext?.showNotifier(text, actionState: actionState);
  }

  Future<void> openUrl(String url) async {
    final res = await showMessage(
      message: TextSpan(text: url),
      title: currentAppLocalizations.externalLink,
      confirmText: currentAppLocalizations.go,
    );
    if (res != true) {
      return;
    }
    launchUrl(Uri.parse(url));
  }

  Future<void> attach() async {
    if (isAttach == true) {
      return;
    }
    await _initApp();
    isAttach = true;
  }

  Future<void> _initApp() async {
    FlutterError.onError = (details) {
      commonPrint.log(
        'exception: ${details.exception} stack: ${details.stack}',
        logLevel: LogLevel.warning,
      );
    };
    container.read(systemActionProvider.notifier).updateTray();
    container.read(profilesActionProvider.notifier).autoUpdateProfiles();
    container.read(commonActionProvider.notifier).autoCheckUpdate();
    autoLaunch?.updateStatus(container.read(appSettingProvider).autoLaunch);
    if (!container.read(appSettingProvider).silentLaunch) {
      window?.show();
    } else {
      window?.hide();
    }
    await _handleFailedPreference();
    // 移除 FlClash 默认两个开屏提示(消费者产品唔需要):
    // 1) 免责声明「仅供学习交流·非商业」— 同商业 VPN 产品自相矛盾,且强制「不同意就退出」好突兀
    // 2) Firebase 数据收集提示 — 非必要弹窗(Crashlytics 本身仍工作,只係唔再首启弹)
    // 正式合规靠《隐私政策》《服务条款》(见 legal/),唔靠呢个 FlClash 占位免责声明。
    // await _handlerDisclaimer();
    // await _showCrashlyticsTip();
    await container.read(coreActionProvider.notifier).connectCore();
    await container.read(coreActionProvider.notifier).initCore();
    await container.read(setupActionProvider.notifier).initStatus();
    container.read(initProvider.notifier).value = true;
    permissions.check();
  }

  Future<void> _handleFailedPreference() async {
    if (await preferences.isInit) return;
    final res = await showMessage(
      title: currentAppLocalizations.tip,
      message: TextSpan(text: currentAppLocalizations.cacheCorrupt),
    );
    if (res == true) {
      final file = File(await appPath.sharedPreferencesPath);
      await file.safeDelete();
    }
    await container.read(systemActionProvider.notifier).handleExit();
  }

  Future<bool> showDisclaimer() async {
    return await showCommonDialog<bool>(
          dismissible: false,
          child: CommonDialog(
            title: currentAppLocalizations.disclaimer,
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(_context).pop<bool>(false);
                },
                child: Text(currentAppLocalizations.exit),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(_context).pop<bool>(true);
                },
                child: Text(currentAppLocalizations.agree),
              ),
            ],
            child: Text(currentAppLocalizations.disclaimerDesc),
          ),
        ) ??
        false;
  }

  // ignore: unused_element
  Future<void> _showCrashlyticsTip() async {
    if (!system.isAndroid) return;
    if (container.read(
      appSettingProvider.select((state) => state.crashlyticsTip),
    )) {
      return;
    }
    await showMessage(
      title: currentAppLocalizations.dataCollectionTip,
      cancelable: false,
      message: TextSpan(text: currentAppLocalizations.dataCollectionContent),
    );
    container
        .read(appSettingProvider.notifier)
        .update((state) => state.copyWith(crashlyticsTip: true));
  }

  // ignore: unused_element
  Future<void> _handlerDisclaimer() async {
    if (container.read(
      appSettingProvider.select((state) => state.disclaimerAccepted),
    )) {
      return;
    }
    final isDisclaimerAccepted = await showDisclaimer();
    if (!isDisclaimerAccepted) {
      await container.read(systemActionProvider.notifier).handleExit();
    }
    container
        .read(appSettingProvider.notifier)
        .update((state) => state.copyWith(disclaimerAccepted: true));
  }
}

final globalState = GlobalState();
