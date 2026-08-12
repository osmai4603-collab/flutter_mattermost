import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/network/api_client.dart';
import 'package:flutter_mattermost/core/network/api_result.dart';
import 'package:flutter_mattermost/core/endpoints/endpoints.dart';
import 'package:flutter_mattermost/features/integrations/data/models/bot_account_model.dart';
import 'package:flutter_mattermost/features/integrations/data/models/bot_model.dart';

abstract class BotsRemoteDataSource {
  Future<List<BotAccountModel>> getBots({
    bool includeDeleted = false,
    bool onlyOrphaned = false,
    int page = 0,
    int perPage = 60,
  });
  Future<BotAccountModel> createBot({
    required String username,
    String displayName = '',
    String description = '',
  });
  Future<BotModel> getBot(String botUserId, {bool includeDeleted = false});
  Future<BotAccountModel> updateBot(
    String botUserId, {
    String? displayName,
    String? description,
  });
  Future<void> deleteBot(String botUserId, {bool permanent = false});
  Future<BotAccountModel> assignBot(String botUserId, String userId);
  Future<void> enableBot(String botUserId);
  Future<void> disableBot(String botUserId);
  Future<BotAccountModel> convertBotToUser(String botUserId);
  Future<BotAccountModel> patchBot(String botUserId, Map<String, dynamic> patch);
}

@LazySingleton(as: BotsRemoteDataSource)
class BotsRemoteDataSourceImpl implements BotsRemoteDataSource {
  final ApiClient _apiClient;

  BotsRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<BotAccountModel>> getBots({
    bool includeDeleted = false,
    bool onlyOrphaned = false,
    int page = 0,
    int perPage = 60,
  }) async {
    final result = await _apiClient.get<List<BotAccountModel>>(
      BotsEndPoint.root,
      queryParameters: {
        'page': page,
        'per_page': perPage,
        'include_deleted': includeDeleted,
        'only_orphaned': onlyOrphaned,
      },
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => BotAccountModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<BotAccountModel>>) {
      return result.data;
    }
    throw Exception('Failed to get bot accounts');
  }

  @override
  Future<BotAccountModel> createBot({
    required String username,
    String displayName = '',
    String description = '',
  }) async {
    final result = await _apiClient.post<BotAccountModel>(
      BotsEndPoint.root,
      data: {
        'username': username,
        'display_name': displayName,
        'description': description,
      },
      fromJson: (json) => BotAccountModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<BotAccountModel>) {
      return result.data;
    }
    throw Exception('Failed to create bot account');
  }

  @override
  Future<BotModel> getBot(
    String botUserId, {
    bool includeDeleted = false,
  }) async {
    final result = await _apiClient.get<BotModel>(
      BotsEndPoint.byBotUserId(botUserId),
      queryParameters: {'include_deleted': includeDeleted},
      fromJson: (json) => BotModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<BotModel>) {
      return result.data;
    }
    throw Exception('Failed to get bot account');
  }

  @override
  Future<BotAccountModel> updateBot(
    String botUserId, {
    String? displayName,
    String? description,
  }) async {
    final result = await _apiClient.put<BotAccountModel>(
      BotsEndPoint.byBotUserId(botUserId),
      data: {
        'display_name': displayName,
        'description': description,
      },
      fromJson: (json) => BotAccountModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<BotAccountModel>) {
      return result.data;
    }
    throw Exception('Failed to update bot account');
  }

  @override
  Future<void> deleteBot(String botUserId, {bool permanent = false}) async {
    final result = await _apiClient.delete(
      BotsEndPoint.byBotUserId(botUserId),
      queryParameters: {'permanently': permanent},
    );
    if (result is ApiFailure) {
      throw Exception('Failed to delete bot account');
    }
  }

  @override
  Future<BotAccountModel> assignBot(String botUserId, String userId) async {
    final result = await _apiClient.post<BotAccountModel>(
      BotsEndPoint.assign(botUserId, userId),
      fromJson: (json) => BotAccountModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<BotAccountModel>) {
      return result.data;
    }
    throw Exception('Failed to assign bot account');
  }

  @override
  Future<void> enableBot(String botUserId) async {
    final result = await _apiClient.post<void>(
      BotsEndPoint.enable(botUserId),
      fromJson: (_) {},
    );
    if (result is ApiFailure) {
      throw Exception('Failed to enable bot account');
    }
  }

  @override
  Future<void> disableBot(String botUserId) async {
    final result = await _apiClient.post<void>(
      BotsEndPoint.disable(botUserId),
      fromJson: (_) {},
    );
    if (result is ApiFailure) {
      throw Exception('Failed to disable bot account');
    }
  }

  @override
  Future<BotAccountModel> convertBotToUser(String botUserId) async {
    final result = await _apiClient.post<BotAccountModel>(
      BotsEndPoint.convertToUser(botUserId),
      fromJson: (json) => BotAccountModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<BotAccountModel>) {
      return result.data;
    }
    throw Exception('Failed to convert bot to user');
  }

  @override
  Future<BotAccountModel> patchBot(String botUserId, Map<String, dynamic> patch) async {
    final result = await _apiClient.put<BotAccountModel>(
      BotsEndPoint.byBotUserId(botUserId),
      data: patch,
      fromJson: (json) => BotAccountModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<BotAccountModel>) {
      return result.data;
    }
    throw Exception('Failed to patch bot account');
  }
}
