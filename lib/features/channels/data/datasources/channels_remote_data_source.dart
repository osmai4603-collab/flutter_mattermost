import 'package:dio/dio.dart';
import 'package:flutter_mattermost/features/channels/data/models/channel_member_model.dart';
import 'package:flutter_mattermost/features/channels/data/models/channel_stats_model.dart';
import 'package:flutter_mattermost/features/channels/data/models/channel_unread_model.dart';
import 'package:flutter_mattermost/features/channels/data/models/sidebar_category_model.dart';
import 'package:flutter_mattermost/features/channels/data/models/view_model.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/network/api_client.dart';
import 'package:flutter_mattermost/core/network/api_result.dart';
import 'package:flutter_mattermost/features/channels/data/models/channel_model.dart';
import 'package:flutter_mattermost/features/chat/data/models/post_list_model.dart';

import 'package:flutter_mattermost/core/endpoints/endpoints.dart';

abstract class ChannelRemoteDataSource {
  // CRUD
  Future<ChannelModel> getChannelById(String channelId);
  Future<ChannelModel> createChannel({
    required String teamId,
    required String displayName,
    required String name,
    required String type,
    String purpose = '',
  });
  Future<ChannelModel> updateChannel({
    required String id,
    required String teamId,
    required String displayName,
    required String name,
    required String type,
    String? purpose,
    String? header,
  });
  Future<ChannelModel> patchChannel(
    String channelId, {
    String? name,
    String? displayName,
    String? purpose,
    String? header,
    Map<String, dynamic>? notifyProps,
  });
  Future<void> deleteChannel(String channelId);
  Future<ChannelModel> unarchiveChannel(String channelId);
  Future<ChannelModel> updateChannelPrivacy(String channelId, String privacy);
  Future<ChannelModel> updateChannelScheme(String channelId, String schemeId);
  Future<ChannelStatsModel> getChannelStats(String channelId);
  Future<List<String>> getChannelTimezones(String channelId);
  Future<int> getChannelStatsMemberCount(String channelId);
  Future<Map<String, dynamic>> markChannelsAsViewed(
    Map<String, dynamic> viewData,
  );
  Future<ChannelUnreadModel> markChannelAsViewed(
    String channelId,
    Map<String, dynamic> viewData,
  );
  Future<PostListModel> getChannelViewPosts(
    String channelId,
    String viewId, {
    int page = 0,
    int perPage = 60,
  });
  Future<ViewModel> updateChannelViewSortOrder(
    String channelId,
    String viewId, {
    required String sortOrder,
  });
  Future<void> deleteChannelView(String channelId, String viewId);

  // Direct / Group
  Future<ChannelModel> createDirectChannel(
    String userId, {
    List<String>? otherUserIds,
  });
  Future<ChannelModel> createGroupChannel(List<String> userIds);
  Future<List<ChannelModel>> searchGroupChannels(String term);
  Future<ChannelModel> convertGroupMessageToPrivateChannel(
    String channelId,
    String teamId, {
    String? name,
    String? displayName,
  });
  Future<List<String>> getGroupMessageMembersCommonTeams(String channelId);

  // Reading / viewing
  Future<List<ChannelModel>> getPublicChannels({
    int page = 0,
    int perPage = 60,
  });
  Future<List<ChannelModel>> searchChannels(Map<String, dynamic> searchParams);
  Future<void> viewMyChannel(
    String channelId, {
    String? prevChannelId,
    bool collapsedThreads = false,
  });
  Future<void> readMultipleChannels(
    List<String> channelIds, {
    bool collapsedThreads = false,
  });
  Future<void> markAllMessagesAsRead(String userId, String channelId);

  // Team-scoped channels
  Future<List<ChannelModel>> getChannelsForTeam(
    String teamId, {
    int page = 0,
    int perPage = 60,
  });
  Future<List<ChannelModel>> getArchivedChannels(
    String teamId, {
    int page = 0,
    int perPage = 60,
  });
  Future<ChannelModel> getChannelByName(
    String teamId,
    String channelName, {
    bool includeDeleted = false,
  });
  Future<ChannelModel> getChannelByNameAndTeamName(
    String teamName,
    String channelName, {
    bool includeDeleted = false,
  });
  Future<List<ChannelModel>> autocompleteChannels(
    String teamId,
    String term, {
    bool includeDeleted = false,
  });
  Future<List<ChannelModel>> autocompleteChannelsForSearch(
    String teamId,
    String term,
  );
  Future<List<ChannelModel>> getRecommendedChannelsForUser(String teamId);
  Future<List<ChannelModel>> searchChannelsForTeam(
    String teamId,
    Map<String, dynamic> searchParams,
  );

