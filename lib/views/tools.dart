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

import '../voguesly/voguesly_auth.dart';
import '../voguesly/voguesly_avatar.dart';
import '../voguesly/voguesly_cs.dart';
import '../voguesly/voguesly_invite.dart';
import '../voguesly/voguesly_notice.dart';
import '../voguesly/voguesly_shop.dart';
import '../voguesly/voguesly_stat.dart';
import '../voguesly/voguesly_subscription.dart';
import '../voguesly/voguesly_tickets.dart';
import '../voguesly/voguesly_user_center.dart';
import 'profiles/profiles.dart';
import 'config/advanced.dart';
import 'dashboard/widgets/outbound_mode.dart' show showGlobalModeNoticeIfNeeded;
import 'developer.dart';
import 'logs.dart';
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
        const _VersionItem(),
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
      const _QuickActions(),
      const _AccountServices(),
      const _FeedbackItem(),
      const _MyTicketsItem(),
      const _LogsViewItem(),
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

/// 版本号展示 + 点击手动检查更新(唔理「不再提示」开关,一定检查+一定俾结果,
/// 含「已是最新版」个案)。数据源见 [[vogueslyVersionCheckUrl]] 自家域名,唔再打上游 GitHub。
class _VersionItem extends ConsumerStatefulWidget {
  const _VersionItem();

  @override
  ConsumerState<_VersionItem> createState() => _VersionItemState();
}

class _VersionItemState extends ConsumerState<_VersionItem> {
  bool _checking = false;

  Future<void> _check() async {
    if (_checking) return;
    setState(() => _checking = true);
    await ref.read(commonActionProvider.notifier).manualCheckUpdate();
    if (!mounted) return;
    setState(() => _checking = false);
  }

  @override
  Widget build(BuildContext context) {
    final pkg = globalState.packageInfo;
    return ListItem(
      leading: const Icon(Icons.system_update_outlined),
      title: const Text('版本'),
      subtitle: Text('v${pkg.version} · 点击检查更新'),
      trailing: _checking
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : null,
      onTap: _check,
    );
  }
}

