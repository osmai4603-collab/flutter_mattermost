import 'package:flutter_mattermost/features/groups/domain/entities/group_syncable_entity.dart';

final class GroupSyncableModel extends GroupSyncableEntity {
  const GroupSyncableModel({
    super.groupId,
    super.teamId,
    super.channelId,
    super.autoAdd,
    super.createAt,
    super.updateAt,
    super.deleteAt,
    super.userCount,
  });

  factory GroupSyncableModel.fromMap(Map<String, dynamic> data) {
    return GroupSyncableModel(
      groupId: data['group_id'] ?? '',
      teamId: data['team_id'] ?? '',
      channelId: data['channel_id'] ?? '',
      autoAdd: data['auto_add'] ?? false,
      createAt: (data['create_at'] ?? 0).toInt(),
      updateAt: (data['update_at'] ?? 0).toInt(),
      deleteAt: (data['delete_at'] ?? 0).toInt(),
      userCount: (data['user_count'] ?? 0).toInt(),
    );
  }

  factory GroupSyncableModel.fromEntity(GroupSyncableEntity entity) {
    return GroupSyncableModel(
      groupId: entity.groupId,
      teamId: entity.teamId,
      channelId: entity.channelId,
      autoAdd: entity.autoAdd,
      createAt: entity.createAt,
      updateAt: entity.updateAt,
      deleteAt: entity.deleteAt,
      userCount: entity.userCount,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'group_id': groupId,
      'team_id': teamId,
      'channel_id': channelId,
      'auto_add': autoAdd,
      'create_at': createAt,
      'update_at': updateAt,
      'delete_at': deleteAt,
      'user_count': userCount,
    };
  }

  @override
  GroupSyncableModel copyWith({
    String? groupId,
    String? teamId,
    String? channelId,
    bool? autoAdd,
    int? createAt,
    int? updateAt,
    int? deleteAt,
    int? userCount,
  }) {
    return GroupSyncableModel(
      groupId: groupId ?? this.groupId,
      teamId: teamId ?? this.teamId,
      channelId: channelId ?? this.channelId,
      autoAdd: autoAdd ?? this.autoAdd,
      createAt: createAt ?? this.createAt,
      updateAt: updateAt ?? this.updateAt,
      deleteAt: deleteAt ?? this.deleteAt,
      userCount: userCount ?? this.userCount,
    );
  }

  GroupSyncableEntity toEntity() {
    return GroupSyncableEntity(
      groupId: groupId,
      teamId: teamId,
      channelId: channelId,
      autoAdd: autoAdd,
      createAt: createAt,
      updateAt: updateAt,
      deleteAt: deleteAt,
      userCount: userCount,
    );
  }
}