  // My channels
  Future<List<ChannelModel>> getAllTeamsChannels();
  Future<List<ChannelModel>> getMyChannels(
    String teamId, {
    int page = 0,
    int perPage = 60,
  });
  Future<Map<String, int>> getChannelsMemberCount(List<String> channelIds);
  Future<ChannelModel> moveChannel(String channelId, Map<String, dynamic> data);
  Future<ChannelModel> createBoard({
    required String boardType,
    required String boardName,
    required String channelId,
  });

  // Missing operations from docs
  Future<ChannelMemberModel> addChannelMember(String channelId, String userId);
  Future<List<ChannelMemberModel>> getChannelMembers(
    String channelId, {
    int page = 0,
    int perPage = 60,
  });
  Future<List<ChannelMemberModel>> getChannelMembersByIds(
    String channelId,
    List<String> userIds,
  );
  Future<void> removeUserFromChannel(String channelId, String userId);
  Future<void> restoreChannel(String channelId);
  Future<List<ChannelModel>> searchAllChannels(
    Map<String, dynamic> searchParams,
  );
  Future<List<ChannelMemberModel>> setChannelMembers(
    String channelId,
    List<String> userIds,
  );
  Future<void> updateChannelMemberAutotranslation(
    String channelId,
    String userId,
    bool enable,
  );
  Future<void> updateChannelNotifyProps(
    String channelId,
    String userId,
    Map<String, dynamic> props,
  );
  Future<ChannelMemberModel> updateChannelRoles(
    String channelId,
    String userId,
    List<String> roles,
  );
  Future<void> viewChannel(String userId, Map<String, dynamic> viewData);
  Future<List<ChannelModel>> getDeletedChannelsForTeam(
    String teamId, {
    int page = 0,
    int perPage = 60,
  });
  Future<List<ChannelModel>> getPrivateChannelsForTeam(
    String teamId, {
    int page = 0,
    int perPage = 60,
  });
  Future<List<ChannelModel>> getPublicChannelsByIdsForTeam(
    String teamId,
    List<String> channelIds,
  );
  Future<List<ChannelModel>> getPublicChannelsForTeam(
    String teamId, {
    int page = 0,
    int perPage = 60,
  });
  Future<List<SidebarCategoryModel>> getSidebarCategoriesForTeamForUser(
    String userId,
    String teamId,
  );
  Future<SidebarCategoryModel> getSidebarCategoryForTeamForUser(
    String userId,
    String teamId,
    String categoryId,
  );
  Future<List<String>> getSidebarCategoryOrderForTeamForUser(
    String userId,
    String teamId,
  );
  Future<void> removeSidebarCategoryForTeamForUser(
    String userId,
    String teamId,
    String categoryId,
  );
  Future<SidebarCategoryModel> updateSidebarCategoryForTeamForUser(
    String userId,
    String teamId,
    String categoryId,
    Map<String, dynamic> category,
  );
  Future<void> updateSidebarCategoryOrderForTeamForUser(
    String userId,
    String teamId,
    List<String> categoryIds,
  );
  Future<List<SidebarCategoryModel>> updateSidebarCategoriesForTeamForUser(
    String userId,
    String teamId,
    List<Map<String, dynamic>> categories,
  );
  Future<SidebarCategoryModel> createSidebarCategoryForTeamForUser(
    String userId,
    String teamId,
    Map<String, dynamic> category,
  );
}

@LazySingleton(as: ChannelRemoteDataSource)
class ChannelRemoteDataSourceImpl implements ChannelRemoteDataSource {
  final ApiClient _apiClient;

  ChannelRemoteDataSourceImpl(this._apiClient);

  @override
  Future<ChannelModel> getChannelById(String channelId) async {
    final result = await _apiClient.get<ChannelModel>(
      ChannelsEndPoint.byChannelId(channelId),
      fromJson: (json) => ChannelModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<ChannelModel>) {
      return result.data;
    }
    throw Exception('Failed to get channel $channelId');
  }

