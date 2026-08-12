import 'package:flutter_mattermost/features/channels/data/models/remote_cluster_info_model.dart';
import 'package:flutter_mattermost/features/channels/data/models/shared_channel_remote_model.dart';

abstract class AdminSharedChannelsRepository {
  Future<RemoteClusterInfoModel> getRemoteInfo(String remoteId);
  Future<List<SharedChannelRemoteModel>> getChannelRemotes(String channelId);
  Future<Map<String, dynamic>> canUserDm(String userId, String otherUserId);
  Future<Map<String, dynamic>> createInstallation(Map<String, dynamic> data);
  Future<void> handleCloudWebhook(Map<String, dynamic> data);
}
