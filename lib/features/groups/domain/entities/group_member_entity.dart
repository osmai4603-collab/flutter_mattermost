import 'package:flutter_mattermost/core/entities/entity.dart';

class GroupMemberEntity extends Entity {
  final String groupId;
  final String userId;
  final int createAt;
  final int deleteAt;

  const GroupMemberEntity({
    this.groupId = '',
    this.userId = '',
    this.createAt = 0,
    this.deleteAt = 0,
  });

  @override
  List<Object?> get props => [groupId, userId, createAt, deleteAt];

  @override
  GroupMemberEntity copyWith({
    String? groupId,
    String? userId,
    int? createAt,
    int? deleteAt,
  }) {
    return GroupMemberEntity(
      groupId: groupId ?? this.groupId,
      userId: userId ?? this.userId,
      createAt: createAt ?? this.createAt,
      deleteAt: deleteAt ?? this.deleteAt,
    );
  }
}