/// 顶部「购买/续费 + 联系客服」并排大按钮(显眼)。
/// ⚠️ 全部原生:购买续费开原生商城(webview 唔共享登录会弹登录页);联系客服开自建 AI 客服浮窗。
class _QuickActions extends ConsumerWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      child: Row(
        children: [
          Expanded(
            child: _QuickActionCard(
              icon: Icons.shopping_bag_outlined,
              label: '购买 / 续费',
              onTap: () => VogueslyShopPage.open(context),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _QuickActionCard(
              icon: Icons.support_agent,
              label: '联系客服',
              onTap: () => VogueslyCsPanel.open(context),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    return Material(
      color: cs.surfaceContainerHighest.withValues(alpha: 0.4),
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Icon(icon, color: cs.primary, size: 26),
              const SizedBox(height: 8),
              Text(
                label,
                style: context.textTheme.bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
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
    // ⚠️ 三态判:direct=裸奔(会显绿但流量唔走节点),唔可以当「智能分流(推荐)」谎报。
    final (subtitle, warn) = switch (mode) {
      // 全局 = 唔再自动分流,IP 跟手选线路走(选机房就显示机房 IP),要讲明白。
      Mode.global => ('全局加速 · 全部走所选线路，IP 跟该线路', false),
      Mode.direct => ('⚠️ 直连模式 · 未加速,流量未走节点(不安全)', true),
      _ => ('智能分流 · AI/银行走住宅，国内直连（推荐）', false),
    };
    return ListItem(
      leading: Icon(Icons.tune, color: warn ? const Color(0xFFEF4444) : null),
      title: const Text('加速模式'),
      subtitle: Text(
        subtitle,
        style: warn
            ? const TextStyle(color: Color(0xFFEF4444))
            : null,
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
              isThreeLine: true,
              leading: Icon(Icons.alt_route, color: cs.primary),
              title: const Text('智能分流（推荐）'),
              subtitle: const Text(
                'AI、银行、支付自动走美国住宅 IP；国内网站直连更快，'
                '看片下载走机房省住宅流量。IP 检测会显示住宅 IP。',
              ),
              trailing: !isGlobal ? Icon(Icons.check, color: cs.primary) : null,
              onTap: () {
                ref.read(setupActionProvider.notifier).changeMode(Mode.rule);
                Navigator.of(ctx).pop();
              },
            ),
            ListTile(
              isThreeLine: true,
              leading: Icon(Icons.public, color: cs.primary),
              title: const Text('全局加速'),
              // ⚠️ 呢句係重点:全局会覆盖智能分流,IP 检测站会显示你手选嗰条线路。
              // 用户选咗机房线路再去测 IP,会以为「买咗住宅 IP 但显示机房」= 产品信任伤害。
              subtitle: const Text(
                '所有流量都走你选的那一条线路，不再自动分流。'
                '若选了机房线路，IP 检测会显示机房 IP；'
                '需要住宅 IP 请在「线路」选住宅节点，或用智能分流。',
              ),
              trailing: isGlobal ? Icon(Icons.check, color: cs.primary) : null,
              onTap: () {
                ref.read(setupActionProvider.notifier).changeMode(Mode.global);
                Navigator.of(ctx).pop();
                // 同仪表盘嗰个切换入口一致:rule → global 弹一次说明。
                showGlobalModeNoticeIfNeeded(
                  context,
                  isGlobal ? Mode.global : Mode.rule,
                  Mode.global,
                );
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

/// 全局可调:打开「反馈问题 / 上传日志」表单(设置页 + 在线客服「上传诊断日志」共用)。
void showVogueslyFeedbackSheet(BuildContext context) {
  showSheet(
    context: context,
    builder: (_) => const AdaptiveSheetScaffold(
      body: _FeedbackBody(),
      title: '反馈问题 / 上传日志',
    ),
  );
}

/// 「反馈问题 / 上传日志」—— 一键把描述 + 设备/版本 + 近期日志发俾客服(建工单)。
/// 客服喺面板见到工单 + Telegram 通知,凭用户 ID 快速定位问题。
/// 账号服务区(手机「我的」页):用户中心/邀请/公告/流量明细。
/// 桌面靠侧栏 ContentOverlay 入呢啲功能,手机无侧栏,喺度用全页 push 补齐入口。
class _AccountServices extends StatelessWidget {
  const _AccountServices();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListItem(
          leading: const Icon(Icons.account_circle_outlined),
          title: const Text('用户中心'),
          subtitle: const Text('余额、订单、重置订阅、修改密码'),
          onTap: () => VogueslyUserCenterPage.open(context),
        ),
        ListItem(
          leading: const Icon(Icons.card_giftcard_outlined),
          title: const Text('邀请返利'),
          subtitle: const Text('邀请好友、查看佣金、提现'),
          onTap: () => VogueslyInvitePage.open(context),
        ),
        ListItem(
          leading: const Icon(Icons.campaign_outlined),
          title: const Text('公告中心'),
          subtitle: const Text('最新公告与维护通知'),
          onTap: () => VogueslyNoticePage.open(context),
        ),
        ListItem(
          leading: const Icon(Icons.bar_chart_outlined),
          title: const Text('流量明细'),
          subtitle: const Text('逐日流量使用记录'),
          onTap: () => VogueslyStatPage.open(context),
        ),
      ],
    );
  }
}

class _FeedbackItem extends StatelessWidget {
  const _FeedbackItem();

  @override
  Widget build(BuildContext context) {
    return ListItem(
      leading: const Icon(Icons.feedback_outlined),
      title: const Text('反馈问题 / 上传日志'),
      subtitle: const Text('一键把日志发给客服，帮你快速定位'),
      onTap: () => showVogueslyFeedbackSheet(context),
    );
  }
}

/// 2026-07-27 补:提交完反馈之后用户睇唔到客服有冇回、亦冇得跟进,唯有再开多张工单。
/// 呢度补返「我的工单」——列表 / 详情 / 继续回复 / 关闭,全部行 XBoard 现成 API。
class _MyTicketsItem extends StatelessWidget {
  const _MyTicketsItem();

  @override
  Widget build(BuildContext context) {
    return ListItem(
      leading: const Icon(Icons.confirmation_number_outlined),
      title: const Text('我的工单'),
      subtitle: const Text('查看客服回复、继续跟进'),
      onTap: () => VogueslyTicketsPage.open(context),
    );
  }
}

/// 2026-07-27 补:上面「反馈问题/上传日志」只能上传,冇地方睇——LogsView 一直存在
/// 但成个 app 冇任何入口跳过去(孤儿页)。呢度补返个一级入口,等用户/客服自己都睇到实时日志。
class _LogsViewItem extends StatelessWidget {
  const _LogsViewItem();

  @override
  Widget build(BuildContext context) {
    return const ListItem.open(
      leading: Icon(Icons.article_outlined),
      title: Text('查看日志'),
      subtitle: Text('实时连接日志，排查问题用'),
      delegate: OpenDelegate(widget: LogsView()),
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

  // <1GB 显 MB(免得剩余 400MB 被 toStringAsFixed(0) 显成「0 GB」误导用户以为耗尽)。
  String _gb(int b) {
    if (b < 1073741824) return '${(b / 1048576).toStringAsFixed(0)} MB';
    return '${(b / 1073741824).toStringAsFixed(1)} GB';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(vogueslyAuthProvider.select((s) => s.user));
    // ⚠️ 已登录但套餐未回填(China→HK 瞬断 → refreshUser 吞异常 user=null)时,
    // 唔可以显示「未登录」误导付费用户。用真登录态区分。
    final loggedIn =
        ref.watch(vogueslyAuthProvider.select((s) => s.isLoggedIn));
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
                  user?.email ??
                      (loggedIn ? '账号已登录 · 套餐加载中…' : context.appLocalizations.vogNotLoggedIn),
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
            // 套餐并发上限:之前完全冇显示,用户撞到「连接数超限」只见到笼统网络错误,
            // 唔知自己套餐限几多台、亦唔知旧客户端仲霸住 session。(0/null = 不限)
            if ((user.deviceLimit ?? 0) > 0) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.devices_outlined,
                      size: 14, color: cs.onSurfaceVariant),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      '套餐可同时连接 ${user.deviceLimit} 台设备；'
                      '若提示连接超限，先完全退出其他客户端再重连',
                      style: context.textTheme.bodySmall
                          ?.copyWith(color: cs.onSurfaceVariant),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ],
      ),
    );
  }
}

/// 一级「我的订阅」大卡(一层化):内联「更新订阅」按钮直接拉最新节点,
/// 唔使再入子页先撳 sync;次级「管理订阅」链接先入 ProfilesView 做进阶管理。
class _SubscriptionEntry extends ConsumerWidget {
  const _SubscriptionEntry();

  // 上次更新时间:今日显「今天 HH:mm」,否则「MM-dd HH:mm」;从未更新显占位。
  String _lastUpdate(BuildContext context, DateTime? d) {
    if (d == null) return '点下方按钮拉取最新节点';
    final now = DateTime.now();
    final sameDay = d.year == now.year && d.month == now.month && d.day == now.day;
    final t = DateFormat('HH:mm').format(d);
    return sameDay ? '上次更新 · 今天 $t' : '上次更新 · ${DateFormat('MM-dd').format(d)} $t';
  }

  Future<void> _refresh(BuildContext context, WidgetRef ref, Profile profile) async {
    final ok = await ref
        .read(profilesActionProvider.notifier)
        .refreshVogueslyProfile(profile, showLoading: true);
    if (!context.mounted) return;
    globalState.showNotifier(ok ? '订阅已更新' : '更新失败,请稍后重试');
  }

  void _openManage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => CommonScaffoldBackActionProvider(
          backAction: () => Navigator.of(ctx).pop(),
          child: const ProfilesView(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = context.colorScheme;
    // 当前账号订阅 profile(揾唔到就用 null → 引导先入管理页导入)。
    final profiles = ref.watch(profilesProvider);
    final vog = profiles.where(isVogueslyProfile);
    final profile = vog.isEmpty ? null : vog.first;
    final updating = profile == null
        ? false
        : ref.watch(isUpdatingProvider(profile.updatingKey));
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      child: Container(
        decoration: BoxDecoration(
          color: cs.primaryContainer.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
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
                        profile == null
                            ? '未导入订阅 · 进入管理页导入'
                            : _lastUpdate(context, profile.lastUpdateDate),
                        style: context.textTheme.bodySmall
                            ?.copyWith(color: cs.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: (profile == null || updating)
                        ? null
                        : () => _refresh(context, ref, profile),
                    icon: updating
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.refresh_rounded, size: 20),
                    label: Text(updating ? '更新中…' : '更新订阅'),
                  ),
                ),
                const SizedBox(width: 10),
                OutlinedButton(
                  onPressed: () => _openManage(context),
                  child: const Text('管理订阅'),
                ),
              ],
            ),
          ],
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
