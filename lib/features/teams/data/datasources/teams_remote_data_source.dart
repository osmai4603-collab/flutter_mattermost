import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_mattermost/features/teams/data/models/team_stats_model.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/network/api_client.dart';
import 'package:flutter_mattermost/core/network/api_result.dart';
import 'package:flutter_mattermost/features/teams/data/models/team_model.dart';
import 'package:flutter_mattermost/features/teams/data/models/team_member_model.dart';
import 'package:flutter_mattermost/features/teams/data/models/team_unread_model.dart';
import 'package:flutter_mattermost/features/channels/data/models/channel_model.dart';
import 'package:flutter_mattermost/features/groups/data/models/groups_associated_to_channels_model.dart';
import 'package:flutter_mattermost/features/integrations/data/models/autocomplete_suggestion_model.dart';
import 'package:flutter_mattermost/features/integrations/data/models/command_model.dart';
import 'package:flutter_mattermost/core/endpoints/endpoints.dart';

abstract class TeamsRemoteDataSource {
  Future<List<TeamModel>> getTeams({
    int page = 0,
    int perPage = 60,
    bool includeDeleted = false,
  });
  Future<TeamModel> createTeam(Map<String, dynamic> team);
  Future<Map<String, dynamic>> getTeamInviteInfo(String inviteId);
  Future<void> invalidateAllEmailInvites();
  Future<TeamModel> addToTeamFromInvite({String? token, String? inviteId});
  Future<bool> checkIfTeamExists(String teamName);
  Future<List<TeamModel>> searchTeams(Map<String, dynamic> searchParams);
  Future<TeamModel> getTeam(String teamId);
  Future<TeamModel> updateTeam(Map<String, dynamic> team);
  Future<TeamModel> patchTeam(String teamId, Map<String, dynamic> patch);
  Future<void> deleteTeam(String teamId);
  Future<TeamModel> updateTeamPrivacy(String teamId, String privacy);
  Future<void> regenerateTeamInviteId(String teamId);
  Future<TeamModel> unarchiveTeam(String teamId);
  Future<TeamModel> updateTeamScheme(String teamId, String schemeId);
  Future<void> setTeamIcon(String teamId, String filePath);
  Future<void> sendEmailInvitesToTeam(
    String teamId,
    List<String> emails,
  );
  Future<void> sendEmailGuestInvitesToChannels(
    String teamId,
    Map<String, dynamic> payload,
  );
  Future<TeamStatsModel> getTeamStats(String teamId);
  Future<List<TeamModel>> getMyTeams({int page = 0, int perPage = 60});
  Future<List<TeamModel>> getTeamsForUser(
    String userId, {
    int page = 0,
    int perPage = 60,
  });
  Future<TeamModel> getTeamByName(String teamName);
  Future<List<TeamMemberModel>> getTeamMembers(
    String teamId, {
    int page = 0,
    int perPage = 60,
  });
  Future<List<TeamMemberModel>> addUsersToTeam(
    String teamId,
    List<String> userIds,
  );
  Future<List<TeamMemberModel>> addUsersToTeamGracefully(
    String teamId,
    List<String> userIds,
  );
  Future<List<TeamMemberModel>> getTeamMembersByIds(
    String teamId,
    List<String> userIds,
  );
  Future<TeamMemberModel> getTeamMember(String teamId, String userId);
  Future<void> removeUserFromTeam(String teamId, String userId);
  Future<TeamMemberModel> updateTeamMemberRoles(
    String teamId,
    String userId,
    List<String> roles,
  );
  Future<TeamMemberModel> updateTeamMemberSchemeRoles(
    String teamId,
    String userId, {
    bool schemeAdmin = false,
    bool schemeUser = true,
    bool schemeGuest = false,
  });
  Future<TeamMemberModel> updateTeamMemberNotifyProps(
    String teamId,
    String userId,
    Map<String, dynamic> notifyProps,
  );
  Future<List<TeamMemberModel>> getTeamMembersMinusGroupMembers(
    String teamId, {
    int page = 0,
    int perPage = 60,
  });
  Future<Map<String, dynamic>> getTeamMemberCountsByGroup(
    String teamId, {
    bool includeTimezones = false,
  });
  Future<List<String>> getTeamTimezones(String teamId);
  Future<List<TeamUnreadModel>> getTeamsUnreadForUser(
    String userId,
  );
  Future<TeamUnreadModel> getTeamUnreadForUser(
    String userId,
    String teamId,
  );
  Future<List<TeamModel>> searchArchivedTeams({int page = 0, int perPage = 60});
  Future<List<ChannelModel>> getChannelIdsInTeam(
    String teamId,
    List<String> channelIds,
  );
  Future<ChannelModel> createPrivateChannel(
    String teamId, {
    required String name,
    required String displayName,
    String? purpose,
    String? header,
  });
  Future<List<CommandModel>> autocompleteCommandsInTeam(String teamId);
  Future<List<AutocompleteSuggestionModel>> autocompleteCommandSuggestions(
    String teamId, {
    String? prefix,
    String? command,
  });
  Future<Map<String, dynamic>> getChannelsManagedCategories(
    String teamId,
  );
  Future<GroupsAssociatedToChannelsModel> getGroupsByChannels(String teamId);
  Future<Map<String, dynamic>> importTeam(
    String teamId,
    Map<String, dynamic> data,
  );

