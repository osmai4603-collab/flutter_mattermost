import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/network/api_client.dart';
import 'package:flutter_mattermost/core/network/api_result.dart';
import 'package:flutter_mattermost/core/endpoints/endpoints.dart';
import 'package:flutter_mattermost/features/integrations/data/models/command_model.dart';

abstract class CommandsRemoteDataSource {
  Future<CommandModel> createCommand(Map<String, dynamic> command);
  Future<List<CommandModel>> getCommands({String? teamId, bool customOnly = false});
  Future<CommandModel> getCommand(String commandId);
  Future<CommandModel> updateCommand(String commandId, Map<String, dynamic> command);
  Future<void> deleteCommand(String commandId);
  Future<CommandModel> regenerateCommandToken(String commandId);
  Future<Map<String, dynamic>> executeCommand({
    required String command,
    required String channelId,
    String? teamId,
    String? rootId,
  });
  Future<List<CommandModel>> autocompleteCommands(String teamId);
  Future<CommandModel> moveCommand(String commandId, Map<String, dynamic> data);
}

@LazySingleton(as: CommandsRemoteDataSource)
class CommandsRemoteDataSourceImpl implements CommandsRemoteDataSource {
  final ApiClient _apiClient;

  CommandsRemoteDataSourceImpl(this._apiClient);

  @override
  Future<CommandModel> createCommand(Map<String, dynamic> command) async {
    final result = await _apiClient.post<CommandModel>(
      CommandsEndPoint.root,
      data: command,
      fromJson: (json) => CommandModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<CommandModel>) {
      return result.data;
    }
    throw Exception('Failed to create slash command');
  }

  @override
  Future<List<CommandModel>> getCommands({
    String? teamId,
    bool customOnly = false,
  }) async {
    final result = await _apiClient.get<List<CommandModel>>(
      CommandsEndPoint.root,
      queryParameters: {
        if (teamId != null) 'team_id': teamId,
        'custom_only': customOnly,
      },
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => CommandModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<CommandModel>>) {
      return result.data;
    }
    throw Exception('Failed to get slash commands');
  }

  @override
  Future<CommandModel> getCommand(String commandId) async {
    final result = await _apiClient.get<CommandModel>(
      CommandsEndPoint.byCommandId(commandId),
      fromJson: (json) => CommandModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<CommandModel>) {
      return result.data;
    }
    throw Exception('Failed to get slash command $commandId');
  }

  @override
  Future<CommandModel> updateCommand(
    String commandId,
    Map<String, dynamic> command,
  ) async {
    final result = await _apiClient.put<CommandModel>(
      CommandsEndPoint.byCommandId(commandId),
      data: command,
      fromJson: (json) => CommandModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<CommandModel>) {
      return result.data;
    }
    throw Exception('Failed to update slash command $commandId');
  }

  @override
  Future<void> deleteCommand(String commandId) async {
    final result = await _apiClient.delete(CommandsEndPoint.byCommandId(commandId));
    if (result is ApiFailure) {
      throw Exception('Failed to delete slash command $commandId');
    }
  }

  @override
  Future<CommandModel> regenerateCommandToken(String commandId) async {
    final result = await _apiClient.put<CommandModel>(
      CommandsEndPoint.regenToken(commandId),
      fromJson: (json) => CommandModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<CommandModel>) {
      return result.data;
    }
    throw Exception('Failed to regenerate token for command $commandId');
  }

  @override
  Future<Map<String, dynamic>> executeCommand({
    required String command,
    required String channelId,
    String? teamId,
    String? rootId,
  }) async {
    final result = await _apiClient.post<Map<String, dynamic>>(
      CommandsEndPoint.execute,
      data: {
        'command': command,
        'channel_id': channelId,
        if (teamId != null) 'team_id': teamId,
        if (rootId != null) 'root_id': rootId,
      },
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to execute slash command');
  }

  @override
  Future<List<CommandModel>> autocompleteCommands(String teamId) async {
    final result = await _apiClient.get<List<CommandModel>>(
      TeamsEndPoint.commandsAutocomplete(teamId),
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => CommandModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<CommandModel>>) {
      return result.data;
    }
    throw Exception('Failed to get autocomplete commands');
  }

  @override
  Future<CommandModel> moveCommand(
    String commandId,
    Map<String, dynamic> data,
  ) async {
    final result = await _apiClient.put<CommandModel>(
      CommandsEndPoint.move(commandId),
      data: data,
      fromJson: (json) => CommandModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<CommandModel>) {
      return result.data;
    }
    throw Exception('Failed to move command $commandId');
  }
}
