// ignore_for_file: use_null_aware_elements

import 'package:flutter_mattermost/features/channels/data/models/shared_channel_model.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/endpoints/endpoints.dart';
import 'package:flutter_mattermost/core/network/api_client.dart';
import 'package:flutter_mattermost/core/network/api_result.dart';
import 'package:flutter_mattermost/features/channels/data/models/remote_cluster_info_model.dart';
import 'package:flutter_mattermost/features/system/data/models/remote_cluster_model.dart';

abstract class AdminRemoteClusterDataSource {
  Future<List<RemoteClusterModel>> getRemoteClusters({
    int page = 0,
    int perPage = 60,
  });
  Future<RemoteClusterModel> getRemoteCluster(String remoteId);
  Future<void> updateRemoteCluster(String remoteId, Map<String, dynamic> patch);
  Future<void> deleteRemoteCluster(String remoteId);
  Future<Map<String, dynamic>> generateInvite(String remoteId);
  Future<Map<String, dynamic>> acceptInvite({
    required String token,
    required String displayName,
    required String description,
    String? remoteId,
  });
  Future<Map<String, dynamic>> confirmInvite(String remoteId);
  Future<void> uninviteRemoteCluster(String remoteId, String channelId);
  Future<void> inviteRemoteCluster(String remoteId, String channelId);
  Future<List<RemoteClusterInfoModel>> getSharedChannelRemotes(
    String remoteId,
  );
  Future<void> sendRemoteClusterMessage(Map<String, dynamic> message);
  Future<Map<String, dynamic>> pingRemoteCluster({String? remoteId});
  Future<void> uploadRemoteClusterData(String uploadId, Map<String, dynamic> data);
  Future<void> setRemoteProfileImage(String userId, String filePath);
  Future<RemoteClusterInfoModel> getRemoteClusterInfo(String remoteId);

  // Missing operations from docs
  Future<List<SharedChannelModel>> getAllSharedChannels({int page = 0, int perPage = 60, String teamId = ''});
  Future<List<RemoteClusterInfoModel>> getSharedChannelRemotesByRemoteCluster(String remoteId);
}

@LazySingleton(as: AdminRemoteClusterDataSource)
class AdminRemoteClusterDataSourceImpl implements AdminRemoteClusterDataSource {
  final ApiClient _apiClient;

  AdminRemoteClusterDataSourceImpl(this._apiClient);

  Map<String, dynamic> _mapFrom(
    ApiResult<Map<String, dynamic>> result,
    String error,
  ) {
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception(error);
  }

  @override
  Future<List<RemoteClusterModel>> getRemoteClusters({
    int page = 0,
    int perPage = 60,
  }) async {
    final result = await _apiClient.get<List<RemoteClusterModel>>(
      RemoteClusterEndPoint.root,
      queryParameters: {'page': page, 'per_page': perPage},
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => RemoteClusterModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<RemoteClusterModel>>) {
      return result.data;
    }
    throw Exception('Failed to get remote clusters');
  }

  @override
  Future<RemoteClusterModel> getRemoteCluster(String remoteId) async {
    final result = await _apiClient.get<RemoteClusterModel>(
      RemoteClusterEndPoint.byRemoteId(remoteId),
      fromJson: (json) => RemoteClusterModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<RemoteClusterModel>) {
      return result.data;
    }
    throw Exception('Failed to get remote cluster');
  }

  @override
  Future<void> updateRemoteCluster(
    String remoteId,
    Map<String, dynamic> patch,
  ) async {
    final result = await _apiClient.put<void>(
      RemoteClusterEndPoint.byRemoteId(remoteId),
      data: patch,
      fromJson: (_) {},
    );
    if (result is ApiFailure) {
      throw Exception('Failed to update remote cluster');
    }
  }

  @override
  Future<void> deleteRemoteCluster(String remoteId) async {
    final result = await _apiClient.delete(
      RemoteClusterEndPoint.byRemoteId(remoteId),
    );
    if (result is ApiFailure) {
      throw Exception('Failed to delete remote cluster');
    }
  }

  @override
  Future<Map<String, dynamic>> generateInvite(String remoteId) async {
    final result = await _apiClient.post<Map<String, dynamic>>(
      RemoteClusterEndPoint.generateInvite(remoteId),
      fromJson: (json) => json as Map<String, dynamic>,
    );
    return _mapFrom(result, 'Failed to generate remote cluster invite');
  }

  @override
  Future<Map<String, dynamic>> acceptInvite({
    required String token,
    required String displayName,
    required String description,
    String? remoteId,
  }) async {
    final result = await _apiClient.post<Map<String, dynamic>>(
      RemoteClusterEndPoint.acceptInvite,
      data: {
        'token': token,
        'display_name': displayName,
        'description': description,
        if (remoteId != null && remoteId.isNotEmpty) 'remote_id': remoteId,
      },
      fromJson: (json) => json as Map<String, dynamic>,
    );
    return _mapFrom(result, 'Failed to accept remote cluster invite');
  }

