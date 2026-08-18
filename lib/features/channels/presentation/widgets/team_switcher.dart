import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/features/teams/domain/entities/team_entity.dart';
import 'package:flutter_mattermost/features/teams/presentation/bloc/team_bloc.dart';
import 'package:flutter_mattermost/features/teams/presentation/pages/create_new_team.dart';
import 'package:go_router/go_router.dart';

/// شريط الفرق الرأسي الأيسر (Team Switcher) — مطابق webapp.
class TeamSwitcher extends StatelessWidget {
  const TeamSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);

    return BlocBuilder<TeamBloc, TeamState>(
      builder: (context, state) {
        final teams = state is TeamsLoadedState
            ? state.teams
            : const <TeamEntity>[];
        final selected = state is TeamsLoadedState ? state.selectedTeam : null;

        return Container(
          width: 64,
          color: theme.sidebarTeamBarBg,
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 16),
            children: [
              for (final team in teams)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _TeamIcon(
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
                padding: const EdgeInsets.only(top: 8),
                child: _AddTeamIcon(
                  tooltip: l10n.teamSwitcherAddTeam,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => const CreateNewTeam(),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TeamIcon extends StatelessWidget {
  final TeamEntity team;
  final bool isActive;
  final VoidCallback onTap;

  const _TeamIcon({
    required this.team,
    required this.isActive,
    required this.onTap,
  });

  Color _teamColor() {
    final seed = team.id.hashCode;
    const palette = [
      Color(0xFF1E88E5),
      Color(0xFF43A047),
      Color(0xFFE53935),
      Color(0xFF8E24AA),
      Color(0xFFFB8C00),
      Color(0xFF00897B),
    ];
    return palette[seed.abs() % palette.length];
  }

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
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isActive ? _teamColor() : theme.sidebarTeamBarBg,
              borderRadius: BorderRadius.circular(12),
              border: isActive
                  ? Border.all(color: theme.sidebarTextActiveColor, width: 2)
                  : Border.all(
                      color: Colors.white.withValues(alpha: 0.15),
                      width: 1,
                    ),
            ),
            child: Center(
              child: Text(
                _initials,
                style: TextStyle(
                  color: isActive ? Colors.white : theme.sidebarText,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AddTeamIcon extends StatelessWidget {
  final String tooltip;
  final VoidCallback onTap;

  const _AddTeamIcon({required this.tooltip, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Center(
      child: Tooltip(
        message: tooltip,
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.add,
              color: theme.sidebarText.withValues(alpha: 0.7),
            ),
          ),
        ),
      ),
    );
  }
}
