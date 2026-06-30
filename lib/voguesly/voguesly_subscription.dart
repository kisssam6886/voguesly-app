import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'voguesly_auth.dart';

/// 记录「当前磁盘上 voguesly 订阅属于边个账号」的 owner 标记(= 导入时嘅 token)。
/// restore 启动时凭此判定:profile 系咪真系属本账号,先决定可唔可以 skip 重导(防串号)。
const String kVogueslyProfileOwnerKey = 'voguesly_profile_owner';

/// 是否正在拉/导入订阅(China→HK 通常十几秒)。
/// 连接圈据此显示「正在载入订阅…」而非误显示「点我开通」(有套餐用户启动时)。
class VogueslyImportingNotifier extends Notifier<bool> {
  @override
  bool build() => false;
  void set(bool v) => state = v;
}

final vogueslyImportingProvider =
    NotifierProvider<VogueslyImportingNotifier, bool>(
  VogueslyImportingNotifier.new,
);

/// 上次导入订阅是否因**网络**失败(≠未开通套餐)。
/// 连接圈据此把空 profile 态分两种:网络失败显「载入失败·点我重试」,未开通显「点我开通」。
class VogueslyImportFailedNotifier extends Notifier<bool> {
  @override
  bool build() => false;
  void set(bool v) => state = v;
}

final vogueslyImportFailedProvider =
    NotifierProvider<VogueslyImportFailedNotifier, bool>(
  VogueslyImportFailedNotifier.new,
);

/// 统一判定:呢个 profile 系咪 voguesly 账号订阅(主域 cp + 中国可达镜像 corelane/octolink)。
/// 三处(导入删 stale / gate 判断 / 登出清理)共用,杜绝匹配器漂移(China 用户最常落镜像域)。
bool isVogueslyProfile(Profile p) =>
    p.url.contains('voguesly') ||
    p.url.contains('corelane') ||
    p.url.contains('octolink');

/// 删走所有 voguesly 订阅 profile + 清 owner 标记(登出 / 换账号防串号)。
/// 用稳定 globalState.container,唔依赖 widget 生命周期。
Future<void> clearVogueslyProfiles() async {
  final container = globalState.container;
  final action = container.read(profilesActionProvider.notifier);
  final ids = container
      .read(profilesProvider)
      .where(isVogueslyProfile)
      .map((p) => p.id)
      .toList();
  for (final id in ids) {
    await action.deleteProfile(id);
  }
  try {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(kVogueslyProfileOwnerKey);
  } catch (_) {}
}

/// 导入当前账号订阅(登录门 + 免费测试开通后都用)。
///
/// ⚠️ 用 globalState.container(稳定,唔受弹窗/页面 dispose 影响) —— 之前传 widget 嘅 ref,
/// 用户中途关弹窗会令 ref.read 抛错并把 importing 卡死喺 true。
///
/// 串号防线:
/// 1) **先无条件删走上一账号 voguesly 订阅**,再去拉新订阅。咁就算之后拉取/导入失败,
///    亦只会停喺「无订阅(fail-safe)」而绝不会停喺「仍用上一账号订阅」。
/// 2) 导入成功后记低 owner = 当前账号 token,restore 启动时凭此判 profile 系咪属本账号。
///
/// ⚠️ 用我哋自己嘅 dio 攞 config bytes(主 cp 失败自动轮镜像),绕开 FlClash 核心 _clashDio
/// (后者主入口瞬断会抛「未知网络错误」且食咗错误唔 throw)。
/// 返回 true=成功导入并设为活动 profile。
///
/// 并发互斥:gate 自动导入 / onboarding 手动一键订阅 / 其它触发可能同时 call,
/// 用 in-flight Future 合并 —— 同一刻只跑一条导入,后到嘅 await 同一结果,免重复删/导+竞态。
Future<bool>? _inFlightImport;
Future<bool> importVogueslySubscription() {
  return _inFlightImport ??=
      _doImportVogueslySubscription().whenComplete(() => _inFlightImport = null);
}

Future<bool> _doImportVogueslySubscription() async {
  final container = globalState.container;
  container.read(vogueslyImportingProvider.notifier).set(true);
  container.read(vogueslyImportFailedProvider.notifier).set(false);
  try {
    final auth = container.read(vogueslyAuthProvider.notifier);
    final token = container.read(vogueslyAuthProvider).token;
    final action = container.read(profilesActionProvider.notifier);
    // 1) 先拉成功新订阅(**先拉后删**):任何拉取/校验失败都唔会删走旧订阅,
    //    用户最多停喺「旧订阅(仍可用)」而非掉到「无订阅·点我开通」。
    //    串号防线唔靠呢度删——靠 owner token 绑定(restore-skip 校验 + 下面成功后删旧账号 profile)。
    final url = await auth.fetchSubscribeUrl();
    if (url == null || url.isEmpty) {
      container.read(vogueslyImportFailedProvider.notifier).set(true);
      return false; // 网络:攞唔到订阅链接
    }
    final api = container.read(vogueslyApiProvider);
    final fetched = await api.fetchSubscribeBytes(url);
    if (fetched == null) {
      container.read(vogueslyImportFailedProvider.notifier).set(true);
      return false; // 网络:全镜像拉 config 失败
    }
    Profile profile;
    try {
      // 显式 set label,否则 saveFile 路径会用 profile id 数字做名(令用户误会账号错)
      profile = await Profile.normal(
        label: '易聯 Residential IP',
        url: fetched.url,
      ).saveFile(fetched.bytes);
    } catch (_) {
      return false; // config 校验失败(例如未开通套餐→订阅无节点),旧订阅保留
    }
    // 缩短自动更新周期(默认 1 天太慢→续费/换套餐后最长 24h 先换新节点);
    // 走镜像 fallback 见 ProfilesActions.autoUpdateProfiles。
    profile = profile.copyWith(autoUpdateDuration: const Duration(hours: 1));
    final newId = profile.id;
    // 2) 新订阅就绪 → 写入 + 设为活动(putProfile 只在无活动时自动切,故显式设)
    action.putProfile(profile);
    container.read(currentProfileIdProvider.notifier).value = newId;
    // 3) 再删走其余(旧账号)voguesly 订阅,只保留刚导入嗰个(按 id 排他,避免同 url 残留)
    final staleIds = container
        .read(profilesProvider)
        .where((p) => isVogueslyProfile(p) && p.id != newId)
        .map((p) => p.id)
        .toList();
    for (final id in staleIds) {
      await action.deleteProfile(id);
    }
    // 4) 记 owner = 当前账号 token(restore-skip 凭此判定 profile 属本账号)
    if (token != null && token.isNotEmpty) {
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(kVogueslyProfileOwnerKey, token);
      } catch (_) {}
    }
    return true;
  } finally {
    container.read(vogueslyImportingProvider.notifier).set(false);
  }
}

/// restore-skip 用:磁盘上 voguesly profile 嘅 owner token 系咪 == 当前账号 token。
/// 仅当相等先可以 skip 重导;唔等/缺失则一律重导(任何失配自愈,杜绝串号被 restore 固化)。
Future<bool> vogueslyProfileOwnedByCurrentToken() async {
  final token = globalState.container.read(vogueslyAuthProvider).token;
  if (token == null || token.isEmpty) return false;
  try {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(kVogueslyProfileOwnerKey) == token;
  } catch (_) {
    return false;
  }
}
