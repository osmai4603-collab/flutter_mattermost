import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/network/api_client.dart';
import 'package:flutter_mattermost/core/network/api_result.dart';
import 'package:flutter_mattermost/features/channels/data/models/channel_member_model.dart';
import 'package:flutter_mattermost/features/channels/data/models/channel_moderation_model.dart';

import 'package:flutter_mattermost/core/endpoints/endpoints.dart';

abstract class ChannelMembersRemoteDataSource {
  Future<List<ChannelMemberModel>> getChannelMembers(
    String channelId, {
    int page = 0,
    int perPage = 60,
  });
  Future<List<ChannelMemberModel>> addToChannels(
    String channelId,
    List<String> userIds,
  );
  Future<List<ChannelMemberModel>> getChannelMembersByIds(
    String channelId,
    List<String> userIds,
  );
  Future<ChannelMemberModel> getMyChannelMember(String channelId);
  Future<ChannelMemberModel> setMyChannelAutotranslation(
    String channelId,
    bool enabled,
  );
  Future<ChannelMemberModel> getChannelMember(String channelId, String userId);
  Future<void> removeFromChannel(String channelId, String userId);
  Future<ChannelMemberModel> updateChannelMemberNotifyProps(
    String channelId,
    String userId,
    Map<String, dynamic> notifyProps,
  );
  Future<ChannelMemberModel> updateChannelMemberRoles(
    String channelId,
    String userId,
    List<String> roles,
  );
  Future<ChannelMemberModel> updateChannelMemberSchemeRoles(
    String channelId,
    String userId, {
    bool schemeAdmin = false,
    bool schemeUser = true,
    bool schemeGuest = false,
  });
  Future<List<ChannelMemberModel>> channelMembersMinusGroupMembers(
    String channelId, {
    int page = 0,
    int perPage = 60,
  });
  Future<Map<String, dynamic>> getChannelMemberCountsByGroup(
    String channelId, {
    bool includeTimezones = false,
  });
  Future<List<ChannelModerationModel>> getChannelModerations(String channelId);
  Future<List<ChannelModerationModel>> patchChannelModerations(
    String channelId,
    List<Map<String, dynamic>> body,
  );
  Future<List<ChannelMemberModel>> getMyChannelMembers(
    String teamId, {
    int page = 0,
    int perPage = 60,
  });
  Future<List<ChannelMemberModel>> getAllChannelsMembers({
    int page = 0,
    int perPage = 60,
  });
}