  // Missing operations from docs
  Future<TeamMemberModel> addTeamMember(String teamId, String userId);
  Future<TeamMemberModel> addTeamMemberFromInvite({String? token, String? inviteId});
  Future<List<TeamMemberModel>> addTeamMembers(String teamId, List<String> userIds);
  Future<void> inviteGuestsToTeam(String teamId, Map<String, dynamic> guests);
  Future<void> inviteUsersToTeam(String teamId, List<String> emails);
  Future<void> invalidateEmailInvites();
  Future<void> removeTeamMember(String teamId, String userId);
  Future<void> softDeleteTeam(String teamId);
  Future<Uint8List> getTeamIcon(String teamId);
  Future<void> removeTeamIcon(String teamId);
}

@LazySingleton(as: TeamsRemoteDataSource)
class TeamsRemoteDataSourceImpl implements TeamsRemoteDataSource {
  final ApiClient _apiClient;

  TeamsRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<TeamModel>> getTeams({
    int page = 0,
    int perPage = 60,
    bool includeDeleted = false,
  }) async {
    final result = await _apiClient.get<List<TeamModel>>(
      TeamsEndPoint.base,
      queryParameters: {
        'page': page,
        'per_page': perPage,
        'include_deleted': includeDeleted,
      },
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => TeamModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<TeamModel>>) {
      return result.data;
    }
    throw Exception('Failed to get teams');
  }

  @override
  Future<TeamModel> createTeam(Map<String, dynamic> team) async {
    final result = await _apiClient.post<TeamModel>(
      TeamsEndPoint.base,
      data: team,
      fromJson: (json) => TeamModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<TeamModel>) {
      return result.data;
    }
    throw Exception('Failed to create team');
  }

