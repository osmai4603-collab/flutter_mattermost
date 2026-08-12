import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/design_tokens.dart';
import 'package:flutter_mattermost/features/users/presentation/pages/settings_tabs.dart';

/// تبويبات إعدادات التطبيق (خاصة بسطح المكتب).
enum AppSettingTab { notifications, display, sidebar, advanced }

extension AppSettingTabLabels on AppSettingTab {
  String label(AppLocalizations l10n) => switch (this) {
    AppSettingTab.notifications => l10n.settingsNotificationsTitle,
    AppSettingTab.display => l10n.settingsDisplayTitle,
    AppSettingTab.sidebar => l10n.settingsSidebarTitle,
    AppSettingTab.advanced => l10n.settingsAdvancedTitle,
  };

  IconData get icon => switch (this) {
    AppSettingTab.notifications => Icons.notifications_outlined,
    AppSettingTab.display => Icons.palette_outlined,
    AppSettingTab.sidebar => Icons.vertical_split,
    AppSettingTab.advanced => Icons.tune,
  };
}

class AppSettingsPage extends StatefulWidget {
  final AppSettingTab initialTab;

  const AppSettingsPage({
    super.key,
    this.initialTab = AppSettingTab.notifications,
  });

  @override
  State<AppSettingsPage> createState() => _AppSettingsPageState();
}

