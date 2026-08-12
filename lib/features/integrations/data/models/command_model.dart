import 'package:flutter_mattermost/features/integrations/domain/entities/command_entity.dart';

final class CommandModel extends CommandEntity {
  const CommandModel({
    super.id,
    super.token,
    super.createAt,
    super.updateAt,
    super.deleteAt,
    super.creatorId,
    super.teamId,
    super.trigger,
    super.method,
    super.username,
    super.iconUrl,
    super.autoComplete,
    super.autoCompleteDesc,
    super.autoCompleteHint,
    super.displayName,
    super.description,
    super.url,
  });

  factory CommandModel.fromMap(Map<String, dynamic> data) {
    return CommandModel(
      id: data['id'] ?? '',
      token: data['token'] ?? '',
      createAt: (data['create_at'] ?? 0).toInt(),
      updateAt: (data['update_at'] ?? 0).toInt(),
      deleteAt: (data['delete_at'] ?? 0).toInt(),
      creatorId: data['creator_id'] ?? '',
      teamId: data['team_id'] ?? '',
      trigger: data['trigger'] ?? '',
      method: data['method'] ?? '',
      username: data['username'] ?? '',
      iconUrl: data['icon_url'] ?? '',
      autoComplete: data['auto_complete'] ?? false,
      autoCompleteDesc: data['auto_complete_desc'] ?? '',
      autoCompleteHint: data['auto_complete_hint'] ?? '',
      displayName: data['display_name'] ?? '',
      description: data['description'] ?? '',
      url: data['url'] ?? '',
    );
  }

  factory CommandModel.fromEntity(CommandEntity entity) {
    return CommandModel(
      id: entity.id,
      token: entity.token,
      createAt: entity.createAt,
      updateAt: entity.updateAt,
      deleteAt: entity.deleteAt,
      creatorId: entity.creatorId,
      teamId: entity.teamId,
      trigger: entity.trigger,
      method: entity.method,
      username: entity.username,
      iconUrl: entity.iconUrl,
      autoComplete: entity.autoComplete,
      autoCompleteDesc: entity.autoCompleteDesc,
      autoCompleteHint: entity.autoCompleteHint,
      displayName: entity.displayName,
      description: entity.description,
      url: entity.url,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'token': token,
      'create_at': createAt,
      'update_at': updateAt,
      'delete_at': deleteAt,
      'creator_id': creatorId,
      'team_id': teamId,
      'trigger': trigger,
      'method': method,
      'username': username,
      'icon_url': iconUrl,
      'auto_complete': autoComplete,
      'auto_complete_desc': autoCompleteDesc,
      'auto_complete_hint': autoCompleteHint,
      'display_name': displayName,
      'description': description,
      'url': url,
    };
  }

  @override
  CommandModel copyWith({
    String? id,
    String? token,
    int? createAt,
    int? updateAt,
    int? deleteAt,
    String? creatorId,
    String? teamId,
    String? trigger,
    String? method,
    String? username,
    String? iconUrl,
    bool? autoComplete,
    String? autoCompleteDesc,
    String? autoCompleteHint,
    String? displayName,
    String? description,
    String? url,
  }) {
    return CommandModel(
      id: id ?? this.id,
      token: token ?? this.token,
      createAt: createAt ?? this.createAt,
      updateAt: updateAt ?? this.updateAt,
      deleteAt: deleteAt ?? this.deleteAt,
      creatorId: creatorId ?? this.creatorId,
      teamId: teamId ?? this.teamId,
      trigger: trigger ?? this.trigger,
      method: method ?? this.method,
      username: username ?? this.username,
      iconUrl: iconUrl ?? this.iconUrl,
      autoComplete: autoComplete ?? this.autoComplete,
      autoCompleteDesc: autoCompleteDesc ?? this.autoCompleteDesc,
      autoCompleteHint: autoCompleteHint ?? this.autoCompleteHint,
      displayName: displayName ?? this.displayName,
      description: description ?? this.description,
      url: url ?? this.url,
    );
  }

  CommandEntity toEntity() {
    return CommandEntity(
      id: id,
      token: token,
      createAt: createAt,
      updateAt: updateAt,
      deleteAt: deleteAt,
      creatorId: creatorId,
      teamId: teamId,
      trigger: trigger,
      method: method,
      username: username,
      iconUrl: iconUrl,
      autoComplete: autoComplete,
      autoCompleteDesc: autoCompleteDesc,
      autoCompleteHint: autoCompleteHint,
      displayName: displayName,
      description: description,
      url: url,
    );
  }
}
