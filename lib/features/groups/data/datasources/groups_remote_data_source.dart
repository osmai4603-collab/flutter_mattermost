import 'package:flutter_mattermost/features/groups/data/models/group_member_model.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/endpoints/channels_endpoint.dart';
import 'package:flutter_mattermost/core/endpoints/groups_endpoint.dart';
import 'package:flutter_mattermost/core/endpoints/ldap_endpoint.dart';
import 'package:flutter_mattermost/core/endpoints/teams_endpoint.dart';
import 'package:flutter_mattermost/core/endpoints/users_endpoint.dart';
import 'package:flutter_mattermost/core/network/api_client.dart';
import 'package:flutter_mattermost/core/network/api_result.dart';
import 'package:flutter_mattermost/features/groups/data/models/group_model.dart';
import 'package:flutter_mattermost/features/groups/data/models/group_syncable_channel_model.dart';
import 'package:flutter_mattermost/features/groups/data/models/group_syncable_channels_model.dart';
import 'package:flutter_mattermost/features/groups/data/models/group_syncable_model.dart';
import 'package:flutter_mattermost/features/groups/data/models/group_syncable_team_model.dart';
import 'package:flutter_mattermost/features/groups/data/models/group_syncable_teams_model.dart';
import 'package:flutter_mattermost/features/groups/data/models/group_users_model.dart';
import 'package:flutter_mattermost/features/groups/data/models/groups_associated_to_channels_model.dart';

abstract class GroupsRemoteDataSource {
  Future<List<GroupModel>> getGroups({
    int page = 0,
    int perPage = 60,
    String? q,
    bool includeMemberCount = false,
    String? notAssociatedToTeam,
    String? notAssociatedToChannel,
    int? since,
    bool filterAllowReference = false,
  });
  Future<GroupModel> createGroup({
    required String name,
    required String displayName,
    String? description,
    String? source,
    String? remoteId,
  });
  Future<List<GroupModel>> getGroupsByNames(List<String> names);
  Future<GroupModel> getGroup(String groupId);
  Future<void> archiveGroup(String groupId);
  Future<void> restoreGroup(String groupId);
  Future<GroupModel> patchGroup(
    String groupId, {
    String? name,
    String? displayName,
    String? description,
    String? source,
    String? remoteId,
  });
  Future<Map<String, dynamic>> getGroupStats(String groupId);
  Future<GroupUsersModel> getGroupUsers({
    required String groupId,
    int page = 0,
    int perPage = 60,
  });
  Future<List<GroupMemberModel>> addUsersToGroup(
    String groupId,
    List<String> userIds,
  );
  Future<void> removeUsersFromGroup(String groupId, List<String> userIds);
  Future<List<GroupSyncableChannelsModel>> getChannelSyncables(String groupId);
  Future<List<GroupSyncableTeamsModel>> getTeamSyncables(String groupId);
  Future<List<GroupSyncableModel>> getGroupSyncables(
    String groupId,
    String syncableType,
  );
  Future<GroupSyncableChannelModel> getGroupSyncableForChannelId(
    String groupId,
    String channelId,
  );
  Future<GroupSyncableTeamModel> getGroupSyncableForTeamId(
    String groupId,
    String teamId,
  );
  Future<GroupSyncableChannelModel> linkGroupSyncableForChannel(
    String groupId,
    String channelId,
  );
  Future<GroupSyncableTeamModel> linkGroupSyncableForTeam(
    String groupId,
    String teamId,
  );
  Future<void> unlinkGroupSyncableForChannel(String groupId, String channelId);
  Future<void> unlinkGroupSyncableForTeam(String groupId, String teamId);
  Future<GroupSyncableChannelModel> patchGroupSyncableForChannel(
    String groupId,
    String channelId, {
    bool? autoAdd,
  });
  Future<GroupSyncableTeamModel> patchGroupSyncableForTeam(
    String groupId,
    String teamId, {
    bool? autoAdd,
  });
  Future<GroupSyncableModel> linkGroupSyncable(
    String groupId,
    String syncableType,
    String syncableId,
  );
  Future<void> unlinkGroupSyncable(
    String groupId,
    String syncableType,
    String syncableId,
  );
  Future<GroupSyncableModel> patchGroupSyncable(
    String groupId,
    String syncableType,
    String syncableId, {
    bool? autoAdd,
  });
  Future<List<GroupModel>> getGroupsAssociatedToTeam({
    required String teamId,
    int page = 0,
    int perPage = 60,
  });
  Future<List<GroupModel>> getGroupsAssociatedToChannel({
    required String channelId,
    int page = 0,
    int perPage = 60,
  });
  Future<GroupsAssociatedToChannelsModel> getGroupsAssociatedToChannelsByTeam({
    required String teamId,
    int page = 0,
    int perPage = 60,
    bool filterAllowReference = false,
    bool paginate = false,
  });
  Future<List<GroupModel>> getGroupsByUserId(String userId);
  Future<void> unlinkLdapGroup(String remoteId);
  Future<void> createGroupTeamsAndChannels(String userId);
}

