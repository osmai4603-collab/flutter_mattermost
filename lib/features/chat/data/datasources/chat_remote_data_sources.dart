import 'package:flutter_mattermost/features/chat/data/models/post_info_model.dart';
import 'package:flutter_mattermost/features/chat/data/models/posts_usage_model.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/network/api_client.dart';
import 'package:flutter_mattermost/core/network/api_result.dart';
import 'package:flutter_mattermost/features/chat/data/models/file_info_model.dart';
import 'package:flutter_mattermost/features/chat/data/models/post_model.dart';

import 'package:flutter_mattermost/core/endpoints/endpoints.dart';

abstract class PostRemoteDataSource {
  // القوائم
  Future<List<PostModel>> getPostsForChannel(
    String channelId, {
    int page = 0,
    int perPage = 60,
    int? since,
    String? after,
    String? before,
    bool fetchDeleted = false,
    bool collapsedThreads = false,
  });
  Future<List<PostModel>> getPinnedPosts(String channelId);
  Future<List<PostModel>> getFlaggedPosts(
    String userId, {
    int page = 0,
    int perPage = 60,
  });
  Future<List<PostModel>> searchPostsInTeam(
    String teamId,
    Map<String, dynamic> searchParams,
  );
  Future<List<PostModel>> getPostsAround(
    String channelId,
    String postId, {
    int perPage = 15,
  });
  Future<PostModel> getPost(String postId);
  Future<List<PostModel>> getPostThread(
    String postId, {
    bool collapsedThreads = false,
  });
  Future<List<PostModel>> getPostEditHistory(String postId);
  Future<PostInfoModel> getPostInfo(String postId);
  Future<List<PostModel>> getPostsByIds(List<String> postIds);
  // الكتابة
  Future<PostModel> createPost({
    required String channelId,
    required String message,
    String? rootId,
    List<String>? fileIds,
    Map<String, dynamic>? metadata,
    bool alsoSendToChannel = false,
  });
  Future<PostModel> sendPost(
    String channelId,
    String message, {
    String? rootId,
    List<String>? fileIds,
    Map<String, dynamic>? metadata,
    bool alsoSendToChannel = false,
  });
  Future<PostModel> updatePost(String postId, Map<String, dynamic> update);
  Future<PostModel> patchPost(String postId, Map<String, dynamic> patch);
  Future<void> deletePost(String postId);
  Future<PostModel> pinPost(String postId);
  Future<PostModel> unpinPost(String postId);
  Future<PostModel> createPostEphemeral(String userId, Map<String, dynamic> post);
  Future<Map<String, dynamic>> getAIRewrittenMessage(
    String message, {
    String? channelId,
  });
  Future<List<FileInfoModel>> getFileInfosForPost(String postId);
  Future<void> doPostActionWithCookie(
    String postId,
    String actionId, {
    String? cookie,
    String? userInput,
  });
  Future<PostModel> restorePostVersion(String postId, String restoreVersionId);
  Future<List<PostModel>> getPaginatedPostThread(
    String postId, {
    int page = 0,
    int perPage = 60,
    bool collapsedThreads = false,
  });
  Future<List<PostModel>> getUserThreads(
    String userId,
    String teamId, {
    int page = 0,
    int perPage = 60,
  });
  Future<List<PostModel>> getPostsUnread(
    String userId,
    String channelId, {
    int? limitBefore,
    int? limitAfter,
  });
  // الحالة
  Future<Map<String, dynamic>> setPostUnread(
    String userId,
    String postId, {
    int unreadMessageCount = 0,
    String? mentionCount,
  });
  Future<void> ackPost(
    String userId,
    String postId, {
    String? ackId,
    bool ack = true,
    bool severe = false,
  });
  Future<void> unacknowledgePost(String userId, String postId);
  Future<void> setPostReminder(
    String userId,
    String postId, {
    required int reminderTime,
  });
  Future<Map<String, dynamic>> burnPost(
    String postId,
    Map<String, dynamic> burn,
  );
  Future<Map<String, dynamic>> revealPost(String postId);
  Future<void> flagPost(String userId, String postId);
  Future<void> unflagPost(String userId, String postId);
  Future<List<PostModel>> searchPostsAcrossAllTeams(
    Map<String, dynamic> searchParams,
  );
  Future<void> moveThread(String postId, String channelId);

