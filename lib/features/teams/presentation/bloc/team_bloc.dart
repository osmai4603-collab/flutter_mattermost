import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/features/teams/domain/entities/team_entity.dart';
import 'package:flutter_mattermost/features/teams/domain/repositories/team_repository.dart';

// Events
abstract class TeamEvent extends Equatable {
  const TeamEvent();
  @override
  List<Object?> get props => [];
}

class LoadMyTeamsEvent extends TeamEvent {}

class SelectTeamEvent extends TeamEvent {
  final TeamEntity team;
  const SelectTeamEvent(this.team);
  @override
  List<Object?> get props => [team];
}

class RefreshTeamsEvent extends TeamEvent {}

// States
abstract class TeamState extends Equatable {
  const TeamState();
  @override
  List<Object?> get props => [];
}

class TeamInitialState extends TeamState {}

class TeamLoadingState extends TeamState {}

class TeamsLoadedState extends TeamState {
  final List<TeamEntity> teams;
  final TeamEntity? selectedTeam;

  const TeamsLoadedState({required this.teams, this.selectedTeam});
  @override
  List<Object?> get props => [teams, selectedTeam];
}

class TeamErrorState extends TeamState {
  final String message;
  const TeamErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

@LazySingleton()
class TeamBloc extends Bloc<TeamEvent, TeamState> {
  final TeamRepository _teamRepository;

  TeamBloc(this._teamRepository) : super(TeamInitialState()) {
    on<LoadMyTeamsEvent>(_onLoadMyTeams);
    on<RefreshTeamsEvent>(_onLoadMyTeams);
    on<SelectTeamEvent>(_onSelectTeam);
  }

  Future<void> _onLoadMyTeams(TeamEvent event, Emitter<TeamState> emit) async {
    emit(TeamLoadingState());
    try {
      final teams = await _teamRepository.getMyTeams();
      final selected = teams.isNotEmpty ? teams.first : null;
      emit(TeamsLoadedState(teams: teams, selectedTeam: selected));
    } catch (e) {
      emit(TeamErrorState(e.toString()));
    }
  }

  void _onSelectTeam(SelectTeamEvent event, Emitter<TeamState> emit) {
    if (state is TeamsLoadedState) {
      final current = state as TeamsLoadedState;
      emit(TeamsLoadedState(teams: current.teams, selectedTeam: event.team));
    }
  }
}
