import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/features/chat/data/datasources/chat_local_data_source.dart';
import 'package:flutter_mattermost/features/chat/data/datasources/chat_remote_data_sources.dart';
import 'package:flutter_mattermost/features/auth/domain/repositories/auth_repository.dart';

@lazySingleton
class DeltaSyncService {
  final ChatLocalDataSource _localDataSource;
  final PostRemoteDataSource _postRemoteDataSource;
  final AuthRepository _authRepository;

  DeltaSyncService(
    this._localDataSource,
    this._postRemoteDataSource,
    this._authRepository,
  );

  Future<void> fullSync() async {
    // 1. Get current user & team
    final user = await _authRepository.getCurrentUser();
    if (user == null) return;

    // In a real implementation, we would store lastSyncAt per channel or globally
    // and only fetch changes since then.
    // For now, we perform a basic sync for active channels.

    // This is a placeholder for actual delta sync logic.
    // Mattermost provides specific endpoints for fetching updates since a timestamp.
  }

  Future<void> syncPosts(String channelId) async {
    // Sync posts for a specific channel
    try {
      final posts = await _postRemoteDataSource.getPostsForChannel(channelId);
      await _localDataSource.cachePosts(
        posts.map((dto) => dto.toEntity()).toList(),
      );
    } catch (_) {}
  }
}
