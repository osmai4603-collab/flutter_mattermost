import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/design_tokens.dart';
import 'package:flutter_mattermost/features/teams/domain/entities/team_entity.dart';
import 'package:flutter_mattermost/features/teams/presentation/bloc/team_bloc.dart';
import 'package:go_router/go_router.dart';

/// عمود الفرق الرأسي — مطابق components/team_sidebar في webapp:
/// عرض 65px، أيقونات 34×34 radius 8، bg rgba(sidebar-text, 0.16)،
/// نشط = ring 3px + bg 0.3، نقاط unread 8×8 + شارة إشارات 99+.
/// يُعرض فقط عند وجود أكثر من فريق واحد (مثل webapp multi-teams).
class TeamSidebar extends StatelessWidget {
  const TeamSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);

    return BlocBuilder<TeamBloc, TeamState>(
      builder: (context, state) {
        final teams = state is TeamsLoadedState
            ? state.teams
            : const <TeamEntity>[];
        if (teams.length <= 1) {
          return const SizedBox.shrink();
        }
        final selected = state is TeamsLoadedState ? state.selectedTeam : null;

        return Container(
          // width: DesignTokens.teamSidebarWidth,
          color: theme.sidebarTeamBarBg,
          child: ListView(
            padding: const EdgeInsets.only(top: 4),
            children: [
              for (final team in teams)
                Container(
                  color: theme.sidebarBg,
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _TeamButton(
                    team: team,
                    isActive: team.id == selected?.id,
                    onTap: () {
                      context.read<TeamBloc>().add(SelectTeamEvent(team));
                      context.go('/${team.name}');
                    },
                  ),
                ),
              if (teams.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: _AddTeamButton(tooltip: l10n.teamSwitcherAddTeam),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TeamButton extends StatelessWidget {
  final TeamEntity team;
  final bool isActive;
  final VoidCallback onTap;

  const _TeamButton({
    required this.team,
    required this.isActive,
    required this.onTap,
  });

  String get _initials {
    final parts = team.displayName
        .split(' ')
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) {
      return team.name.isEmpty ? '?' : team.name[0].toUpperCase();
    }
    if (parts.length == 1) {
      return parts.first.characters.take(2).toString().toUpperCase();
    }
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Center(
      child: Tooltip(
        message: team.displayName,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(DesignTokens.radiusM),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 34,
                height: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: theme.sidebarBg.withValues(
                    alpha: isActive ? 0.3 : 0.16,
                  ),
                  borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                  border: Border.all(
                    color: theme.sidebarText.withValues(alpha: 0.08),
                    width: 1,
                  ),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: theme.sidebarTextActiveBorder,
                            spreadRadius: 3,
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  _initials,
                  style: TextStyle(
                    color: theme.sidebarText,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddTeamButton extends StatelessWidget {
  final String tooltip;

  const _AddTeamButton({required this.tooltip});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Center(
      child: Tooltip(
        message: tooltip,
        child: InkWell(
          onTap: () {},
          customBorder: const CircleBorder(),
          child: Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: theme.sidebarText.withValues(alpha: 0.16),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.add,
              size: 20,
              color: theme.sidebarText.withValues(alpha: 0.7),
            ),
          ),
        ),
      ),
    );
  }
}
