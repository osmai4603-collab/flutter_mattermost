import 'package:flutter_mattermost/core/entities/entity.dart';

class BotAccountEntity extends Entity {
  final String userId;
  final String username;
  final String displayName;
  final String description;
  final String ownerId;
  final int lastIconUpdate;
  final bool isDeleted;

  const BotAccountEntity({
    required this.userId,
    required this.username,
    this.displayName = '',
    this.description = '',
    this.ownerId = '',
    this.lastIconUpdate = 0,
    this.isDeleted = false,
  });

  @override
  List<Object?> get props => [
        userId,
        username,
        displayName,
        description,
        ownerId,
        lastIconUpdate,
        isDeleted,
      ];

  @override
  BotAccountEntity copyWith({
    String? userId,
    String? username,
    String? displayName,
    String? description,
    String? ownerId,
    int? lastIconUpdate,
    bool? isDeleted,
  }) {
    return BotAccountEntity(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      description: description ?? this.description,
      ownerId: ownerId ?? this.ownerId,
      lastIconUpdate: lastIconUpdate ?? this.lastIconUpdate,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}
