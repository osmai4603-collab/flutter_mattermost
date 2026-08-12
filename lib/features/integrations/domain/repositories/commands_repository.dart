import 'package:flutter_mattermost/features/integrations/domain/entities/command_entity.dart';

abstract class CommandsRepository {
  Future<List<CommandEntity>> getCommands(String teamId);
  Future<CommandEntity> createCommand({
    required String teamId,
    required String trigger,
    required String url,
    String method,
    String username,
    String iconUrl,
    bool autoComplete,
    String autoCompleteHint,
    String autoCompleteDescription,
  });
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
  });
  Future<void> deleteCommand(String commandId);
  Future<Map<String, dynamic>> executeCommand({
    required String command,
    required String channelId,
    required String teamId,
  });
  Future<List<CommandEntity>> autocompleteCommands(String teamId);
}
