import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/views/profiles/profiles.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../voguesly/voguesly_auth.dart';
import '../../../voguesly/voguesly_avatar.dart';

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
      (name == null || name.isEmpty) ? '' : '当前套餐: $name · ';

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
          // 轻触账号卡 → 打开「我的订阅」页。
          // ⚠️ 唔可以用 currentPageLabelProvider.toProfiles():订阅页唔喺消费者版 3-tab
          // 导航入面,切咗 label 都冇页面 render(之前就係咁「跳唔郁」)。直接 push 页面。
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => CommonScaffoldBackActionProvider(
                  backAction: () => Navigator.of(ctx).pop(),
                  child: const ProfilesView(),
                ),
              ),
            );
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
                                    (loggedIn ? '正在载入账号…' : l.vogMyAccount),
                                overflow: TextOverflow.ellipsis,
                                style: context.textTheme.titleSmall,
                              ),
              Text(
                                user == null
                                    ? '${l.vogExpiry}: ${loggedIn ? '载入中…' : '—'}'
                                    : expired
                                        ? '${_planPrefix(user.planName)}已过期'
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
                            child: Text(
                              _gb(user.remain),
                              overflow: TextOverflow.ellipsis,
                              style: context.textTheme.headlineSmall?.copyWith(
                                color: warn
                                    ? warnColor
                                    : context.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 3),
                            child: Text(
                              expired
                                  ? '已过期 · 请续费'
                                  : exhausted
                                      ? '流量已用尽 · 请续费'
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
                              onTap: () => launchUrl(
                                Uri.parse('https://cp.samseah.qzz.io/#/shop'),
                                mode: LaunchMode.externalApplication,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                child: Text(
                                  '购买/续费',
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
                        loggedIn ? '正在载入套餐…' : l.vogNotLoggedIn,
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
