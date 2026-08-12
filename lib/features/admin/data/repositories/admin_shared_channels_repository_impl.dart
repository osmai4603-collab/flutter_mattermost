import 'package:flutter_mattermost/features/channels/data/models/remote_cluster_info_model.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/features/admin/data/datasources/admin_shared_channels_data_source.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_shared_channels_repository.dart';
import 'package:flutter_mattermost/features/channels/data/models/shared_channel_remote_model.dart';

@LazySingleton(as: AdminSharedChannelsRepository)
class AdminSharedChannelsRepositoryImpl
    implements AdminSharedChannelsRepository {
  final AdminSharedChannelsDataSource _dataSource;

  AdminSharedChannelsRepositoryImpl(this._dataSource);

  @override
  Future<RemoteClusterInfoModel> getRemoteInfo(String remoteId) =>
      _dataSource.getRemoteInfo(remoteId);

  @override
  Future<List<SharedChannelRemoteModel>> getChannelRemotes(String channelId) =>
      _dataSource.getChannelRemotes(channelId);

  @override
  Future<Map<String, dynamic>> canUserDm(String userId, String otherUserId) =>
      _dataSource.canUserDm(userId, otherUserId);

  @override
  Future<Map<String, dynamic>> createInstallation(Map<String, dynamic> data) =>
      _dataSource.createInstallation(data);

  @override
  Future<void> handleCloudWebhook(Map<String, dynamic> data) =>
      _dataSource.handleCloudWebhook(data);
}
