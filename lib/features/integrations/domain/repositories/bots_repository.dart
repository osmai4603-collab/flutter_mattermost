import 'package:flutter_mattermost/features/integrations/domain/entities/bot_account_entity.dart';

abstract class BotsRepository {
  Future<List<BotAccountEntity>> getBots({bool includeDeleted = false});
  Future<BotAccountEntity> createBot({
    required String username,
    String displayName,
    String description,
  });
  Future<BotAccountEntity> updateBot(
    String botUserId, {
    String? displayName,
    String? description,
  });
  Future<void> deleteBot(String botUserId, {bool permanent = false});
  Future<void> enableBot(String botUserId);
  Future<void> disableBot(String botUserId);
}
