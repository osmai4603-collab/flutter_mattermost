import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/features/integrations/data/datasources/hooks_remote_data_source.dart';
import 'package:flutter_mattermost/features/integrations/domain/entities/incoming_webhook_entity.dart';
import 'package:flutter_mattermost/features/integrations/domain/entities/outgoing_webhook_entity.dart';
import 'package:flutter_mattermost/features/integrations/domain/repositories/webhooks_repository.dart';

@LazySingleton(as: WebhooksRepository)
class WebhooksRepositoryImpl implements WebhooksRepository {
  final HooksRemoteDataSource _remoteDataSource;

  WebhooksRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<IncomingWebhookEntity>> getIncomingWebhooks({
    String? teamId,
    int page = 0,
    int perPage = 60,
  }) async {
    final models = await _remoteDataSource.getIncomingWebhooks(
      teamId: teamId,
      page: page,
      perPage: perPage,
    );
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<IncomingWebhookEntity> createIncomingWebhook({
    required String channelId,
    String? teamId,
    String displayName = '',
    String description = '',
    String username = '',
    String iconUrl = '',
    bool channelLocked = false,
  }) async {
    final model = await _remoteDataSource.createIncomingWebhook(
      channelId: channelId,
      teamId: teamId,
      displayName: displayName,
      description: description,
      username: username,
      iconUrl: iconUrl,
      channelLocked: channelLocked,
    );
    return model.toEntity();
  }

  @override
  Future<IncomingWebhookEntity> updateIncomingWebhook(
    String hookId, {
    String? channelId,
    String? displayName,
    String? description,
    String? username,
    String? iconUrl,
    bool? channelLocked,
  }) async {
    final model = await _remoteDataSource.updateIncomingWebhook(
      hookId,
      channelId: channelId,
      displayName: displayName,
      description: description,
      username: username,
      iconUrl: iconUrl,
      channelLocked: channelLocked,
    );
    return model.toEntity();
  }

  @override
  Future<void> deleteIncomingWebhook(String hookId) async {
    await _remoteDataSource.deleteIncomingWebhook(hookId);
  }

  @override
  Future<List<OutgoingWebhookEntity>> getOutgoingWebhooks({
    String? teamId,
    String? channelId,
    int page = 0,
    int perPage = 60,
  }) async {
    final models = await _remoteDataSource.getOutgoingWebhooks(
      teamId: teamId,
      channelId: channelId,
      page: page,
      perPage: perPage,
    );
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<OutgoingWebhookEntity> createOutgoingWebhook({
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
    final model = await _remoteDataSource.createOutgoingWebhook(
      teamId: teamId,
      channelId: channelId,
      callbackUrls: callbackUrls,
      triggerWords: triggerWords,
      triggerWhen: triggerWhen,
      displayName: displayName,
      description: description,
      contentType: contentType,
      username: username,
      iconUrl: iconUrl,
    );
    return model.toEntity();
  }

  @override
  Future<OutgoingWebhookEntity> updateOutgoingWebhook(
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
    final model = await _remoteDataSource.updateOutgoingWebhook(
      hookId,
      channelId: channelId,
      displayName: displayName,
      description: description,
      callbackUrls: callbackUrls,
      triggerWords: triggerWords,
      contentType: contentType,
      username: username,
      iconUrl: iconUrl,
    );
    return model.toEntity();
  }

  @override
  Future<String> regenerateOutgoingWebhookToken(String hookId) async {
    final model = await _remoteDataSource.regenerateOutgoingWebhookToken(hookId);
    return model.token;
  }

  @override
  Future<void> deleteOutgoingWebhook(String hookId) async {
    await _remoteDataSource.deleteOutgoingWebhook(hookId);
  }
}
