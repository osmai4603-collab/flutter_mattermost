import 'package:flutter_mattermost/core/entities/entity.dart';

class OutgoingWebhookEntity extends Entity {
  final String id;
  final String token;
  final int createAt;
  final int updateAt;
  final int deleteAt;
  final String creatorId;
  final String teamId;
  final String channelId;
  final String description;
  final String displayName;
  final List<String> triggerWords;
  final int triggerWhen;
  final List<String> callbackUrls;
  final String contentType;
  final String username;
  final String iconUrl;

  const OutgoingWebhookEntity({
    this.id = '',
    this.token = '',
    this.createAt = 0,
    this.updateAt = 0,
    this.deleteAt = 0,
    this.creatorId = '',
    this.teamId = '',
    this.channelId = '',
    this.description = '',
    this.displayName = '',
    this.triggerWords = const [],
    this.triggerWhen = 0,
    this.callbackUrls = const [],
    this.contentType = 'application/x-www-form-urlencoded',
    this.username = '',
    this.iconUrl = '',
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
        channelId,
        description,
        displayName,
        triggerWords,
        triggerWhen,
        callbackUrls,
        contentType,
        username,
        iconUrl,
      ];

  @override
  OutgoingWebhookEntity copyWith({
    String? id,
    String? token,
    int? createAt,
    int? updateAt,
    int? deleteAt,
    String? creatorId,
    String? teamId,
    String? channelId,
    String? description,
    String? displayName,
    List<String>? triggerWords,
    int? triggerWhen,
    List<String>? callbackUrls,
    String? contentType,
    String? username,
    String? iconUrl,
  }) {
    return OutgoingWebhookEntity(
      id: id ?? this.id,
      token: token ?? this.token,
      createAt: createAt ?? this.createAt,
      updateAt: updateAt ?? this.updateAt,
      deleteAt: deleteAt ?? this.deleteAt,
      creatorId: creatorId ?? this.creatorId,
      teamId: teamId ?? this.teamId,
      channelId: channelId ?? this.channelId,
      description: description ?? this.description,
      displayName: displayName ?? this.displayName,
      triggerWords: triggerWords ?? this.triggerWords,
      triggerWhen: triggerWhen ?? this.triggerWhen,
      callbackUrls: callbackUrls ?? this.callbackUrls,
      contentType: contentType ?? this.contentType,
      username: username ?? this.username,
      iconUrl: iconUrl ?? this.iconUrl,
    );
  }
}