  @override
  Future<ChannelModel> createChannel({
    required String teamId,
    required String displayName,
    required String name,
    required String type,
    String purpose = '',
  }) async {
    final result = await _apiClient.post<ChannelModel>(
      ChannelsEndPoint.base,
      data: {
        'team_id': teamId,
        'display_name': displayName,
        'name': name,
        'type': type,
        if (purpose.isNotEmpty) 'purpose': purpose,
      },
      fromJson: (json) => ChannelModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<ChannelModel>) {
      return result.data;
    }
    throw Exception('Failed to create channel');
  }

  @override
  Future<ChannelModel> updateChannel({
    required String id,
    required String teamId,
    required String displayName,
    required String name,
    required String type,
    String? purpose,
    String? header,
  }) async {
    final result = await _apiClient.put<ChannelModel>(
      ChannelsEndPoint.byChannelId(id),
      data: {
        'id': id,
        'team_id': teamId,
        'display_name': displayName,
        'name': name,
        'type': type,
        if (purpose != null) 'purpose': purpose,
        if (header != null) 'header': header,
      },
      fromJson: (json) => ChannelModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<ChannelModel>) {
      return result.data;
    }
    throw Exception('Failed to update channel $id');
  }

  @override
  Future<ChannelModel> patchChannel(
    String channelId, {
    String? name,
    String? displayName,
    String? purpose,
    String? header,
    Map<String, dynamic>? notifyProps,
  }) async {
    final result = await _apiClient.put<ChannelModel>(
      ChannelsEndPoint.patch(channelId),
      data: {
        if (name != null) 'name': name,
        if (displayName != null) 'display_name': displayName,
        if (purpose != null) 'purpose': purpose,
        if (header != null) 'header': header,
        if (notifyProps != null) 'notify_props': notifyProps,
      },
      fromJson: (json) => ChannelModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<ChannelModel>) {
      return result.data;
    }
    throw Exception('Failed to patch channel $channelId');
  }

  @override
  Future<void> deleteChannel(String channelId) async {
    await _apiClient.delete(ChannelsEndPoint.byChannelId(channelId));
  }

  @override
  Future<ChannelModel> unarchiveChannel(String channelId) async {
    final result = await _apiClient.post<ChannelModel>(
      ChannelsEndPoint.restore(channelId),
      fromJson: (json) => ChannelModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<ChannelModel>) {
      return result.data;
    }
    throw Exception('Failed to unarchive channel $channelId');
  }

  @override
  Future<ChannelModel> updateChannelPrivacy(
    String channelId,
    String privacy,
  ) async {
    final result = await _apiClient.put<ChannelModel>(
      ChannelsEndPoint.privacy(channelId),
      data: {'privacy': privacy},
      fromJson: (json) => ChannelModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<ChannelModel>) {
      return result.data;
    }
    throw Exception('Failed to update privacy of channel $channelId');
  }

  @override
  Future<ChannelModel> updateChannelScheme(
    String channelId,
    String schemeId,
  ) async {
    final result = await _apiClient.put<ChannelModel>(
      ChannelsEndPoint.scheme(channelId),
      data: {'scheme_id': schemeId},
      fromJson: (json) => ChannelModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<ChannelModel>) {
      return result.data;
    }
    throw Exception('Failed to update scheme of channel $channelId');
  }

  @override
  Future<ChannelStatsModel> getChannelStats(String channelId) async {
    final result = await _apiClient.get<ChannelStatsModel>(
      '/channels/$channelId/stats',
      queryParameters: {'exclude_files_count': 'true'},
      fromJson: (json) =>
          ChannelStatsModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<ChannelStatsModel>) {
      return result.data;
    }
    throw Exception('Failed to get stats of channel $channelId');
  }

  @override
  Future<List<String>> getChannelTimezones(String channelId) async {
    final result = await _apiClient.get<List<String>>(
      ChannelsEndPoint.timezones(channelId),
      fromJson: (json) => (json as List<dynamic>).cast<String>(),
    );
    if (result is ApiSuccess<List<String>>) {
      return result.data;
    }
    throw Exception('Failed to get timezones of channel $channelId');
  }

