import 'package:flutter_mattermost/core/entities/entity.dart';

class BotEntity extends Entity {
  final String userId;
  final int createAt;
  final int updateAt;
  final int deleteAt;
  final String username;
  final String displayName;
  final String description;
  final String ownerId;

  const BotEntity({
    this.userId = '',
    this.createAt = 0,
    this.updateAt = 0,
    this.deleteAt = 0,
    this.username = '',
    this.displayName = '',
    this.description = '',
    this.ownerId = '',
  });

  @override
  List<Object?> get props => [
        userId,
        createAt,
        updateAt,
        deleteAt,
        username,
        displayName,
        description,
        ownerId,
      ];

  @override
  BotEntity copyWith({
    String? userId,
    int? createAt,
    int? updateAt,
    int? deleteAt,
    String? username,
    String? displayName,
    String? description,
    String? ownerId,
  }) {
    return BotEntity(
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
}
