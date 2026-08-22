import 'dart:typed_data';
import 'package:flutter_mattermost/core/storage/secure_storage_service.dart';
import 'package:flutter_mattermost/features/chat/data/datasources/chat_local_data_source.dart';
import 'package:flutter_mattermost/features/chat/data/datasources/chat_remote_data_sources.dart';
import 'package:flutter_mattermost/features/chat/data/datasources/files_remote_data_source.dart';
import 'package:flutter_mattermost/features/chat/data/datasources/reactions_remote_data_source.dart';
import 'package:flutter_mattermost/features/chat/domain/entities/file_info_entity.dart';
import 'package:flutter_mattermost/features/chat/domain/entities/post_entity.dart';
import 'package:flutter_mattermost/features/chat/domain/entities/reaction_entity.dart';
import 'package:flutter_mattermost/features/chat/domain/repositories/post_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/features/users/data/datasources/users_remote_data_source.dart';

@LazySingleton(as: PostRepository)
class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource _remoteDataSource;
  final ChatLocalDataSource _localDataSource;
  final ReactionsRemoteDataSource _reactionsDataSource;
  final FilesRemoteDataSource _filesDataSource;
  final SecureStorageService _secureStorage;

  PostRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._reactionsDataSource,
    this._filesDataSource,
    this._secureStorage,
  );

  Future<String> _currentUserId() async {
    final stored = await _secureStorage.getUserId();
    if (stored != null && stored.isNotEmpty && stored != 'me') {
      return stored;
    }
    try {
      final me = await getIt<UsersRemoteDataSource>().getMe();
      if (me.id.isNotEmpty) {
        await _secureStorage.saveUserId(me.id);
        return me.id;
      }
    } catch (_) {}
    return 'me';
  }

  @override
  Future<List<PostEntity>> getPostsForChannel(
    String channelId, {
    int page = 0,
    int perPage = 60,
    String? before,
    String? after,
  }) async {
    final models = await _remoteDataSource.getPostsForChannel(
      channelId,
      page: page,
      perPage: perPage,
      before: before,
      after: after,
    );
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<PostEntity>> getPostsUnread(
    String userId,
    String channelId, {
    int? limitBefore,
    int? limitAfter,
  }) async {
    final models = await _remoteDataSource.getPostsUnread(
      userId,
      channelId,
      limitBefore: limitBefore,
      limitAfter: limitAfter,
    );
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<PostEntity> sendPost(
    String channelId,
    String message, {
    String? rootId,
    List<String> fileIds = const [],
    bool alsoSendToChannel = false,
    Map<String, dynamic>? metadata,
    int? scheduledAt,
  }) async {
    final model = await _remoteDataSource.sendPost(
      channelId,
      message,
      rootId: rootId,
      fileIds: fileIds,
      alsoSendToChannel: alsoSendToChannel,
      metadata: metadata,
      scheduledAt: scheduledAt,
    );
    return model.toEntity();
  }

  @override
  Future<PostEntity> getPostById(String postId) async {
    final model = await _remoteDataSource.getPost(postId);
    return model.toEntity();
  }

  @override
  Future<List<PostEntity>> getPostsAround(
    String channelId,
    String postId, {
    int perPage = 40,
  }) async {
    final models = await _remoteDataSource.getPostsAround(
      channelId,
      postId,
      perPage: perPage,
    );
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<PostEntity>> getPostThread(String postId) async {
    final models = await _remoteDataSource.getPostThread(postId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<PostEntity>> searchPostsInTeam(
    String teamId,
    String term, {
    bool isOrSearch = false,
  }) async {
    final models = await _remoteDataSource.searchPostsInTeam(teamId, {
      'terms': term,
      if (isOrSearch) 'is_or_search': true,
    });
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<PostEntity>> getPinnedPosts(String channelId) async {
    final models = await _remoteDataSource.getPinnedPosts(channelId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<PostEntity>> getFlaggedPosts(String userId) async {
    final models = await _remoteDataSource.getFlaggedPosts(userId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> flagPost(String postId) =>
      _remoteDataSource.flagPost('me', postId);

  @override
  Future<void> unflagPost(String postId) =>
      _remoteDataSource.unflagPost('me', postId);

  @override
  Future<PostEntity> patchPost(
    String postId,
    Map<String, dynamic> patch,
  ) async {
    final model = await _remoteDataSource.patchPost(postId, patch);
    return model.toEntity();
  }

  @override
  Future<PostEntity> pinPost(String postId) async {
    final model = await _remoteDataSource.pinPost(postId);
    return model.toEntity();
  }

  @override
  Future<PostEntity> unpinPost(String postId) async {
    final model = await _remoteDataSource.unpinPost(postId);
    return model.toEntity();
  }

  @override
  Future<void> deletePost(String postId) =>
      _remoteDataSource.deletePost(postId);

  @override
  Future<List<PostEntity>> getPostEditHistory(String postId) async {
    final models = await _remoteDataSource.getPostEditHistory(postId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<PostEntity> restorePostVersion(
    String postId,
    String versionId,
  ) async {
    final model =
        await _remoteDataSource.restorePostVersion(postId, versionId);
    return model.toEntity();
  }

  @override
  Future<Map<String, List<ReactionEntity>>> getReactionsForPosts(
    List<String> postIds,
  ) async {
    if (postIds.isEmpty) return {};
    try {
      final byPost = await _reactionsDataSource.getReactionsForPosts(postIds);
      final result = byPost.map(
        (postId, models) =>
            MapEntry(postId, models.map((m) => m.toEntity()).toList()),
      );
      // تخزين محلي عند النجاح ليتم عرض التفاعلات في وضع الأوفلاين لاحقاً.
      final all = result.values.expand((list) => list).toList();
      if (all.isNotEmpty) {
        await _localDataSource.cacheReactions(all);
      }
      return result;
    } catch (_) {
      // الاحتياطي المحلي عند فشل الشبكة (وضع الأوفلاين).
      return _localDataSource.getCachedReactionsForPosts(postIds);
    }
  }

  @override
  Future<void> addReaction(String postId, String emoji) async {
    final userId = await _currentUserId();
    try {
      await _reactionsDataSource.addReaction(
        emoji: emoji,
        postId: postId,
        userId: userId,
      );
      // تحديث قاعدة البيانات المحلية فور النجاح.
      await _localDataSource.cacheReactions([
        ReactionEntity(
          serverId: '', // سيتم تحديثه عند المزامنة الكاملة
          userId: userId,
          postId: postId,
          emojiName: emoji,
          createAt: DateTime.now().millisecondsSinceEpoch,
        ),
      ]);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> removeReaction(String postId, String emoji) async {
    final userId = await _currentUserId();
    try {
      await _reactionsDataSource.removeReaction(userId, postId, emoji);
      // إزالة التفاعل من قاعدة البيانات المحلية.
      await _localDataSource.removeReaction(userId, postId, emoji);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<FileInfoEntity>> getFilesForPost(String postId) async {
    final models = await _filesDataSource.getFilesForPost(postId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Uint8List> getFileThumbnail(String fileId) =>
      _filesDataSource.getFileThumbnail(fileId);

  @override
  Future<Uint8List> getFile(String fileId) =>
      _filesDataSource.getFile(fileId);
}
