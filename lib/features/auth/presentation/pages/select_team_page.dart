import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/design_tokens.dart';
import 'package:flutter_mattermost/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_mattermost/features/teams/domain/entities/team_entity.dart';
import 'package:flutter_mattermost/features/teams/presentation/bloc/team_bloc.dart';

/// صفحة اختيار الفريق — مطابقة لـ SelectTeam في webapp
class SelectTeamPage extends StatelessWidget {
  const SelectTeamPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: theme.centerChannelBg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo / Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.groups_outlined,
                            size: 32,
                            color: theme.buttonBg,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Mattermost',
                            style: TextStyle(
                              color: theme.centerChannelColor,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.logout),
                        color: theme.centerChannelColor.withValues(alpha: 0.72),
                        tooltip: 'Logout',
                        onPressed: () {
                          context.read<AuthBloc>().add(LogoutRequestedEvent());
                          context.go('/login');
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Title & Description
                  Text(
                    l10n.select_teamRecommended,
                    style: TextStyle(
                      color: theme.centerChannelColor,
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.signup_teamJoin_open,
                    style: TextStyle(
                      color: theme.centerChannelColor.withValues(alpha: 0.72),
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Team list card
                  BlocBuilder<TeamBloc, TeamState>(
                    builder: (context, state) {
                      if (state is TeamLoadingState) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(48),
                            child: CircularProgressIndicator(color: theme.buttonBg),
                          ),
                        );
                      }

                      final teams = switch (state) {
                        TeamsLoadedState(:final teams) => teams,
                        _ => const <TeamEntity>[],
                      };

                      if (teams.isEmpty && state is TeamsLoadedState) {
                        return Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: theme.centerChannelBg,
                            borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                            border: Border.all(
                              color: theme.centerChannelColor.withValues(alpha: 0.16),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              l10n.signup_teamNo_open_teams,
                              style: TextStyle(
                                color: theme.centerChannelColor.withValues(alpha: 0.6),
                                fontSize: 15,
                              ),
                            ),
                          ),
                        );
                      }

                      return Container(
                        decoration: BoxDecoration(
                          color: theme.centerChannelBg,
                          borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                          border: Border.all(
                            color: theme.centerChannelColor.withValues(alpha: 0.16),
                          ),
                        ),
                        child: Column(
                          children: [
                            for (int i = 0; i < teams.length; i++) ...[
                              if (i > 0)
                                Divider(
                                  height: 1,
                                  color: theme.centerChannelColor.withValues(alpha: 0.12),
                                ),
                              _TeamRowItem(
                                team: teams[i],
                                isRecommended: i == 0,
                                onTap: () {
                                  context.read<TeamBloc>().add(
                                        SelectTeamEvent(teams[i]),
                                      );
                                  context.go('/${teams[i].name}');
                                },
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Bottom action: Create a new team
                  OutlinedButton.icon(
                    onPressed: () => context.go('/create_team'),
                    icon: const Icon(Icons.add),
                    label: Text(l10n.teamSwitcherAddTeam),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      foregroundColor: theme.buttonBg,
                      side: BorderSide(color: theme.buttonBg),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TeamRowItem extends StatelessWidget {
  final TeamEntity team;
  final bool isRecommended;
  final VoidCallback onTap;

  const _TeamRowItem({
    required this.team,
    required this.isRecommended,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);

    return InkWell(
      onTap: onTap,
      child: Container(
        height: 60, // 3.8em (webapp select_team_table)
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            // Team Icon / Avatar
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: theme.buttonBg.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
              ),
              child: Center(
                child: Text(
                  team.displayName.isNotEmpty
                      ? team.displayName[0].toUpperCase()
                      : 'T',
                  style: TextStyle(
                    color: theme.buttonBg,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Team info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        team.displayName,
                        style: TextStyle(
                          color: theme.centerChannelColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (isRecommended) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: theme.buttonBg.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            l10n.select_teamRecommended,
                            style: TextStyle(
                              color: theme.buttonBg,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (team.description.isNotEmpty) ...[
                    const SizedBox(width: 4),
                    Text(
                      team.description,
                      style: TextStyle(
                        color: theme.centerChannelColor.withValues(alpha: 0.6),
                        fontSize: 13,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),

            Icon(
              Icons.chevron_right,
              color: theme.centerChannelColor.withValues(alpha: 0.48),
            ),
          ],
        ),
      ),
    );
  }
}
