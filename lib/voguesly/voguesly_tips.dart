import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 新手 TIP(2026-09-18 Sam):
/// ① 第一次进入:大圆圈上方一个气泡「点一下圆圈就能连上,其他不用管」(见 connect_button.dart);
/// ② 第一次连上之后:弹一次「小贴士」讲清楚 购买套餐 / 在线客服 / 更新订阅 喺边度。
/// 全部只出一次,flag 落 SharedPreferences。
const String kVogueslyTipConnectSeen = 'vg_tip_connect_seen_v1';
const String kVogueslyTipFeaturesSeen = 'vg_tip_features_seen_v1';

Future<bool> vogueslyTipSeen(String key) async {
  try {
    final p = await SharedPreferences.getInstance();
    return p.getBool(key) ?? false;
  } catch (_) {
    return true; // 读唔到就当睇过,唔好反复弹
  }
}

Future<void> markVogueslyTipSeen(String key) async {
  try {
    final p = await SharedPreferences.getInstance();
    await p.setBool(key, true);
  } catch (_) {}
}

/// 第一次连上之后弹一次「小贴士」;已弹过直接返回。
Future<void> maybeShowVogueslyFeatureTips(BuildContext context) async {
  if (await vogueslyTipSeen(kVogueslyTipFeaturesSeen)) return;
  await markVogueslyTipSeen(kVogueslyTipFeaturesSeen);
  if (!context.mounted) return;
  await showSheet(
    context: context,
    builder: (_) => AdaptiveSheetScaffold(
      title: currentAppLocalizations.vgTipsTitle,
      body: const _FeatureTipsBody(),
    ),
  );
}

class _FeatureTipsBody extends StatelessWidget {
  const _FeatureTipsBody();

  @override
  Widget build(BuildContext context) {
    final l = currentAppLocalizations;
    final desktop = system.isDesktop;
    final rows = <(IconData, String)>[
      (Icons.storefront, desktop ? l.vgTipShopDesktop : l.vgTipShopMobile),
      (Icons.support_agent, desktop ? l.vgTipSupportDesktop : l.vgTipSupportMobile),
      (Icons.cloud_sync_outlined, desktop ? l.vgTipUpdateSubDesktop : l.vgTipUpdateSubMobile),
    ];
    final cs = context.colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (icon, text) in rows)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: cs.primaryContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, size: 20, color: cs.onPrimaryContainer),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 7),
                      child: Text(text, style: context.textTheme.bodyMedium),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () => Navigator.of(context).maybePop(),
            child: Text(l.vgGotIt),
          ),
        ],
      ),
    );
  }
}

/// 大圆圈上方嘅首次提示气泡。
class VogueslyConnectTipBubble extends StatelessWidget {
  const VogueslyConnectTipBubble({super.key, required this.onDismiss});

  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 10, 8, 10),
        decoration: BoxDecoration(
          color: cs.primaryContainer,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(Icons.lightbulb_outline, size: 18, color: cs.onPrimaryContainer),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                currentAppLocalizations.vgTipConnectFirst,
                style: context.textTheme.bodySmall?.copyWith(
                  color: cs.onPrimaryContainer,
                  height: 1.35,
                ),
              ),
            ),
            TextButton(
              onPressed: onDismiss,
              style: TextButton.styleFrom(
                visualDensity: VisualDensity.compact,
                foregroundColor: cs.onPrimaryContainer,
              ),
              child: Text(currentAppLocalizations.vgGotIt),
            ),
          ],
        ),
      ),
    );
  }
}
