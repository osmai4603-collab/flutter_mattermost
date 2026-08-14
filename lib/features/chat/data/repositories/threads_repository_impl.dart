import 'package:flutter_mattermost/features/chat/data/datasources/threads_remote_data_source.dart';
import 'package:flutter_mattermost/features/chat/data/models/thread_model.dart';
import 'package:flutter_mattermost/features/chat/domain/entities/thread_entity.dart';
import 'package:flutter_mattermost/features/chat/domain/repositories/threads_repository.dart';

/// ينفّذ [ThreadsRepository] عبر ThreadsRemoteDataSource مع فتح
/// الجذر (root post) من حمولة الاستجابة.
class ThreadsRepositoryImpl implements ThreadsRepository {
  final ThreadsRemoteDataSource _remoteDataSource;

  ThreadsRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<ThreadEntity>> getThreadsForUser(
    String userId,
    String teamId, {
    int page = 0,
    int perPage = 60,
    bool unread = false,
  }) async {
    final data = await _remoteDataSource.getThreadsForUser(
      teamId,
      page: page,
      perPage: perPage,
      unread: unread,
    );
    final rawThreads = (data['threads'] as List<dynamic>? ?? const []);
    return [
      for (final raw in rawThreads)
        ThreadModel.fromMap(raw as Map<String, dynamic>).toEntity(),
    ];
  }

  @override
  Future<void> markThreadAsRead(
    String userId,
    String teamId,
    String threadId,
  ) async {
    await _remoteDataSource.markThreadAsRead(
      userId,
      teamId,
      threadId,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );
  }

  @override
  Future<void> followThread(String userId, String teamId, String threadId) async {
    await _remoteDataSource.followThread(
      userId,
      teamId,
      threadId,
    );
  }

  @override
  Future<void> unfollowThread(String userId, String teamId, String threadId) async {
    await _remoteDataSource.unfollowThread(
      userId,
      teamId,
      threadId,
    );
  }

  @override
  Future<void> markAllThreadsAsRead(
    String userId,
    String teamId,
  ) async {
    await _remoteDataSource.markAllThreadsAsRead(
      userId,
      teamId,
    );
  }

  @override
  Future<void> setThreadUnread(
    String userId,
    String teamId,
    String threadId,
    String postId,
  ) async {
    await _remoteDataSource.setThreadUnread(
      userId,
      teamId,
      threadId,
      postId,
    );
  }

  @override
  Future<void> moveThread(String threadId, String channelId) async {
    await _remoteDataSource.moveThread(threadId, channelId);
  }
}