@LazySingleton(as: GroupsRemoteDataSource)
class GroupsRemoteDataSourceImpl implements GroupsRemoteDataSource {
  final ApiClient _apiClient;

  GroupsRemoteDataSourceImpl(this._apiClient);

  List<GroupModel> _fromList(ApiResult<List<GroupModel>> result, String error) {
    if (result is ApiSuccess<List<GroupModel>>) {
      return result.data;
    }
    throw Exception(error);
  }

  GroupModel _from(ApiResult<GroupModel> result, String error) {
    if (result is ApiSuccess<GroupModel>) {
      return result.data;
    }
    throw Exception(error);
  }

  List<GroupModel> _fromGroupJson(dynamic json) => (json as List<dynamic>)
      .map((e) => GroupModel.fromMap(e as Map<String, dynamic>))
      .toList();

  @override
  Future<List<GroupModel>> getGroups({
    int page = 0,
    int perPage = 60,
    String? q,
    bool includeMemberCount = false,
    String? notAssociatedToTeam,
    String? notAssociatedToChannel,
    int? since,
    bool filterAllowReference = false,
  }) async {
    final result = await _apiClient.get<List<GroupModel>>(
      GroupsEndPoint.base,
      queryParameters: {
        'page': page,
        'per_page': perPage,
        'q': q,
        'include_member_count': includeMemberCount,
        'not_associated_to_team': notAssociatedToTeam,
        'not_associated_to_channel': notAssociatedToChannel,
        'since': since,
        'filter_allow_reference': filterAllowReference,
      },
      fromJson: _fromGroupJson,
    );
    return _fromList(result, 'Failed to get groups');
  }

  @override
  Future<GroupModel> createGroup({
    required String name,
    required String displayName,
    String? description,
    String? source,
    String? remoteId,
  }) async {
    final result = await _apiClient.post<GroupModel>(
      GroupsEndPoint.base,
      data: {
        'name': name,
        'display_name': displayName,
        if (description != null) 'description': description,
        if (source != null) 'source': source,
        if (remoteId != null) 'remote_id': remoteId,
      },
      fromJson: (json) => GroupModel.fromMap(json as Map<String, dynamic>),
    );
    return _from(result, 'Failed to create group');
  }

  @override
  Future<List<GroupModel>> getGroupsByNames(List<String> names) async {
    final result = await _apiClient.post<List<GroupModel>>(
      GroupsEndPoint.names,
      data: names,
      fromJson: _fromGroupJson,
    );
    return _fromList(result, 'Failed to get groups by names');
  }

  @override
  Future<GroupModel> getGroup(String groupId) async {
    final result = await _apiClient.get<GroupModel>(
      GroupsEndPoint.byGroupId(groupId),
      fromJson: (json) => GroupModel.fromMap(json as Map<String, dynamic>),
    );
    return _from(result, 'Failed to get group');
  }

