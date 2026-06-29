import 'dart:io';

import 'package:fl_clash/common/common.dart';
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
import 'package:intl/intl.dart';
import 'package:path/path.dart' show dirname, join;

import '../voguesly/voguesly_auth.dart';
import '../voguesly/voguesly_avatar.dart';
import 'config/advanced.dart';
import 'developer.dart';
import 'theme.dart';

class ToolsView extends ConsumerStatefulWidget {
  const ToolsView({super.key});

  @override
  ConsumerState<ToolsView> createState() => _ToolViewState();
}

class _ToolViewState extends ConsumerState<ToolsView> {
  Widget _buildNavigationMenuItem(NavigationItem navigationItem) {
    return ListItem.open(
      leading: navigationItem.icon,
      title: Text(Intl.message(navigationItem.label.name)),
      subtitle: navigationItem.description != null
          ? Text(Intl.message(navigationItem.description!))
          : null,
      delegate: OpenDelegate(widget: navigationItem.builder(context)),
    );
  }

  Widget _buildNavigationMenu(List<NavigationItem> navigationItems) {
    return Column(
      children: [
        for (final navigationItem in navigationItems) ...[
          _buildNavigationMenuItem(navigationItem),
          navigationItems.last != navigationItem
              ? const Divider(height: 0)
              : Container(),
        ],
      ],
    );
  }

  List<Widget> _getOtherList(bool enableDeveloperMode) {
    return generateSection(
      title: context.appLocalizations.other,
      items: [
        const _DisclaimerItem(),
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
        const _LocaleItem(),
        const _ThemeItem(),
        const _ConfigItem(),
        const _SettingItem(),
        // 进阶项收埋落子页(备份/访问控制/进阶配置/快捷键/loopback),保持主页简洁
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
      Consumer(
        builder: (_, ref, _) {
          final state = ref.watch(moreToolsSelectorStateProvider);
          if (state.navigationItems.isEmpty) {
            return Container();
          }
          return Column(
            children: [
              ListHeader(title: context.appLocalizations.more),
              _buildNavigationMenu(state.navigationItems),
            ],
          );
        },
      ),
      ..._getSettingList(),
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

class _AdvancedToolsView extends StatelessWidget {
  const _AdvancedToolsView();

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      const _BackupItem(),
      if (system.isDesktop) const _HotkeyItem(),
      if (system.isWindows) const _LoopbackItem(),
      if (system.isAndroid) const _AccessItem(),
      const _AdvancedConfigItem(),
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
          ref.read(vogueslyAuthProvider.notifier).logout();
        }
      },
    );
  }
}
