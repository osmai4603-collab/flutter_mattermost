import 'package:flutter_mattermost/features/integrations/domain/entities/incoming_webhook_entity.dart';

final class IncomingWebhookModel extends IncomingWebhookEntity {
  const IncomingWebhookModel({
    super.id,
    super.createAt,
    super.updateAt,
    super.deleteAt,
    super.lastUsed,
    super.userId,
    super.channelId,
    super.teamId,
    super.displayName,
    super.description,
    super.username,
    super.iconUrl,
    super.channelLocked,
  });

  factory IncomingWebhookModel.fromMap(Map<String, dynamic> data) {
    return IncomingWebhookModel(
      id: data['id'] ?? '',
      createAt: (data['create_at'] ?? 0).toInt(),
      updateAt: (data['update_at'] ?? 0).toInt(),
      deleteAt: (data['delete_at'] ?? 0).toInt(),
      lastUsed: (data['last_used'] ?? 0).toInt(),
      userId: data['user_id'] ?? '',
      channelId: data['channel_id'] ?? '',
      teamId: data['team_id'] ?? '',
      displayName: data['display_name'] ?? '',
      description: data['description'] ?? '',
      username: data['username'] ?? '',
      iconUrl: data['icon_url'] ?? '',
      channelLocked: data['channel_locked'] ?? false,
    );
  }

  factory IncomingWebhookModel.fromEntity(IncomingWebhookEntity entity) {
    return IncomingWebhookModel(
      id: entity.id,
      createAt: entity.createAt,
      updateAt: entity.updateAt,
      deleteAt: entity.deleteAt,
      lastUsed: entity.lastUsed,
      userId: entity.userId,
      channelId: entity.channelId,
      teamId: entity.teamId,
      displayName: entity.displayName,
      description: entity.description,
      username: entity.username,
      iconUrl: entity.iconUrl,
      channelLocked: entity.channelLocked,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'create_at': createAt,
      'update_at': updateAt,
      'delete_at': deleteAt,
      'last_used': lastUsed,
      'user_id': userId,
      'channel_id': channelId,
      'team_id': teamId,
      'display_name': displayName,
      'description': description,
      'username': username,
      'icon_url': iconUrl,
      'channel_locked': channelLocked,
    };
  }

  @override
  IncomingWebhookModel copyWith({
    String? id,
    int? createAt,
    int? updateAt,
    int? deleteAt,
    int? lastUsed,
    String? userId,
    String? channelId,
    String? teamId,
    String? displayName,
    String? description,
    String? username,
    String? iconUrl,
    bool? channelLocked,
  }) {
    return IncomingWebhookModel(
      id: id ?? this.id,
      createAt: createAt ?? this.createAt,
      updateAt: updateAt ?? this.updateAt,
      deleteAt: deleteAt ?? this.deleteAt,
      lastUsed: lastUsed ?? this.lastUsed,
      userId: userId ?? this.userId,
      channelId: channelId ?? this.channelId,
      teamId: teamId ?? this.teamId,
      displayName: displayName ?? this.displayName,
      description: description ?? this.description,
      username: username ?? this.username,
      iconUrl: iconUrl ?? this.iconUrl,
      channelLocked: channelLocked ?? this.channelLocked,
    );
  }

  IncomingWebhookEntity toEntity() {
    return IncomingWebhookEntity(
      id: id,
      createAt: createAt,
      updateAt: updateAt,
      deleteAt: deleteAt,
      lastUsed: lastUsed,
      userId: userId,
      channelId: channelId,
      teamId: teamId,
      displayName: displayName,
      description: description,
      username: username,
      iconUrl: iconUrl,
      channelLocked: channelLocked,
    );
  }
}
