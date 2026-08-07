import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../voguesly/voguesly_auth.dart';
import '../../../voguesly/voguesly_avatar.dart';
import '../../../voguesly/voguesly_overlay.dart';
import '../../../voguesly/voguesly_shop.dart';
import '../../../voguesly/voguesly_user_center.dart';

/// 仪表盘「易聯 账号」大卡：可选头像 + 用户名(email) + 剩余/总流量(进度条) + 到期 + 已用。
/// 数据来自 vogueslyAuthProvider(登录后 getUserInfo 缓存)，头像来自 vogueslyAvatarProvider。
class VogueslyAccount extends StatelessWidget {
  const VogueslyAccount({super.key});

  // <1GB 显 MB(免费测试 500MB 用户唔会见到「0.49 GB」咁掉价);≥1GB 显 1 位小数 GB。
  String _gb(int bytes) {
    if (bytes < 1073741824) {
      return '${(bytes / 1048576).toStringAsFixed(0)} MB';
    }
    return '${(bytes / 1073741824).toStringAsFixed(1)} GB';
  }

  // 明确标签「当前套餐: Plus · 到期: …」;无套餐名则唔加个标签。
  String _planPrefix(String? name) =>
      (name == null || name.isEmpty) ? '' : currentAppLocalizations.vgCurrentPlanPrefixWith(name);

  String _expiry(int? expiredAt, String permanent) {
    if (expiredAt == null || expiredAt == 0) return permanent;
    final d = DateTime.fromMillisecondsSinceEpoch(expiredAt * 1000);
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-'
        '${d.day.toString().padLeft(2, '0')}';
  }

  void _showAvatarPicker(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  ctx.appLocalizations.vogChooseAvatar,
                  style: ctx.textTheme.titleMedium,
                ),
              ),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: vogueslyAvatars.map((id) {
                  return GestureDetector(
                    onTap: () {
                      ref.read(vogueslyAvatarProvider.notifier).select(id);
                      Navigator.of(ctx).pop();
                    },
                    child: ClipOval(
                      child: SvgPicture.asset(
                        vogueslyAvatarAsset(id),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final subColor = context.colorScheme.onSurfaceVariant.opacity80;
    return SizedBox(
      height: getWidgetHeight(2),
      child: RepaintBoundary(
        child: CommonCard(
          // 轻触账号卡 → 「用户中心」(账号中枢:余额/套餐/订单/邀请/重置订阅/改密码)。
          // 桌面用半框 overlay;手机无 overlay 宿主,改用全页 push。
          onPressed: () {
            final w = MediaQuery.maybeOf(context)?.size.width ?? 0;
            if (w > 0 && w < 640) {
              VogueslyUserCenterPage.open(context);
            } else {
              ProviderScope.containerOf(context, listen: false)
                  .read(contentOverlayProvider.notifier)
                  .set(ContentOverlay.userCenter);
            }
          },
          child: Consumer(
            builder: (_, ref, _) {
              final user = ref.watch(
                vogueslyAuthProvider.select((s) => s.user),
              );
              // 登录态(经登录门后基本恒 true);user==null 时区分「载入中」vs「未登录」。
              final loggedIn = ref.watch(
                vogueslyAuthProvider.select((s) => s.isLoggedIn),
              );
              final avatar = ref.watch(vogueslyAvatarProvider);
              final l = context.appLocalizations;
              // 套餐到期 / 流量耗尽:红色警示,免「假连接」用户唔知自己冇得用。
              const warnColor = Color(0xFFEF4444);
              final nowMs = DateTime.now().millisecondsSinceEpoch;
              final expired = user?.expiredAt != null &&
                  user!.expiredAt! > 0 &&
                  user.expiredAt! * 1000 < nowMs;
              final exhausted = user != null &&
                  user.transferEnable > 0 &&
                  user.remain <= 0;
              final warn = expired || exhausted;
              return Padding(
                padding: baseInfoEdgeInsets,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => _showAvatarPicker(context, ref),
                          child: SizedBox(
                            width: 40,
                            height: 40,
                            child: ClipOval(
                              child: SvgPicture.asset(
                                vogueslyAvatarAsset(avatar),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                user?.email ??
                                    (loggedIn ? currentAppLocalizations.vgLoadingAccount : l.vogMyAccount),
                                overflow: TextOverflow.ellipsis,
                                style: context.textTheme.titleSmall,
                              ),
              Text(
                                user == null
                                    ? '${l.vogExpiry}: ${loggedIn ? currentAppLocalizations.vgLoadingEllipsis : '—'}'
                                    : expired
                                        ? currentAppLocalizations.vgExpiredSuffix(_planPrefix(user.planName))
                                        : '${_planPrefix(user.planName)}${l.vogExpiry}: ${_expiry(user.expiredAt, l.vogPermanent)}',
                                overflow: TextOverflow.ellipsis,
                                style: context.textTheme.bodySmall?.copyWith(
                                  color: expired ? warnColor : subColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (user != null) ...[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Flexible(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                _gb(user.remain),
                                maxLines: 1,
                                style: context.textTheme.headlineSmall?.copyWith(
                                  color: warn
                                      ? warnColor
                                      : context.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 3),
                            child: Text(
                              expired
                                  ? currentAppLocalizations.vgExpiredRenew
                                  : exhausted
                                      ? currentAppLocalizations.vgDataExhaustedRenew
                                      : '${l.vogRemainTotal} ${_gb(user.transferEnable)}',
                              style: context.textTheme.bodySmall?.copyWith(
                                color: warn ? warnColor : subColor,
                              ),
                            ),
                          ),
                          const Spacer(),
                          // 移落呢行(唔再喺账号名嗰行同「当前套餐:xxx·到期:xxx」争横向空间——
                          // 之前挤埋一行会令长套餐名+到期日被 ellipsis 切晒,睇唔到完整到期日)。
                          Material(
                            color: warn
                                ? warnColor.withValues(alpha: 0.12)
                                : context.colorScheme.primary
                                    .withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20),
                            clipBehavior: Clip.antiAlias,
                            child: InkWell(
                              // 原生商城(webview 唔共享登录会弹登录页;照 Ninja 全原生)。
                              onTap: () => VogueslyShopPage.open(context),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                child: Text(
                                  currentAppLocalizations.vgBuyRenewShort,
                                  style: context.textTheme.labelSmall?.copyWith(
                                    color: warn
                                        ? warnColor
                                        : context.colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: user.remainRatio,
                          minHeight: 6,
                          backgroundColor:
                              context.colorScheme.surfaceContainerHighest,
                          color:
                              warn ? warnColor : context.colorScheme.primary,
                        ),
                      ),
                    ] else
                      Text(
                        loggedIn ? currentAppLocalizations.vgLoadingPlan : l.vogNotLoggedIn,
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: subColor,
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