  @override
  Future<ChannelModel> createDirectChannel(
    String userId, {
    List<String>? otherUserIds,
  }) async {
    final users = [userId, ...?otherUserIds];
    final result = await _apiClient.post<ChannelModel>(
      ChannelsEndPoint.direct,
      data: users,
      fromJson: (json) => ChannelModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<ChannelModel>) {
      return result.data;
    }
    throw Exception('Failed to create direct channel with $userId');
  }

  @override
  Future<ChannelModel> createGroupChannel(List<String> userIds) async {
    final result = await _apiClient.post<ChannelModel>(
      ChannelsEndPoint.group,
      data: userIds,
      fromJson: (json) => ChannelModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<ChannelModel>) {
      return result.data;
    }
    throw Exception('Failed to create group channel');
  }

  @override
  Future<List<ChannelModel>> searchGroupChannels(String term) async {
    final result = await _apiClient.post<List<ChannelModel>>(
      ChannelsEndPoint.groupSearch,
      data: {'term': term},
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => ChannelModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<ChannelModel>>) {
      return result.data;
    }
    throw Exception('Failed to search group channels');
  }

  @override
  Future<ChannelModel> convertGroupMessageToPrivateChannel(
    String channelId,
    String teamId, {
    String? name,
    String? displayName,
  }) async {
    final result = await _apiClient.post<ChannelModel>(
      ChannelsEndPoint.convertToChannel(channelId),
      data: {
        'team_id': teamId,
        'name': name ?? '',
        'display_name': displayName ?? '',
      },
      fromJson: (json) => ChannelModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<ChannelModel>) {
      return result.data;
    }
    throw Exception('Failed to convert group message to channel');
  }

  @override
  Future<List<String>> getGroupMessageMembersCommonTeams(
    String channelId,
  ) async {
    final result = await _apiClient.get<Map<String, dynamic>>(
      ChannelsEndPoint.commonTeams(channelId),
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return (result.data['team_ids'] as List<dynamic>? ?? const [])
          .cast<String>();
    }
    throw Exception('Failed to get common teams for channel $channelId');
  }

  @override
  Future<List<ChannelModel>> getPublicChannels({
    int page = 0,
    int perPage = 60,
  }) async {
    final result = await _apiClient.get<List<ChannelModel>>(
      ChannelsEndPoint.base,
      queryParameters: {'page': page, 'per_page': perPage},
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => ChannelModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<ChannelModel>>) {
      return result.data;
    }
    throw Exception('Failed to get public channels');
  }

  @override
  Future<List<ChannelModel>> searchChannels(
    Map<String, dynamic> searchParams,
  ) async {
    final result = await _apiClient.post<List<ChannelModel>>(
      ChannelsEndPoint.search,
      data: searchParams,
      fromJson: (json) {
        if (json is Map<String, dynamic>) {
          final channels = json['channels'];
          if (channels is List) {
            return channels
                .map((e) => ChannelModel.fromMap(e as Map<String, dynamic>))
                .toList();
          }
        }
        return (json as List<dynamic>)
            .map((e) => ChannelModel.fromMap(e as Map<String, dynamic>))
            .toList();
      },
    );
    if (result is ApiSuccess<List<ChannelModel>>) {
      return result.data;
    }
    throw Exception('Failed to search channels');
  }

  @override
  Future<void> viewMyChannel(
    String channelId, {
    String? prevChannelId,
    bool collapsedThreads = false,
  }) async {
    await _apiClient.post<void>(
      ChannelsEndPoint.membersView('me'),
      data: {
        'channel_id': channelId,
        'prev_channel_id': prevChannelId ?? '',
        'collapsed_threads': collapsedThreads,
      },
      fromJson: (_) {},
    );
  }

  @override
  Future<void> readMultipleChannels(
    List<String> channelIds, {
    bool collapsedThreads = false,
  }) async {
    await _apiClient.post<void>(
      ChannelsEndPoint.membersMarkRead('me'),
      data: {'channel_ids': channelIds, 'collapsed_threads': collapsedThreads},
      fromJson: (_) {},
    );
  }

  @override
  Future<void> markAllMessagesAsRead(String userId, String channelId) async {
    await _apiClient.put<void>(
      ChannelsEndPoint.membersDirectRead(userId),
      data: {'channel_id': channelId, 'collapsed_threads': false},
      fromJson: (_) {},
    );
  }

