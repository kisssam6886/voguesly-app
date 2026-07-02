import 'dart:io';

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/views/about.dart';
import 'package:fl_clash/views/access.dart';
import 'package:fl_clash/views/application_setting.dart';
import 'package:fl_clash/views/backup_and_restore.dart';
import 'package:fl_clash/views/config/config.dart';
import 'package:fl_clash/views/hotkey.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' show dirname, join;
import 'package:url_launcher/url_launcher.dart';

import '../voguesly/voguesly_auth.dart';
import '../voguesly/voguesly_avatar.dart';
import '../voguesly/voguesly_subscription.dart';
import 'profiles/profiles.dart';
import 'config/advanced.dart';
import 'developer.dart';
import 'theme.dart';

class ToolsView extends ConsumerStatefulWidget {
  const ToolsView({super.key});

  @override
  ConsumerState<ToolsView> createState() => _ToolViewState();
}

class _ToolViewState extends ConsumerState<ToolsView> {
  List<Widget> _getOtherList(bool enableDeveloperMode) {
    return generateSection(
      title: context.appLocalizations.other,
      items: [
        // 移除 FlClash 免责声明项(「仅供学习交流·严禁商业」同付费产品自打脸,且点退出会强杀App)。
        if (enableDeveloperMode) const _DeveloperItem(),
        const _InfoItem(),
        const _LogoutItem(),
      ],
    );
  }