  @override
  Future<void> archiveGroup(String groupId) async {
    final result = await _apiClient.delete(GroupsEndPoint.byGroupId(groupId));
    if (result is ApiFailure) {
      throw Exception('Failed to archive group');
    }
  }

  @override
  Future<void> restoreGroup(String groupId) async {
    final result = await _apiClient.post<void>(
      GroupsEndPoint.restore(groupId),
      fromJson: (_) {},
    );
    if (result is ApiFailure) {
      throw Exception('Failed to restore group');
    }
  }

  @override
  Future<GroupModel> patchGroup(
    String groupId, {
    String? name,
    String? displayName,
    String? description,
    String? source,
    String? remoteId,
  }) async {
    final result = await _apiClient.put<GroupModel>(
      GroupsEndPoint.patch(groupId),
      data: {
        if (name != null) 'name': name,
        if (displayName != null) 'display_name': displayName,
        if (description != null) 'description': description,
        if (source != null) 'source': source,
        if (remoteId != null) 'remote_id': remoteId,
      },
      fromJson: (json) => GroupModel.fromMap(json as Map<String, dynamic>),
    );
    return _from(result, 'Failed to patch group');
  }

  @override
  Future<Map<String, dynamic>> getGroupStats(String groupId) async {
    final result = await _apiClient.get<Map<String, dynamic>>(
      GroupsEndPoint.stats(groupId),
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to get group stats');
  }

  @override
  Future<GroupUsersModel> getGroupUsers({
    required String groupId,
    int page = 0,
    int perPage = 60,
  }) async {
    final result = await _apiClient.get<GroupUsersModel>(
      GroupsEndPoint.members(groupId),
      queryParameters: {'page': page, 'per_page': perPage},
      fromJson: (json) => GroupUsersModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<GroupUsersModel>) {
      return result.data;
    }
    throw Exception('Failed to get group users');
  }

  @override
  Future<List<GroupMemberModel>> addUsersToGroup(
    String groupId,
    List<String> userIds,
  ) async {
    final result = await _apiClient.post<List<GroupMemberModel>>(
      GroupsEndPoint.members(groupId),
      data: {'user_ids': userIds},
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => GroupMemberModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<GroupMemberModel>>) {
      return result.data;
    }
    throw Exception('Failed to add users to group');
  }

  @override
  Future<void> removeUsersFromGroup(
    String groupId,
    List<String> userIds,
  ) async {
    final result = await _apiClient.delete(
      GroupsEndPoint.members(groupId),
      data: {'user_ids': userIds},
    );
    if (result is ApiFailure) {
      throw Exception('Failed to remove users from group');
    }
  }

  @override
  Future<List<GroupSyncableChannelsModel>> getChannelSyncables(
    String groupId,
  ) async {
    final result = await _apiClient.get<List<GroupSyncableChannelsModel>>(
      GroupsEndPoint.byGroupIdSyncableType(groupId, 'channels'),
      fromJson: (json) => (json as List<dynamic>)
          .map(
            (e) =>
                GroupSyncableChannelsModel.fromMap(e as Map<String, dynamic>),
          )
          .toList(),
    );
    if (result is ApiSuccess<List<GroupSyncableChannelsModel>>) {
      return result.data;
    }
    throw Exception('Failed to get channel syncables');
  }

  @override
  Future<List<GroupSyncableTeamsModel>> getTeamSyncables(String groupId) async {
    final result = await _apiClient.get<List<GroupSyncableTeamsModel>>(
      GroupsEndPoint.byGroupIdSyncableType(groupId, 'teams'),
      fromJson: (json) => (json as List<dynamic>)
          .map(
            (e) => GroupSyncableTeamsModel.fromMap(e as Map<String, dynamic>),
          )
          .toList(),
    );
    if (result is ApiSuccess<List<GroupSyncableTeamsModel>>) {
      return result.data;
    }
    throw Exception('Failed to get team syncables');
  }

  @override
  Future<List<GroupSyncableModel>> getGroupSyncables(
    String groupId,
    String syncableType,
  ) async {
    final result = await _apiClient.get<List<GroupSyncableModel>>(
      GroupsEndPoint.syncables(groupId, syncableType),
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => GroupSyncableModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<GroupSyncableModel>>) {
      return result.data;
    }
    throw Exception('Failed to get group syncables');
  }

  @override
  Future<GroupSyncableChannelModel> getGroupSyncableForChannelId(
    String groupId,
    String channelId,
  ) async {
    final result = await _apiClient.get<GroupSyncableChannelModel>(
      GroupsEndPoint.channelSyncable(groupId, channelId),
      fromJson: (json) =>
          GroupSyncableChannelModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<GroupSyncableChannelModel>) {
      return result.data;
    }
    throw Exception('Failed to get channel syncable');
  }

  @override
  Future<GroupSyncableTeamModel> getGroupSyncableForTeamId(
    String groupId,
    String teamId,
  ) async {
    final result = await _apiClient.get<GroupSyncableTeamModel>(
      GroupsEndPoint.teamSyncable(groupId, teamId),
      fromJson: (json) =>
          GroupSyncableTeamModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<GroupSyncableTeamModel>) {
      return result.data;
    }
    throw Exception('Failed to get team syncable');
  }

  @override
  Future<GroupSyncableChannelModel> linkGroupSyncableForChannel(
    String groupId,
    String channelId,
  ) async {
    final result = await _apiClient.post<GroupSyncableChannelModel>(
      GroupsEndPoint.channelLink(groupId, channelId),
      fromJson: (json) =>
          GroupSyncableChannelModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<GroupSyncableChannelModel>) {
      return result.data;
    }
    throw Exception('Failed to link group to channel');
  }

  @override
  Future<GroupSyncableTeamModel> linkGroupSyncableForTeam(
    String groupId,
    String teamId,
  ) async {
    final result = await _apiClient.post<GroupSyncableTeamModel>(
      GroupsEndPoint.teamLink(groupId, teamId),
      fromJson: (json) =>
          GroupSyncableTeamModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<GroupSyncableTeamModel>) {
      return result.data;
    }
    throw Exception('Failed to link group to team');
  }

  @override
  Future<void> unlinkGroupSyncableForChannel(
    String groupId,
    String channelId,
  ) async {
    final result = await _apiClient.delete(
      GroupsEndPoint.channelLink(groupId, channelId),
    );
    if (result is ApiFailure) {
      throw Exception('Failed to unlink group from channel');
    }
  }

  @override
  Future<void> unlinkGroupSyncableForTeam(String groupId, String teamId) async {
    final result = await _apiClient.delete(
      GroupsEndPoint.teamLink(groupId, teamId),
    );
    if (result is ApiFailure) {
      throw Exception('Failed to unlink group from team');
    }
  }

  @override
  Future<GroupSyncableChannelModel> patchGroupSyncableForChannel(
    String groupId,
    String channelId, {
    bool? autoAdd,
  }) async {
    final result = await _apiClient.put<GroupSyncableChannelModel>(
      GroupsEndPoint.channelPatch(groupId, channelId),
      data: {if (autoAdd != null) 'auto_add': autoAdd},
      fromJson: (json) =>
          GroupSyncableChannelModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<GroupSyncableChannelModel>) {
      return result.data;
    }
    throw Exception('Failed to patch channel syncable');
  }

  @override
  Future<GroupSyncableTeamModel> patchGroupSyncableForTeam(
    String groupId,
    String teamId, {
    bool? autoAdd,
  }) async {
    final result = await _apiClient.put<GroupSyncableTeamModel>(
      GroupsEndPoint.teamPatch(groupId, teamId),
      data: {if (autoAdd != null) 'auto_add': autoAdd},
      fromJson: (json) =>
          GroupSyncableTeamModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<GroupSyncableTeamModel>) {
      return result.data;
    }
    throw Exception('Failed to patch team syncable');
  }

  @override
  Future<GroupSyncableModel> linkGroupSyncable(
    String groupId,
    String syncableType,
    String syncableId,
  ) async {
    final result = await _apiClient.post<GroupSyncableModel>(
      GroupsEndPoint.link(groupId, syncableType, syncableId),
      fromJson: (json) =>
          GroupSyncableModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<GroupSyncableModel>) {
      return result.data;
    }
    throw Exception('Failed to link group syncable');
  }

  @override
  Future<void> unlinkGroupSyncable(
    String groupId,
    String syncableType,
    String syncableId,
  ) async {
    final result = await _apiClient.delete(
      GroupsEndPoint.link(groupId, syncableType, syncableId),
    );
    if (result is ApiFailure) {
      throw Exception('Failed to unlink group syncable');
    }
  }

  @override
  Future<GroupSyncableModel> patchGroupSyncable(
    String groupId,
    String syncableType,
    String syncableId, {
    bool? autoAdd,
  }) async {
    final result = await _apiClient.put<GroupSyncableModel>(
      GroupsEndPoint.patch2(groupId, syncableType, syncableId),
      data: {if (autoAdd != null) 'auto_add': autoAdd},
      fromJson: (json) =>
          GroupSyncableModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<GroupSyncableModel>) {
      return result.data;
    }
    throw Exception('Failed to patch group syncable');
  }

  @override
  Future<List<GroupModel>> getGroupsAssociatedToTeam({
    required String teamId,
    int page = 0,
    int perPage = 60,
  }) async {
    final result = await _apiClient.get<List<GroupModel>>(
      TeamsEndPoint.groups(teamId),
      queryParameters: {'page': page, 'per_page': perPage},
      fromJson: _fromGroupJson,
    );
    return _fromList(result, 'Failed to get groups associated to team');
  }

  @override
  Future<List<GroupModel>> getGroupsAssociatedToChannel({
    required String channelId,
    int page = 0,
    int perPage = 60,
  }) async {
    final result = await _apiClient.get<List<GroupModel>>(
      ChannelsEndPoint.groups(channelId),
      queryParameters: {'page': page, 'per_page': perPage},
      fromJson: _fromGroupJson,
    );
    return _fromList(result, 'Failed to get groups associated to channel');
  }

  @override
  Future<GroupsAssociatedToChannelsModel> getGroupsAssociatedToChannelsByTeam({
    required String teamId,
    int page = 0,
    int perPage = 60,
    bool filterAllowReference = false,
    bool paginate = false,
  }) async {
    final result = await _apiClient.get<GroupsAssociatedToChannelsModel>(
      TeamsEndPoint.groupsByChannels(teamId),
      queryParameters: {
        'page': page,
        'per_page': perPage,
        'filter_allow_reference': filterAllowReference,
        'paginate': paginate,
      },
      fromJson: (json) {
        final data = json as Map<String, dynamic>;
        return GroupsAssociatedToChannelsModel.fromMap(
          (data['groups'] ?? const {}) as Map<String, dynamic>,
        );
      },
    );
    if (result is ApiSuccess<GroupsAssociatedToChannelsModel>) {
      return result.data;
    }
    throw Exception('Failed to get groups associated to channels by team');
  }

  @override
  Future<List<GroupModel>> getGroupsByUserId(String userId) async {
    final result = await _apiClient.get<List<GroupModel>>(
      UsersEndPoint.groups(userId),
      fromJson: _fromGroupJson,
    );
    return _fromList(result, 'Failed to get groups by user');
  }

  @override
  Future<void> unlinkLdapGroup(String remoteId) async {
    final result = await _apiClient.delete(LdapEndPoint.groupsLink(remoteId));
    if (result is ApiFailure) {
      throw Exception('Failed to unlink ldap group');
    }
  }

  @override
  Future<void> createGroupTeamsAndChannels(String userId) async {
    final result = await _apiClient.post<void>(
      LdapEndPoint.usersGroupSyncMemberships(userId),
      fromJson: (_) {},
    );
    if (result is ApiFailure) {
      throw Exception('Failed to create group teams and channels');
    }
  }
}
