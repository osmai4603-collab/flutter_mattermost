import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/features/integrations/data/datasources/bots_remote_data_source.dart';
import 'package:flutter_mattermost/features/integrations/domain/entities/bot_account_entity.dart';
import 'package:flutter_mattermost/features/integrations/domain/repositories/bots_repository.dart';

@LazySingleton(as: BotsRepository)
class BotsRepositoryImpl implements BotsRepository {
  final BotsRemoteDataSource _remoteDataSource;

  BotsRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<BotAccountEntity>> getBots({bool includeDeleted = false}) async {
    final models = await _remoteDataSource.getBots(
      includeDeleted: includeDeleted,
    );
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<BotAccountEntity> createBot({
    required String username,
    String displayName = '',
    String description = '',
  }) async {
    final model = await _remoteDataSource.createBot(
      username: username,
      displayName: displayName,
      description: description,
    );
    return model.toEntity();
  }

  @override
  Future<BotAccountEntity> updateBot(
    String botUserId, {
    String? displayName,
    String? description,
  }) async {
    final model = await _remoteDataSource.updateBot(
      botUserId,
      displayName: displayName,
      description: description,
    );
    return model.toEntity();
  }

  @override
  Future<void> deleteBot(String botUserId, {bool permanent = false}) async {
    await _remoteDataSource.deleteBot(botUserId, permanent: permanent);
  }

  @override
  Future<void> enableBot(String botUserId) async {
    await _remoteDataSource.enableBot(botUserId);
  }

  @override
  Future<void> disableBot(String botUserId) async {
    await _remoteDataSource.disableBot(botUserId);
  }
}