  // Missing operations from docs
  Future<void> deleteAcknowledgementForPost(String postId, String userId);
  Future<Map<String, dynamic>> getAncillaryPermissionsPost(String postId);
  Future<PostsUsageModel> getPostsUsage();
  Future<void> saveAcknowledgementForPost(String postId, String userId, Map<String, dynamic> ack);
  Future<void> setThreadUnreadByPostId(String userId, String teamId, String threadId, String postId);
  Future<void> updateThreadReadForUser(String userId, String teamId, String threadId, int timestamp);
  Future<void> updateThreadsReadForUser(String userId, String teamId);
}

@LazySingleton(as: PostRemoteDataSource)
class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final ApiClient _apiClient;

  PostRemoteDataSourceImpl(this._apiClient);

  List<PostModel> _parsePostList(dynamic json) {
    final data = json as Map<String, dynamic>;
    final postsOrder = (data['order'] as List<dynamic>?)?.cast<String>() ?? [];
    final postsMap = (data['posts'] as Map<String, dynamic>?) ?? {};
    return postsOrder
        .where((id) => postsMap.containsKey(id))
        .map((id) => PostModel.fromMap(postsMap[id] as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<PostModel>> getPostsForChannel(
    String channelId, {
    int page = 0,
    int perPage = 60,
    int? since,
    String? after,
    String? before,
    bool fetchDeleted = false,
    bool collapsedThreads = false,
  }) async {
    final result = await _apiClient.get<List<PostModel>>(
      ChannelsEndPoint.posts(channelId),
      queryParameters: {
        'page': page,
        'per_page': perPage,
        if (since != null) 'since': since,
        if (after != null) 'after': after,
        if (before != null) 'before': before,
        'collapsed_threads': collapsedThreads,
        'fetch_deleted': fetchDeleted,
      },
      fromJson: _parsePostList,
    );
    if (result is ApiSuccess<List<PostModel>>) {
      return result.data;
    }
    throw Exception('Failed to get posts for channel: $channelId');
  }

  @override
  Future<List<PostModel>> getPinnedPosts(String channelId) async {
    final result = await _apiClient.get<List<PostModel>>(
      ChannelsEndPoint.pinned(channelId),
      fromJson: _parsePostList,
    );
    if (result is ApiSuccess<List<PostModel>>) {
      return result.data;
    }
    throw Exception('Failed to get pinned posts for channel: $channelId');
  }

  @override
  Future<List<PostModel>> getFlaggedPosts(
    String userId, {
    int page = 0,
    int perPage = 60,
  }) async {
    final result = await _apiClient.get<List<PostModel>>(
      UsersEndPoint.postsFlagged(userId),
      queryParameters: {'page': page, 'per_page': perPage},
      fromJson: _parsePostList,
    );
    if (result is ApiSuccess<List<PostModel>>) {
      return result.data;
    }
    throw Exception('Failed to get flagged posts for user: $userId');
  }

  @override
  Future<List<PostModel>> searchPostsInTeam(
    String teamId,
    Map<String, dynamic> searchParams,
  ) async {
    final result = await _apiClient.post<List<PostModel>>(
      TeamsEndPoint.postsSearch(teamId),
      data: searchParams,
      fromJson: _parsePostList,
    );
    if (result is ApiSuccess<List<PostModel>>) {
      return result.data;
    }
    throw Exception('Failed to search posts in team: $teamId');
  }

  @override
  Future<List<PostModel>> searchPostsAcrossAllTeams(
    Map<String, dynamic> searchParams,
  ) async {
    final result = await _apiClient.post<List<PostModel>>(
      PostsEndPoint.search,
      data: searchParams,
      fromJson: _parsePostList,
    );
    if (result is ApiSuccess<List<PostModel>>) {
      return result.data;
    }
    throw Exception('Failed to search posts across all teams');
  }

  @override
  Future<List<PostModel>> getPostsAround(
    String channelId,
    String postId, {
    int perPage = 20,
  }) async {
    final result = await _apiClient.get<List<PostModel>>(
      ChannelsEndPoint.posts(channelId),
      queryParameters: {'around': postId, 'per_page': perPage},
      fromJson: _parsePostList,
    );
    if (result is ApiSuccess<List<PostModel>>) {
      return result.data;
    }
    throw Exception('Failed to get posts around $postId');
  }

  @override
  Future<PostModel> getPost(String postId) async {
    final result = await _apiClient.get<PostModel>(
      PostsEndPoint.byPostId(postId),
      fromJson: (json) => PostModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<PostModel>) {
      return result.data;
    }
    throw Exception('Failed to get post $postId');
  }

  @override
  Future<List<PostModel>> getPostThread(
    String postId, {
    bool collapsedThreads = false,
  }) async {
    final result = await _apiClient.get<List<PostModel>>(
      PostsEndPoint.thread(postId),
      queryParameters: {'collapsedThreads': collapsedThreads},
      fromJson: _parsePostList,
    );
    if (result is ApiSuccess<List<PostModel>>) {
      return result.data;
    }
    throw Exception('Failed to get thread for post $postId');
  }

  @override
  Future<List<PostModel>> getPostEditHistory(String postId) async {
    final result = await _apiClient.get<List<PostModel>>(
      PostsEndPoint.editHistory(postId),
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => PostModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<PostModel>>) {
      return result.data;
    }
    throw Exception('Failed to get edit history for post $postId');
  }

  @override
  Future<PostInfoModel> getPostInfo(String postId) async {
    final result = await _apiClient.get<PostInfoModel>(
      PostsEndPoint.info(postId),
      fromJson: (json) => PostInfoModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<PostInfoModel>) {
      return result.data;
    }
    throw Exception('Failed to get info for post $postId');
  }

  @override
  Future<List<PostModel>> getPostsByIds(List<String> postIds) async {
    final result = await _apiClient.post<List<PostModel>>(
      PostsEndPoint.ids,
      data: postIds,
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => PostModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<PostModel>>) {
      return result.data;
    }
    throw Exception('Failed to get posts by ids');
  }

  @override
  Future<PostModel> createPost({
    required String channelId,
    required String message,
    String? rootId,
    List<String>? fileIds,
    Map<String, dynamic>? metadata,
    bool alsoSendToChannel = false,
  }) async {
    final result = await _apiClient.post<PostModel>(
      PostsEndPoint.root,
      data: {
        'channel_id': channelId,
        'message': message,
        if (rootId != null && rootId.isNotEmpty) 'root_id': rootId,
        if (fileIds != null && fileIds.isNotEmpty) 'file_ids': fileIds,
        if (metadata != null) 'metadata': metadata,
        if (alsoSendToChannel) 'props': {'also_send_to_channel': 'true'},
      },
      fromJson: (json) => PostModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<PostModel>) {
      return result.data;
    }
    throw Exception('Failed to create post');
  }

  @override
  Future<PostModel> sendPost(
    String channelId,
    String message, {
    String? rootId,
    List<String>? fileIds,
    Map<String, dynamic>? metadata,
    bool alsoSendToChannel = false,
  }) async {
    return createPost(
      channelId: channelId,
      message: message,
      rootId: rootId,
      fileIds: fileIds,
      metadata: metadata,
      alsoSendToChannel: alsoSendToChannel,
    );
  }

  @override
  Future<void> moveThread(String postId, String channelId) async {
    final result = await _apiClient.post<void>(
      PostsEndPoint.move(postId),
      data: {'channel_id': channelId},
      fromJson: (_) {},
    );
    if (result is ApiFailure) {
      throw Exception('Failed to move thread $postId');
    }
  }

  @override
  Future<PostModel> updatePost(String postId, Map<String, dynamic> update) async {
    final result = await _apiClient.put<PostModel>(
      PostsEndPoint.byPostId(postId),
      data: update,
      fromJson: (json) => PostModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<PostModel>) {
      return result.data;
    }
    throw Exception('Failed to update post $postId');
  }

  @override
  Future<PostModel> patchPost(String postId, Map<String, dynamic> patch) async {
    final result = await _apiClient.put<PostModel>(
      PostsEndPoint.patch(postId),
      data: patch,
      fromJson: (json) => PostModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<PostModel>) {
      return result.data;
    }
    throw Exception('Failed to patch post $postId');
  }

  @override
  Future<void> deletePost(String postId) async {
    await _apiClient.delete(PostsEndPoint.byPostId(postId));
  }

  @override
  Future<void> flagPost(String userId, String postId) async {
    await _apiClient.put(
      UsersEndPoint.postFlag(userId, postId),
      fromJson: (json) => {},
    );
  }

  @override
  Future<void> unflagPost(String userId, String postId) async {
    await _apiClient.delete(UsersEndPoint.postFlag(userId, postId));
  }

  @override
  Future<PostModel> pinPost(String postId) async {
    final result = await _apiClient.post<PostModel>(
      PostsEndPoint.pin(postId),
      fromJson: (json) => PostModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<PostModel>) {
      return result.data;
    }
    throw Exception('Failed to pin post $postId');
  }

  @override
  Future<PostModel> unpinPost(String postId) async {
    final result = await _apiClient.post<PostModel>(
      PostsEndPoint.unpin(postId),
      fromJson: (json) => PostModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<PostModel>) {
      return result.data;
    }
    throw Exception('Failed to unpin post $postId');
  }

  @override
  Future<Map<String, dynamic>> setPostUnread(
    String userId,
    String postId, {
    int unreadMessageCount = 0,
    String? mentionCount,
  }) async {
    final result = await _apiClient.post<Map<String, dynamic>>(
      UsersEndPoint.postsSetUnread(userId, postId),
      data: {
        'unread_count': unreadMessageCount,
        if (mentionCount != null) 'mention_count': mentionCount,
      },
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to set post unread state: $postId');
  }

  @override
  Future<void> ackPost(
    String userId,
    String postId, {
    String? ackId,
    bool ack = true,
    bool severe = false,
  }) async {
    await _apiClient.post<void>(
      UsersEndPoint.postsAck(userId, postId),
      data: {'ack': ack, 'severe': severe, if (ackId != null) 'ack_id': ackId},
      fromJson: (_) {},
    );
  }

  @override
  Future<PostModel> createPostEphemeral(
    String userId,
    Map<String, dynamic> post,
  ) async {
    final result = await _apiClient.post<PostModel>(
      PostsEndPoint.ephemeral,
      data: {'user_id': userId, 'post': post},
      fromJson: (json) => PostModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<PostModel>) {
      return result.data;
    }
    throw Exception('Failed to create ephemeral post');
  }

  @override
  Future<Map<String, dynamic>> getAIRewrittenMessage(
    String message, {
    String? channelId,
  }) async {
    final result = await _apiClient.post<Map<String, dynamic>>(
      PostsEndPoint.rewrite,
      data: {
        'message': message,
        if (channelId != null) 'channel_id': channelId,
      },
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to rewrite message');
  }

  @override
  Future<List<FileInfoModel>> getFileInfosForPost(String postId) async {
    final result = await _apiClient.get<List<FileInfoModel>>(
      PostsEndPoint.filesInfo(postId),
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => FileInfoModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<FileInfoModel>>) {
      return result.data;
    }
    throw Exception('Failed to get file infos for post $postId');
  }

  @override
  Future<void> doPostActionWithCookie(
    String postId,
    String actionId, {
    String? cookie,
    String? userInput,
  }) async {
    await _apiClient.post<void>(
      PostsEndPoint.actions(postId, actionId),
      data: {
        if (cookie != null) 'cookie': cookie,
        if (userInput != null) 'user_input': userInput,
      },
      fromJson: (_) {},
    );
  }

  @override
  Future<PostModel> restorePostVersion(
    String postId,
    String restoreVersionId,
  ) async {
    final result = await _apiClient.post<PostModel>(
      PostsEndPoint.restore(postId, restoreVersionId),
      fromJson: (json) => PostModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<PostModel>) {
      return result.data;
    }
    throw Exception('Failed to restore post version for $postId');
  }

  @override
  Future<List<PostModel>> getPaginatedPostThread(
    String postId, {
    int page = 0,
    int perPage = 60,
    bool collapsedThreads = false,
  }) async {
    final result = await _apiClient.get<List<PostModel>>(
      PostsEndPoint.thread(postId),
      queryParameters: {
        'page': page,
        'per_page': perPage,
        'collapsed_threads': collapsedThreads,
      },
      fromJson: _parsePostList,
    );
    if (result is ApiSuccess<List<PostModel>>) {
      return result.data;
    }
    throw Exception('Failed to get paginated thread for post $postId');
  }

  @override
  Future<List<PostModel>> getUserThreads(
    String userId,
    String teamId, {
    int page = 0,
    int perPage = 60,
  }) async {
    final result = await _apiClient.get<List<PostModel>>(
      UsersEndPoint.teamsThreads(userId, teamId),
      queryParameters: {'page': page, 'per_page': perPage},
      fromJson: (json) {
        final data = json as Map<String, dynamic>;
        final threads = data['threads'] as List<dynamic>? ?? [];
        return threads
            .map((e) => PostModel.fromMap(e as Map<String, dynamic>))
            .toList();
      },
    );
    if (result is ApiSuccess<List<PostModel>>) {
      return result.data;
    }
    throw Exception('Failed to get user threads');
  }

  @override
  Future<List<PostModel>> getPostsUnread(
    String userId,
    String channelId, {
    int? limitBefore,
    int? limitAfter,
  }) async {
    final result = await _apiClient.get<List<PostModel>>(
      UsersEndPoint.channelsPostsUnread(userId, channelId),
      queryParameters: {
        if (limitBefore != null) 'limit_before': limitBefore,
        if (limitAfter != null) 'limit_after': limitAfter,
      },
      fromJson: _parsePostList,
    );
    if (result is ApiSuccess<List<PostModel>>) {
      return result.data;
    }
    throw Exception('Failed to get unread posts');
  }

  @override
  Future<void> unacknowledgePost(String userId, String postId) async {
    await _apiClient.delete(UsersEndPoint.postsAck(userId, postId));
  }

  @override
  Future<void> setPostReminder(
    String userId,
    String postId, {
    required int reminderTime,
  }) async {
    await _apiClient.post<void>(
      UsersEndPoint.postsReminder(userId, postId),
      data: {'reminder_time': reminderTime},
      fromJson: (_) {},
    );
  }

  @override
  Future<Map<String, dynamic>> burnPost(
    String postId,
    Map<String, dynamic> post,
  ) async {
    final result = await _apiClient.post<Map<String, dynamic>>(
      PostsEndPoint.burn(postId),
      data: post,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to burn post $postId');
  }

  @override
  Future<Map<String, dynamic>> revealPost(String postId) async {
    final result = await _apiClient.post<Map<String, dynamic>>(
      PostsEndPoint.reveal(postId),
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to reveal post $postId');
  }

  @override
  Future<void> deleteAcknowledgementForPost(String postId, String userId) async {
    await _apiClient.delete(UsersEndPoint.postsAck(userId, postId));
  }

  @override
  Future<Map<String, dynamic>> getAncillaryPermissionsPost(String postId) async {
    final result = await _apiClient.get<Map<String, dynamic>>(
      PostsEndPoint.ancillaryPermissions(postId),
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to get ancillary permissions for post $postId');
  }

  @override
  Future<PostsUsageModel> getPostsUsage() async {
    final result = await _apiClient.get<PostsUsageModel>(
      UsageEndPoint.posts,
      fromJson: (json) => PostsUsageModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<PostsUsageModel>) {
      return result.data;
    }
    throw Exception('Failed to get posts usage');
  }

  @override
  Future<void> saveAcknowledgementForPost(String postId, String userId, Map<String, dynamic> ack) async {
    await _apiClient.post<void>(
      UsersEndPoint.postsAck(userId, postId),
      data: ack,
      fromJson: (_) {},
    );
  }

  @override
  Future<void> setThreadUnreadByPostId(String userId, String teamId, String threadId, String postId) async {
    await _apiClient.post<void>(
      UsersEndPoint.teamsThreadsSetUnread(userId, teamId, threadId, postId),
      fromJson: (_) {},
    );
  }

  @override
  Future<void> updateThreadReadForUser(String userId, String teamId, String threadId, int timestamp) async {
    await _apiClient.put<void>(
      UsersEndPoint.teamsThreadsRead2(userId, teamId, threadId, timestamp.toString()),
      fromJson: (_) {},
    );
  }

  @override
  Future<void> updateThreadsReadForUser(String userId, String teamId) async {
    await _apiClient.put<void>(
      UsersEndPoint.teamsThreadsRead(userId, teamId),
      fromJson: (_) {},
    );
  }
}
