import 'package:flutter_mattermost/features/chat/data/models/scheduled_post_model.dart';

/// مستودع الرسائل المجدولة — /posts/schedule.
abstract class ScheduledPostsRepository {
  Future<List<ScheduledPostModel>> getScheduledPosts(
    String teamId, {
    int page = 0,
    int perPage = 60,
  });

  Future<void> deleteScheduledPost(String scheduledPostId);

  Future<ScheduledPostModel> editScheduledPost(
    String scheduledPostId, {
    String? message,
    int? scheduledAt,
  });
}
