import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/network/api_client.dart';
import 'package:flutter_mattermost/core/network/api_result.dart';
import 'package:flutter_mattermost/features/chat/data/models/reaction_model.dart';

import 'package:flutter_mattermost/core/endpoints/endpoints.dart';

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

  @override
  Future<ReactionModel> addReaction({
    required String emoji,
    required String postId,
    required String userId,
    bool fromWebSocket = false,
  }) async {
    final result = await _apiClient.post<ReactionModel>(
      ReactionsEndPoint.root,
      data: {
        'user_id': userId,
        'post_id': postId,
        'emoji_name': emoji,
        'from_webhook': fromWebSocket,
      },
      fromJson: (json) => ReactionModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<ReactionModel>) {
      return result.data;
    }
    throw Exception('Failed to add reaction to post $postId');
  }

  @override
  Future<void> removeReaction(
    String userId,
    String postId,
    String emoji,
  ) async {
    await _apiClient.delete(
      UsersEndPoint.postsReactions(userId, postId, emoji),
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
    throw Exception('Failed to get reactions for post $postId');
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
    throw Exception('Failed to get reactions for multiple posts');
  }
}
