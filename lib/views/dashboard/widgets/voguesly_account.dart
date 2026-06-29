import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../voguesly/voguesly_auth.dart';
import '../../../voguesly/voguesly_avatar.dart';

/// 仪表盘「易聯 账号」大卡：可选头像 + 用户名(email) + 剩余/总流量(进度条) + 到期 + 已用。
/// 数据来自 vogueslyAuthProvider(登录后 getUserInfo 缓存)，头像来自 vogueslyAvatarProvider。
class VogueslyAccount extends StatelessWidget {
  const VogueslyAccount({super.key});

  String _gb(int bytes) => '${(bytes / 1073741824).toStringAsFixed(2)} GB';

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
          onPressed: () {},
          child: Consumer(
            builder: (_, ref, _) {
              final user = ref.watch(
                vogueslyAuthProvider.select((s) => s.user),
              );
              final avatar = ref.watch(vogueslyAvatarProvider);
              final l = context.appLocalizations;
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
                                user?.email ?? l.vogMyAccount,
                                overflow: TextOverflow.ellipsis,
                                style: context.textTheme.titleSmall,
                              ),
                              Text(
                                '${l.vogExpiry}: ${_expiry(user?.expiredAt, l.vogPermanent)}',
                                style: context.textTheme.bodySmall?.copyWith(
                                  color: subColor,
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
                                color: context.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 3),
                            child: Text(
                              '${l.vogRemainTotal} ${_gb(user.transferEnable)}',
                              style: context.textTheme.bodySmall?.copyWith(
                                color: subColor,
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
                          color: context.colorScheme.primary,
                        ),
                      ),
                    ] else
                      Text(
                        l.vogNotLoggedIn,
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
