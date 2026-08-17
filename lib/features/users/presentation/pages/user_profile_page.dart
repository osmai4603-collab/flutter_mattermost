import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/design_tokens.dart';
import 'package:flutter_mattermost/core/widgets/profile_picture.dart';
import 'package:flutter_mattermost/features/auth/presentation/bloc/auth_bloc.dart';

enum UserProfileTab { profileSettings, security }

extension UserProfileTabLabels on UserProfileTab {
  String label(AppLocalizations l10n) => switch (this) {
    UserProfileTab.profileSettings => l10n.userSettingsModalProfile,
    UserProfileTab.security => l10n.userSettingsModalSecurity,
  };

  IconData get icon => switch (this) {
    UserProfileTab.profileSettings => Icons.account_circle_outlined,
    UserProfileTab.security => Icons.shield_outlined,
  };
}

class UserProfilePage extends StatefulWidget {
  final UserProfileTab initialTab;

  const UserProfilePage({
    super.key,
    this.initialTab = UserProfileTab.profileSettings,
  });

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late UserProfileTab _selectedTab = widget.initialTab;

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
              _UserProfileHeader(
                title: l10n.userSettingsModalTitle,
                onClose: () => Navigator.of(context).pop(),
              ),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _UserProfileSidebar(
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

  Widget _buildTabContent(UserProfileTab tab) => switch (tab) {
    UserProfileTab.profileSettings => const _ProfileSettingsContent(),
    UserProfileTab.security => const _SecuritySettingsContent(),
  };
}

class _UserProfileHeader extends StatelessWidget {
  final String title;
  final VoidCallback onClose;

  const _UserProfileHeader({required this.title, required this.onClose});

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

class _UserProfileSidebar extends StatelessWidget {
  final UserProfileTab selected;
  final ValueChanged<UserProfileTab> onSelect;

  const _UserProfileSidebar({required this.selected, required this.onSelect});

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
          for (final tab in UserProfileTab.values)
            _UserProfileNavItem(
              tab: tab,
              active: tab == selected,
              onTap: () => onSelect(tab),
            ),
        ],
      ),
    );
  }
}

class _UserProfileNavItem extends StatelessWidget {
  final UserProfileTab tab;
  final bool active;
  final VoidCallback onTap;

  const _UserProfileNavItem({
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

class _ProfileSettingsContent extends StatelessWidget {
  const _ProfileSettingsContent();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final authState = context.watch<AuthBloc>().state;
    final user = authState is AuthenticatedState ? authState.user : null;
    final fullName = '${user?.firstName ?? ''} ${user?.lastName ?? ''}'.trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.userSettingsModalProfile,
          style: TextStyle(
            color: AppTheme.of(context).centerChannelColor,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 24),
        _ProfileDetailTile(
          title: 'Full Name',
          subtitle: fullName.isEmpty ? '—' : fullName,
          onEdit: () {},
        ),
        _ProfileDetailTile(
          title: 'Username',
          subtitle: user?.username ?? '—',
          onEdit: () {},
        ),
        _ProfileDetailTile(
          title: 'Nickname',
          subtitle: user?.nickname ?? '—',
          onEdit: () {},
        ),
        _ProfileDetailTile(
          title: 'Position',
          subtitle: user?.position ?? '—',
          onEdit: () {},
        ),
        _ProfileDetailTile(
          title: 'Email',
          subtitle: user?.email ?? '—',
          onEdit: () {},
        ),
        _ProfileDetailTile(
          title: 'Profile Picture',
          subtitle: 'Update your avatar',
          leading: ProfilePicture.xl(
            userId: user?.id,
            username: user?.username ?? '?',
            avatarUrl: null,
            status: null,
          ),
          onEdit: () {},
        ),
      ],
    );
  }
}

class _ProfileDetailTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? leading;
  final VoidCallback onEdit;

  const _ProfileDetailTile({
    required this.title,
    required this.subtitle,
    required this.onEdit,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.centerChannelColor.withValues(alpha: 0.08),
        ),
        borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: leading,
        title: Text(
          title,
          style: TextStyle(
            color: theme.centerChannelColor,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: theme.centerChannelColor.withValues(alpha: 0.7),
            fontSize: 13,
          ),
        ),
        trailing: TextButton.icon(
          onPressed: onEdit,
          icon: Icon(Icons.edit_outlined, size: 18, color: theme.buttonBg),
          label: Text(
            'Edit',
            style: TextStyle(
              color: theme.buttonBg,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _SecuritySettingsContent extends StatelessWidget {
  const _SecuritySettingsContent();

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Security Settings',
          style: TextStyle(
            color: theme.centerChannelColor,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 24),
        _SecurityTile(
          title: 'Password',
          subtitle: 'Change or reset your password',
          onTap: () {},
        ),
        _SecurityTile(
          title: 'OAuth 2.0 Applications',
          subtitle: 'Manage connected applications',
          onTap: () {},
        ),
        const SizedBox(height: 32),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: theme.buttonBg),
                  foregroundColor: theme.buttonBg,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('View Access History'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: FilledButton(
                onPressed: () {},
                style: FilledButton.styleFrom(
                  backgroundColor: theme.buttonBg,
                  foregroundColor: theme.buttonColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('View and Log Out Of Active Sessions'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SecurityTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SecurityTile({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.centerChannelColor.withValues(alpha: 0.08),
        ),
        borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          title,
          style: TextStyle(
            color: theme.centerChannelColor,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: theme.centerChannelColor.withValues(alpha: 0.7),
            fontSize: 13,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: theme.centerChannelColor.withValues(alpha: 0.6),
        ),
      ),
    );
  }
}
