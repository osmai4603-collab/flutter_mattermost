import 'package:flutter_mattermost/core/entities/entity.dart';

class IncomingWebhookEntity extends Entity {
  final String id;
  final int createAt;
  final int updateAt;
  final int deleteAt;
  final int lastUsed;
  final String userId;
  final String channelId;
  final String teamId;
  final String displayName;
  final String description;
  final String username;
  final String iconUrl;
  final bool channelLocked;

  const IncomingWebhookEntity({
    this.id = '',
    this.createAt = 0,
    this.updateAt = 0,
    this.deleteAt = 0,
    this.lastUsed = 0,
    this.userId = '',
    this.channelId = '',
    this.teamId = '',
    this.displayName = '',
    this.description = '',
    this.username = '',
    this.iconUrl = '',
    this.channelLocked = false,
  });

  @override
  List<Object?> get props => [
        id,
        createAt,
        updateAt,
        deleteAt,
        lastUsed,
        userId,
        channelId,
        teamId,
        displayName,
        description,
        username,
        iconUrl,
        channelLocked,
      ];

  @override
  IncomingWebhookEntity copyWith({
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
    return IncomingWebhookEntity(
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
}
