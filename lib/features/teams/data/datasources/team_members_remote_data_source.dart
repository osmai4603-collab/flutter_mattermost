import 'package:flutter_mattermost/features/teams/data/models/team_member_model.dart';
import 'package:flutter_mattermost/features/teams/data/models/team_unread_model.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/network/api_client.dart';
import 'package:flutter_mattermost/core/network/api_result.dart';
import 'package:flutter_mattermost/core/endpoints/endpoints.dart';

abstract class TeamMembersRemoteDataSource {
  Future<List<TeamMemberModel>> getTeamMembers(
    String teamId, {
    int page = 0,
    int perPage = 60,
  });
  Future<TeamMemberModel> addToTeam(String teamId, String userId);
  Future<TeamMemberModel> addMemberFromInvite({
    String? token,
    String? inviteId,
  });
  Future<List<TeamMemberModel>> addUsersToTeam(
    String teamId,
    List<String> userIds,
  );
  Future<List<TeamMemberModel>> getTeamMembersByIds(
    String teamId,
    List<String> userIds,
  );
  Future<void> removeFromTeam(String teamId, String userId);
  Future<TeamMemberModel> getTeamMember(String teamId, String userId);
  Future<void> updateTeamMemberRoles(
    String teamId,
    String userId,
    List<String> roles,
  );
  Future<void> updateTeamMemberSchemeRoles(
    String teamId,
    String userId, {
    bool schemeAdmin = false,
    bool schemeUser = true,
  });
  Future<List<TeamMemberModel>> teamMembersMinusGroupMembers(
    String teamId, {
    int page = 0,
    int perPage = 60,
  });
  Future<List<TeamMemberModel>> getMyTeamMembers({
    int page = 0,
    int perPage = 60,
  });
  Future<List<TeamUnreadModel>> getMyTeamUnreads({
    bool includeCollapsedThreads = false,
  });
  Future<List<TeamMemberModel>> getTeamMembersForUser(
    String userId, {
    int page = 0,
    int perPage = 60,
  });
  Future<void> markAllInTeamAsRead(String userId, String teamId);
}

@LazySingleton(as: TeamMembersRemoteDataSource)
class TeamMembersRemoteDataSourceImpl implements TeamMembersRemoteDataSource {
  final ApiClient _apiClient;

  TeamMembersRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<TeamMemberModel>> getTeamMembers(
    String teamId, {
    int page = 0,
    int perPage = 60,
  }) async {
    final result = await _apiClient.get<List<TeamMemberModel>>(
      TeamsEndPoint.members(teamId),
      queryParameters: {'page': page, 'per_page': perPage},
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => TeamMemberModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<TeamMemberModel>>) {
      return result.data;
    }
    throw Exception('Failed to get members of team $teamId');
  }

  @override
  Future<TeamMemberModel> addToTeam(String teamId, String userId) async {
    final result = await _apiClient.post<TeamMemberModel>(
      TeamsEndPoint.members(teamId),
      data: {'team_id': teamId, 'user_id': userId},
      fromJson: (json) => TeamMemberModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<TeamMemberModel>) {
      return result.data;
    }
    throw Exception('Failed to add user $userId to team $teamId');
  }

  @override
  Future<TeamMemberModel> addMemberFromInvite({
    String? token,
    String? inviteId,
  }) async {
    final result = await _apiClient.post<TeamMemberModel>(
      TeamsEndPoint.membersInvite,
      queryParameters: {
        if (token != null) 'token': token,
        if (inviteId != null) 'invite_id': inviteId,
      },
      fromJson: (json) => TeamMemberModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<TeamMemberModel>) {
      return result.data;
    }
    throw Exception('Failed to add member from invite');
  }

  @override
  Future<List<TeamMemberModel>> addUsersToTeam(
    String teamId,
    List<String> userIds,
  ) async {
    final result = await _apiClient.post<List<TeamMemberModel>>(
      TeamsEndPoint.membersBatch(teamId),
      data: {'team_id': teamId, 'user_ids': userIds},
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => TeamMemberModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<TeamMemberModel>>) {
      return result.data;
    }
    throw Exception('Failed to add users to team $teamId');
  }

