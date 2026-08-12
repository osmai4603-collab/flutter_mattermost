import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/network/api_client.dart';
import 'package:flutter_mattermost/core/network/api_result.dart';
import 'package:flutter_mattermost/features/channels/data/models/channel_join_request_model.dart';

import 'package:flutter_mattermost/core/endpoints/endpoints.dart';

abstract class ChannelJoinRequestsRemoteDataSource {
  Future<Map<String, dynamic>> getMyChannelJoinRequest(String channelId);
  Future<Map<String, dynamic>> requestJoinChannel(
    String channelId, {
    String? invitationId,
    String? message,
    String? joinUrlId,
  });
  Future<void> withdrawMyChannelJoinRequest(String channelId);
  Future<List<ChannelJoinRequestModel>> getChannelJoinRequests(
    String channelId, {
    int page = 0,
    int perPage = 60,
  });
  Future<int> countPendingChannelJoinRequests(String channelId);
  Future<Map<String, dynamic>> patchChannelJoinRequest(
    String channelId,
    String requestId, {
    String? status,
    String? userId,
  });
  Future<List<ChannelJoinRequestModel>> getMyChannelJoinRequests({
    int page = 0,
    int perPage = 60,
  });
}

@LazySingleton(as: ChannelJoinRequestsRemoteDataSource)
class ChannelJoinRequestsRemoteDataSourceImpl
    implements ChannelJoinRequestsRemoteDataSource {
  final ApiClient _apiClient;

  ChannelJoinRequestsRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Map<String, dynamic>> getMyChannelJoinRequest(String channelId) async {
    final result = await _apiClient.get<Map<String, dynamic>>(
      ChannelsEndPoint.joinRequest(channelId),
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to get my join request for channel $channelId');
  }

  @override
  Future<Map<String, dynamic>> requestJoinChannel(
    String channelId, {
    String? invitationId,
    String? message,
    String? joinUrlId,
  }) async {
    final result = await _apiClient.post<Map<String, dynamic>>(
      ChannelsEndPoint.joinRequest(channelId),
      data: {
        if (invitationId != null) 'invitation_id': invitationId,
        if (message != null) 'message': message,
        if (joinUrlId != null) 'join_url_id': joinUrlId,
      },
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to request join for channel $channelId');
  }

  @override
  Future<void> withdrawMyChannelJoinRequest(String channelId) async {
    await _apiClient.delete(ChannelsEndPoint.joinRequest(channelId));
  }

  @override
  Future<List<ChannelJoinRequestModel>> getChannelJoinRequests(
    String channelId, {
    int page = 0,
    int perPage = 60,
  }) async {
    final result = await _apiClient.get<List<ChannelJoinRequestModel>>(
      ChannelsEndPoint.joinRequests(channelId),
      queryParameters: {'page': page, 'per_page': perPage},
      fromJson: (json) => (json as List<dynamic>)
          .map(
            (e) => ChannelJoinRequestModel.fromMap(e as Map<String, dynamic>),
          )
          .toList(),
    );
    if (result is ApiSuccess<List<ChannelJoinRequestModel>>) {
      return result.data;
    }
    throw Exception('Failed to get join requests for channel $channelId');
  }

  @override
  Future<int> countPendingChannelJoinRequests(String channelId) async {
    final result = await _apiClient.get<Map<String, dynamic>>(
      ChannelsEndPoint.joinRequestsCount(channelId),
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return (result.data['count'] as num?)?.toInt() ?? 0;
    }
    throw Exception('Failed to count pending join requests for $channelId');
  }

  @override
  Future<Map<String, dynamic>> patchChannelJoinRequest(
    String channelId,
    String requestId, {
    String? status,
    String? userId,
  }) async {
    final result = await _apiClient.patch<Map<String, dynamic>>(
      ChannelsEndPoint.joinRequests2(channelId, requestId),
      data: {
        if (status != null) 'status': status,
        if (userId != null) 'user_id': userId,
      },
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to patch join request $requestId');
  }

  @override
  Future<List<ChannelJoinRequestModel>> getMyChannelJoinRequests({
    int page = 0,
    int perPage = 60,
  }) async {
    final result = await _apiClient.get<List<ChannelJoinRequestModel>>(
      UsersEndPoint.channelJoinRequests('me'),
      queryParameters: {'page': page, 'per_page': perPage},
      fromJson: (json) => (json as List<dynamic>)
          .map(
            (e) => ChannelJoinRequestModel.fromMap(e as Map<String, dynamic>),
          )
          .toList(),
    );
    if (result is ApiSuccess<List<ChannelJoinRequestModel>>) {
      return result.data;
    }
    throw Exception('Failed to get my channel join requests');
  }
}
