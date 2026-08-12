import 'package:flutter_mattermost/features/integrations/domain/entities/incoming_webhook_entity.dart';
import 'package:flutter_mattermost/features/integrations/domain/entities/outgoing_webhook_entity.dart';

abstract class WebhooksRepository {
  Future<List<IncomingWebhookEntity>> getIncomingWebhooks({
    String? teamId,
    int page = 0,
    int perPage = 60,
  });
  Future<IncomingWebhookEntity> createIncomingWebhook({
    required String channelId,
    String? teamId,
    String displayName,
    String description,
    String username,
    String iconUrl,
    bool channelLocked,
  });
  Future<IncomingWebhookEntity> updateIncomingWebhook(
    String hookId, {
    String? channelId,
    String? displayName,
    String? description,
    String? username,
    String? iconUrl,
    bool? channelLocked,
  });
  Future<void> deleteIncomingWebhook(String hookId);

  Future<List<OutgoingWebhookEntity>> getOutgoingWebhooks({
    String? teamId,
    String? channelId,
    int page = 0,
    int perPage = 60,
  });
  Future<OutgoingWebhookEntity> createOutgoingWebhook({
    required String teamId,
    String? channelId,
    required List<String> callbackUrls,
    List<String> triggerWords,
    int triggerWhen,
    String displayName,
    String description,
    String contentType,
    String username,
    String iconUrl,
  });
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
  });
  Future<String> regenerateOutgoingWebhookToken(String hookId);
  Future<void> deleteOutgoingWebhook(String hookId);
}
