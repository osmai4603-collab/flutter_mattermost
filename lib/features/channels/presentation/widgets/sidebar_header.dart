import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_mattermost/app/routes/admin_console_route.dart';
import 'package:flutter_mattermost/app/routes/integration_route.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/modals/modal_identifiers.dart';
import 'package:flutter_mattermost/core/modals/modal_registry.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/design_tokens.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:flutter_mattermost/core/widgets/matter_menu.dart';
import 'package:flutter_mattermost/core/widgets/profile_picture.dart';
import 'package:flutter_mattermost/features/auth/domain/entities/user_status_entity.dart';
import 'package:flutter_mattermost/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_mattermost/features/channels/presentation/widgets/quick_switcher.dart';
import 'package:flutter_mattermost/features/teams/presentation/bloc/team_bloc.dart';
import 'package:flutter_mattermost/features/users/presentation/bloc/user_status_bloc.dart';

/// رأس الشريط الجانبي — مطابق sidebar_header.tsx في webapp:
/// ارتفاع 55px، اسم الفريق Metropolis 16 + قائمة رئيسية (إعدادات/دعوة/كونسول)
/// + اسم المستخدم وأفاتاره + زر (+) بقائمة إنشاء قناة/تصفح/رسالة مباشرة.
class SidebarHeader extends StatelessWidget {
  const SidebarHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);
    final authState = context.watch<AuthBloc>().state;
    final user = authState is AuthenticatedState ? authState.user : null;
    final statusState = context.watch<UserStatusBloc>().state;
    final myStatus = statusState is UserStatusesLoadedState
        ? statusState.statusOf('me')
        : UserStatus.offline;

    return Container(
      height: DesignTokens.sidebarHeaderHeight,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      color: theme.sidebarBg,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _MainMenu(theme: theme, l10n: l10n),
          const SizedBox(width: 6),
          _UserChip(
            theme: theme,
            l10n: l10n,
            username: user?.username ?? '?',
            displayName: user?.firstName ?? user?.username ?? '',
            status: myStatus,
          ),
          const SizedBox(width: 6),
          _AddChannelMenu(theme: theme, l10n: l10n),
        ],
      ),
    );
  }
}

/// اسم الفريق + القائمة الرئيسية (webapp sidebar_header + main_menu).
class _MainMenu extends StatelessWidget {
  final MattermostColors theme;
  final AppLocalizations l10n;

  const _MainMenu({required this.theme, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeamBloc, TeamState>(
      builder: (context, teamState) {
        final team = teamState is TeamsLoadedState
            ? teamState.selectedTeam
            : null;
        return Flexible(
          child: MatterMenuScope(
            items: [
              MatterMenuItem(
                id: 'account_settings',
                label: l10n.navbar_dropdownAccountSettings,
                icon: const Icon(Icons.settings_outlined, size: 18),
                onTap: () {
                  ModalRegistry.open(
                    context,
                    id: ModalIdentifiers.userSettings,
                    args: const {'initialTab': 'profile'},
                  );
                },
              ),
              MatterMenuItem(
                id: 'invite_people',
                label: l10n.sidebar_leftInviteMembers,
                icon: const Icon(Icons.person_add_alt_outlined, size: 18),
                onTap: () {
                  ModalRegistry.open(context, id: ModalIdentifiers.invitation);
                },
              ),
              MatterMenuItem(
                id: 'quick_switch',
                label: l10n.sidebar_leftChannel_navigatorChannelSwitcherLabel,
                icon: const Icon(Icons.keyboard, size: 18),
                onTap: () => showQuickSwitcher(context),
              ),
              MatterMenuItem.divider(),
              MatterMenuItem(
                id: 'create_team',
                label: l10n.teamCreateTeam,
                icon: const Icon(Icons.group_add_outlined, size: 18),
                onTap: () {},
              ),
              MatterMenuItem(
                id: 'join_team',
                label: l10n.teamJoinTeam,
                icon: const Icon(Icons.add, size: 18),
                onTap: () {},
              ),
              MatterMenuItem.divider(),
              MatterMenuItem(
                id: 'integrations',
                label: l10n.navbar_dropdownIntegrations,
                icon: const Icon(Icons.extension_outlined, size: 18),
                onTap: () {
                  if (team != null) {
                    context.go(IntegrationRoutes.root.replaceAll(':team', team.name));
                  }
                },
              ),
              MatterMenuItem(
                id: 'system_console',
                label: l10n.sidebar_right_menuConsole,
                icon: const Icon(Icons.terminal_rounded, size: 18),
                onTap: () => context.go(AdminConsoleRoutes.root),
              ),
            ],
            child: Tooltip(
              message: l10n.teamMenuTitle,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 2,
                ),
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        team?.displayName ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Metropolis',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: theme.sidebarHeaderTextColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.keyboard_arrow_down,
                      size: 18,
                      color: theme.sidebarHeaderTextColor.withValues(
                        alpha: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// اسم المستخدم + أفاتار مع الحالة (يُفتح قائمة الحساب عند النقر).
class _UserChip extends StatelessWidget {
  final MattermostColors theme;
  final AppLocalizations l10n;
  final String username;
  final String displayName;
  final UserStatus? status;

  const _UserChip({
    required this.theme,
    required this.l10n,
    required this.username,
    required this.displayName,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ProfilePicture.sm(
          username: username,
          avatarUrl: null,
          status: status,
          showStatus: true,
        ),
        if (displayName.isNotEmpty) ...[
          const SizedBox(width: 5),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 72),
            child: Text(
              displayName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: theme.sidebarHeaderTextColor.withValues(alpha: 0.85),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// زر (+) — قائمة إنشاء قناة/تصفح قنوات/رسالة مباشرة
/// (مطابق SidebarAddChannelMenu في webapp).
class _AddChannelMenu extends StatelessWidget {
  final MattermostColors theme;
  final AppLocalizations l10n;

  const _AddChannelMenu({required this.theme, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return MatterMenuScope(
      items: [
        MatterMenuItem(
          id: 'create_channel',
          label: l10n.sidebar_leftAdd_channel_dropdownCreateNewChannel,
          icon: const Icon(Icons.add_comment_outlined, size: 18),
          onTap: () {
            ModalRegistry.open(context, id: ModalIdentifiers.newChannel);
          },
        ),
        MatterMenuItem(
          id: 'browse_channels',
          label: l10n.sidebar_leftAdd_channel_dropdownBrowseChannels,
          icon: const Icon(Icons.explore_outlined, size: 18),
          onTap: () {
            ModalRegistry.open(context, id: ModalIdentifiers.moreChannels);
          },
        ),
        MatterMenuItem.divider(),
        MatterMenuItem(
          id: 'direct_message',
          label: l10n.sidebarCreateDirectMessage,
          icon: const Icon(Icons.alternate_email, size: 18),
          onTap: () {
            ModalRegistry.open(
              context,
              id: ModalIdentifiers.moreDirectChannels,
            );
          },
        ),
      ],
      child: Material(
        borderRadius: BorderRadius.circular(DesignTokens.radiusPill),
        color: theme.sidebarHeaderTextColor.withValues(alpha: 0.12),
        child: InkWell(
          borderRadius: BorderRadius.circular(DesignTokens.radiusPill),
          child: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(shape: BoxShape.circle),
            child: Icon(
              Icons.add,
              size: 16,
              color: theme.sidebarHeaderTextColor,
            ),
          ),
        ),
      ),
    );
  }
}