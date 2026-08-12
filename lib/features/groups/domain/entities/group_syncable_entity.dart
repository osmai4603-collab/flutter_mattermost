import 'package:flutter_mattermost/core/entities/entity.dart';

class GroupSyncableEntity extends Entity {
  final String groupId;
  final String teamId;
  final String channelId;
  final bool autoAdd;
  final int createAt;
  final int updateAt;
  final int deleteAt;
  final int userCount;

  const GroupSyncableEntity({
    this.groupId = '',
    this.teamId = '',
    this.channelId = '',
    this.autoAdd = false,
    this.createAt = 0,
    this.updateAt = 0,
    this.deleteAt = 0,
    this.userCount = 0,
  });

  @override
  List<Object?> get props => [
        groupId,
        teamId,
        channelId,
        autoAdd,
        createAt,
        updateAt,
        deleteAt,
        userCount,
      ];

  @override
  GroupSyncableEntity copyWith({
    String? groupId,
    String? teamId,
    String? channelId,
    bool? autoAdd,
    int? createAt,
    int? updateAt,
    int? deleteAt,
    int? userCount,
  }) {
    return GroupSyncableEntity(
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

  String get syncableId => teamId.isNotEmpty ? teamId : channelId;
}
