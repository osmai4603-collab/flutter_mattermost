import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/features/groups/data/datasources/groups_remote_data_source.dart';
import 'package:flutter_mattermost/features/groups/data/models/group_model.dart';
import 'package:flutter_mattermost/features/groups/data/models/groups_associated_to_channels_model.dart';

abstract class TeamGroupsState extends Equatable {
  const TeamGroupsState();
  @override
  List<Object?> get props => [];
}

class TeamGroupsInitialState extends TeamGroupsState {}

class TeamGroupsLoadingState extends TeamGroupsState {}

class TeamGroupsLoadedState extends TeamGroupsState {
  final String teamId;
  final List<GroupModel> userGroups;
  final GroupsAssociatedToChannelsModel? channelGroups;

  const TeamGroupsLoadedState({
    required this.teamId,
    required this.userGroups,
    this.channelGroups,
  });

  @override
  List<Object?> get props => [teamId, userGroups, channelGroups];
}

class TeamGroupsErrorState extends TeamGroupsState {
  final String message;
  const TeamGroupsErrorState(this.message);

  @override
  List<Object?> get props => [message];
}


@LazySingleton()
class TeamGroupsCubit extends Cubit<TeamGroupsState> {
  final GroupsRemoteDataSource _groupsRemoteDataSource;

  TeamGroupsCubit(this._groupsRemoteDataSource)
      : super(TeamGroupsInitialState());

  Future<void> loadGroupsForTeam(String userId, String teamId) async {
    emit(TeamGroupsLoadingState());
    try {
      final results = await Future.wait([
        _groupsRemoteDataSource.getGroupsByUserId(
          userId.isEmpty ? 'me' : userId,
        ),
        _groupsRemoteDataSource.getGroupsAssociatedToChannelsByTeam(
          teamId: teamId,
        ),
      ]);

      final userGroups = results[0] as List<GroupModel>;
      final channelGroups = results[1] as GroupsAssociatedToChannelsModel;

      emit(
        TeamGroupsLoadedState(
          teamId: teamId,
          userGroups: userGroups,
          channelGroups: channelGroups,
        ),
      );
    } catch (e) {
      emit(TeamGroupsErrorState(e.toString()));
    }
  }

  void updateGroupsLocally(
    String teamId,
    List<GroupModel> userGroups,
    GroupsAssociatedToChannelsModel? channelGroups,
  ) {
    emit(
      TeamGroupsLoadedState(
        teamId: teamId,
        userGroups: userGroups,
        channelGroups: channelGroups,
      ),
    );
  }
}
