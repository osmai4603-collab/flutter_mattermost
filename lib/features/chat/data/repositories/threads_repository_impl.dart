import 'package:flutter_mattermost/core/storage/secure_storage_service.dart';
import 'package:flutter_mattermost/features/chat/data/datasources/threads_remote_data_source.dart';
import 'package:flutter_mattermost/features/chat/data/models/thread_model.dart';
import 'package:flutter_mattermost/features/chat/domain/entities/thread_entity.dart';
import 'package:flutter_mattermost/features/chat/domain/repositories/threads_repository.dart';

/// ينفّذ [ThreadsRepository] عبر ThreadsRemoteDataSource مع فتح
/// الجذر (root post) من حمولة الاستجابة.
class ThreadsRepositoryImpl implements ThreadsRepository {
  final ThreadsRemoteDataSource _remoteDataSource;
  final SecureStorageService _secureStorage;

  ThreadsRepositoryImpl(this._remoteDataSource, this._secureStorage);

  Future<String> _currentUserId() async =>
      (await _secureStorage.getUserId()) ?? 'me';

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
}
