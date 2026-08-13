import 'dart:typed_data';
import 'package:flutter_mattermost/core/enums/post_type.dart';
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

  Future<String> _currentUserId() async =>
      (await _secureStorage.getUserId()) ?? 'me';

  @override
  Future<List<PostEntity>> getPostsForChannel(
    String channelId, {
    int page = 0,
    int perPage = 60,
    String? before,
    String? after,
  }) async {
    try {
      final models = await _remoteDataSource.getPostsForChannel(
        channelId,
        page: page,
        perPage: perPage,
        before: before,
        after: after,
      );
      final entities = models.map((m) => m.toEntity()).toList();

      await _localDataSource.cachePosts(entities);
      return entities;
    } catch (_) {
      return await _localDataSource.getCachedPosts(channelId);
    }
  }

  @override
  Future<PostEntity> sendPost(
    String channelId,
    String message, {
    String? rootId,
    List<String> fileIds = const [],
    bool alsoSendToChannel = false,
  }) async {
    try {
      final model = await _remoteDataSource.sendPost(
        channelId,
        message,
        rootId: rootId,
        fileIds: fileIds,
        alsoSendToChannel: alsoSendToChannel,
      );
      final entity = model.toEntity();

      await _localDataSource.cachePosts([entity]);
      return entity;
    } catch (e) {
      final offlineEntity = PostEntity(
        id: 'pending_${DateTime.now().millisecondsSinceEpoch}',
        channelId: channelId,
        userId: 'current_user',
        message: message,
        rootId: rootId ?? '',
        createAt: DateTime.now().millisecondsSinceEpoch,
        updateAt: DateTime.now().millisecondsSinceEpoch,
        deleteAt: 0,
        editAt: 0,
        originalId: '',
        type: PostType.defaultType,
        propsData: const {},
        hashtag: '',
        fileIds: fileIds,
        pendingPostId: 'pending_${DateTime.now().millisecondsSinceEpoch}',
      );
      await _localDataSource.cachePosts([offlineEntity]);
      await _localDataSource.enqueuePendingAction('CREATE_POST', {
        'channel_id': channelId,
        'message': message,
        'root_id': rootId,
        if (fileIds.isNotEmpty) 'file_ids': fileIds,
      });
      return offlineEntity;
    }
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
  Future<List<PostEntity>> searchPostsInTeam(String teamId, String term) async {
    final models = await _remoteDataSource.searchPostsInTeam(teamId, {
      'terms': term,
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
  Future<Map<String, List<ReactionEntity>>> getReactionsForPosts(
    List<String> postIds,
  ) async {
    if (postIds.isEmpty) return {};
    final byPost = await _reactionsDataSource.getReactionsForPosts(postIds);
    return byPost.map(
      (postId, models) => MapEntry(postId, models.map((m) => m.toEntity()).toList()),
    );
  }

  @override
  Future<void> addReaction(String postId, String emoji) async {
    final userId = await _currentUserId();
    await _reactionsDataSource.addReaction(
      emoji: emoji,
      postId: postId,
      userId: userId,
    );
  }

  @override
  Future<void> removeReaction(String postId, String emoji) async {
    final userId = await _currentUserId();
    await _reactionsDataSource.removeReaction(userId, postId, emoji);
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
