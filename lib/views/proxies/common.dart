import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/core/core.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

double get listHeaderHeight {
  final measure = globalState.measure;
  return 20 + measure.titleMediumHeight + 4 + measure.bodyMediumHeight + 2;
}

double getItemHeight(ProxyCardType proxyCardType) {
  final measure = globalState.measure;
  final baseHeight =
      16 + measure.bodyMediumHeight * 2 + measure.bodySmallHeight + 8 + 4;
  return switch (proxyCardType) {
    ProxyCardType.expand => baseHeight + measure.labelSmallHeight + 6,
    ProxyCardType.shrink => baseHeight,
    ProxyCardType.min => baseHeight - measure.bodyMediumHeight,
  };
}

List<Group> getCurrentGroups() {
  return globalState.container.read(currentGroupsStateProvider).value;
}

List<Group> getGroups() {
  return globalState.container.read(groupsProvider);
}

String? getCurrentGroupName() {
  return globalState.container.read(
    currentProfileProvider.select((state) => state?.currentGroupName),
  );
}

void updateCurrentGroupName(String groupName) {
  globalState.container
      .read(proxiesActionProvider.notifier)
      .updateCurrentGroupName(groupName);
}

void updateCurrentUnfoldSet(Set<String> value) {
  globalState.container
      .read(proxiesActionProvider.notifier)
      .updateCurrentUnfoldSet(value);
}

Future<void> proxyDelayTest(Proxy proxy, [String? testUrl]) async {
  final ref = globalState.container;
  final groups = getGroups();
  final selectedMap = ref.read(
    currentProfileProvider.select((state) => state?.selectedMap ?? {}),
  );
  final state = computeRealSelectedProxyState(
    proxy.name,
    groups: groups,
    selectedMap: selectedMap,
  );
  final currentTestUrl = state.testUrl.takeFirstValid([
    ref.read(realTestUrlProvider(testUrl)),
  ]);
  if (state.proxyName.isEmpty) {
    return;
  }
  ref
      .read(proxiesActionProvider.notifier)
      .setDelay(Delay(url: currentTestUrl, name: state.proxyName, value: 0));
  ref
      .read(proxiesActionProvider.notifier)
      .setDelay(await coreController.getDelay(currentTestUrl, state.proxyName));
}

/// 整组延迟测试嘅并发上限。
///
/// 点解要限:原本 `batch(100)` 等于一次过掟 100 条落 Core。超出 Core 自己嘅
/// 并发处理能力嗰批会喺入面排队,排到嘅时候已经食晒 5 秒 timeout ⇒ 明明活嘅节点
/// 报「超时/红」。Sam 2026-09-08 实测:52 条节点一次过测,大量报死;改逐条顺序测
/// 之后只有 6 条係真死。上游 chen08209 亦独立撞到同一个坑(commit 7fb4f4f,
/// 佢哋 cap 喺 50 —— 但我哋实测 52 已经出事,所以要更保守)。
///
/// 同一个根因喺 `voguesly_detection.dart` 嘅 `_pingBounded` 已经写过:
/// 并发暴发会令个别探针嘅暖连接建唔起、量到冷握手(虚高≈4×RTT)。
///
/// 12 = 准确度同总时长嘅折衷:52 条约 5 轮,每条结果一完成即刻回填 UI(唔係等
/// 成批先刷),所以用户见到嘅係逐个亮起,唔会觉得卡住。
const _kDelayTestConcurrency = 12;

Future<void> delayTest(List<Proxy> proxies, [String? testUrl]) async {
  final list = List<Proxy>.of(proxies);
  var index = 0;

  Future<void> worker() async {
    while (true) {
      final i = index++;
      if (i >= list.length) return;
      await proxyDelayTest(list[i], testUrl);
    }
  }

  final workerCount =
      list.length < _kDelayTestConcurrency ? list.length : _kDelayTestConcurrency;
  await Future.wait([for (var w = 0; w < workerCount; w++) worker()]);
  globalState.container.read(sortNumProvider.notifier).add();
}

double getScrollToSelectedOffset({
  required String groupName,
  required List<Proxy> proxies,
}) {
  final ref = globalState.container;
  final columns = ref.read(proxiesColumnsProvider);
  final proxyCardType = ref.read(
    proxiesStyleSettingProvider.select((state) => state.cardType),
  );
  final selectedProxyName = ref.read(selectedProxyNameProvider(groupName));
  final findSelectedIndex = proxies.indexWhere(
    (proxy) => proxy.name == selectedProxyName,
  );
  final selectedIndex = findSelectedIndex != -1 ? findSelectedIndex : 0;
  final rows = (selectedIndex / columns).floor();
  return rows * getItemHeight(proxyCardType) + (rows - 1) * 8;
}