  @override
  Future<List<ChannelModel>> getChannelsForTeam(
    String teamId, {
    int page = 0,
    int perPage = 60,
  }) async {
    final result = await _apiClient.get<List<ChannelModel>>(
      TeamsEndPoint.channels(teamId),
      queryParameters: {'page': page, 'per_page': perPage},
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => ChannelModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<ChannelModel>>) {
      return result.data;
    }
    throw Exception('Failed to get channels for team $teamId');
  }

  @override
  Future<List<ChannelModel>> getArchivedChannels(
    String teamId, {
    int page = 0,
    int perPage = 60,
  }) async {
    final result = await _apiClient.get<List<ChannelModel>>(
      TeamsEndPoint.channelsDeleted(teamId),
      queryParameters: {'page': page, 'per_page': perPage},
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => ChannelModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<ChannelModel>>) {
      return result.data;
    }
    throw Exception('Failed to get archived channels for team $teamId');
  }

  @override
  Future<ChannelModel> getChannelByName(
    String teamId,
    String channelName, {
    bool includeDeleted = false,
  }) async {
    final result = await _apiClient.get<ChannelModel>(
      TeamsEndPoint.channelsName(teamId, channelName),
      queryParameters: {'include_deleted': includeDeleted},
      fromJson: (json) => ChannelModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<ChannelModel>) {
      return result.data;
    }
    throw Exception('Failed to get channel by name $channelName');
  }

  @override
  Future<ChannelModel> getChannelByNameAndTeamName(
    String teamName,
    String channelName, {
    bool includeDeleted = false,
  }) async {
    final result = await _apiClient.get<ChannelModel>(
      TeamsEndPoint.nameChannelsName(teamName, channelName),
      queryParameters: {'include_deleted': includeDeleted},
      fromJson: (json) => ChannelModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<ChannelModel>) {
      return result.data;
    }
    throw Exception('Failed to get channel by name and team name');
  }

  @override
  Future<List<ChannelModel>> autocompleteChannels(
    String teamId,
    String term, {
    bool includeDeleted = false,
  }) async {
    final result = await _apiClient.get<List<ChannelModel>>(
      TeamsEndPoint.channelsAutocomplete(teamId),
      queryParameters: {'term': term, 'include_deleted': includeDeleted},
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => ChannelModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<ChannelModel>>) {
      return result.data;
    }
    throw Exception('Failed to autocomplete channels');
  }

  @override
  Future<List<ChannelModel>> autocompleteChannelsForSearch(
    String teamId,
    String term,
  ) async {
    final result = await _apiClient.get<List<ChannelModel>>(
      TeamsEndPoint.channelsSearchAutocomplete(teamId),
      queryParameters: {'term': term},
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => ChannelModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<ChannelModel>>) {
      return result.data;
    }
    throw Exception('Failed to autocomplete channels for search');
  }

  @override
  Future<List<ChannelModel>> getRecommendedChannelsForUser(
    String teamId,
  ) async {
    final result = await _apiClient.get<List<ChannelModel>>(
      TeamsEndPoint.channelsRecommended(teamId),
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => ChannelModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<ChannelModel>>) {
      return result.data;
    }
    throw Exception('Failed to get recommended channels');
  }

  @override
  Future<List<ChannelModel>> searchChannelsForTeam(
    String teamId,
    Map<String, dynamic> searchParams,
  ) async {
    final result = await _apiClient.post<List<ChannelModel>>(
      TeamsEndPoint.channelsSearch(teamId),
      data: searchParams,
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => ChannelModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<ChannelModel>>) {
      return result.data;
    }
    throw Exception('Failed to search channels in team $teamId');
  }

  @override
  Future<List<ChannelModel>> getAllTeamsChannels() async {
    final result = await _apiClient.get<List<ChannelModel>>(
      UsersEndPoint.channels('me'),
      queryParameters: const {},
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => ChannelModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<ChannelModel>>) {
      return result.data;
    }
    throw Exception('Failed to get all teams channels');
  }

  @override
  Future<List<ChannelModel>> getMyChannels(
    String teamId, {
    int page = 0,
    int perPage = 60,
  }) async {
    final result = await _apiClient.get<List<ChannelModel>>(
      UsersEndPoint.teamsChannels('me', teamId),
      queryParameters: {'page': page, 'per_page': perPage},
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => ChannelModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<ChannelModel>>) {
      return result.data;
    }
    throw Exception('Failed to get my channels for team $teamId');
  }