  @override
  Future<List<TeamMemberModel>> getTeamMembersByIds(
    String teamId,
    List<String> userIds,
  ) async {
    final result = await _apiClient.post<List<TeamMemberModel>>(
      TeamsEndPoint.membersIds(teamId),
      data: userIds,
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => TeamMemberModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<TeamMemberModel>>) {
      return result.data;
    }
    throw Exception('Failed to get members by ids for team $teamId');
  }

  @override
  Future<void> removeFromTeam(String teamId, String userId) async {
    await _apiClient.delete(TeamsEndPoint.members2(teamId, userId));
  }

  @override
  Future<TeamMemberModel> getTeamMember(String teamId, String userId) async {
    final result = await _apiClient.get<TeamMemberModel>(
      TeamsEndPoint.members2(teamId, userId),
      fromJson: (json) => TeamMemberModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<TeamMemberModel>) {
      return result.data;
    }
    throw Exception('Failed to get member $userId of team $teamId');
  }

  @override
  Future<void> updateTeamMemberRoles(
    String teamId,
    String userId,
    List<String> roles,
  ) async {
    await _apiClient.put<void>(
      TeamsEndPoint.membersRoles(teamId, userId),
      data: {'roles': roles.join(',')},
      fromJson: (_) {},
    );
  }

  @override
  Future<void> updateTeamMemberSchemeRoles(
    String teamId,
    String userId, {
    bool schemeAdmin = false,
    bool schemeUser = true,
  }) async {
    await _apiClient.put<void>(
      TeamsEndPoint.membersSchemeroles(teamId, userId),
      data: {'scheme_admin': schemeAdmin, 'scheme_user': schemeUser},
      fromJson: (_) {},
    );
  }

  @override
  Future<List<TeamMemberModel>> teamMembersMinusGroupMembers(
    String teamId, {
    int page = 0,
    int perPage = 60,
  }) async {
    final result = await _apiClient.get<List<TeamMemberModel>>(
      TeamsEndPoint.membersMinusGroupMembers(teamId),
      queryParameters: {'page': page, 'per_page': perPage},
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => TeamMemberModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<TeamMemberModel>>) {
      return result.data;
    }
    throw Exception('Failed to get members minus group members for $teamId');
  }

  @override
  Future<List<TeamMemberModel>> getMyTeamMembers({
    int page = 0,
    int perPage = 60,
  }) async {
    final result = await _apiClient.get<List<TeamMemberModel>>(
      UsersEndPoint.teamsMembers('me'),
      queryParameters: {'page': page, 'per_page': perPage},
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => TeamMemberModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<TeamMemberModel>>) {
      return result.data;
    }
    throw Exception('Failed to get my team members');
  }

  @override
  Future<List<TeamUnreadModel>> getMyTeamUnreads({
    String? excludeTeam,
    bool includeCollapsedThreads = false,
  }) async {
    final result = await _apiClient.get<List<TeamUnreadModel>>(
      UsersEndPoint.teamsUnread('me'),
      queryParameters: {
        if (excludeTeam != null) 'exclude_team': excludeTeam,
        if (includeCollapsedThreads) 'include_collapsed_threads': true,
      },
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => TeamUnreadModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<TeamUnreadModel>>) {
      return result.data;
    }
    throw Exception('Failed to get my team unreads');
  }

  @override
  Future<List<TeamMemberModel>> getTeamMembersForUser(
    String userId, {
    int page = 0,
    int perPage = 60,
  }) async {
    final result = await _apiClient.get<List<TeamMemberModel>>(
      UsersEndPoint.teamsMembers(userId),
      queryParameters: {'page': page, 'per_page': perPage},
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => TeamMemberModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<TeamMemberModel>>) {
      return result.data;
    }
    throw Exception('Failed to get team members for user $userId');
  }

  @override
  Future<void> markAllInTeamAsRead(String userId, String teamId) async {
    await _apiClient.put<void>(
      UsersEndPoint.teamsRead(userId, teamId),
      fromJson: (_) {},
    );
  }
}
