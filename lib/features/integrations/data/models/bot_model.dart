import 'package:flutter_mattermost/features/integrations/domain/entities/bot_entity.dart';

final class BotModel extends BotEntity {
  const BotModel({
    super.userId,
    super.createAt,
    super.updateAt,
    super.deleteAt,
    super.username,
    super.displayName,
    super.description,
    super.ownerId,
  });

  factory BotModel.fromMap(Map<String, dynamic> data) {
    return BotModel(
      userId: data['user_id'] ?? '',
      createAt: (data['create_at'] ?? 0).toInt(),
      updateAt: (data['update_at'] ?? 0).toInt(),
      deleteAt: (data['delete_at'] ?? 0).toInt(),
      username: data['username'] ?? '',
      displayName: data['display_name'] ?? '',
      description: data['description'] ?? '',
      ownerId: data['owner_id'] ?? '',
    );
  }

  factory BotModel.fromEntity(BotEntity entity) {
    return BotModel(
      userId: entity.userId,
      createAt: entity.createAt,
      updateAt: entity.updateAt,
      deleteAt: entity.deleteAt,
      username: entity.username,
      displayName: entity.displayName,
      description: entity.description,
      ownerId: entity.ownerId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'create_at': createAt,
      'update_at': updateAt,
      'delete_at': deleteAt,
      'username': username,
      'display_name': displayName,
      'description': description,
      'owner_id': ownerId,
    };
  }

  @override
  BotModel copyWith({
    String? userId,
    int? createAt,
    int? updateAt,
    int? deleteAt,
    String? username,
    String? displayName,
    String? description,
    String? ownerId,
  }) {
    return BotModel(
      userId: userId ?? this.userId,
      createAt: createAt ?? this.createAt,
      updateAt: updateAt ?? this.updateAt,
      deleteAt: deleteAt ?? this.deleteAt,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      description: description ?? this.description,
      ownerId: ownerId ?? this.ownerId,
    );
  }

  BotEntity toEntity() {
    return BotEntity(
      userId: userId,
      createAt: createAt,
      updateAt: updateAt,
      deleteAt: deleteAt,
      username: username,
      displayName: displayName,
      description: description,
      ownerId: ownerId,
    );
  }
}
