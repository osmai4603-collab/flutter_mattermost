import 'package:flutter_mattermost/features/integrations/domain/entities/outgoing_webhook_entity.dart';

final class OutgoingWebhookModel extends OutgoingWebhookEntity {
  const OutgoingWebhookModel({
    super.id,
    super.token,
    super.createAt,
    super.updateAt,
    super.deleteAt,
    super.creatorId,
    super.teamId,
    super.channelId,
    super.description,
    super.displayName,
    super.triggerWords,
    super.triggerWhen,
    super.callbackUrls,
    super.contentType,
    super.username,
    super.iconUrl,
  });

  factory OutgoingWebhookModel.fromMap(Map<String, dynamic> data) {
    return OutgoingWebhookModel(
      id: data['id'] ?? '',
      token: data['token'] ?? '',
      createAt: (data['create_at'] ?? 0).toInt(),
      updateAt: (data['update_at'] ?? 0).toInt(),
      deleteAt: (data['delete_at'] ?? 0).toInt(),
      creatorId: data['creator_id'] ?? '',
      teamId: data['team_id'] ?? '',
      channelId: data['channel_id'] ?? '',
      description: data['description'] ?? '',
      displayName: data['display_name'] ?? '',
      triggerWords: List<String>.from(data['trigger_words'] ?? const []),
      triggerWhen: (data['trigger_when'] ?? 0).toInt(),
      callbackUrls: List<String>.from(data['callback_urls'] ?? const []),
      contentType: data['content_type'] ?? 'application/x-www-form-urlencoded',
      username: data['username'] ?? '',
      iconUrl: data['icon_url'] ?? '',
    );
  }

  factory OutgoingWebhookModel.fromEntity(OutgoingWebhookEntity entity) {
    return OutgoingWebhookModel(
      id: entity.id,
      token: entity.token,
      createAt: entity.createAt,
      updateAt: entity.updateAt,
      deleteAt: entity.deleteAt,
      creatorId: entity.creatorId,
      teamId: entity.teamId,
      channelId: entity.channelId,
      description: entity.description,
      displayName: entity.displayName,
      triggerWords: entity.triggerWords,
      triggerWhen: entity.triggerWhen,
      callbackUrls: entity.callbackUrls,
      contentType: entity.contentType,
      username: entity.username,
      iconUrl: entity.iconUrl,
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
      'channel_id': channelId,
      'description': description,
      'display_name': displayName,
      'trigger_words': triggerWords,
      'trigger_when': triggerWhen,
      'callback_urls': callbackUrls,
      'content_type': contentType,
      'username': username,
      'icon_url': iconUrl,
    };
  }

  @override
  OutgoingWebhookModel copyWith({
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
    return OutgoingWebhookModel(
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

  OutgoingWebhookEntity toEntity() {
    return OutgoingWebhookEntity(
      id: id,
      token: token,
      createAt: createAt,
      updateAt: updateAt,
      deleteAt: deleteAt,
      creatorId: creatorId,
      teamId: teamId,
      channelId: channelId,
      description: description,
      displayName: displayName,
      triggerWords: triggerWords,
      triggerWhen: triggerWhen,
      callbackUrls: callbackUrls,
      contentType: contentType,
      username: username,
      iconUrl: iconUrl,
    );
  }
}