  @override
  Future<Map<String, dynamic>> confirmInvite(String remoteId) async {
    final result = await _apiClient.post<Map<String, dynamic>>(
      RemoteClusterEndPoint.confirmInvite,
      data: {'remote_id': remoteId},
      fromJson: (json) => json as Map<String, dynamic>,
    );
    return _mapFrom(result, 'Failed to confirm remote cluster invite');
  }

  @override
  Future<void> uninviteRemoteCluster(String remoteId, String channelId) async {
    final result = await _apiClient.post<void>(
      RemoteClusterEndPoint.channelsUninvite(remoteId, channelId),
      fromJson: (_) {},
    );
    if (result is ApiFailure) {
      throw Exception('Failed to uninvite channel from remote cluster');
    }
  }

  @override
  Future<void> inviteRemoteCluster(String remoteId, String channelId) async {
    final result = await _apiClient.post<void>(
      RemoteClusterEndPoint.channelsInvite(remoteId, channelId),
      fromJson: (_) {},
    );
    if (result is ApiFailure) {
      throw Exception('Failed to invite channel to remote cluster');
    }
  }

  @override
  Future<List<RemoteClusterInfoModel>> getSharedChannelRemotes(
    String remoteId,
  ) async {
    final result = await _apiClient.get<List<RemoteClusterInfoModel>>(
      RemoteClusterEndPoint.sharedchannelremotes(remoteId),
      fromJson: (json) => (json as List<dynamic>)
          .map((e) =>
              RemoteClusterInfoModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<RemoteClusterInfoModel>>) {
      return result.data;
    }
    throw Exception('Failed to get shared channel remotes');
  }

  @override
  Future<void> sendRemoteClusterMessage(Map<String, dynamic> message) async {
    final result = await _apiClient.post<void>(
      RemoteClusterEndPoint.msg,
      data: message,
      fromJson: (_) {},
    );
    if (result is ApiFailure) {
      throw Exception('Failed to send remote cluster message');
    }
  }

  @override
  Future<Map<String, dynamic>> pingRemoteCluster({String? remoteId}) async {
    final result = await _apiClient.post<Map<String, dynamic>>(
      RemoteClusterEndPoint.ping,
      data: {if (remoteId != null) 'remote_id': remoteId},
      fromJson: (json) => json as Map<String, dynamic>,
    );
    return _mapFrom(result, 'Failed to ping remote cluster');
  }

  @override
  Future<void> uploadRemoteClusterData(
    String uploadId,
    Map<String, dynamic> data,
  ) async {
    final result = await _apiClient.post<void>(
      RemoteClusterEndPoint.upload(uploadId),
      data: data,
      fromJson: (_) {},
    );
    if (result is ApiFailure) {
      throw Exception('Failed to upload remote cluster data');
    }
  }

  @override
  Future<void> setRemoteProfileImage(String userId, String savePath) async {
    final result = await _apiClient.post<void>(
      RemoteClusterEndPoint.image(userId),
      data: {'user_id': userId},
      fromJson: (_) {},
    );
    if (result is ApiFailure) {
      throw Exception('Failed to set remote cluster profile image');
    }
  }

  @override
  Future<RemoteClusterInfoModel> getRemoteClusterInfo(String remoteId) async {
    final result = await _apiClient.get<RemoteClusterInfoModel>(
      SharedChannelsEndPoint.remoteInfo(remoteId),
      fromJson: (json) => RemoteClusterInfoModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<RemoteClusterInfoModel>) {
      return result.data;
    }
    throw Exception('Failed to get remote cluster info');
  }

  @override
  Future<List<SharedChannelModel>> getAllSharedChannels({int page = 0, int perPage = 60, String teamId = ''}) async {
    final result = await _apiClient.get<List<SharedChannelModel>>(
      SharedChannelsEndPoint.root,
      queryParameters: {'page': page, 'per_page': perPage, 'team_id': teamId},
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => SharedChannelModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<SharedChannelModel>>) {
      return result.data;
    }
    throw Exception('Failed to get shared channels');
  }

  @override
  Future<List<RemoteClusterInfoModel>> getSharedChannelRemotesByRemoteCluster(String remoteId) async {
    final result = await _apiClient.get<List<RemoteClusterInfoModel>>(
      SharedChannelsEndPoint.remoteInfo(remoteId),
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => RemoteClusterInfoModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<RemoteClusterInfoModel>>) {
      return result.data;
    }
    throw Exception('Failed to get shared channel remotes by remote cluster');
  }
}