  List<Widget> _getSettingList() {
    return generateSection(
      title: context.appLocalizations.settings,
      items: [
        const _AccelModeItem(),
        const _LocaleItem(),
        const _ThemeItem(),
        const _SettingItem(),
        // 进阶项全部收埋落子页(基本配置/请求/连接/资源/备份/访问控制/进阶配置),保持简洁
        const _AdvancedItem(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm2 = ref.watch(
      appSettingProvider.select(
        (state) => VM2(state.locale, state.developerMode),
      ),
    );
    final items = [
      const _AccountHeader(),
      const _SubscriptionEntry(),
      const _BuyPlanItem(),
      const _SupportItem(),
      const _FeedbackItem(),
      ..._getSettingList(),
      // 诊断项(请求/连接/资源)收入「进阶工具」子页,「我的」一级唔再露工程化菜单。
      ..._getOtherList(vm2.b),
    ];
    return CommonScaffold(
      title: context.appLocalizations.tools,
      body: ListView.builder(
        key: toolsStoreKey,
        itemCount: items.length,
        itemBuilder: (_, index) => items[index],
        padding: const EdgeInsets.only(bottom: 20),
      ),
    );
  }
}

class _LocaleItem extends ConsumerWidget {
  const _LocaleItem();

  String _getLocaleString(BuildContext context, Locale? locale) {
    if (locale == null) return context.appLocalizations.defaultText;
    const names = {
      'zh_CN': '简体中文',
      'zh_Hant': '繁體中文',
      'en': 'English',
      'ja': '日本語',
      'ru': 'Русский',
    };
    return names[locale.toString()] ?? Intl.message(locale.toString());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(
      appSettingProvider.select((state) => state.locale),
    );
    final currentLocale = utils.getLocaleForString(locale);
    return ListItem<Locale?>.options(
      leading: const Icon(Icons.language_outlined),
      title: Text(context.appLocalizations.language),
      subtitle: Text(_getLocaleString(context, currentLocale)),
      delegate: OptionsDelegate(
        title: context.appLocalizations.language,
        options: [null, ...AppLocalizations.delegate.supportedLocales],
        onChanged: (Locale? locale) {
          ref
              .read(appSettingProvider.notifier)
              .update((state) => state.copyWith(locale: locale?.toString()));
        },
        textBuilder: (locale) => _getLocaleString(context, locale),
        value: currentLocale,
      ),
    );
  }
}

class _ThemeItem extends StatelessWidget {
  const _ThemeItem();

  @override
  Widget build(BuildContext context) {
    return ListItem.open(
      leading: const Icon(Icons.style),
      title: Text(context.appLocalizations.theme),
      subtitle: Text(context.appLocalizations.themeDesc),
      delegate: const OpenDelegate(widget: ThemeView()),
    );
  }
}

class _BackupItem extends StatelessWidget {
  const _BackupItem();

  @override
  Widget build(BuildContext context) {
    return ListItem.open(
      leading: const Icon(Icons.cloud_sync),
      title: Text(context.appLocalizations.backupAndRestore),
      subtitle: Text(context.appLocalizations.backupAndRestoreDesc),
      delegate: const OpenDelegate(widget: BackupAndRestore()),
    );
  }
}

class _HotkeyItem extends StatelessWidget {
  const _HotkeyItem();

  @override
  Widget build(BuildContext context) {
    return ListItem.open(
      leading: const Icon(Icons.keyboard),
      title: Text(context.appLocalizations.hotkeyManagement),
      subtitle: Text(context.appLocalizations.hotkeyManagementDesc),
      delegate: const OpenDelegate(widget: HotKeyView()),
    );
  }
}

class _LoopbackItem extends StatelessWidget {
  const _LoopbackItem();

  @override
  Widget build(BuildContext context) {
    return ListItem(
      leading: const Icon(Icons.lock),
      title: Text(context.appLocalizations.loopback),
      subtitle: Text(context.appLocalizations.loopbackDesc),
      onTap: () {
        windows?.runas(
          '"${join(dirname(Platform.resolvedExecutable), "EnableLoopback.exe")}"',
          '',
        );
      },
    );
  }
}

class _AccessItem extends StatelessWidget {
  const _AccessItem();

  @override
  Widget build(BuildContext context) {
    return ListItem.open(
      leading: const Icon(Icons.view_list),
      title: Text(context.appLocalizations.accessControl),
      subtitle: Text(context.appLocalizations.accessControlDesc),
      delegate: const OpenDelegate(widget: AccessView()),
    );
  }
}

class _ConfigItem extends StatelessWidget {
  const _ConfigItem();

  @override
  Widget build(BuildContext context) {
    return ListItem.open(
      leading: const Icon(Icons.edit),
      title: Text(context.appLocalizations.basicConfig),
      subtitle: Text(context.appLocalizations.basicConfigDesc),
      delegate: const OpenDelegate(widget: ConfigView()),
    );
  }
}

class _AdvancedConfigItem extends StatelessWidget {
  const _AdvancedConfigItem();

  @override
  Widget build(BuildContext context) {
    return ListItem.open(
      leading: const Icon(Icons.build),
      title: Text(context.appLocalizations.advancedConfig),
      subtitle: Text(context.appLocalizations.advancedConfigDesc),
      delegate: const OpenDelegate(widget: AdvancedConfigView()),
    );
  }
}

/// 进阶入口:把唔常用嘅项(备份/访问控制/进阶配置/快捷键/loopback)收埋落子页,保持工具页简洁。
class _AdvancedItem extends StatelessWidget {
  const _AdvancedItem();

  @override
  Widget build(BuildContext context) {
    return ListItem.open(
      leading: const Icon(Icons.tune),
      title: Text(context.appLocalizations.advancedTools),
      delegate: const OpenDelegate(widget: _AdvancedToolsView()),
    );
  }
}

class _AdvancedToolsView extends ConsumerWidget {
  const _AdvancedToolsView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 诊断项(请求/连接/资源)由「我的」一级收落嚟呢度,普通用户唔会见到工程化菜单。
    final diagnostics =
        ref.watch(moreToolsSelectorStateProvider).navigationItems;
    final items = <Widget>[
      const _ConfigItem(),
      const _BackupItem(),
      if (system.isDesktop) const _HotkeyItem(),
      if (system.isWindows) const _LoopbackItem(),
      if (system.isAndroid) const _AccessItem(),
      const _AdvancedConfigItem(),
      for (final item in diagnostics)
        ListItem.open(
          leading: item.icon,
          title: Text(Intl.message(item.label.name)),
          subtitle: item.description != null
              ? Text(Intl.message(item.description!))
              : null,
          delegate: OpenDelegate(widget: item.builder(context)),
        ),
    ];
    return BaseScaffold(
      title: context.appLocalizations.advancedTools,
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (_, index) => items[index],
        padding: const EdgeInsets.only(bottom: 20),
      ),
    );
  }
}

class _SettingItem extends StatelessWidget {
  const _SettingItem();

  @override
  Widget build(BuildContext context) {
    return ListItem.open(
      leading: const Icon(Icons.settings),
      title: Text(context.appLocalizations.application),
      subtitle: Text(context.appLocalizations.applicationDesc),
      delegate: const OpenDelegate(widget: ApplicationSettingView()),
    );
  }
}

// ignore: unused_element
class _DisclaimerItem extends ConsumerWidget {
  const _DisclaimerItem();

  @override
  Widget build(BuildContext context, ref) {
    return ListItem(
      leading: const Icon(Icons.gavel),
      title: Text(context.appLocalizations.disclaimer),
      onTap: () async {
        final isDisclaimerAccepted = await globalState.showDisclaimer();
        if (!isDisclaimerAccepted) {
          await ref.read(systemActionProvider.notifier).handleExit();
        }
      },
    );
  }
}

class _InfoItem extends StatelessWidget {
  const _InfoItem();