  @override
  Future<int> getChannelStatsMemberCount(String channelId) async {
    final result = await _apiClient.get<int>(
      ChannelsEndPoint.statsMemberCount(channelId),
      fromJson: (json) {
        final data = json as Map<String, dynamic>;
        return (data['member_count'] as num?)?.toInt() ?? 0;
      },
    );
    if (result is ApiSuccess<int>) {
      return result.data;
    }
    throw Exception('Failed to get channel member count');
  }

  @override
  Future<Map<String, dynamic>> markChannelsAsViewed(
    Map<String, dynamic> viewData,
  ) async {
    final result = await _apiClient.post<Map<String, dynamic>>(
      ChannelsEndPoint.viewsBatch,
      data: viewData,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to mark channels as viewed');
  }

  @override
  Future<ChannelUnreadModel> markChannelAsViewed(
    String channelId,
    Map<String, dynamic> viewData,
  ) async {
    final result = await _apiClient.post<ChannelUnreadModel>(
      ChannelsEndPoint.views(channelId),
      data: viewData,
      fromJson: (json) =>
          ChannelUnreadModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<ChannelUnreadModel>) {
      return result.data;
    }
    throw Exception('Failed to mark channel as viewed');
  }

  @override
  Future<PostListModel> getChannelViewPosts(
    String channelId,
    String viewId, {
    int page = 0,
    int perPage = 60,
  }) async {
    final result = await _apiClient.get<PostListModel>(
      ChannelsEndPoint.viewsPosts(channelId, viewId),
      queryParameters: {'page': page, 'per_page': perPage},
      fromJson: (json) => PostListModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<PostListModel>) {
      return result.data;
    }
    throw Exception('Failed to get channel view posts');
  }

  @override
  Future<ViewModel> updateChannelViewSortOrder(
    String channelId,
    String viewId, {
    required String sortOrder,
  }) async {
    final result = await _apiClient.put<ViewModel>(
      ChannelsEndPoint.viewsSortOrder(channelId, viewId),
      data: {'sort_order': sortOrder},
      fromJson: (json) => ViewModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<ViewModel>) {
      return result.data;
    }
    throw Exception('Failed to update channel view sort order');
  }

  @override
  Future<void> deleteChannelView(String channelId, String viewId) async {
    final result = await _apiClient.delete(
      ChannelsEndPoint.views2(channelId, viewId),
    );
    if (result is ApiFailure) {
      throw Exception('Failed to delete channel view $viewId');
    }
  }

  @override
  Future<Map<String, int>> getChannelsMemberCount(
    List<String> channelIds,
  ) async {
    final result = await _apiClient.post<Map<String, int>>(
      ChannelsEndPoint.statsMemberCountBatch,
      data: channelIds,
      fromJson: (json) {
        final data = json as Map<String, dynamic>;
        return data.map((key, value) => MapEntry(key, (value as num).toInt()));
      },
    );
    if (result is ApiSuccess<Map<String, int>>) {
      return result.data;
    }
    throw Exception('Failed to get member counts for channels');
  }

  @override
  Future<ChannelModel> moveChannel(
    String channelId,
    Map<String, dynamic> data,
  ) async {
    final result = await _apiClient.post<ChannelModel>(
      ChannelsEndPoint.move(channelId),
      data: data,
      fromJson: (json) => ChannelModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<ChannelModel>) {
      return result.data;
    }
    throw Exception('Failed to move channel $channelId');
  }

  @override
  Future<ChannelModel> createBoard({
    required String boardType,
    required String boardName,
    required String channelId,
  }) async {
    final result = await _apiClient.post<ChannelModel>(
      BoardsEndPoint.root,
      data: {
        'board_type': boardType,
        'board_name': boardName,
        'channel_id': channelId,
      },
      fromJson: (json) => ChannelModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<ChannelModel>) {
      return result.data;
    }
    throw Exception('Failed to create board channel');
  }

  @override
  Future<ChannelMemberModel> addChannelMember(
    String channelId,
    String userId,
  ) async {
    final result = await _apiClient.post<ChannelMemberModel>(
      ChannelsEndPoint.members(channelId),
      data: {'user_id': userId},
      fromJson: (json) =>
          ChannelMemberModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<ChannelMemberModel>) {
      return result.data;
    }
    throw Exception('Failed to add member to channel');
  }

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
    throw Exception('Failed to get channel members');
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
    throw Exception('Failed to get channel members by ids');
  }

