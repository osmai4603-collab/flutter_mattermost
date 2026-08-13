// ignore_for_file: use_null_aware_elements

import 'package:flutter_mattermost/features/chat/data/models/post_model.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/network/api_client.dart';
import 'package:flutter_mattermost/core/network/api_result.dart';

import 'package:flutter_mattermost/core/endpoints/endpoints.dart';

abstract class ThreadsRemoteDataSource {
  Future<Map<String, dynamic>> getThreadsForUser(
    String teamId, {
    int page = 0,
    int perPage = 60,
    int? since,
    int? before,
    int? after,
    bool unread = false,
    bool deleted = false,
    bool totalsOnly = false,
    bool extended = false,
  });
  Future<PostModel> getThread(
    String userId,
    String teamId,
    String threadId, {
    bool collapsedThreads = false,
  });
  Future<Map<String, dynamic>> followThread(
    String userId,
    String teamId,
    String threadId,
  );
  Future<void> unfollowThread(String userId, String teamId, String threadId);
  Future<void> markThreadAsRead(
    String userId,
    String teamId,
    String threadId, {
    int? timestamp,
  });
  Future<void> markAllThreadsAsRead(
    String userId,
    String teamId,
  );
  Future<void> setThreadUnread(
    String userId,
    String teamId,
    String threadId,
    String postId,
  );
}

@LazySingleton(as: ThreadsRemoteDataSource)
class ThreadsRemoteDataSourceImpl implements ThreadsRemoteDataSource {
  final ApiClient _apiClient;

  ThreadsRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Map<String, dynamic>> getThreadsForUser(
    String teamId, {
    int page = 0,
    int perPage = 60,
    int? since,
    int? before,
    int? after,
    bool unread = false,
    bool deleted = false,
    bool totalsOnly = false,
    bool extended = false,
  }) async {
    final result = await _apiClient.get<Map<String, dynamic>>(
      UsersEndPoint.teamsThreads('me', teamId),
      queryParameters: {
        'page': page,
        'per_page': perPage,
        if (since != null) 'since': since,
        if (before != null) 'before': before,
        if (after != null) 'after': after,
        'unread': unread,
        'deleted': deleted,
        'totalsOnly': totalsOnly,
        'extended': extended,
      },
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to get threads for team $teamId');
  }

  @override
  Future<PostModel> getThread(
    String userId,
    String teamId,
    String threadId, {
    bool collapsedThreads = false,
  }) async {
    final result = await _apiClient.get<PostModel>(
      UsersEndPoint.teamsThreads2(userId, teamId, threadId),
      queryParameters: {'collapsedThreads': collapsedThreads},
      fromJson: (json) => PostModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<PostModel>) {
      return result.data;
    }
    throw Exception('Failed to get thread $threadId');
  }

  @override
  Future<Map<String, dynamic>> followThread(
    String userId,
    String teamId,
    String threadId,
  ) async {
    final result = await _apiClient.put<Map<String, dynamic>>(
      UsersEndPoint.teamsThreadsFollowing(userId, teamId, threadId),
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to follow thread $threadId');
  }

  @override
  Future<void> unfollowThread(
    String userId,
    String teamId,
    String threadId,
  ) async {
    await _apiClient.delete(
      UsersEndPoint.teamsThreadsFollowing(userId, teamId, threadId),
    );
  }

  @override
  Future<void> markThreadAsRead(
    String userId,
    String teamId,
    String threadId, {
    int? timestamp,
  }) async {
    final ts = timestamp ?? DateTime.now().millisecondsSinceEpoch;
    await _apiClient.put<void>(
      UsersEndPoint.teamsThreadsRead2(userId, teamId, threadId, ts.toString()),
      fromJson: (_) {},
    );
  }

  @override
  Future<void> markAllThreadsAsRead(
    String userId,
    String teamId,
  ) async {
    await _apiClient.put<void>(
      UsersEndPoint.teamsThreadsRead(userId, teamId),
      fromJson: (_) {},
    );
  }

  @override
  Future<void> setThreadUnread(
    String userId,
    String teamId,
    String threadId,
    String postId,
  ) async {
    await _apiClient.put<void>(
      UsersEndPoint.teamsThreadsSetUnread(userId, teamId, threadId, postId),
      fromJson: (_) {},
    );
  }
}
