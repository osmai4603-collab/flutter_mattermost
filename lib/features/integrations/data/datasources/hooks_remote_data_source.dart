import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/network/api_client.dart';
import 'package:flutter_mattermost/core/network/api_result.dart';
import 'package:flutter_mattermost/core/endpoints/endpoints.dart';
import 'package:flutter_mattermost/features/integrations/data/models/incoming_webhook_model.dart';
import 'package:flutter_mattermost/features/integrations/data/models/outgoing_webhook_model.dart';

abstract class HooksRemoteDataSource {
  Future<List<IncomingWebhookModel>> getIncomingWebhooks({
    String? teamId,
    int page = 0,
    int perPage = 60,
  });
  Future<IncomingWebhookModel> createIncomingWebhook({
    required String channelId,
    String? teamId,
    String displayName = '',
    String description = '',
    String username = '',
    String iconUrl = '',
    bool channelLocked = false,
  });
  Future<IncomingWebhookModel> getIncomingWebhook(String hookId);
  Future<IncomingWebhookModel> updateIncomingWebhook(
    String hookId, {
    String? channelId,
    String? displayName,
    String? description,
    String? username,
    String? iconUrl,
    bool? channelLocked,
  });
  Future<void> deleteIncomingWebhook(String hookId);

  Future<List<OutgoingWebhookModel>> getOutgoingWebhooks({
    String? teamId,
    String? channelId,
    int page = 0,
    int perPage = 60,
  });
  Future<OutgoingWebhookModel> createOutgoingWebhook({
    required String teamId,
    String? channelId,
    required List<String> callbackUrls,
    List<String> triggerWords = const [],
    int triggerWhen = 0,
    String displayName = '',
    String description = '',
    String contentType = 'application/x-www-form-urlencoded',
    String username = '',
    String iconUrl = '',
  });
  Future<OutgoingWebhookModel> getOutgoingWebhook(String hookId);
  Future<OutgoingWebhookModel> updateOutgoingWebhook(
    String hookId, {
    String? channelId,
    String? displayName,
    String? description,
    List<String>? callbackUrls,
    List<String>? triggerWords,
    String? contentType,
    String? username,
    String? iconUrl,
  });
  Future<void> deleteOutgoingWebhook(String hookId);
  Future<OutgoingWebhookModel> regenerateOutgoingWebhookToken(String hookId);
}

@LazySingleton(as: HooksRemoteDataSource)
class HooksRemoteDataSourceImpl implements HooksRemoteDataSource {
  final ApiClient _apiClient;

  HooksRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<IncomingWebhookModel>> getIncomingWebhooks({
    String? teamId,
    int page = 0,
    int perPage = 60,
  }) async {
    final result = await _apiClient.get<List<IncomingWebhookModel>>(
      HooksEndPoint.incoming,
      queryParameters: {'page': page, 'per_page': perPage, 'team_id': teamId},
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => IncomingWebhookModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<IncomingWebhookModel>>) {
      return result.data;
    }
    throw Exception('Failed to get incoming webhooks');
  }

  @override
  Future<IncomingWebhookModel> createIncomingWebhook({
    required String channelId,
    String? teamId,
    String displayName = '',
    String description = '',
    String username = '',
    String iconUrl = '',
    bool channelLocked = false,
  }) async {
    final result = await _apiClient.post<IncomingWebhookModel>(
      HooksEndPoint.incoming,
      data: {
        'channel_id': channelId,
        if (teamId != null) 'team_id': teamId,
        'display_name': displayName,
        'description': description,
        'username': username,
        'icon_url': iconUrl,
        'channel_locked': channelLocked,
      },
      fromJson: (json) =>
          IncomingWebhookModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<IncomingWebhookModel>) {
      return result.data;
    }
    throw Exception('Failed to create incoming webhook');
  }

  @override
  Future<IncomingWebhookModel> getIncomingWebhook(String hookId) async {
    final result = await _apiClient.get<IncomingWebhookModel>(
      HooksEndPoint.incoming2(hookId),
      fromJson: (json) =>
          IncomingWebhookModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<IncomingWebhookModel>) {
      return result.data;
    }
    throw Exception('Failed to get incoming webhook');
  }

