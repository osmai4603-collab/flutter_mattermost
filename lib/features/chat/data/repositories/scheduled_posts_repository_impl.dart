import 'package:flutter_mattermost/features/chat/data/datasources/scheduled_posts_remote_data_source.dart';
import 'package:flutter_mattermost/features/chat/data/models/scheduled_post_model.dart';
import 'package:flutter_mattermost/features/chat/domain/repositories/scheduled_posts_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ScheduledPostsRepository)
class ScheduledPostsRepositoryImpl implements ScheduledPostsRepository {
  final ScheduledPostsRemoteDataSource _remoteDataSource;

  ScheduledPostsRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<ScheduledPostModel>> getScheduledPosts(
    String teamId, {
    int page = 0,
    int perPage = 60,
  }) {
    return _remoteDataSource.getScheduledPosts(
      teamId: teamId,
      page: page,
      perPage: perPage,
    );
  }

  @override
  Future<void> deleteScheduledPost(String scheduledPostId) {
    return _remoteDataSource.deleteScheduledPost(scheduledPostId);
  }

  @override
  Future<ScheduledPostModel> editScheduledPost(
    String scheduledPostId, {
    String? message,
    int? scheduledAt,
  }) {
    return _remoteDataSource.updateScheduledPost(
      ScheduledPostModel(
        id: scheduledPostId,
        message: message ?? '',
        scheduledAt: scheduledAt ?? 0,
      ),
    );
  }
}
