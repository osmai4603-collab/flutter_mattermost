import 'package:flutter_mattermost/features/groups/domain/entities/group_syncable_channels_entity.dart';

final class GroupSyncableChannelsModel extends GroupSyncableChannelsEntity {
  const GroupSyncableChannelsModel({
    required super.channel_id,
    required super.channel_display_name,
    required super.channel_type,
    required super.team_id,
    required super.team_display_name,
    required super.team_type,
    required super.group_id,
    required super.auto_add,
    required super.create_at,
    required super.delete_at,
    required super.update_at,
  });

  factory GroupSyncableChannelsModel.fromMap(Map<String, dynamic> map) {
    return GroupSyncableChannelsModel(
      channel_id: map["channel_id"] as String?,
      channel_display_name: map["channel_display_name"] as String?,
      channel_type: map["channel_type"] as String?,
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
      "channel_id": channel_id,
      "channel_display_name": channel_display_name,
      "channel_type": channel_type,
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

  factory GroupSyncableChannelsModel.fromEntity(GroupSyncableChannelsEntity entity) {
    return GroupSyncableChannelsModel(
      channel_id: entity.channel_id,
      channel_display_name: entity.channel_display_name,
      channel_type: entity.channel_type,
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
  GroupSyncableChannelsModel copyWith({
    String? channel_id,
    String? channel_display_name,
    String? channel_type,
    String? team_id,
    String? team_display_name,
    String? team_type,
    String? group_id,
    bool? auto_add,
    int? create_at,
    int? delete_at,
    int? update_at,
  }) {
    return GroupSyncableChannelsModel(
      channel_id: channel_id ?? this.channel_id,
      channel_display_name: channel_display_name ?? this.channel_display_name,
      channel_type: channel_type ?? this.channel_type,
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

  GroupSyncableChannelsEntity toEntity() => GroupSyncableChannelsEntity(
        channel_id: channel_id,
        channel_display_name: channel_display_name,
        channel_type: channel_type,
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
