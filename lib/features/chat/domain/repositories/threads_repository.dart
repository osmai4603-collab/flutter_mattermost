import 'package:flutter_mattermost/features/chat/domain/entities/thread_entity.dart';

/// وصول ثقّي للمحادثات متعددة الفروع (webapp global threads).
abstract class ThreadsRepository {
  Future<List<ThreadEntity>> getThreadsForUser(
    String userId,
    String teamId, {
    int page = 0,
    int perPage = 60,
    bool unread = false,
  });

  Future<void> markThreadAsRead(
    String userId,
    String teamId,
    String threadId,
  );

  Future<void> followThread(
    String userId,
    String teamId,
    String threadId,
  );

  Future<void> unfollowThread(
    String userId,
    String teamId,
    String threadId,
  );

  Future<void> markAllThreadsAsRead(
    String userId,
    String teamId,
  );
}