  @override
  Widget build(BuildContext context) {
    return ListItem.open(
      leading: const Icon(Icons.info),
      title: Text(context.appLocalizations.about),
      delegate: const OpenDelegate(widget: AboutView()),
    );
  }
}

/// 一级「联系客服」入口(原本只埋喺关于页底,求助无门)。直接开 Telegram 即时支援。
class _SupportItem extends StatelessWidget {
  const _SupportItem();

  @override
  Widget build(BuildContext context) {
    return ListItem(
      leading: const Icon(Icons.support_agent),
      title: const Text('联系客服'),
      // 自家可信链接直接开,唔弹「外部链接+裸URL」确认框。
      onTap: () => launchUrl(
        Uri.parse('https://t.me/easysvpn'),
        mode: LaunchMode.externalApplication,
      ),
    );
  }
}

/// 「加速模式」消费者向二选一:智能分流(推荐) / 全局加速。
/// 刻意唔暴露 FlClash 原版「直连」(= 唔加速嘅地雷:会显绿但流量裸奔)。
class _AccelModeItem extends ConsumerWidget {
  const _AccelModeItem();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(patchClashConfigProvider.select((s) => s.mode));
    final isGlobal = mode == Mode.global;
    return ListItem(
      leading: const Icon(Icons.tune),
      title: const Text('加速模式'),
      subtitle: Text(
        isGlobal ? '全局加速 · 所有流量走节点' : '智能分流 · 国内直连，境外走节点（推荐）',
      ),
      onTap: () => _choose(context, ref, isGlobal),
    );
  }

  void _choose(BuildContext context, WidgetRef ref, bool isGlobal) {
    final cs = context.colorScheme;
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.alt_route, color: cs.primary),
              title: const Text('智能分流（推荐）'),
              subtitle:
                  const Text('国内网站直连更快，境外自动走节点，省流量'),
              trailing: !isGlobal ? Icon(Icons.check, color: cs.primary) : null,
              onTap: () {
                ref.read(setupActionProvider.notifier).changeMode(Mode.rule);
                Navigator.of(ctx).pop();
              },
            ),
            ListTile(
              leading: Icon(Icons.public, color: cs.primary),
              title: const Text('全局加速'),
              subtitle:
                  const Text('所有流量都走节点（更耗流量，国内网站可能变慢）'),
              trailing: isGlobal ? Icon(Icons.check, color: cs.primary) : null,
              onTap: () {
                ref.read(setupActionProvider.notifier).changeMode(Mode.global);
                Navigator.of(ctx).pop();
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

/// 「反馈问题 / 上传日志」—— 一键把描述 + 设备/版本 + 近期日志发俾客服(建工单)。
/// 客服喺面板见到工单 + Telegram 通知,凭用户 ID 快速定位问题。
class _FeedbackItem extends StatelessWidget {
  const _FeedbackItem();

  @override
  Widget build(BuildContext context) {
    return ListItem(
      leading: const Icon(Icons.feedback_outlined),
      title: const Text('反馈问题 / 上传日志'),
      subtitle: const Text('一键把日志发给客服，帮你快速定位'),
      onTap: () => showSheet(
        context: context,
        builder: (_) => const AdaptiveSheetScaffold(
          body: _FeedbackBody(),
          title: '反馈问题',
        ),
      ),
    );
  }
}

class _FeedbackBody extends ConsumerStatefulWidget {
  const _FeedbackBody();

  @override
  ConsumerState<_FeedbackBody> createState() => _FeedbackBodyState();
}

class _FeedbackBodyState extends ConsumerState<_FeedbackBody> {
  final _desc = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _desc.dispose();
    super.dispose();
  }

  Future<String> _collectDiagnostics() async {
    final b = StringBuffer();
    try {
      final pkg = await PackageInfo.fromPlatform();
      b.writeln('版本: ${pkg.version}+${pkg.buildNumber}');
    } catch (_) {}
    try {
      final d = await DeviceInfoPlugin().androidInfo;
      b.writeln('设备: ${d.manufacturer} ${d.model} · Android ${d.version.release}');
    } catch (_) {}
    // 近期 app 日志(尾 120 条)
    final logs = globalState.container.read(logsProvider).list;
    final tail = logs.length > 120 ? logs.sublist(logs.length - 120) : logs;
    b.writeln('--- 近期日志 ---');
    for (final l in tail) {
      b.writeln('${l.dateTime} [${l.logLevel.name}] ${l.payload}');
    }
    return b.toString();
  }

  Future<void> _submit() async {
    final token = ref.read(vogueslyAuthProvider).token;
    if (token == null) {
      globalState.showNotifier('请先登录再反馈');
      return;
    }
    setState(() => _busy = true);
    final diag = await _collectDiagnostics();
    final msg = '${_desc.text.trim()}\n\n=== 诊断信息(自动附带) ===\n$diag';
    final res = await ref.read(vogueslyApiProvider).submitFeedback(token, message: msg);
    if (!mounted) return;
    setState(() => _busy = false);
    globalState.showNotifier(res.message);
    if (res.ok) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '描述你遇到嘅问题，我哋会自动附上设备信息同近期日志帮你定位。',
            style: context.textTheme.bodyMedium
                ?.copyWith(color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _desc,
            minLines: 3,
            maxLines: 6,
            decoration: InputDecoration(
              hintText: '例如：连接后打唔开网页 / 某个节点连唔到…',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: _busy ? null : _submit,
            icon: _busy
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.send_rounded),
            label: Text(_busy ? '提交中…' : '提交给客服'),
          ),
        ],
      ),
    );
  }
}

