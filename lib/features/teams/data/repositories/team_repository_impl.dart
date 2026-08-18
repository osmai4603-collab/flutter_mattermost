import 'package:flutter_mattermost/features/teams/domain/entities/team_stats_entity.dart';
import 'package:flutter_mattermost/features/teams/domain/entities/team_unread_entity.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/features/teams/data/models/team_model.dart';
import 'package:flutter_mattermost/features/teams/data/datasources/teams_remote_data_source.dart';
import 'package:flutter_mattermost/features/teams/domain/entities/team_entity.dart';
import 'package:flutter_mattermost/features/teams/domain/entities/team_member_entity.dart';
import 'package:flutter_mattermost/features/teams/domain/repositories/team_repository.dart';

@LazySingleton(as: TeamRepository)
class TeamRepositoryImpl implements TeamRepository {
  final TeamsRemoteDataSource _remoteDataSource;
  final Map<String, TeamEntity> _teamCache = {};

  TeamRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<TeamEntity>> getMyTeams({int page = 0, int perPage = 60}) async {
    final models = await _remoteDataSource.getMyTeams(
      page: page,
      perPage: perPage,
    );
    return _cacheAndReturn(models);
  }

  @override
  Future<List<TeamEntity>> getTeamsForUser(
    String userId, {
    int page = 0,
    int perPage = 60,
  }) async {
    final models = await _remoteDataSource.getTeamsForUser(
      userId,
      page: page,
      perPage: perPage,
    );
    return _cacheAndReturn(models);
  }

  List<TeamEntity> _cacheAndReturn(List<TeamModel> models) {
    final entities = models.map((m) => m.toEntity()).toList();
    for (final entity in entities) {
      _teamCache[entity.id] = entity;
    }
    return entities;
  }

  @override
  Future<TeamEntity> getTeamById(String teamId) async {
    try {
      final model = await _remoteDataSource.getTeam(teamId);
      final entity = model.toEntity();
      _teamCache[entity.id] = entity;
      return entity;
    } catch (_) {
      final cached = _teamCache[teamId];
      if (cached != null) return cached;
      rethrow;
    }
  }

  @override
  Future<TeamEntity> getTeamByName(String teamName) async {
    final model = await _remoteDataSource.getTeamByName(teamName);
    final entity = model.toEntity();
    _teamCache[entity.id] = entity;
    return entity;
  }

  @override
  Future<List<TeamMemberEntity>> getTeamMembers(
    String teamId, {
    int page = 0,
    int perPage = 60,
  }) async {
    final members = await _remoteDataSource.getTeamMembers(
      teamId,
      page: page,
      perPage: perPage,
    );
    return members.map((m) => m.toEntity()).toList();
  }

  @override
  Future<TeamMemberEntity> getTeamMember(String teamId, String userId) async {
    final m = await _remoteDataSource.getTeamMember(teamId, userId);
    return m.toEntity();
  }

  @override
  Future<List<TeamUnreadEntity>> getTeamsUnreadForUser(String userId) async {
    final unread = await _remoteDataSource.getTeamsUnreadForUser(userId);
    return unread.map((m) => m.toEntity()).toList();
  }

  @override
  Future<TeamUnreadEntity> getTeamUnreadForUser(
    String userId,
    String teamId,
  ) async {
    final model = await _remoteDataSource.getTeamUnreadForUser(userId, teamId);
    return model.toEntity();
  }

  @override
  Future<bool> checkIfTeamExists(String teamName) =>
      _remoteDataSource.checkIfTeamExists(teamName);

  @override
  Future<TeamStatsEntity> getTeamStats(String teamId) async {
    final model = await _remoteDataSource.getTeamStats(teamId);
    return model.toEntity();
  }

  @override
  Future<TeamEntity> createTeam(Map<String, dynamic> team) async {
    final model = await _remoteDataSource.createTeam(team);
    final entity = model.toEntity();
    _teamCache[entity.id] = entity;
    return entity;
  }

  @override
  Future<void> inviteMembersByEmail(
    String teamId,
    List<String> emails,
  ) =>
      _remoteDataSource.sendEmailInvitesToTeam(teamId, emails);

  @override
  Future<void> inviteGuestsToChannels(
    String teamId, {
    required List<String> emails,
    required List<String> channelIds,
  }) {
    return _remoteDataSource.sendEmailGuestInvitesToChannels(teamId, {
        'emails': emails,
        'channels': channelIds,
      });
  }
}
