import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/modals/modal_identifiers.dart';
import 'package:flutter_mattermost/core/modals/modal_registry.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/design_tokens.dart';
import 'package:flutter_mattermost/core/widgets/matter_menu.dart';
import 'package:flutter_mattermost/features/teams/presentation/bloc/team_bloc.dart';

/// رأس الشريط الجانبي — مطابق sidebar_header.tsx في webapp:
/// ارتفاع 55px، اسم الفريق Metropolis 16 + زر (+) لتجاوز.
class SidebarHeader extends StatelessWidget {
  const SidebarHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);

    return Container(
      height: DesignTokens.sidebarHeaderHeight,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: theme.sidebarBg,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BlocBuilder<TeamBloc, TeamState>(
            builder: (context, teamState) {
              final team = teamState is TeamsLoadedState
                  ? teamState.selectedTeam
                  : null;
              return SizedBox(
                width: 138,
                child: MatterMenuScope(
                  items: [
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
                  ],
                  child: Tooltip(
                    message: l10n.teamMenuTitle,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
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
          ),
          const SizedBox(width: 8),
          Material(
            borderRadius: BorderRadius.circular(DesignTokens.radiusPill),

            color: theme.sidebarHeaderTextColor.withValues(alpha: 0.12),
            child: InkWell(
              onTap: () => ModalRegistry.open(
                context,
                id: ModalIdentifiers.moreChannels,
              ),
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
        ],
      ),
    );
  }
}