@LazySingleton(as: ChannelMembersRemoteDataSource)
class ChannelMembersRemoteDataSourceImpl
    implements ChannelMembersRemoteDataSource {
  final ApiClient _apiClient;

  ChannelMembersRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<ChannelMemberModel>> getChannelMembers(
    String channelId, {
    int page = 0,
    int perPage = 60,
  }) async {
    final result = await _apiClient.get<List<ChannelMemberModel>>(
      ChannelsEndPoint.members(channelId),
      queryParameters: {'page': page, 'per_page': perPage},
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => ChannelMemberModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<ChannelMemberModel>>) {
      return result.data;
    }
    throw Exception('Failed to get members of channel $channelId');
  }

  @override
  Future<List<ChannelMemberModel>> addToChannels(
    String channelId,
    List<String> userIds,
  ) async {
    final result = await _apiClient.post<List<ChannelMemberModel>>(
      ChannelsEndPoint.members(channelId),
      data: userIds,
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => ChannelMemberModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<ChannelMemberModel>>) {
      return result.data;
    }
    throw Exception('Failed to add members to channel $channelId');
  }

  @override
  Future<List<ChannelMemberModel>> getChannelMembersByIds(
    String channelId,
    List<String> userIds,
  ) async {
    final result = await _apiClient.post<List<ChannelMemberModel>>(
      ChannelsEndPoint.membersIds(channelId),
      data: userIds,
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => ChannelMemberModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<ChannelMemberModel>>) {
      return result.data;
    }
    throw Exception('Failed to get members by ids in channel $channelId');
  }

  @override
  Future<ChannelMemberModel> getMyChannelMember(String channelId) async {
    final result = await _apiClient.get<ChannelMemberModel>(
      ChannelsEndPoint.members2(channelId, 'me'),
      fromJson: (json) =>
          ChannelMemberModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<ChannelMemberModel>) {
      return result.data;
    }
    throw Exception('Failed to get my member of channel $channelId');
  }

  @override
  Future<ChannelMemberModel> setMyChannelAutotranslation(
    String channelId,
    bool enabled,
  ) async {
    final result = await _apiClient.put<ChannelMemberModel>(
      ChannelsEndPoint.membersAutotranslation(channelId, 'me'),
      data: {'enabled': enabled},
      fromJson: (json) =>
          ChannelMemberModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<ChannelMemberModel>) {
      return result.data;
    }
    throw Exception('Failed to set autotranslation in channel $channelId');
  }

  @override
  Future<ChannelMemberModel> getChannelMember(
    String channelId,
    String userId,
  ) async {
    final result = await _apiClient.get<ChannelMemberModel>(
      ChannelsEndPoint.members2(channelId, userId),
      fromJson: (json) =>
          ChannelMemberModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<ChannelMemberModel>) {
      return result.data;
    }
    throw Exception('Failed to get member $userId of channel $channelId');
  }

  @override
  Future<void> removeFromChannel(String channelId, String userId) async {
    await _apiClient.delete(ChannelsEndPoint.members2(channelId, userId));
  }

  @override
  Future<ChannelMemberModel> updateChannelMemberNotifyProps(
    String channelId,
    String userId,
    Map<String, dynamic> notifyProps,
  ) async {
    final result = await _apiClient.put<ChannelMemberModel>(
      ChannelsEndPoint.membersNotifyProps(channelId, userId),
      data: notifyProps,
      fromJson: (json) =>
          ChannelMemberModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<ChannelMemberModel>) {
      return result.data;
    }
    throw Exception('Failed to update notify props of $userId in $channelId');
  }

  @override
  Future<ChannelMemberModel> updateChannelMemberRoles(
    String channelId,
    String userId,
    List<String> roles,
  ) async {
    final result = await _apiClient.put<ChannelMemberModel>(
      ChannelsEndPoint.membersRoles(channelId, userId),
      data: {'roles': roles.join(',')},
      fromJson: (json) =>
          ChannelMemberModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<ChannelMemberModel>) {
      return result.data;
    }
    throw Exception('Failed to update roles of $userId in $channelId');
  }

  @override
  Future<ChannelMemberModel> updateChannelMemberSchemeRoles(
    String channelId,
    String userId, {
    bool schemeAdmin = false,
    bool schemeUser = true,
    bool schemeGuest = false,
  }) async {
    final result = await _apiClient.put<ChannelMemberModel>(
      ChannelsEndPoint.membersSchemeRoles(channelId, userId),
      data: {
        'scheme_admin': schemeAdmin,
        'scheme_user': schemeUser,
        'scheme_guest': schemeGuest,
      },
      fromJson: (json) =>
          ChannelMemberModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<ChannelMemberModel>) {
      return result.data;
    }
    throw Exception('Failed to update scheme roles of $userId in $channelId');
  }

  @override
  Future<List<ChannelMemberModel>> channelMembersMinusGroupMembers(
    String channelId, {
    int page = 0,
    int perPage = 60,
  }) async {
    final result = await _apiClient.get<List<ChannelMemberModel>>(
      ChannelsEndPoint.membersMinusGroupMembers(channelId),
      queryParameters: {'page': page, 'per_page': perPage},
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => ChannelMemberModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<ChannelMemberModel>>) {
      return result.data;
    }
    throw Exception('Failed to get members minus group members of $channelId');
  }

  @override
  Future<Map<String, dynamic>> getChannelMemberCountsByGroup(
    String channelId, {
    bool includeTimezones = false,
  }) async {
    final result = await _apiClient.get<Map<String, dynamic>>(
      ChannelsEndPoint.memberCountsByGroup(channelId),
      queryParameters: {'include_timezones': includeTimezones},
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to get member counts by group of $channelId');
  }

  @override
  Future<List<ChannelModerationModel>> getChannelModerations(
    String channelId,
  ) async {
    final result = await _apiClient.get<List<ChannelModerationModel>>(
      ChannelsEndPoint.moderations(channelId),
      fromJson: (json) => (json as List<dynamic>)
          .map(
            (e) => ChannelModerationModel.fromMap(e as Map<String, dynamic>),
          )
          .toList(),
    );
    if (result is ApiSuccess<List<ChannelModerationModel>>) {
      return result.data;
    }
    throw Exception('Failed to get moderations of channel $channelId');
  }

  @override
  Future<List<ChannelModerationModel>> patchChannelModerations(
    String channelId,
    List<Map<String, dynamic>> body,
  ) async {
    final result = await _apiClient.put<List<ChannelModerationModel>>(
      ChannelsEndPoint.moderationsPatch(channelId),
      data: body,
      fromJson: (json) => (json as List<dynamic>)
          .map(
            (e) => ChannelModerationModel.fromMap(e as Map<String, dynamic>),
          )
          .toList(),
    );
    if (result is ApiSuccess<List<ChannelModerationModel>>) {
      return result.data;
    }
    throw Exception('Failed to patch moderations of channel $channelId');
  }

  @override
  Future<List<ChannelMemberModel>> getMyChannelMembers(
    String teamId, {
    int page = 0,
    int perPage = 60,
  }) async {
    final result = await _apiClient.get<List<ChannelMemberModel>>(
      UsersEndPoint.teamsChannelsMembers('me', teamId),
      queryParameters: {'page': page, 'per_page': perPage},
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => ChannelMemberModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<ChannelMemberModel>>) {
      return result.data;
    }
    throw Exception('Failed to get my channel members of team $teamId');
  }

  @override
  Future<List<ChannelMemberModel>> getAllChannelsMembers({
    int page = 0,
    int perPage = 60,
  }) async {
    final result = await _apiClient.get<List<ChannelMemberModel>>(
      UsersEndPoint.channelMembers('me'),
      queryParameters: {'page': page, 'per_page': perPage},
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => ChannelMemberModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<ChannelMemberModel>>) {
      return result.data;
    }
    throw Exception('Failed to get all channels members');
  }
}