  @override
  Future<void> removeUserFromChannel(String channelId, String userId) async {
    await _apiClient.delete('/channels/$channelId/members/$userId');
  }

  @override
  Future<void> restoreChannel(String channelId) async {
    await _apiClient.post<void>(
      ChannelsEndPoint.restore(channelId),
      fromJson: (_) {},
    );
  }

  @override
  Future<List<ChannelModel>> searchAllChannels(
    Map<String, dynamic> searchParams,
  ) async {
    final result = await _apiClient.post<List<ChannelModel>>(
      ChannelsEndPoint.search,
      data: searchParams,
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => ChannelModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<ChannelModel>>) {
      return result.data;
    }
    throw Exception('Failed to search all channels');
  }

  @override
  Future<List<ChannelMemberModel>> setChannelMembers(
    String channelId,
    List<String> userIds,
  ) async {
    final result = await _apiClient.post<List<ChannelMemberModel>>(
      ChannelsEndPoint.members(channelId),
      data: userIds.map((id) => {'user_id': id}).toList(),
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => ChannelMemberModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<ChannelMemberModel>>) {
      return result.data;
    }
    throw Exception('Failed to set channel members');
  }

  @override
  Future<void> updateChannelMemberAutotranslation(
    String channelId,
    String userId,
    bool enable,
  ) async {
    await _apiClient.put<void>(
      ChannelsEndPoint.membersSchemeRoles(channelId, userId),
      data: {'enable': enable},
      fromJson: (_) {},
    );
  }

  @override
  Future<void> updateChannelNotifyProps(
    String channelId,
    String userId,
    Map<String, dynamic> props,
  ) async {
    await _apiClient.put<void>(
      ChannelsEndPoint.membersNotifyProps(channelId, userId),
      data: props,
      fromJson: (_) {},
    );
  }

  @override
  Future<ChannelMemberModel> updateChannelRoles(
    String channelId,
    String userId,
    List<String> roles,
  ) async {
    final result = await _apiClient.put<ChannelMemberModel>(
      ChannelsEndPoint.membersRoles(channelId, userId),
      data: {'roles': roles.join(' ')},
      fromJson: (json) =>
          ChannelMemberModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<ChannelMemberModel>) {
      return result.data;
    }
    throw Exception('Failed to update channel roles');
  }

  @override
  Future<void> viewChannel(String userId, Map<String, dynamic> viewData) async {
    await _apiClient.post<void>(
      ChannelsEndPoint.membersView(userId),
      data: viewData,
      fromJson: (_) {},
    );
  }

  @override
  Future<List<ChannelModel>> getDeletedChannelsForTeam(
    String teamId, {
    int page = 0,
    int perPage = 60,
  }) async {
    final result = await _apiClient.get<List<ChannelModel>>(
      TeamsEndPoint.channelsDeleted(teamId),
      queryParameters: {'page': page, 'per_page': perPage},
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => ChannelModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<ChannelModel>>) {
      return result.data;
    }
    throw Exception('Failed to get deleted channels for team');
  }

  @override
  Future<List<ChannelModel>> getPrivateChannelsForTeam(
    String teamId, {
    int page = 0,
    int perPage = 60,
  }) async {
    final result = await _apiClient.get<List<ChannelModel>>(
      TeamsEndPoint.channelsPrivate(teamId),
      queryParameters: {'page': page, 'per_page': perPage},
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => ChannelModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<ChannelModel>>) {
      return result.data;
    }
    throw Exception('Failed to get private channels for team');
  }

  @override
  Future<List<ChannelModel>> getPublicChannelsByIdsForTeam(
    String teamId,
    List<String> channelIds,
  ) async {
    final result = await _apiClient.post<List<ChannelModel>>(
      TeamsEndPoint.channelsIds(teamId),
      data: channelIds,
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => ChannelModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<ChannelModel>>) {
      return result.data;
    }
    throw Exception('Failed to get public channels by ids');
  }

