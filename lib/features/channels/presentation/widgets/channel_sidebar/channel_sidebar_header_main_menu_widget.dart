import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/app/routes/admin_console_route.dart';
import 'package:flutter_mattermost/app/routes/integration_route.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/modals/modal_identifiers.dart';
import 'package:flutter_mattermost/core/modals/modal_registry.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:flutter_mattermost/core/widgets/matter_menu.dart';
import 'package:flutter_mattermost/features/channels/presentation/widgets/quick_switcher.dart';
import 'package:flutter_mattermost/features/teams/presentation/bloc/team_bloc.dart';
import 'package:go_router/go_router.dart';

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
    return BlocBuilder<TeamBloc, TeamState>(
      builder: (context, teamState) {
        final team = teamState is TeamsLoadedState
            ? teamState.selectedTeam
            : null;
        return Flexible(
          child: MatterMenuScope(
            items: [
              MatterMenuItem(
                id: 'invite_people',
                label: l10n.sidebar_leftInviteMembers,
                subtitle: 'Add or invite people to the team',
                icon: const Icon(Icons.group_add, size: 18),
                onTap: () {
                  ModalRegistry.open(context, id: ModalIdentifiers.invitation);
                },
              ),
              MatterMenuItem(
                id: 'view_members',
                label: 'View Members',
                icon: const Icon(Icons.groups_2, size: 18),
                onTap: () {},
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
              MatterMenuItem(
                id: 'join_team',
                label: l10n.teamJoinTeam,
                icon: const Icon(Icons.post_add, size: 18),
                onTap: () {},
              ),
              MatterMenuItem(
                id: 'create_team',
                label: l10n.teamCreateTeam,
                icon: const Icon(Icons.group_add_outlined, size: 18),
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
                          fontFamily: 'NotoNaskhArabic',
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