/// 一级「购买 / 续费套餐」入口 —— 随时可入官网套餐页(登入状态下直接买/续)。
/// 用现役 panel 域名 cp.samseah.qzz.io(唔用弃用嘅 voguesly.com)。
class _BuyPlanItem extends StatelessWidget {
  const _BuyPlanItem();

  @override
  Widget build(BuildContext context) {
    return ListItem(
      leading: const Icon(Icons.shopping_bag_outlined),
      title: const Text('购买 / 续费套餐'),
      // 面板套餐页路由係 /#/shop(ez-voguesly 主题),唔係 /#/plan。直接开,唔弹确认框。
      onTap: () => launchUrl(
        Uri.parse('https://cp.samseah.qzz.io/#/shop'),
        mode: LaunchMode.externalApplication,
      ),
    );
  }
}

class _DeveloperItem extends StatelessWidget {
  const _DeveloperItem();

  @override
  Widget build(BuildContext context) {
    return ListItem.open(
      leading: const Icon(Icons.developer_board),
      title: Text(context.appLocalizations.developerMode),
      delegate: const OpenDelegate(widget: DeveloperView()),
    );
  }
}

/// 「我的」页顶账号卡:头像 + 邮箱 + 剩余/总流量。数据来自 vogueslyAuthProvider。
class _AccountHeader extends ConsumerWidget {
  const _AccountHeader();

  String _gb(int b) => '${(b / 1073741824).toStringAsFixed(0)} GB';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(vogueslyAuthProvider.select((s) => s.user));
    final avatar = ref.watch(vogueslyAvatarProvider);
    final cs = context.colorScheme;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipOval(
                child: SvgPicture.asset(
                  vogueslyAvatarAsset(avatar),
                  width: 44,
                  height: 44,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  user?.email ?? context.appLocalizations.vogNotLoggedIn,
                  style: context.textTheme.titleSmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (user != null) ...[
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _gb(user.remain),
                  style: context.textTheme.titleLarge?.copyWith(
                    color: cs.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${context.appLocalizations.vogRemainTotal} ${_gb(user.transferEnable)}',
                  style: context.textTheme.bodySmall
                      ?.copyWith(color: cs.onSurfaceVariant),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: user.remainRatio,
                minHeight: 6,
                backgroundColor: cs.surfaceContainerHighest,
                color: cs.primary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// 突出嘅「我的订阅」入口(用户常用,唔折叠)。开 ProfilesView。
class _SubscriptionEntry extends StatelessWidget {
  const _SubscriptionEntry();

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      child: Material(
        color: cs.primaryContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => CommonScaffoldBackActionProvider(
                  backAction: () => Navigator.of(ctx).pop(),
                  child: const ProfilesView(),
                ),
              ),
            );
          },
          // 一级大卡(消费者向):订阅係核心动作,做大做明显,唔好同下面设置行混埋。
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: cs.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child:
                      Icon(Icons.cloud_sync_outlined, color: cs.primary, size: 26),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '我的订阅',
                        style: context.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '更新节点 · 管理订阅',
                        style: context.textTheme.bodySmall
                            ?.copyWith(color: cs.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: cs.onSurfaceVariant),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LogoutItem extends ConsumerWidget {
  const _LogoutItem();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = context.colorScheme;
    return ListItem(
      leading: Icon(Icons.logout, color: cs.error),
      title: Text('退出登录', style: TextStyle(color: cs.error)),
      onTap: () async {
        final ok = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('退出登录'),
            content: const Text('确定退出当前账户?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(context.appLocalizations.cancel),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('退出'),
              ),
            ],
          ),
        );
        if (ok == true) {
          // 先删本账号订阅(防换账号串号),再清登录态。两条登出路径共用同一清理。
          await clearVogueslyProfiles();
          ref.read(vogueslyAuthProvider.notifier).logout();
        }
      },
    );
  }
}
