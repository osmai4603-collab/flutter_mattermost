import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/modals/modal_identifiers.dart';
import 'package:flutter_mattermost/core/modals/modal_registry.dart';
import 'package:flutter_mattermost/core/permissions/enums/mattermost_permission.dart';
import 'package:flutter_mattermost/core/permissions/enums/mattermost_role.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:flutter_mattermost/core/widgets/matter_menu.dart';
import 'package:flutter_mattermost/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_mattermost/features/teams/presentation/bloc/team_bloc.dart';

/// اسم الفريق + القائمة الرئيسية (webapp sidebar_header + main_menu).
class ChannelSidebarHeaderMainMenuWidget extends StatelessWidget {
  final MattermostColors theme;
  final AppLocalizations l10n;

  const ChannelSidebarHeaderMainMenuWidget({
    super.key,
    required this.theme,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final userState = context.read<AuthBloc>().state;
    final currentUser = userState is AuthenticatedState ? userState.user : null;
    return BlocBuilder<TeamBloc, TeamState>(
      builder: (context, teamState) {
        final team = teamState is TeamsLoadedState
            ? teamState.selectedTeam
            : null;
        return MatterMenuScope(
          items: [
            MatterMenuItem(
              id: 'invite_people',
              label: 'Invite people',
              subtitle: 'Add or invite people to the team',
              icon: const Icon(Icons.group_add, size: 18),
              onTap: () {
                ModalRegistry.open(
                  context,
                  id: ModalIdentifiers.invitePeopleInTeam,
                );
              },
            ),
            MatterMenuItem(
              id: 'team_settings',
              label: 'Team Settings',
              icon: const Icon(Icons.settings_outlined, size: 18),
              onTap: () => ModalRegistry.open(
                context,
                id: ModalIdentifiers.teamSettings,
              ),
            ),
            if ((currentUser?.hasRole(MMRole.teamAdmin) ?? false) ||
                (currentUser?.hasRole(MMRole.systemAdmin) ?? false))
              MatterMenuItem(
                id: 'manage_members',
                label: 'Manage Members',
                icon: const Icon(Icons.groups_outlined, size: 18),
                onTap: () => ModalRegistry.open(
                  context,
                  id: ModalIdentifiers.teamSettings,
                ),
              ),
            MatterMenuItem(
              id: 'leave_team',
              label: '',
              icon: Row(
                children: [
                  const Icon(Icons.settings_outlined, size: 18),
                  const SizedBox(width: 8),
                  Text('Leave Team', style: TextStyle(color: Colors.red)),
                ],
              ),
              onTap: () {},
            ),
            MatterMenuItem.divider(),
            if ((currentUser?.hasPermission(.manageTeam) ?? false))
              MatterMenuItem(
                id: 'join_team',
                label: l10n.teamJoinTeam,
                icon: const Icon(Icons.post_add, size: 18),
                onTap: () {},
              ),
            MatterMenuItem(
              id: 'create_team',
              label: l10n.teamCreateTeam,
              icon: const Icon(Icons.add_outlined, size: 18),
              onTap: () {},
            ),
            MatterMenuItem.divider(),

            MatterMenuItem(
              id: 'learn',
              label: '',
              icon: Row(
                children: [
                  const Icon(Icons.tips_and_updates, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'Learn about teams',
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                ],
              ),
            ),
          ],
          child: Tooltip(
            message: l10n.teamMenuTitle,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      team?.displayName ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
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
                    color: theme.sidebarHeaderTextColor.withValues(alpha: 0.8),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
