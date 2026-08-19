import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/endpoints/endpoints.dart';
import 'package:flutter_mattermost/core/network/api_client.dart';
import 'package:flutter_mattermost/core/network/api_result.dart';
import 'package:flutter_mattermost/features/chat/data/models/scheduled_post_model.dart';

abstract class ScheduledPostsRemoteDataSource {
  Future<List<ScheduledPostModel>> getScheduledPosts({
    required String teamId,
    int page = 0,
    int perPage = 60,
  });
  Future<ScheduledPostModel> createScheduledPost(ScheduledPostModel post);
  Future<ScheduledPostModel> updateScheduledPost(ScheduledPostModel post);
  Future<void> deleteScheduledPost(String scheduledPostId);
}

@LazySingleton(as: ScheduledPostsRemoteDataSource)
class ScheduledPostsRemoteDataSourceImpl
    implements ScheduledPostsRemoteDataSource {
  final ApiClient _apiClient;

  ScheduledPostsRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<ScheduledPostModel>> getScheduledPosts({
    required String teamId,
    int page = 0,
    int perPage = 60,
  }) async {
    final result = await _apiClient.get<List<ScheduledPostModel>>(
      PostsEndPoint.scheduledTeam(teamId),
      queryParameters: {'page': page, 'per_page': perPage},
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => ScheduledPostModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<ScheduledPostModel>>) {
      return result.data;
    }
    final error = result is ApiFailure ? (result as ApiFailure).error : null;
    throw Exception(
      'Failed to get scheduled posts: ${error.runtimeType} - ${error.toString()}',
    );
  }

  @override
  Future<ScheduledPostModel> createScheduledPost(
    ScheduledPostModel post,
  ) async {
    final result = await _apiClient.post<ScheduledPostModel>(
      PostsEndPoint.schedule,
      data: post.toMap(),
      fromJson: (json) =>
          ScheduledPostModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<ScheduledPostModel>) {
      return result.data;
    }
    throw Exception('Failed to create scheduled post');
  }

  @override
  Future<ScheduledPostModel> updateScheduledPost(
    ScheduledPostModel post,
  ) async {
    final result = await _apiClient.put<ScheduledPostModel>(
      PostsEndPoint.schedule2(post.id),
      data: post.toMap(),
      fromJson: (json) =>
          ScheduledPostModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<ScheduledPostModel>) {
      return result.data;
    }
    throw Exception('Failed to update scheduled post');
  }

  @override
  Future<void> deleteScheduledPost(String scheduledPostId) async {
    final result = await _apiClient.delete(
      PostsEndPoint.schedule2(scheduledPostId),
    );
    if (result is ApiFailure) {
      throw Exception('Failed to delete scheduled post');
    }
  }
}