  @override
  Future<IncomingWebhookModel> updateIncomingWebhook(
    String hookId, {
    String? channelId,
    String? displayName,
    String? description,
    String? username,
    String? iconUrl,
    bool? channelLocked,
  }) async {
    final result = await _apiClient.put<IncomingWebhookModel>(
      HooksEndPoint.incoming2(hookId),
      data: {
        if (channelId != null) 'channel_id': channelId,
        if (displayName != null) 'display_name': displayName,
        if (description != null) 'description': description,
        if (username != null) 'username': username,
        if (iconUrl != null) 'icon_url': iconUrl,
        if (channelLocked != null) 'channel_locked': channelLocked,
      },
      fromJson: (json) =>
          IncomingWebhookModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<IncomingWebhookModel>) {
      return result.data;
    }
    throw Exception('Failed to update incoming webhook');
  }

  @override
  Future<void> deleteIncomingWebhook(String hookId) async {
    final result = await _apiClient.delete(HooksEndPoint.incoming2(hookId));
    if (result is ApiFailure) {
      throw Exception('Failed to delete incoming webhook');
    }
  }

  @override
  Future<List<OutgoingWebhookModel>> getOutgoingWebhooks({
    String? teamId,
    String? channelId,
    int page = 0,
    int perPage = 60,
  }) async {
    final result = await _apiClient.get<List<OutgoingWebhookModel>>(
      HooksEndPoint.outgoing,
      queryParameters: {
        'page': page,
        'per_page': perPage,
        'team_id': teamId,
        'channel_id': channelId,
      },
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => OutgoingWebhookModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<OutgoingWebhookModel>>) {
      return result.data;
    }
    throw Exception('Failed to get outgoing webhooks');
  }

  @override
  Future<OutgoingWebhookModel> createOutgoingWebhook({
    required String teamId,
    String? channelId,
    required List<String> callbackUrls,
    List<String> triggerWords = const [],
    int triggerWhen = 0,
    String displayName = '',
    String description = '',
    String contentType = 'application/x-www-form-urlencoded',
    String username = '',
    String iconUrl = '',
  }) async {
    final result = await _apiClient.post<OutgoingWebhookModel>(
      HooksEndPoint.outgoing,
      data: {
        'team_id': teamId,
        if (channelId != null) 'channel_id': channelId,
        'callback_urls': callbackUrls,
        'trigger_words': triggerWords,
        'trigger_when': triggerWhen,
        'display_name': displayName,
        'description': description,
        'content_type': contentType,
        'username': username,
        'icon_url': iconUrl,
      },
      fromJson: (json) =>
          OutgoingWebhookModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<OutgoingWebhookModel>) {
      return result.data;
    }
    throw Exception('Failed to create outgoing webhook');
  }

  @override
  Future<OutgoingWebhookModel> getOutgoingWebhook(String hookId) async {
    final result = await _apiClient.get<OutgoingWebhookModel>(
      HooksEndPoint.outgoing2(hookId),
      fromJson: (json) =>
          OutgoingWebhookModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<OutgoingWebhookModel>) {
      return result.data;
    }
    throw Exception('Failed to get outgoing webhook');
  }

  @override
  Future<OutgoingWebhookModel> updateOutgoingWebhook(
    String hookId, {
    String? channelId,
    String? displayName,
    String? description,
    List<String>? callbackUrls,
    List<String>? triggerWords,
    String? contentType,
    String? username,
    String? iconUrl,
  }) async {
    final result = await _apiClient.put<OutgoingWebhookModel>(
      HooksEndPoint.outgoing2(hookId),
      data: {
        if (channelId != null) 'channel_id': channelId,
        if (displayName != null) 'display_name': displayName,
        if (description != null) 'description': description,
        if (callbackUrls != null) 'callback_urls': callbackUrls,
        if (triggerWords != null) 'trigger_words': triggerWords,
        if (contentType != null) 'content_type': contentType,
        if (username != null) 'username': username,
        if (iconUrl != null) 'icon_url': iconUrl,
      },
      fromJson: (json) =>
          OutgoingWebhookModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<OutgoingWebhookModel>) {
      return result.data;
    }
    throw Exception('Failed to update outgoing webhook');
  }

  @override
  Future<void> deleteOutgoingWebhook(String hookId) async {
    final result = await _apiClient.delete(HooksEndPoint.outgoing2(hookId));
    if (result is ApiFailure) {
      throw Exception('Failed to delete outgoing webhook');
    }
  }

  @override
  Future<OutgoingWebhookModel> regenerateOutgoingWebhookToken(
    String hookId,
  ) async {
    final result = await _apiClient.post<OutgoingWebhookModel>(
      HooksEndPoint.outgoingRegenToken(hookId),
      fromJson: (json) =>
          OutgoingWebhookModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<OutgoingWebhookModel>) {
      return result.data;
    }
    throw Exception('Failed to regenerate outgoing webhook token');
  }
}
