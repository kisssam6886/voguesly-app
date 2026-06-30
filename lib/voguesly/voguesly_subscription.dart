import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'voguesly_auth.dart';

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

/// 共用「导入当前账号订阅」逻辑(登录门 + 免费测试开通后都用)。
///
/// 先删走上一个账号导入的 voguesly 订阅,再导入当前账号并强制设为活动 profile,
/// 否则 FlClash 的 putProfile 只在「当前无活动 profile」时才切换 → 新账号继续用旧订阅(串号)。
///
/// ⚠️ 用我哋自己嘅 dio 攞 config bytes(主 cp 失败自动轮镜像),绕开 FlClash 核心
/// _clashDio(后者主入口瞬断会抛「未知网络错误」且食咗错误唔 throw)。
/// 返回 true=成功导入并设为活动 profile。
Future<bool> importVogueslySubscription(WidgetRef ref) async {
  ref.read(vogueslyImportingProvider.notifier).set(true);
  try {
    final url =
        await ref.read(vogueslyAuthProvider.notifier).fetchSubscribeUrl();
    if (url == null || url.isEmpty) return false;
    final action = ref.read(profilesActionProvider.notifier);
    // 删走之前账号导入的 voguesly 订阅(含 fallback 镜像域),避免新账号继续用旧订阅
    final staleIds = ref
        .read(profilesProvider)
        .where((p) =>
            p.url.contains('voguesly') ||
            p.url.contains('corelane') ||
            p.url.contains('octolink'))
        .map((p) => p.id)
        .toList();
    for (final id in staleIds) {
      await action.deleteProfile(id);
    }
    final api = ref.read(vogueslyApiProvider);
    final fetched = await api.fetchSubscribeBytes(url);
    if (fetched == null) return false;
    final Profile profile;
    try {
      // 显式 set label,否则 saveFile 路径会用 profile id 数字做名(令用户误会账号错)
      profile = await Profile.normal(
        label: '易聯 Residential IP',
        url: fetched.url,
      ).saveFile(fetched.bytes);
    } catch (_) {
      return false; // config 校验失败(例如未开通套餐→订阅无节点)
    }
    action.putProfile(profile);
    final importedUrl = fetched.url;
    // 强制把当前账号订阅设为活动 profile(防止旧 currentProfileId 残留)
    final imported = ref
        .read(profilesProvider)
        .where((p) => p.url == importedUrl)
        .toList();
    if (imported.isNotEmpty) {
      ref.read(currentProfileIdProvider.notifier).value = imported.last.id;
      return true;
    }
    return false;
  } finally {
    ref.read(vogueslyImportingProvider.notifier).set(false);
  }
}