  @override
  Future<Map<String, dynamic>> getTeamInviteInfo(String inviteId) async {
    final result = await _apiClient.get<Map<String, dynamic>>(
      TeamsEndPoint.invite(inviteId),
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to get team invite info');
  }

  @override
  Future<void> invalidateAllEmailInvites() async {
    await _apiClient.delete(TeamsEndPoint.invitesEmail);
  }

  @override
  Future<TeamModel> addToTeamFromInvite({String? token, String? inviteId}) async {
    final result = await _apiClient.post<TeamModel>(
      TeamsEndPoint.membersInvite,
      data: {'token': token ?? '', 'invite_id': inviteId ?? ''},
      fromJson: (json) => TeamModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<TeamModel>) {
      return result.data;
    }
    throw Exception('Failed to join team from invite');
  }

  @override
  Future<bool> checkIfTeamExists(String teamName) async {
    final result = await _apiClient.get<Map<String, dynamic>>(
      TeamsEndPoint.nameExists(teamName),
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return (result.data['exists'] as bool?) ?? false;
    }
    throw Exception('Failed to check team existence');
  }

  @override
  Future<List<TeamModel>> searchTeams(Map<String, dynamic> searchParams) async {
    final result = await _apiClient.post<List<TeamModel>>(
      TeamsEndPoint.search,
      data: searchParams,
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => TeamModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<TeamModel>>) {
      return result.data;
    }
    throw Exception('Failed to search teams');
  }

  @override
  Future<TeamModel> getTeam(String teamId) async {
    final result = await _apiClient.get<TeamModel>(
      TeamsEndPoint.byTeamId(teamId),
      fromJson: (json) => TeamModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<TeamModel>) {
      return result.data;
    }
    throw Exception('Failed to get team $teamId');
  }

  @override
  Future<TeamModel> updateTeam(Map<String, dynamic> team) async {
    final teamId = team['id'] as String;
    final result = await _apiClient.put<TeamModel>(
      TeamsEndPoint.byTeamId(teamId),
      data: team,
      fromJson: (json) => TeamModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<TeamModel>) {
      return result.data;
    }
    throw Exception('Failed to update team $teamId');
  }

  @override
  Future<TeamModel> patchTeam(String teamId, Map<String, dynamic> patch) async {
    final result = await _apiClient.put<TeamModel>(
      TeamsEndPoint.patch(teamId),
      data: patch,
      fromJson: (json) => TeamModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<TeamModel>) {
      return result.data;
    }
    throw Exception('Failed to patch team $teamId');
  }

  @override
  Future<void> deleteTeam(String teamId) async {
    await _apiClient.delete(TeamsEndPoint.byTeamId(teamId));
  }

  @override
  Future<TeamModel> updateTeamPrivacy(String teamId, String privacy) async {
    final result = await _apiClient.put<TeamModel>(
      TeamsEndPoint.privacy(teamId),
      data: {'privacy': privacy},
      fromJson: (json) => TeamModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<TeamModel>) {
      return result.data;
    }
    throw Exception('Failed to update team privacy');
  }

  @override
  Future<void> regenerateTeamInviteId(String teamId) async {
    await _apiClient.post<void>(
      TeamsEndPoint.regenerateInviteId(teamId),
      fromJson: (_) {},
    );
  }

  @override
  Future<TeamModel> unarchiveTeam(String teamId) async {
    final result = await _apiClient.post<TeamModel>(
      TeamsEndPoint.restore(teamId),
      fromJson: (json) => TeamModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<TeamModel>) {
      return result.data;
    }
    throw Exception('Failed to unarchive team $teamId');
  }

  @override
  Future<TeamModel> updateTeamScheme(String teamId, String schemeId) async {
    final result = await _apiClient.put<TeamModel>(
      TeamsEndPoint.scheme(teamId),
      data: {'scheme_id': schemeId},
      fromJson: (json) => TeamModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<TeamModel>) {
      return result.data;
    }
    throw Exception('Failed to update team scheme');
  }

  @override
  Future<void> setTeamIcon(String teamId, String filePath) async {
    final formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(filePath),
    });
    await _apiClient.dio.post(
      TeamsEndPoint.image(teamId),
      data: formData,
      options: Options(headers: {'Content-Type': 'multipart/form-data'}),
    );
  }

  @override
  Future<void> sendEmailInvitesToTeam(
    String teamId,
    List<String> emails,
  ) async {
    await _apiClient.post<void>(
      TeamsEndPoint.inviteEmail(teamId),
      data: {'emails': emails},
      fromJson: (_) {},
    );
  }

  @override
  Future<void> sendEmailGuestInvitesToChannels(
    String teamId,
    Map<String, dynamic> payload,
  ) async {
    await _apiClient.post<void>(
      TeamsEndPoint.inviteGuestsEmail(teamId),
      data: payload,
      fromJson: (_) {},
    );
  }

  @override
  Future<TeamStatsModel> getTeamStats(String teamId) async {
    final result = await _apiClient.get<TeamStatsModel>(
      TeamsEndPoint.stats(teamId),
      fromJson: (json) => TeamStatsModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<TeamStatsModel>) {
      return result.data;
    }
    throw Exception('Failed to get team stats for $teamId');
  }

  @override
  Future<List<TeamModel>> getMyTeams({int page = 0, int perPage = 60}) async {
    final result = await _apiClient.get<List<TeamModel>>(
      UsersEndPoint.teams('me'),
      queryParameters: {'page': page, 'per_page': perPage},
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => TeamModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<TeamModel>>) {
      return result.data;
    }
    throw Exception('Failed to get my teams');
  }

  @override
  Future<List<TeamModel>> getTeamsForUser(
    String userId, {
    int page = 0,
    int perPage = 60,
  }) async {
    final result = await _apiClient.get<List<TeamModel>>(
      UsersEndPoint.teams(userId),
      queryParameters: {'page': page, 'per_page': perPage},
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => TeamModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<TeamModel>>) {
      return result.data;
    }
    throw Exception('Failed to get teams for user $userId');
  }

  @override
  Future<TeamModel> getTeamByName(String teamName) async {
    final result = await _apiClient.get<TeamModel>(
      TeamsEndPoint.name(teamName),
      fromJson: (json) => TeamModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<TeamModel>) {
      return result.data;
    }
    throw Exception('Failed to get team by name $teamName');
  }

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
  Future<List<TeamMemberModel>> addUsersToTeam(
    String teamId,
    List<String> userIds,
  ) async {
    final result = await _apiClient.post<List<TeamMemberModel>>(
      TeamsEndPoint.members(teamId),
      data: userIds,
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
  Future<List<TeamMemberModel>> addUsersToTeamGracefully(
    String teamId,
    List<String> userIds,
  ) async {
    final result = await _apiClient.post<List<TeamMemberModel>>(
      TeamsEndPoint.membersBatch(teamId),
      data: userIds,
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => TeamMemberModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<TeamMemberModel>>) {
      return result.data;
    }
    throw Exception('Failed to gracefully add users to team $teamId');
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
    throw Exception('Failed to get members by ids in team $teamId');
  }

  @override
  Future<TeamMemberModel> getTeamMember(
    String teamId,
    String userId,
  ) async {
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
  Future<void> removeUserFromTeam(String teamId, String userId) async {
    await _apiClient.delete(TeamsEndPoint.members2(teamId, userId));
  }

  @override
  Future<TeamMemberModel> updateTeamMemberRoles(
    String teamId,
    String userId,
    List<String> roles,
  ) async {
    final result = await _apiClient.put<TeamMemberModel>(
      TeamsEndPoint.membersRoles(teamId, userId),
      data: {'roles': roles.join(',')},
      fromJson: (json) => TeamMemberModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<TeamMemberModel>) {
      return result.data;
    }
    throw Exception('Failed to update roles of user $userId in team $teamId');
  }

  @override
  Future<TeamMemberModel> updateTeamMemberSchemeRoles(
    String teamId,
    String userId, {
    bool schemeAdmin = false,
    bool schemeUser = true,
    bool schemeGuest = false,
  }) async {
    final result = await _apiClient.put<TeamMemberModel>(
      TeamsEndPoint.membersSchemeroles(teamId, userId),
      data: {
        'scheme_admin': schemeAdmin,
        'scheme_user': schemeUser,
        'scheme_guest': schemeGuest,
      },
      fromJson: (json) => TeamMemberModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<TeamMemberModel>) {
      return result.data;
    }
    throw Exception('Failed to update scheme roles of $userId in team $teamId');
  }

  @override
  Future<TeamMemberModel> updateTeamMemberNotifyProps(
    String teamId,
    String userId,
    Map<String, dynamic> notifyProps,
  ) async {
    final result = await _apiClient.put<TeamMemberModel>(
      TeamsEndPoint.membersNotifyProps(teamId, userId),
      data: notifyProps,
      fromJson: (json) => TeamMemberModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<TeamMemberModel>) {
      return result.data;
    }
    throw Exception('Failed to update notify props of $userId in team $teamId');
  }

  @override
  Future<List<TeamMemberModel>> getTeamMembersMinusGroupMembers(
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
  Future<Map<String, dynamic>> getTeamMemberCountsByGroup(
    String teamId, {
    bool includeTimezones = false,
  }) async {
    final result = await _apiClient.get<Map<String, dynamic>>(
      TeamsEndPoint.memberCountsByGroup(teamId),
      queryParameters: {'include_timezones': includeTimezones},
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to get member counts by group for $teamId');
  }

  @override
  Future<List<String>> getTeamTimezones(String teamId) async {
    final result = await _apiClient.get<List<String>>(
      TeamsEndPoint.timezones(teamId),
      fromJson: (json) => (json as List<dynamic>).cast<String>(),
    );
    if (result is ApiSuccess<List<String>>) {
      return result.data;
    }
    throw Exception('Failed to get timezones of team $teamId');
  }

  @override
  Future<List<TeamUnreadModel>> getTeamsUnreadForUser(
    String userId,
  ) async {
    final result = await _apiClient.get<List<TeamUnreadModel>>(
      UsersEndPoint.teamsUnread(userId),
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => TeamUnreadModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<TeamUnreadModel>>) {
      return result.data;
    }
    throw Exception('Failed to get unread teams for user $userId');
  }

  @override
  Future<TeamUnreadModel> getTeamUnreadForUser(
    String userId,
    String teamId,
  ) async {
    final result = await _apiClient.get<TeamUnreadModel>(
      UsersEndPoint.teamsUnread2(userId, teamId),
      fromJson: (json) =>
          TeamUnreadModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<TeamUnreadModel>) {
      return result.data;
    }
    throw Exception('Failed to get unread for team $teamId');
  }

  @override
  Future<List<TeamModel>> searchArchivedTeams({
    int page = 0,
    int perPage = 60,
  }) async {
    // The teams search endpoint is a POST that can return either a paginated
    // object `{ teams: [], total_count: N }` or a plain array. Use POST
    // with the same shape as searchTeams but allow both response shapes.
    final result = await _apiClient.post<dynamic>(
      TeamsEndPoint.search,
      data: {'page': page, 'per_page': perPage},
      fromJson: (json) => json,
    );
    if (result is ApiSuccess) {
      final data = result.data;
      if (data is Map && data['teams'] is List) {
        return (data['teams'] as List<dynamic>)
            .map((e) => TeamModel.fromMap(e as Map<String, dynamic>))
            .toList();
      }
      if (data is List) {
        return data
            .map((e) => TeamModel.fromMap(e as Map<String, dynamic>))
            .toList();
      }
    }
    throw Exception('Failed to search archived teams');
  }

  @override
  Future<List<ChannelModel>> getChannelIdsInTeam(
    String teamId,
    List<String> channelIds,
  ) async {
    final result = await _apiClient.post<List<ChannelModel>>(
      TeamsEndPoint.channelsIds(teamId),
      data: {'channel_ids': channelIds},
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => ChannelModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<ChannelModel>>) {
      return result.data;
    }
    throw Exception('Failed to get channel ids in team $teamId');
  }

  @override
  Future<ChannelModel> createPrivateChannel(
    String teamId, {
    required String name,
    required String displayName,
    String? purpose,
    String? header,
  }) async {
    final result = await _apiClient.post<ChannelModel>(
      TeamsEndPoint.channelsPrivate(teamId),
      data: {
        'name': name,
        'display_name': displayName,
        if (purpose != null) 'purpose': purpose,
        if (header != null) 'header': header,
      },
      fromJson: (json) => ChannelModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<ChannelModel>) {
      return result.data;
    }
    throw Exception('Failed to create private channel');
  }

  @override
  Future<List<CommandModel>> autocompleteCommandsInTeam(
    String teamId,
  ) async {
    final result = await _apiClient.get<List<CommandModel>>(
      TeamsEndPoint.commandsAutocomplete(teamId),
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => CommandModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<CommandModel>>) {
      return result.data;
    }
    throw Exception('Failed to autocomplete commands in team $teamId');
  }

  @override
  Future<List<AutocompleteSuggestionModel>> autocompleteCommandSuggestions(
    String teamId, {
    String? prefix,
    String? command,
  }) async {
    final result = await _apiClient.get<List<AutocompleteSuggestionModel>>(
      TeamsEndPoint.commandsAutocompleteSuggestions(teamId),
      queryParameters: {
        if (prefix != null) 'prefix': prefix,
        if (command != null) 'command': command,
      },
      fromJson: (json) => (json as List<dynamic>)
          .map(
            (e) => AutocompleteSuggestionModel.fromMap(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
    if (result is ApiSuccess<List<AutocompleteSuggestionModel>>) {
      return result.data;
    }
    throw Exception('Failed to get command suggestions');
  }

  @override
  Future<Map<String, dynamic>> getChannelsManagedCategories(
    String teamId,
  ) async {
    final result = await _apiClient.get<Map<String, dynamic>>(
      TeamsEndPoint.channelsManagedCategories(teamId),
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to get managed categories for team $teamId');
  }

  @override
  Future<GroupsAssociatedToChannelsModel> getGroupsByChannels(
    String teamId,
  ) async {
    final result = await _apiClient.get<GroupsAssociatedToChannelsModel>(
      TeamsEndPoint.groupsByChannels(teamId),
      fromJson: (json) =>
          GroupsAssociatedToChannelsModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<GroupsAssociatedToChannelsModel>) {
      return result.data;
    }
    throw Exception('Failed to get groups by channels for team $teamId');
  }

  @override
  Future<Map<String, dynamic>> importTeam(
    String teamId,
    Map<String, dynamic> data,
  ) async {
    final result = await _apiClient.post<Map<String, dynamic>>(
      TeamsEndPoint.import(teamId),
      data: data,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to import team $teamId');
  }

  @override
  Future<TeamMemberModel> addTeamMember(String teamId, String userId) async {
    final result = await _apiClient.post<TeamMemberModel>(
      TeamsEndPoint.members(teamId),
      data: {'team_id': teamId, 'user_id': userId},
      fromJson: (json) => TeamMemberModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<TeamMemberModel>) {
      return result.data;
    }
    throw Exception('Failed to add member to team $teamId');
  }

  @override
  Future<TeamMemberModel> addTeamMemberFromInvite({String? token, String? inviteId}) async {
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
  Future<List<TeamMemberModel>> addTeamMembers(String teamId, List<String> userIds) async {
    final result = await _apiClient.post<List<TeamMemberModel>>(
      TeamsEndPoint.membersBatch(teamId),
      data: userIds.map((id) => {'team_id': teamId, 'user_id': id}).toList(),
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => TeamMemberModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<TeamMemberModel>>) {
      return result.data;
    }
    throw Exception('Failed to add members to team $teamId');
  }

  @override
  Future<void> inviteGuestsToTeam(String teamId, Map<String, dynamic> guests) async {
    await _apiClient.post<void>(
      TeamsEndPoint.inviteGuestsEmail(teamId),
      data: guests,
      fromJson: (_) {},
    );
  }

  @override
  Future<void> inviteUsersToTeam(String teamId, List<String> emails) async {
    await _apiClient.post<void>(
      TeamsEndPoint.inviteEmail(teamId),
      data: {'emails': emails},
      fromJson: (_) {},
    );
  }

  @override
  Future<void> invalidateEmailInvites() async {
    await _apiClient.delete(TeamsEndPoint.invitesEmail);
  }

  @override
  Future<void> removeTeamMember(String teamId, String userId) async {
    await _apiClient.delete(TeamsEndPoint.members2(teamId, userId));
  }

  @override
  Future<void> softDeleteTeam(String teamId) async {
    await _apiClient.delete(TeamsEndPoint.byTeamId(teamId));
  }

  @override
  Future<Uint8List> getTeamIcon(String teamId) async {
    final response = await _apiClient.dio.get(
      TeamsEndPoint.image(teamId),
      options: Options(responseType: ResponseType.bytes),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to get team icon');
    }
    return response.data as Uint8List;
  }

  @override
  Future<void> removeTeamIcon(String teamId) async {
    await _apiClient.delete(TeamsEndPoint.image(teamId));
  }
}
