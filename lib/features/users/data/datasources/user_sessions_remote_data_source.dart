import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/network/api_client.dart';
import 'package:flutter_mattermost/core/network/api_result.dart';
import 'package:flutter_mattermost/features/auth/data/models/session_model.dart';

import 'package:flutter_mattermost/core/endpoints/endpoints.dart';

abstract class UserSessionsRemoteDataSource {
  Future<List<SessionModel>> getUserSessions(String userId);
  Future<List<SessionModel>> getMySessions();
  Future<void> revokeSession(String userId, String sessionId);
  Future<void> revokeAllSessionsForUser(String userId);
  Future<void> revokeAllSessions();
}

@LazySingleton(as: UserSessionsRemoteDataSource)
class UserSessionsRemoteDataSourceImpl implements UserSessionsRemoteDataSource {
  final ApiClient _apiClient;

  UserSessionsRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<SessionModel>> getUserSessions(String userId) async {
    final result = await _apiClient.get<List<SessionModel>>(
      UsersEndPoint.sessions(userId),
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => SessionModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<SessionModel>>) {
      return result.data;
    }
    throw Exception('Failed to get sessions for user $userId');
  }

  @override
  Future<List<SessionModel>> getMySessions() => getUserSessions('me');

  @override
  Future<void> revokeSession(String userId, String sessionId) async {
    await _apiClient.post<void>(
      UsersEndPoint.sessionsRevoke(userId),
      data: {'session_id': sessionId},
      fromJson: (_) {},
    );
  }

  @override
  Future<void> revokeAllSessionsForUser(String userId) async {
    await _apiClient.post<void>(
      UsersEndPoint.sessionsRevokeAll2(userId),
      fromJson: (_) {},
    );
  }

  @override
  Future<void> revokeAllSessions() async {
    await _apiClient.post<void>(
      UsersEndPoint.sessionsRevokeAll,
      fromJson: (_) {},
    );
  }
}
