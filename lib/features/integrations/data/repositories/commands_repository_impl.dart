import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/features/integrations/data/datasources/commands_remote_data_source.dart';
import 'package:flutter_mattermost/features/integrations/domain/entities/command_entity.dart';
import 'package:flutter_mattermost/features/integrations/domain/repositories/commands_repository.dart';

@LazySingleton(as: CommandsRepository)
class CommandsRepositoryImpl implements CommandsRepository {
  final CommandsRemoteDataSource _remoteDataSource;

  CommandsRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<CommandEntity>> getCommands(String teamId) async {
    final models = await _remoteDataSource.getCommands(teamId: teamId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<CommandEntity> createCommand({
    required String teamId,
    required String trigger,
    required String url,
    String method = 'POST',
    String username = '',
    String iconUrl = '',
    bool autoComplete = false,
    String autoCompleteHint = '',
    String autoCompleteDescription = '',
  }) async {
    final model = await _remoteDataSource.createCommand({
      'team_id': teamId,
      'trigger': trigger,
      'url': url,
      'method': method,
      'username': username,
      'icon_url': iconUrl,
      'autocomplete': autoComplete,
      'autocomplete_hint': autoCompleteHint,
      'autocomplete_description': autoCompleteDescription,
    });
    return model.toEntity();
  }

  @override
  Future<CommandEntity> updateCommand(
    String commandId, {
    String? trigger,
    String? url,
    String? method,
    String? username,
    String? iconUrl,
    bool? autoComplete,
    String? autoCompleteHint,
    String? autoCompleteDescription,
  }) async {
    final model = await _remoteDataSource.updateCommand(commandId, {
      'trigger': trigger,
      'url': url,
      'method': method,
      'username': username,
      'icon_url': iconUrl,
      'autocomplete': autoComplete,
      'autocomplete_hint': autoCompleteHint,
      'autocomplete_description': autoCompleteDescription,
    });
    return model.toEntity();
  }

  @override
  Future<void> deleteCommand(String commandId) async {
    await _remoteDataSource.deleteCommand(commandId);
  }

  @override
  Future<Map<String, dynamic>> executeCommand({
    required String command,
    required String channelId,
    required String teamId,
  }) async {
    return _remoteDataSource.executeCommand(
      command: command,
      channelId: channelId,
      teamId: teamId,
    );
  }

  @override
  Future<List<CommandEntity>> autocompleteCommands(String teamId) async {
    final models = await _remoteDataSource.autocompleteCommands(teamId);
    return models.map((m) => m.toEntity()).toList();
  }
}
