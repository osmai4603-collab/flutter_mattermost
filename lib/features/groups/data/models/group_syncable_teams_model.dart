import 'package:flutter_mattermost/features/groups/domain/entities/group_syncable_teams_entity.dart';

final class GroupSyncableTeamsModel extends GroupSyncableTeamsEntity {
  const GroupSyncableTeamsModel({
    required super.team_id,
    required super.team_display_name,
    required super.team_type,
    required super.group_id,
    required super.auto_add,
    required super.create_at,
    required super.delete_at,
    required super.update_at,
  });

  factory GroupSyncableTeamsModel.fromMap(Map<String, dynamic> map) {
    return GroupSyncableTeamsModel(
      team_id: map["team_id"] as String?,
      team_display_name: map["team_display_name"] as String?,
      team_type: map["team_type"] as String?,
      group_id: map["group_id"] as String?,
      auto_add: map["auto_add"] as bool?,
      create_at: (map["create_at"] as num?)?.toInt(),
      delete_at: (map["delete_at"] as num?)?.toInt(),
      update_at: (map["update_at"] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "team_id": team_id,
      "team_display_name": team_display_name,
      "team_type": team_type,
      "group_id": group_id,
      "auto_add": auto_add,
      "create_at": create_at,
      "delete_at": delete_at,
      "update_at": update_at,
    };
  }

  factory GroupSyncableTeamsModel.fromEntity(GroupSyncableTeamsEntity entity) {
    return GroupSyncableTeamsModel(
      team_id: entity.team_id,
      team_display_name: entity.team_display_name,
      team_type: entity.team_type,
      group_id: entity.group_id,
      auto_add: entity.auto_add,
      create_at: entity.create_at,
      delete_at: entity.delete_at,
      update_at: entity.update_at,
    );
  }

  @override
  GroupSyncableTeamsModel copyWith({
    String? team_id,
    String? team_display_name,
    String? team_type,
    String? group_id,
    bool? auto_add,
    int? create_at,
    int? delete_at,
    int? update_at,
  }) {
    return GroupSyncableTeamsModel(
      team_id: team_id ?? this.team_id,
      team_display_name: team_display_name ?? this.team_display_name,
      team_type: team_type ?? this.team_type,
      group_id: group_id ?? this.group_id,
      auto_add: auto_add ?? this.auto_add,
      create_at: create_at ?? this.create_at,
      delete_at: delete_at ?? this.delete_at,
      update_at: update_at ?? this.update_at,
    );
  }

  GroupSyncableTeamsEntity toEntity() => GroupSyncableTeamsEntity(
        team_id: team_id,
        team_display_name: team_display_name,
        team_type: team_type,
        group_id: group_id,
        auto_add: auto_add,
        create_at: create_at,
        delete_at: delete_at,
        update_at: update_at,
      );
}
