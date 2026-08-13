import 'dart:typed_data';
import 'package:flutter_mattermost/features/chat/domain/entities/file_info_entity.dart';
import 'package:flutter_mattermost/features/chat/domain/entities/post_entity.dart';
import 'package:flutter_mattermost/features/chat/domain/entities/reaction_entity.dart';

abstract class PostRepository {
  Future<List<PostEntity>> getPostsForChannel(
    String channelId, {
    int page = 0,
    int perPage = 60,
    String? before,
    String? after,
  });
  Future<PostEntity> sendPost(
    String channelId,
    String message, {
    String? rootId,
    List<String> fileIds = const [],
    bool alsoSendToChannel = false,
  });
  Future<PostEntity> getPostById(String postId);
  Future<List<PostEntity>> getPostsAround(
    String channelId,
    String postId, {
    int perPage = 40,
  });
  Future<List<PostEntity>> getPostThread(String postId);
  Future<List<PostEntity>> searchPostsInTeam(String teamId, String term);
  Future<List<PostEntity>> getPinnedPosts(String channelId);
  Future<List<PostEntity>> getFlaggedPosts(String userId);
  Future<void> flagPost(String postId);
  Future<void> unflagPost(String postId);
  Future<PostEntity> patchPost(String postId, Map<String, dynamic> patch);
  Future<PostEntity> pinPost(String postId);
  Future<PostEntity> unpinPost(String postId);
  Future<void> deletePost(String postId);
  Future<Map<String, List<ReactionEntity>>> getReactionsForPosts(
    List<String> postIds,
  );
  Future<void> addReaction(String postId, String emoji);
  Future<void> removeReaction(String postId, String emoji);
  Future<List<FileInfoEntity>> getFilesForPost(String postId);
  Future<Uint8List> getFileThumbnail(String fileId);
  Future<Uint8List> getFile(String fileId);
}
