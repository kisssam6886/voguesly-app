import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/views/proxies/common.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProxyCard extends StatelessWidget {
  final String groupName;
  final Proxy proxy;
  final GroupType groupType;
  final ProxyCardType type;
  final String? testUrl;

  const ProxyCard({
    super.key,
    required this.groupName,
    required this.testUrl,
    required this.proxy,
    required this.groupType,
    required this.type,
  });

  Measure get measure => globalState.measure;

  void _handleTestCurrentDelay() {
    proxyDelayTest(proxy, testUrl);
  }

  /// 「套餐信息」组嗰啲 ━━━ / 剩余流量 / 套餐到期 / 官网 等係信息横幅,唔係真节点。
  /// 唔应该当真节点(可点选 + 测速显 Timeout + 标 Vless)。
  static bool _isInfoBanner(String name) {
    return name.contains('━') ||
        name.contains('剩余流量') ||
        name.contains('套餐') ||
        name.contains('到期') ||
        name.contains('官网') ||
        name.contains('客服') ||
        name.contains('邀请码') ||
        name.contains('打不开');
  }

  /// 信息横幅:纯文字,唔可点、无测速、无协议标签。
  Widget _buildInfoBanner(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Text(
        proxy.name.replaceAll('━', '').trim(),
        maxLines: 2,
        textAlign: TextAlign.center,
        style: context.textTheme.labelSmall?.copyWith(
          color: context.colorScheme.onSurfaceVariant.opacity80,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _buildDelayText() {
    return SizedBox(
      height: measure.labelSmallHeight,
      child: Consumer(
        builder: (context, ref, _) {
          final delay = ref.watch(
            delayProvider(proxyName: proxy.name, testUrl: testUrl),
          );
          return FadeThroughBox(
            alignment: type == ProxyCardType.expand
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: delay == 0 || delay == null
                ? SizedBox(
                    height: measure.labelSmallHeight,
                    width: measure.labelSmallHeight,
                    child: delay == 0
                        ? const CircularProgressIndicator(strokeWidth: 2)
                        : IconButton(
                            icon: const Icon(Icons.bolt),
                            iconSize: globalState.measure.labelSmallHeight,
                            padding: EdgeInsets.zero,
                            onPressed: _handleTestCurrentDelay,
                          ),
                  )
                : GestureDetector(
                    onTap: _handleTestCurrentDelay,
                    child: Text(
                      delay > 0 ? '$delay ms' : '超时',
                      style: context.textTheme.labelSmall?.copyWith(
                        overflow: TextOverflow.ellipsis,
                        color: utils.getDelayColor(delay),
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }

  /// 从节点名推地区旗(只对明确含地区词嘅真节点;信息横幅/decoy 唔 match 唔加)。
  static String _regionFlag(String name) {
    bool has(List<String> kws) => kws.any((k) => name.contains(k));
    if (has(['香港', '香港', 'HK', 'Hong'])) return '🇭🇰';
    if (has(['新加坡', '狮城', '獅城', 'Singapore', 'SG'])) return '🇸🇬';
    if (has(['日本', '東京', '东京', 'Japan', 'JP'])) return '🇯🇵';
    if (has(['韩国', '韓國', '首尔', 'Korea', 'KR'])) return '🇰🇷';
    if (has(['荷兰', '荷蘭', 'Netherlands', 'NL'])) return '🇳🇱';
    if (has(['英国', '英國', 'UK', 'London', 'GB'])) return '🇬🇧';
    if (has(['德国', '德國', 'Germany', 'DE'])) return '🇩🇪';
    if (has(['台湾', '台灣', 'Taiwan', 'TW'])) return '🇨🇳';
    if (has(['美国', '美國', 'US', 'United States'])) return '🇺🇸';
    return '';
  }

  String _displayName() {
    final flag = _regionFlag(proxy.name);
    return flag.isEmpty ? proxy.name : '$flag ${proxy.name}';
  }

  Widget _buildProxyNameText(BuildContext context) {
    final name = _displayName();
    if (type == ProxyCardType.min) {
      return SizedBox(
        height: measure.bodyMediumHeight * 1,
        child: EmojiText(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.textTheme.bodyMedium,
        ),
      );
    } else {
      return SizedBox(
        height: measure.bodyMediumHeight * 2,
        child: EmojiText(
          name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: context.textTheme.bodyMedium,
        ),
      );
    }
  }

  Future<void> _changeProxy(WidgetRef ref) async {
    final isComputedSelected = groupType.isComputedSelected;
    final isSelector = groupType == GroupType.Selector;
    final ref = globalState.container;
    if (isComputedSelected || isSelector) {
      final currentProxyName = ref.read(proxyNameProvider(groupName));
      final nextProxyName = switch (isComputedSelected) {
        true => currentProxyName == proxy.name ? '' : proxy.name,
        false => proxy.name,
      };
      ref
          .read(profilesActionProvider.notifier)
          .updateCurrentSelectedMap(groupName, nextProxyName);
      ref
          .read(proxiesActionProvider.notifier)
          .changeProxyDebounce(groupName, nextProxyName);
      return;
    }
    globalState.showNotifier(currentAppLocalizations.notSelectedTip);
  }

  @override
  Widget build(BuildContext context) {
    // 信息横幅(套餐/剩余流量/官网…)渲染成纯文字,唔当真节点。
    if (_isInfoBanner(proxy.name)) {
      return _buildInfoBanner(context);
    }
    final measure = globalState.measure;
    final delayText = _buildDelayText();
    final proxyNameText = _buildProxyNameText(context);
    return Stack(
      children: [
        Consumer(
          builder: (_, ref, child) {
            final selectedProxyName = ref.watch(
              selectedProxyNameProvider(groupName),
            );
            return CommonCard(
              key: key,
              onPressed: () {
                _changeProxy(ref);
              },
              isSelected: selectedProxyName == proxy.name,
              child: child!,
            );
          },
          child: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                proxyNameText,
                const SizedBox(height: 8),
                if (type == ProxyCardType.expand) ...[
                  SizedBox(
                    height: measure.bodySmallHeight,
                    child: _ProxyDesc(proxy: proxy),
                  ),
                  const SizedBox(height: 6),
                  delayText,
                ] else
                  SizedBox(
                    height: measure.bodySmallHeight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          flex: 1,
                          child: TooltipText(
                            text: Text(
                              _ProxyDesc._protocols.contains(
                                      proxy.type.toLowerCase())
                                  ? ''
                                  : proxy.type,
                              style: context.textTheme.bodySmall?.copyWith(
                                overflow: TextOverflow.ellipsis,
                                color: context
                                    .textTheme
                                    .bodySmall
                                    ?.color
                                    ?.opacity80,
                              ),
                            ),
                          ),
                        ),
                        delayText,
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (groupType.isComputedSelected)
          Positioned(
            top: 0,
            right: 0,
            child: _ProxyComputedMark(groupName: groupName, proxy: proxy),
          ),
      ],
    );
  }
}

class _ProxyDesc extends ConsumerWidget {
  final Proxy proxy;

  const _ProxyDesc({required this.proxy});

  // 裸协议名对消费者係黑话,隐藏;组类型(如「URLTest(美国)」含括号)保留选中节点显示。
  static const _protocols = {
    'vless', 'trojan', 'vmess', 'ss', 'ssr', 'hysteria', 'hysteria2',
    'tuic', 'wireguard', 'http', 'socks5', 'snell', 'anytls', 'mieru',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final desc = ref.watch(proxyDescProvider(proxy));
    final shown = _protocols.contains(desc.toLowerCase()) ? '' : desc;
    return EmojiText(
      shown,
      overflow: TextOverflow.ellipsis,
      style: context.textTheme.bodySmall?.copyWith(
        color: context.textTheme.bodySmall?.color?.opacity80,
      ),
    );
  }
}

class _ProxyComputedMark extends ConsumerWidget {
  final String groupName;
  final Proxy proxy;

  const _ProxyComputedMark({required this.groupName, required this.proxy});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final proxyName = ref.watch(proxyNameProvider(groupName));
    if (proxyName != proxy.name) {
      return const SizedBox();
    }
    return Container(
      alignment: Alignment.topRight,
      margin: const EdgeInsets.all(8),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.secondaryContainer,
        ),
        child: const SelectIcon(),
      ),
    );
  }
}
