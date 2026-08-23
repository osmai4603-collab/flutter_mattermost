import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/network/api_client.dart';
import 'package:flutter_mattermost/core/network/api_result.dart';
import 'package:flutter_mattermost/features/auth/data/models/user_status_model.dart';
import 'package:flutter_mattermost/features/auth/domain/entities/user_status_entity.dart';

import 'package:flutter_mattermost/core/endpoints/endpoints.dart';

abstract class UserStatusRemoteDataSource {
  Future<List<UserStatusModel>> getStatusesByIds(List<String> userIds);
  Future<UserStatusModel> getStatus(String userId);
  Future<UserStatusModel> updateStatus(
    String userId,
    UserStatus status, {
    String? dndEndTime,
  });
  Future<UserStatusModel> updateCustomStatus(
    String userId, {
    required String emoji,
    String? text,
    String? duration,
    String? expiresAt,
  });
  Future<void> unsetCustomStatus(String userId);
  Future<void> removeRecentCustomStatus(String userId, String emoji);
}

@LazySingleton(as: UserStatusRemoteDataSource)
class UserStatusRemoteDataSourceImpl implements UserStatusRemoteDataSource {
  final ApiClient _apiClient;

  UserStatusRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<UserStatusModel>> getStatusesByIds(List<String> userIds) async {
    final result = await _apiClient.post<List<UserStatusModel>>(
      UsersEndPoint.statusIds,
      data: userIds,
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => UserStatusModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<UserStatusModel>>) {
      return result.data;
    }
    throw Exception('Failed to get statuses by ids');
  }

  @override
  Future<UserStatusModel> getStatus(String userId) async {
    final result = await _apiClient.get<UserStatusModel>(
      UsersEndPoint.status(userId),
      fromJson: (json) => UserStatusModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<UserStatusModel>) {
      return result.data;
    }
    throw Exception('Failed to get status for user $userId');
  }

  @override
  Future<UserStatusModel> updateStatus(
    String userId,
    UserStatus status, {
    String? dndEndTime,
  }) async {
    final result = await _apiClient.put<UserStatusModel>(
      UsersEndPoint.status(userId),
      data: {
        'user_id': userId,
        'status': status.value,
        'dnd_end_time': dndEndTime != null ? int.tryParse(dndEndTime) ?? 0 : 0,
      },
      fromJson: (json) => UserStatusModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<UserStatusModel>) {
      return result.data;
    }
    throw Exception('Failed to update status for user $userId');
  }

  @override
  Future<UserStatusModel> updateCustomStatus(
    String userId, {
    required String emoji,
    String? text,
    String? duration,
    String? expiresAt,
  }) async {
    final result = await _apiClient.put<dynamic>(
      UsersEndPoint.statusCustom('me'),
      data: {
        'emoji': emoji,
        'text': text ?? '',
        if (duration != null && duration.isNotEmpty) 'duration': duration,
        if (expiresAt != null && expiresAt.isNotEmpty) 'expires_at': expiresAt,
      },
      fromJson: (json) => json,
    );
    if (result is ApiSuccess) {
      return UserStatusModel(userId: userId, customStatus: text ?? '');
    }
    throw Exception('Failed to update custom status for user $userId');
  }

  @override
  Future<void> unsetCustomStatus(String userId) async {
    await _apiClient.delete(UsersEndPoint.statusCustom('me'));
  }

  @override
  Future<void> removeRecentCustomStatus(String userId, String emoji) async {
    await _apiClient.post<void>(
      UsersEndPoint.statusCustomRecentDelete('me'),
      data: {'emoji': emoji},
      fromJson: (_) {},
    );
  }
}
