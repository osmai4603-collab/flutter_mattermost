import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/network/api_client.dart';
import 'package:flutter_mattermost/core/network/api_result.dart';
import 'package:flutter_mattermost/features/auth/data/models/user_access_token_model.dart';

import 'package:flutter_mattermost/core/endpoints/endpoints.dart';

abstract class UserTokensRemoteDataSource {
  Future<List<UserAccessTokenModel>> getUserAccessTokens({
    int page = 0,
    int perPage = 60,
  });
  Future<UserAccessTokenModel> getUserAccessToken(String tokenId);
  Future<void> disableUserAccessToken(String tokenId);
  Future<void> enableUserAccessToken(String tokenId);
  Future<void> revokeUserAccessToken(String tokenId);
  Future<UserAccessTokenModel> rotateUserAccessToken(String tokenId);
  Future<int> getNonCompliantUserAccessTokenCount();
  Future<void> revokeNonCompliantUserAccessTokens();
  Future<List<UserAccessTokenModel>> getUserAccessTokensForUser(String userId);
  Future<UserAccessTokenModel> createUserAccessToken(
    String userId,
    String description,
  );
}

@LazySingleton(as: UserTokensRemoteDataSource)
class UserTokensRemoteDataSourceImpl implements UserTokensRemoteDataSource {
  final ApiClient _apiClient;

  UserTokensRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<UserAccessTokenModel>> getUserAccessTokens({
    int page = 0,
    int perPage = 60,
  }) async {
    final result = await _apiClient.get<List<UserAccessTokenModel>>(
      UsersEndPoint.tokens,
      queryParameters: {'page': page, 'per_page': perPage},
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => UserAccessTokenModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<UserAccessTokenModel>>) {
      return result.data;
    }
    throw Exception('Failed to get user access tokens');
  }

  @override
  Future<UserAccessTokenModel> getUserAccessToken(String tokenId) async {
    final result = await _apiClient.get<UserAccessTokenModel>(
      UsersEndPoint.tokens2(tokenId),
      fromJson: (json) =>
          UserAccessTokenModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<UserAccessTokenModel>) {
      return result.data;
    }
    throw Exception('Failed to get access token $tokenId');
  }

  @override
  Future<void> disableUserAccessToken(String tokenId) async {
    await _apiClient.post<void>(
      UsersEndPoint.tokensDisable,
      data: {'token_id': tokenId},
      fromJson: (_) {},
    );
  }

  @override
  Future<void> enableUserAccessToken(String tokenId) async {
    await _apiClient.post<void>(
      UsersEndPoint.tokensEnable,
      data: {'token_id': tokenId},
      fromJson: (_) {},
    );
  }

  @override
  Future<void> revokeUserAccessToken(String tokenId) async {
    await _apiClient.post<void>(
      UsersEndPoint.tokensRevoke,
      data: {'token_id': tokenId},
      fromJson: (_) {},
    );
  }

  @override
  Future<UserAccessTokenModel> rotateUserAccessToken(String tokenId) async {
    final result = await _apiClient.post<UserAccessTokenModel>(
      UsersEndPoint.tokensRotate,
      data: {'token_id': tokenId},
      fromJson: (json) =>
          UserAccessTokenModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<UserAccessTokenModel>) {
      return result.data;
    }
    throw Exception('Failed to rotate access token $tokenId');
  }

  @override
  Future<int> getNonCompliantUserAccessTokenCount() async {
    final result = await _apiClient.get<Map<String, dynamic>>(
      UsersEndPoint.tokensNonCompliantCount,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return (result.data['count'] as int?) ?? 0;
    }
    throw Exception('Failed to get non-compliant token count');
  }

  @override
  Future<void> revokeNonCompliantUserAccessTokens() async {
    await _apiClient.post<void>(
      UsersEndPoint.tokensNonCompliantRevoke,
      fromJson: (_) {},
    );
  }

  @override
  Future<List<UserAccessTokenModel>> getUserAccessTokensForUser(
    String userId,
  ) async {
    final result = await _apiClient.get<List<UserAccessTokenModel>>(
      UsersEndPoint.tokens3(userId),
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => UserAccessTokenModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<UserAccessTokenModel>>) {
      return result.data;
    }
    throw Exception('Failed to get access tokens for user $userId');
  }

  @override
  Future<UserAccessTokenModel> createUserAccessToken(
    String userId,
    String description,
  ) async {
    final result = await _apiClient.post<UserAccessTokenModel>(
      UsersEndPoint.tokens3(userId),
      data: {'description': description},
      fromJson: (json) =>
          UserAccessTokenModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<UserAccessTokenModel>) {
      return result.data;
    }
    throw Exception('Failed to create access token for user $userId');
  }
}
