import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/features/teams/domain/entities/team_entity.dart';
import 'package:flutter_mattermost/features/teams/domain/entities/team_member_entity.dart';
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

class CreateTeamEvent extends TeamEvent {
  final String displayName;
  final String name;
  final String type;

  const CreateTeamEvent({
    required this.displayName,
    required this.name,
    required this.type,
  });

  @override
  List<Object?> get props => [displayName, name, type];
}

class AddTeamMemberEvent extends TeamEvent {
  final String teamId;
  final String userId;

  const AddTeamMemberEvent({required this.teamId, required this.userId});

  @override
  List<Object?> get props => [teamId, userId];
}

class AddTeamMembersEvent extends TeamEvent {
  final String teamId;
  final List<String> userIds;

  const AddTeamMembersEvent({required this.teamId, required this.userIds});

  @override
  List<Object?> get props => [teamId, userIds];
}

class ClearTeamsEvent extends TeamEvent {}

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

class TeamMemberAddedState extends TeamState {
  final TeamMemberEntity member;

  const TeamMemberAddedState(this.member);

  @override
  List<Object?> get props => [member];
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
    on<CreateTeamEvent>(_onCreateTeam);
    on<AddTeamMemberEvent>(_onAddTeamMember);
    on<AddTeamMembersEvent>(_onAddTeamMembers);
    on<ClearTeamsEvent>(_onClearTeams);
  }

  void _onClearTeams(ClearTeamsEvent event, Emitter<TeamState> emit) {
    emit(TeamInitialState());
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

  Future<void> _onCreateTeam(
    CreateTeamEvent event,
    Emitter<TeamState> emit,
  ) async {
    try {
      final team = await _teamRepository.createTeam({
        'display_name': event.displayName,
        'name': event.name,
        'type': event.type,
      });
      if (state is TeamsLoadedState) {
        final current = state as TeamsLoadedState;
        emit(TeamsLoadedState(
          teams: [...current.teams, team],
          selectedTeam: team,
        ));
      } else {
        add(LoadMyTeamsEvent());
      }
    } catch (e) {
      emit(TeamErrorState(e.toString()));
    }
  }

  Future<void> _onAddTeamMember(
    AddTeamMemberEvent event,
    Emitter<TeamState> emit,
  ) async {
    try {
      final member = await _teamRepository.addToTeam(
        event.teamId,
        event.userId,
      );
      emit(TeamMemberAddedState(member));
    } catch (e) {
      emit(TeamErrorState(e.toString()));
    }
  }

  Future<void> _onAddTeamMembers(
    AddTeamMembersEvent event,
    Emitter<TeamState> emit,
  ) async {
    try {
      final members = await _teamRepository.addUsersToTeam(
        event.teamId,
        event.userIds,
      );
      if (members.isNotEmpty) {
        emit(TeamMemberAddedState(members.first));
      }
    } catch (e) {
      emit(TeamErrorState(e.toString()));
    }
  }
}
