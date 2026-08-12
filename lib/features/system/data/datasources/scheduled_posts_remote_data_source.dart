import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/network/api_client.dart';
import 'package:flutter_mattermost/core/network/api_result.dart';
import 'package:flutter_mattermost/features/chat/data/models/post_model.dart';

import 'package:flutter_mattermost/core/endpoints/endpoints.dart';

abstract class ScheduledPostsRemoteDataSource {
  Future<List<PostModel>> getScheduledPosts(
    String teamId, {
    int page = 0,
    int perPage = 60,
  });
  Future<Map<String, dynamic>> createScheduledPost({
    required String channelId,
    required String message,
    required int scheduledAt,
    String? rootId,
    List<String>? fileIds,
    Map<String, dynamic>? priority,
    Map<String, dynamic>? propsData,
    Map<String, dynamic>? metadata,
  });
  Future<Map<String, dynamic>> editScheduledPost(
    String scheduledPostId, {
    required String channelId,
    required String message,
    required int scheduledAt,
    String? rootId,
    List<String>? fileIds,
    Map<String, dynamic>? priority,
    Map<String, dynamic>? propsData,
    Map<String, dynamic>? metadata,
  });
  Future<void> deleteScheduledPost(String scheduledPostId);
}

@LazySingleton(as: ScheduledPostsRemoteDataSource)
class ScheduledPostsRemoteDataSourceImpl
    implements ScheduledPostsRemoteDataSource {
  final ApiClient _apiClient;

  ScheduledPostsRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<PostModel>> getScheduledPosts(
    String teamId, {
    int page = 0,
    int perPage = 60,
  }) async {
    final result = await _apiClient.get<List<PostModel>>(
      PostsEndPoint.scheduledTeam(teamId),
      queryParameters: {'page': page, 'per_page': perPage},
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => PostModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<PostModel>>) {
      return result.data;
    }
    throw Exception('Failed to get scheduled posts for team $teamId');
  }

  @override
  Future<Map<String, dynamic>> createScheduledPost({
    required String channelId,
    required String message,
    required int scheduledAt,
    String? rootId,
    List<String>? fileIds,
    Map<String, dynamic>? priority,
    Map<String, dynamic>? propsData,
    Map<String, dynamic>? metadata,
  }) async {
    final result = await _apiClient.post<Map<String, dynamic>>(
      PostsEndPoint.schedule,
      data: {
        'channel_id': channelId,
        'message': message,
        'scheduled_at': scheduledAt,
        if (rootId != null) 'root_id': rootId,
        if (fileIds != null) 'file_ids': fileIds,
        if (priority != null) 'priority': priority,
        if (propsData != null) 'props': propsData,
        if (metadata != null) 'metadata': metadata,
      },
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to create scheduled post');
  }

  @override
  Future<Map<String, dynamic>> editScheduledPost(
    String scheduledPostId, {
    required String channelId,
    required String message,
    required int scheduledAt,
    String? rootId,
    List<String>? fileIds,
    Map<String, dynamic>? priority,
    Map<String, dynamic>? propsData,
    Map<String, dynamic>? metadata,
  }) async {
    final result = await _apiClient.put<Map<String, dynamic>>(
      PostsEndPoint.schedule2(scheduledPostId),
      data: {
        'channel_id': channelId,
        'message': message,
        'scheduled_at': scheduledAt,
        if (rootId != null) 'root_id': rootId,
        if (fileIds != null) 'file_ids': fileIds,
        if (priority != null) 'priority': priority,
        if (propsData != null) 'props': propsData,
        if (metadata != null) 'metadata': metadata,
      },
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to edit scheduled post $scheduledPostId');
  }

  @override
  Future<void> deleteScheduledPost(String scheduledPostId) async {
    await _apiClient.delete(PostsEndPoint.schedule2(scheduledPostId));
  }
}
