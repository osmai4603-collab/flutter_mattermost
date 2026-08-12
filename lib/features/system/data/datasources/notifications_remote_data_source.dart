// ignore_for_file: use_null_aware_elements

import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/network/api_client.dart';
import 'package:flutter_mattermost/core/network/api_result.dart';

import 'package:flutter_mattermost/core/endpoints/endpoints.dart';

abstract class NotificationsRemoteDataSource {
  Future<Map<String, dynamic>> ackNotification({
    required String userId,
    required String postId,
    String? reason,
    String? status,
    int? receivedAt,
    String? platform,
    bool? isIdLoaded,
    bool? isActive,
  });
  Future<Map<String, dynamic>> testNotification();
}

@LazySingleton(as: NotificationsRemoteDataSource)
class NotificationsRemoteDataSourceImpl
    implements NotificationsRemoteDataSource {
  final ApiClient _apiClient;

  NotificationsRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Map<String, dynamic>> ackNotification({
    required String userId,
    required String postId,
    String? reason,
    String? status,
    int? receivedAt,
    String? platform,
    bool? isIdLoaded,
    bool? isActive,
  }) async {
    final result = await _apiClient.post<Map<String, dynamic>>(
      NotificationsEndPoint.ack,
      data: {
        'user_id': userId,
        'post_id': postId,
        if (reason != null) 'reason': reason,
        if (status != null) 'status': status,
        if (receivedAt != null) 'received_at': receivedAt,
        if (platform != null) 'platform': platform,
        if (isIdLoaded != null) 'is_id_loaded': isIdLoaded,
        if (isActive != null) 'is_active': isActive,
      },
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to ack notification for post $postId');
  }

  @override
  Future<Map<String, dynamic>> testNotification() async {
    final result = await _apiClient.post<Map<String, dynamic>>(
      NotificationsEndPoint.test,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to send test notification');
  }
}
