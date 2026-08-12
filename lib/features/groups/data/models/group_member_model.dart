import 'package:flutter_mattermost/features/groups/domain/entities/group_member_entity.dart';

final class GroupMemberModel extends GroupMemberEntity {
  const GroupMemberModel({
    super.groupId,
    super.userId,
    super.createAt,
    super.deleteAt,
  });

  factory GroupMemberModel.fromMap(Map<String, dynamic> data) {
    return GroupMemberModel(
      groupId: data['group_id'] ?? '',
      userId: data['user_id'] ?? '',
      createAt: (data['create_at'] ?? 0).toInt(),
      deleteAt: (data['delete_at'] ?? 0).toInt(),
    );
  }

  factory GroupMemberModel.fromEntity(GroupMemberEntity entity) {
    return GroupMemberModel(
      groupId: entity.groupId,
      userId: entity.userId,
      createAt: entity.createAt,
      deleteAt: entity.deleteAt,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'group_id': groupId,
      'user_id': userId,
      'create_at': createAt,
      'delete_at': deleteAt,
    };
  }

  @override
  GroupMemberModel copyWith({
    String? groupId,
    String? userId,
    int? createAt,
    int? deleteAt,
  }) {
    return GroupMemberModel(
      groupId: groupId ?? this.groupId,
      userId: userId ?? this.userId,
      createAt: createAt ?? this.createAt,
      deleteAt: deleteAt ?? this.deleteAt,
    );
  }

  GroupMemberEntity toEntity() {
    return GroupMemberEntity(
      groupId: groupId,
      userId: userId,
      createAt: createAt,
      deleteAt: deleteAt,
    );
  }
}
