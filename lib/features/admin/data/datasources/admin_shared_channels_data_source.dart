import 'package:flutter_mattermost/features/channels/data/models/remote_cluster_info_model.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/endpoints/endpoints.dart';
import 'package:flutter_mattermost/core/network/api_client.dart';
import 'package:flutter_mattermost/core/network/api_result.dart';
import 'package:flutter_mattermost/features/channels/data/models/shared_channel_model.dart';
import 'package:flutter_mattermost/features/channels/data/models/shared_channel_remote_model.dart';

abstract class AdminSharedChannelsDataSource {
  Future<RemoteClusterInfoModel> getRemoteInfo(String remoteId);
  Future<List<SharedChannelRemoteModel>> getChannelRemotes(String channelId);
  Future<Map<String, dynamic>> canUserDm(String userId, String otherUserId);
  Future<Map<String, dynamic>> createInstallation(Map<String, dynamic> data);
  Future<void> handleCloudWebhook(Map<String, dynamic> data);
  Future<List<SharedChannelModel>> getAllSharedChannels(
    String teamId, {
    int page = 0,
    int perPage = 60,
  });

  // Missing operations from docs
  Future<List<SharedChannelRemoteModel>> getSharedChannelRemotes({int page = 0, int perPage = 60});
  Future<List<SharedChannelRemoteModel>> getSharedChannelRemotesByRemoteCluster(String remoteId);
}

@LazySingleton(as: AdminSharedChannelsDataSource)
class AdminSharedChannelsDataSourceImpl
    implements AdminSharedChannelsDataSource {
  final ApiClient _apiClient;

  AdminSharedChannelsDataSourceImpl(this._apiClient);

  @override
  Future<RemoteClusterInfoModel> getRemoteInfo(String remoteId) async {
    final result = await _apiClient.get<RemoteClusterInfoModel>(
      SharedChannelsEndPoint.remoteInfo(remoteId),
      fromJson: (json) => RemoteClusterInfoModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<RemoteClusterInfoModel>) {
      return result.data;
    }
    throw Exception('Failed to get remote info $remoteId');
  }

  @override
  Future<List<SharedChannelRemoteModel>> getChannelRemotes(
    String channelId,
  ) async {
    final result = await _apiClient.get<List<SharedChannelRemoteModel>>(
      SharedChannelsEndPoint.remotes(channelId),
      fromJson: (json) => (json as List<dynamic>)
          .map((e) =>
              SharedChannelRemoteModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<SharedChannelRemoteModel>>) {
      return result.data;
    }
    throw Exception('Failed to get remotes for channel $channelId');
  }

  @override
  Future<Map<String, dynamic>> canUserDm(
    String userId,
    String otherUserId,
  ) async {
    final result = await _apiClient.get<Map<String, dynamic>>(
      SharedChannelsEndPoint.usersCanDm(userId, otherUserId),
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to check DM between $userId and $otherUserId');
  }

  @override
  Future<Map<String, dynamic>> createInstallation(
    Map<String, dynamic> data,
  ) async {
    final result = await _apiClient.post<Map<String, dynamic>>(
      CloudEndPoint.installation,
      data: data,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to create installation');
  }

  @override
  Future<void> handleCloudWebhook(Map<String, dynamic> data) async {
    final result = await _apiClient.post<void>(
      CloudEndPoint.webhook,
      data: data,
      fromJson: (_) {},
    );
    if (result is ApiFailure) {
      throw Exception('Failed to handle cloud webhook');
    }
  }

  @override
  Future<List<SharedChannelModel>> getAllSharedChannels(
    String teamId, {
    int page = 0,
    int perPage = 60,
  }) async {
    final result = await _apiClient.get<List<SharedChannelModel>>(
      SharedChannelsEndPoint.byTeamId(teamId),
      queryParameters: {'page': page, 'per_page': perPage},
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => SharedChannelModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<SharedChannelModel>>) {
      return result.data;
    }
    throw Exception('Failed to get shared channels for team $teamId');
  }

  @override
  Future<List<SharedChannelRemoteModel>> getSharedChannelRemotes({int page = 0, int perPage = 60}) async {
    final result = await _apiClient.get<List<SharedChannelRemoteModel>>(
      SharedChannelsEndPoint.remotesRoot,
      queryParameters: {'page': page, 'per_page': perPage},
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => SharedChannelRemoteModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<SharedChannelRemoteModel>>) {
      return result.data;
    }
    throw Exception('Failed to get shared channel remotes');
  }

  @override
  Future<List<SharedChannelRemoteModel>> getSharedChannelRemotesByRemoteCluster(String remoteId) async {
    final result = await _apiClient.get<List<SharedChannelRemoteModel>>(
      SharedChannelsEndPoint.remotesByRemoteId(remoteId),
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => SharedChannelRemoteModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<SharedChannelRemoteModel>>) {
      return result.data;
    }
    throw Exception('Failed to get shared channel remotes by remote cluster');
  }
}
