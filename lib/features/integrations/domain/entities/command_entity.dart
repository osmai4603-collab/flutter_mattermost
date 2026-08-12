import 'package:flutter_mattermost/core/entities/entity.dart';

class CommandEntity extends Entity {
  final String id;
  final String token;
  final int createAt;
  final int updateAt;
  final int deleteAt;
  final String creatorId;
  final String teamId;
  final String trigger;
  final String method;
  final String username;
  final String iconUrl;
  final bool autoComplete;
  final String autoCompleteDesc;
  final String autoCompleteHint;
  final String displayName;
  final String description;
  final String url;

  const CommandEntity({
    this.id = '',
    this.token = '',
    this.createAt = 0,
    this.updateAt = 0,
    this.deleteAt = 0,
    this.creatorId = '',
    this.teamId = '',
    this.trigger = '',
    this.method = '',
    this.username = '',
    this.iconUrl = '',
    this.autoComplete = false,
    this.autoCompleteDesc = '',
    this.autoCompleteHint = '',
    this.displayName = '',
    this.description = '',
    this.url = '',
  });

  @override
  List<Object?> get props => [
        id,
        token,
        createAt,
        updateAt,
        deleteAt,
        creatorId,
        teamId,
        trigger,
        method,
        username,
        iconUrl,
        autoComplete,
        autoCompleteDesc,
        autoCompleteHint,
        displayName,
        description,
        url,
      ];

  @override
  CommandEntity copyWith({
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
    return CommandEntity(
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
}
