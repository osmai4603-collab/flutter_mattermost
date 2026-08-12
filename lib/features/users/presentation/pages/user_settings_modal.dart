import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/design_tokens.dart';
import 'package:flutter_mattermost/features/users/presentation/pages/settings_tabs.dart';

/// تبويبات نافذة الإعدادات — مطابقة UserSettingsTabs في webapp.
enum UserSettingsTab {
  profile,
  notifications,
  display,
  sidebar,
  advanced,
  security,
}

extension UserSettingsTabLabels on UserSettingsTab {
  String label(AppLocalizations l10n) => switch (this) {
    UserSettingsTab.profile => l10n.userAccountMenuProfile,
    UserSettingsTab.notifications => l10n.settingsNotificationsTitle,
    UserSettingsTab.display => l10n.settingsDisplayTitle,
    UserSettingsTab.sidebar => l10n.settingsSidebarTitle,
    UserSettingsTab.advanced => l10n.settingsAdvancedTitle,
    UserSettingsTab.security => 'Sucurity',
  };

  IconData get icon => switch (this) {
    UserSettingsTab.profile => Icons.account_circle_outlined,
    UserSettingsTab.notifications => Icons.notifications_outlined,
    UserSettingsTab.display => Icons.palette_outlined,
    UserSettingsTab.sidebar => Icons.vertical_split,
    UserSettingsTab.advanced => Icons.tune,
    UserSettingsTab.security => Icons.shield_outlined,
  };
}

/// نافذة إعدادات المستخدم — مطابقة user_settings_modal.tsx في webapp:
/// Modal بعرض 800px + قائمة جانبية (SettingsSidebar) بتبويبات
/// + لوحة محتوى مقسمة لأقسام. تُفتح عبر ModalIdentifiers.userSettings
/// مع معامل initialTab ('profile' أو 'settings' أو غيرها).
class UserSettingsModal extends StatefulWidget {
  final UserSettingsTab initialTab;

  const UserSettingsModal({
    super.key,
    this.initialTab = UserSettingsTab.notifications,
  });

  @override
  State<UserSettingsModal> createState() => _UserSettingsModalState();
}

class _UserSettingsModalState extends State<UserSettingsModal> {
  late UserSettingsTab _selectedTab = widget.initialTab;

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
                title: 'User Profile',
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

  Widget _buildTabContent(UserSettingsTab tab) => switch (tab) {
    UserSettingsTab.profile => const ProfileSettingsTab(),
    UserSettingsTab.notifications => const NotificationsSettingsTab(),
    UserSettingsTab.display => const DisplaySettingsTab(),
    UserSettingsTab.sidebar => const SidebarSettingsTab(),
    UserSettingsTab.advanced => const AdvancedSettingsTab(),
    UserSettingsTab.security => const SecuritySettingsTab(),
  };
}

/// رأس النافذة: عنوان + زر إغلاق (مطابق modal-header).
class _SettingsModalHeader extends StatelessWidget {
  final String title;
  final VoidCallback onClose;

  const _SettingsModalHeader({required this.title, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Container(
      height: 48,
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
                fontSize: 16,
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

/// القائمة الجانبية للتبويبات — مطابقة SettingsSidebar في webapp:
/// خلفية شبه شفافة، عنصر نشط بخلفية button-bg 0.08 ولون button-bg.
class _SettingsSidebar extends StatelessWidget {
  final UserSettingsTab selected;
  final ValueChanged<UserSettingsTab> onSelect;

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
          for (final tab in UserSettingsTab.values)
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
  final UserSettingsTab tab;
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