class _AppSettingsPageState extends State<AppSettingsPage> {
  late AppSettingTab _selectedTab = widget.initialTab;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);

    return Center(
      child: Material(
        color: theme.centerChannelBg,
        elevation: 16,
        borderRadius: BorderRadius.circular(DesignTokens.dialogRadius),
        clipBehavior: Clip.antiAlias,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800, maxHeight: 640),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _SettingsModalHeader(
                title: l10n
                    .navbar_dropdownAccountSettings, // or app settings if available
                onClose: () => Navigator.of(context).pop(),
              ),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _SettingsSidebar(
                      selected: _selectedTab,
                      onSelect: (tab) => setState(() => _selectedTab = tab),
                    ),
                    Container(
                      width: 1,
                      color: theme.centerChannelColor.withValues(alpha: 0.1),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: _buildTabContent(_selectedTab),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent(AppSettingTab tab) => switch (tab) {
    AppSettingTab.notifications => const AppNotificationsTab(),
    AppSettingTab.display =>
      const DisplaySettingsTab(), // Reusing from user settings if applicable
    AppSettingTab.sidebar =>
      const SidebarSettingsTab(), // Reusing from user settings if applicable
    AppSettingTab.advanced => const AppAdvancedTab(),
  };
}

class _SettingsModalHeader extends StatelessWidget {
  final String title;
  final VoidCallback onClose;

  const _SettingsModalHeader({required this.title, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.centerChannelColor.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: theme.centerChannelColor,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          InkWell(
            onTap: onClose,
            borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Icon(
                Icons.close,
                size: 20,
                color: theme.centerChannelColor.withValues(alpha: 0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsSidebar extends StatelessWidget {
  final AppSettingTab selected;
  final ValueChanged<AppSettingTab> onSelect;

  const _SettingsSidebar({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Container(
      width: 240,
      color: theme.centerChannelColor.withValues(alpha: 0.04),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final tab in AppSettingTab.values)
            _SettingsNavItem(
              tab: tab,
              active: tab == selected,
              onTap: () => onSelect(tab),
            ),
        ],
      ),
    );
  }
}

class _SettingsNavItem extends StatelessWidget {
  final AppSettingTab tab;
  final bool active;
  final VoidCallback onTap;

  const _SettingsNavItem({
    required this.tab,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);

    return InkWell(
      onTap: onTap,
      hoverColor: theme.centerChannelColor.withValues(alpha: 0.06),
      child: Container(
        height: 40,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: active
              ? theme.buttonBg.withValues(alpha: 0.08)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
        ),
        child: Row(
          children: [
            Icon(
              tab.icon,
              size: 18,
              color: active
                  ? theme.buttonBg
                  : theme.centerChannelColor.withValues(alpha: 0.7),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                tab.label(l10n),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: active ? theme.buttonBg : theme.centerChannelColor,
                  fontSize: 14,
                  fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppNotificationsTab extends StatefulWidget {
  const AppNotificationsTab({super.key});

  @override
  State<AppNotificationsTab> createState() => _AppNotificationsTabState();
}

class _AppNotificationsTabState extends State<AppNotificationsTab> {
  bool _bounceIcon = true;
  bool _flashTaskbar = true;
  bool _showUnreadBadge = true;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Notifications',
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        Divider(
          thickness: 0.10,
          height: 0,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        ListTile(
          onTap: () { },
          title: Text('Desktop and mobile notifications',
              style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            'Mentions, direct messages, and group messages.',
            style: textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
          ),
          trailing: TextButton.icon(
            icon: const Icon(Icons.edit, size: 16),
            label: const Text('Edit'),
            onPressed: () {},
          ),
        ),
        Divider(
          thickness: 0.10,
          height: 0,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        ListTile(
          onTap: () { },
          title: Text('Desktop notification sounds',
              style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            '"Bing" for messages.',
            style: textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
          ),
          trailing: TextButton.icon(
            icon: const Icon(Icons.edit, size: 16),
            label: const Text('Edit'),
            onPressed: () {},
          ),
        ),
        Divider(
          thickness: 0.10,
          height: 0,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        ListTile(
          onTap: () { },
          title: Text('Email notifications',
              style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            'On',
            style: textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
          ),
          trailing: TextButton.icon(
            icon: const Icon(Icons.edit, size: 16),
            label: const Text('Edit'),
            onPressed: () {},
          ),
        ),
        Divider(
          thickness: 0.10,
          height: 0,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        ListTile(
          onTap: () { },
          title: Text('Auto-follow threads on channel-wide mentions',
              style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            'On',
            style: textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
          ),
          trailing: TextButton.icon(
            icon: const Icon(Icons.edit, size: 16),
            label: const Text('Edit'),
            onPressed: () {},
          ),
        ),
        Divider(
          thickness: 0.10,
          height: 0,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        ListTile(
          onTap: () { },
          title: Text('Keywords that trigger notifications',
              style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            'osmai4603@gmail.com',
            style: textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
          ),
          trailing: TextButton.icon(
            icon: const Icon(Icons.edit, size: 16),
            label: const Text('Edit'),
            onPressed: () {},
          ),
        ),
        // SettingsSectionGroup(
        //   title: l10n.userSettingsNotificationsDesktopTitle,
        //   children: [
        //     SettingsToggleRow(
        //       label: "Bounce application icon on new messages",
        //       value: _bounceIcon,
        //       onChanged: (v) => setState(() => _bounceIcon = v),
        //     ),
        //     SettingsToggleRow(
        //       label: "Flash taskbar icon on new messages",
        //       value: _flashTaskbar,
        //       onChanged: (v) => setState(() => _flashTaskbar = v),
        //     ),
        //     SettingsToggleRow(
        //       label: "Show unread message badge",
        //       value: _showUnreadBadge,
        //       onChanged: (v) => setState(() => _showUnreadBadge = v),
        //     ),
        //   ],
        // ),
      ],
    );
  }
}

class AppAdvancedTab extends StatefulWidget {
  const AppAdvancedTab({super.key});

  @override
  State<AppAdvancedTab> createState() => _AppAdvancedTabState();
}

class _AppAdvancedTabState extends State<AppAdvancedTab> {
  bool _gpuAcceleration = true;
  bool _launchOnStartup = false;
  bool _spellChecker = true;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSectionGroup(
          title: l10n.settingsAdvancedTitle,
          children: [
            SettingsToggleRow(
              label: "Use GPU acceleration",
              description:
                  "May improve performance but could cause display issues on some hardware.",
              value: _gpuAcceleration,
              onChanged: (v) => setState(() => _gpuAcceleration = v),
            ),
            SettingsToggleRow(
              label: "Launch on startup",
              value: _launchOnStartup,
              onChanged: (v) => setState(() => _launchOnStartup = v),
            ),
            SettingsToggleRow(
              label: "Enable spell checker",
              value: _spellChecker,
              onChanged: (v) => setState(() => _spellChecker = v),
            ),
          ],
        ),
      ],
    );
  }
}
