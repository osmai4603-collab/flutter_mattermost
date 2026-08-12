import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/network/api_client.dart';

import 'package:flutter_mattermost/core/endpoints/endpoints.dart';

abstract class TypingRemoteDataSource {
  Future<void> sendTypingEvent(String channelId, {String? parentId});
  Future<void> publishTyping(String userId, String channelId);
}

@LazySingleton(as: TypingRemoteDataSource)
class TypingRemoteDataSourceImpl implements TypingRemoteDataSource {
  final ApiClient _apiClient;

  TypingRemoteDataSourceImpl(this._apiClient);

  @override
  Future<void> sendTypingEvent(String channelId, {String? parentId}) async {
    await _apiClient.post<void>(
      ChannelsEndPoint.typing(channelId),
      data: {
        if (parentId != null && parentId.isNotEmpty) 'parent_id': parentId,
      },
      fromJson: (_) {},
    );
  }

  @override
  Future<void> publishTyping(String userId, String channelId) async {
    await _apiClient.post<void>(
      UsersEndPoint.typing(userId),
      data: {'channel_id': channelId},
      fromJson: (_) {},
    );
  }
}
