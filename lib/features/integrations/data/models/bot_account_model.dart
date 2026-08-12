import 'package:flutter_mattermost/features/integrations/domain/entities/bot_account_entity.dart';

final class BotAccountModel extends BotAccountEntity {
  const BotAccountModel({
    required super.userId,
    required super.username,
    super.displayName,
    super.description,
    super.ownerId,
    super.lastIconUpdate,
    super.isDeleted,
  });

  factory BotAccountModel.fromMap(Map<String, dynamic> data) {
    return BotAccountModel(
      userId: data['user_id'] ?? '',
      username: data['username'] ?? '',
      displayName: data['display_name'] ?? '',
      description: data['description'] ?? '',
      ownerId: data['owner_id'] ?? '',
      lastIconUpdate: (data['last_icon_update'] ?? 0).toInt(),
      isDeleted: (data['delete_at'] ?? 0) > 0,
    );
  }

  factory BotAccountModel.fromEntity(BotAccountEntity entity) {
    return BotAccountModel(
      userId: entity.userId,
      username: entity.username,
      displayName: entity.displayName,
      description: entity.description,
      ownerId: entity.ownerId,
      lastIconUpdate: entity.lastIconUpdate,
      isDeleted: entity.isDeleted,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'username': username,
      'display_name': displayName,
      'description': description,
      'owner_id': ownerId,
      'last_icon_update': lastIconUpdate,
      'delete_at': isDeleted ? 1 : 0,
    };
  }

  @override
  BotAccountModel copyWith({
    String? userId,
    String? username,
    String? displayName,
    String? description,
    String? ownerId,
    int? lastIconUpdate,
    bool? isDeleted,
  }) {
    return BotAccountModel(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      description: description ?? this.description,
      ownerId: ownerId ?? this.ownerId,
      lastIconUpdate: lastIconUpdate ?? this.lastIconUpdate,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  BotAccountEntity toEntity() {
    return BotAccountEntity(
      userId: userId,
      username: username,
      displayName: displayName,
      description: description,
      ownerId: ownerId,
      lastIconUpdate: lastIconUpdate,
      isDeleted: isDeleted,
    );
  }
}