  @override
  Future<List<ChannelModel>> getPublicChannelsForTeam(
    String teamId, {
    int page = 0,
    int perPage = 60,
  }) async {
    final result = await _apiClient.get<List<ChannelModel>>(
      TeamsEndPoint.channels(teamId),
      queryParameters: {'page': page, 'per_page': perPage},
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => ChannelModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<ChannelModel>>) {
      return result.data;
    }
    throw Exception('Failed to get public channels for team');
  }

  @override
  Future<List<SidebarCategoryModel>> getSidebarCategoriesForTeamForUser(
    String userId,
    String teamId,
  ) async {
    final result = await _apiClient.get<List<SidebarCategoryModel>>(
      UsersEndPoint.teamsChannelsCategories(userId, teamId),
      fromJson: (json) {
        final data = json as Map<String, dynamic>;
        return (data['categories'] as List<dynamic>)
            .map((e) => SidebarCategoryModel.fromMap(e as Map<String, dynamic>))
            .toList();
      },
    );
    if (result is ApiSuccess<List<SidebarCategoryModel>>) {
      return result.data;
    }
    throw Exception('Failed to get sidebar categories');
  }

  @override
  Future<SidebarCategoryModel> getSidebarCategoryForTeamForUser(
    String userId,
    String teamId,
    String categoryId,
  ) async {
    final result = await _apiClient.get<SidebarCategoryModel>(
      UsersEndPoint.teamsChannelsCategories2(userId, teamId, categoryId),
      fromJson: (json) =>
          SidebarCategoryModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<SidebarCategoryModel>) {
      return result.data;
    }
    throw Exception('Failed to get sidebar category');
  }

  @override
  Future<List<String>> getSidebarCategoryOrderForTeamForUser(
    String userId,
    String teamId,
  ) async {
    final result = await _apiClient.get<List<String>>(
      UsersEndPoint.teamsChannelsCategoriesOrder(userId, teamId),
      fromJson: (json) => (json as List<dynamic>).cast<String>(),
    );
    if (result is ApiSuccess<List<String>>) {
      return result.data;
    }
    throw Exception('Failed to get sidebar category order');
  }

  @override
  Future<void> removeSidebarCategoryForTeamForUser(
    String userId,
    String teamId,
    String categoryId,
  ) async {
    await _apiClient.delete(
      UsersEndPoint.teamsChannelsCategories2(userId, teamId, categoryId),
    );
  }

  @override
  Future<SidebarCategoryModel> updateSidebarCategoryForTeamForUser(
    String userId,
    String teamId,
    String categoryId,
    Map<String, dynamic> category,
  ) async {
    final result = await _apiClient.put<SidebarCategoryModel>(
      UsersEndPoint.teamsChannelsCategories2(userId, teamId, categoryId),
      data: category,
      fromJson: (json) =>
          SidebarCategoryModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<SidebarCategoryModel>) {
      return result.data;
    }
    throw Exception('Failed to update sidebar category');
  }

  @override
  Future<void> updateSidebarCategoryOrderForTeamForUser(
    String userId,
    String teamId,
    List<String> categoryIds,
  ) async {
    await _apiClient.put<void>(
      UsersEndPoint.teamsChannelsCategoriesOrder(userId, teamId),
      data: categoryIds,
      fromJson: (_) {},
    );
  }

  @override
  Future<List<SidebarCategoryModel>> updateSidebarCategoriesForTeamForUser(
    String userId,
    String teamId,
    List<Map<String, dynamic>> categories,
  ) async {
    final result = await _apiClient.put<List<SidebarCategoryModel>>(
      UsersEndPoint.teamsChannelsCategories(userId, teamId),
      data: categories,
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => SidebarCategoryModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<SidebarCategoryModel>>) {
      return result.data;
    }
    throw Exception('Failed to update sidebar categories');
  }

  @override
  Future<SidebarCategoryModel> createSidebarCategoryForTeamForUser(
    String userId,
    String teamId,
    Map<String, dynamic> category,
  ) async {
    final result = await _apiClient.post<SidebarCategoryModel>(
      UsersEndPoint.teamsChannelsCategories(userId, teamId),
      data: category,
      fromJson: (json) =>
          SidebarCategoryModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<SidebarCategoryModel>) {
      return result.data;
    }
    throw Exception('Failed to create sidebar category');
  }
}
