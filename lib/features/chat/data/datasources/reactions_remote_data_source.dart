import 'package:flutter_mattermost/core/network/api_error.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/endpoints/endpoints.dart';
import 'package:flutter_mattermost/core/network/api_client.dart';
import 'package:flutter_mattermost/core/network/api_result.dart';
import 'package:flutter_mattermost/core/storage/secure_storage_service.dart';
import 'package:flutter_mattermost/core/utils/emoji_utils.dart';
import 'package:flutter_mattermost/features/chat/data/models/reaction_model.dart';
import 'package:flutter_mattermost/features/users/data/datasources/users_remote_data_source.dart';

abstract class ReactionsRemoteDataSource {
  Future<ReactionModel> addReaction({
    required String emoji,
    required String postId,
    required String userId,
    bool fromWebSocket = false,
  });
  Future<void> removeReaction(String userId, String postId, String emoji);
  Future<List<ReactionModel>> getReactionsForPost(String postId);
  Future<Map<String, List<ReactionModel>>> getReactionsForPosts(
    List<String> postIds,
  );
}

@LazySingleton(as: ReactionsRemoteDataSource)
class ReactionsRemoteDataSourceImpl implements ReactionsRemoteDataSource {
  final ApiClient _apiClient;

  ReactionsRemoteDataSourceImpl(this._apiClient);

  /// Resolves an emoji input to a Mattermost-compatible shortcode name.
  ///
  /// Converts unicode characters (e.g. '👍') to their shortcode equivalent
  /// (e.g. '+1'), strips colon wrappers, and lowercases the result.
  String _cleanEmoji(String emoji) => EmojiUtils.resolveToMattermostName(emoji);

  Future<String> _resolveUserId(String userId) async {
    if (userId.isNotEmpty && userId != 'me') {
      return userId;
    }
    try {
      final storage = getIt<SecureStorageService>();
      final storedId = await storage.getUserId();
      if (storedId != null && storedId.isNotEmpty && storedId != 'me') {
        return storedId;
      }
      final me = await getIt<UsersRemoteDataSource>().getMe();
      if (me.id.isNotEmpty) {
        await storage.saveUserId(me.id);
        return me.id;
      }
    } catch (_) {}
    return userId;
  }

  @override
  Future<ReactionModel> addReaction({
    required String emoji,
    required String postId,
    required String userId,
    bool fromWebSocket = false,
  }) async {
    final cleanEmoji = _cleanEmoji(emoji);
    final actualUserId = await _resolveUserId(userId);

    final result = await _apiClient.post<ReactionModel>(
      ReactionsEndPoint.root,
      data: {
        'user_id': actualUserId,
        'post_id': postId,
        'emoji_name': cleanEmoji,
        'create_at': DateTime.now().millisecondsSinceEpoch,
        // 'from_webhook': fromWebSocket,
      },
      fromJson: (json) => ReactionModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<ReactionModel>) {
      return result.data;
    }
    final error = (result as ApiFailure<ReactionModel>).error;
    final msg = error is ResourceError
        ? error.message
        : error is ServerError
        ? error.message
        : error.toString();
    throw Exception('Failed to add reaction to post $postId: $msg');
  }

  @override
  Future<void> removeReaction(
    String userId,
    String postId,
    String emoji,
  ) async {
    final cleanEmoji = _cleanEmoji(emoji);
    final actualUserId = await _resolveUserId(userId);
    final encodedEmoji = Uri.encodeComponent(cleanEmoji);

    await _apiClient.delete(
      UsersEndPoint.postsReactions(actualUserId, postId, encodedEmoji),
    );
  }

  @override
  Future<List<ReactionModel>> getReactionsForPost(String postId) async {
    final result = await _apiClient.get<List<ReactionModel>>(
      PostsEndPoint.reactions(postId),
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => ReactionModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<ReactionModel>>) {
      return result.data;
    }
    final error = (result as ApiFailure<List<ReactionModel>>).error;
    final msg = error is ResourceError
        ? error.message
        : error is ServerError
        ? error.message
        : error.toString();
    throw Exception('Failed to get reactions for post $postId: $msg');
  }

  @override
  Future<Map<String, List<ReactionModel>>> getReactionsForPosts(
    List<String> postIds,
  ) async {
    final result = await _apiClient.post<Map<String, List<ReactionModel>>>(
      PostsEndPoint.idsReactions,
      data: postIds,
      fromJson: (json) {
        final data = json as Map<String, dynamic>;
        return data.map(
          (postId, reactions) => MapEntry(
            postId,
            (reactions as List<dynamic>)
                .map((e) => ReactionModel.fromMap(e as Map<String, dynamic>))
                .toList(),
          ),
        );
      },
    );
    if (result is ApiSuccess<Map<String, List<ReactionModel>>>) {
      return result.data;
    }
    final error =
        (result as ApiFailure<Map<String, List<ReactionModel>>>).error;
    final msg = error is ResourceError
        ? error.message
        : error is ServerError
        ? error.message
        : error.toString();
    throw Exception('Failed to get reactions for multiple posts: $msg');
  }
}
