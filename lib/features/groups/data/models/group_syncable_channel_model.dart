import 'package:flutter_mattermost/features/groups/domain/entities/group_syncable_channel_entity.dart';

final class GroupSyncableChannelModel extends GroupSyncableChannelEntity {
  const GroupSyncableChannelModel({
    required super.channel_id,
    required super.group_id,
    required super.auto_add,
    required super.create_at,
    required super.delete_at,
    required super.update_at,
  });

  factory GroupSyncableChannelModel.fromMap(Map<String, dynamic> map) {
    return GroupSyncableChannelModel(
      channel_id: map["channel_id"] as String?,
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
      "group_id": group_id,
      "auto_add": auto_add,
      "create_at": create_at,
      "delete_at": delete_at,
      "update_at": update_at,
    };
  }

  factory GroupSyncableChannelModel.fromEntity(GroupSyncableChannelEntity entity) {
    return GroupSyncableChannelModel(
      channel_id: entity.channel_id,
      group_id: entity.group_id,
      auto_add: entity.auto_add,
      create_at: entity.create_at,
      delete_at: entity.delete_at,
      update_at: entity.update_at,
    );
  }

  @override
  GroupSyncableChannelModel copyWith({
    String? channel_id,
    String? group_id,
    bool? auto_add,
    int? create_at,
    int? delete_at,
    int? update_at,
  }) {
    return GroupSyncableChannelModel(
      channel_id: channel_id ?? this.channel_id,
      group_id: group_id ?? this.group_id,
      auto_add: auto_add ?? this.auto_add,
      create_at: create_at ?? this.create_at,
      delete_at: delete_at ?? this.delete_at,
      update_at: update_at ?? this.update_at,
    );
  }

  GroupSyncableChannelEntity toEntity() => GroupSyncableChannelEntity(
        channel_id: channel_id,
        group_id: group_id,
        auto_add: auto_add,
        create_at: create_at,
        delete_at: delete_at,
        update_at: update_at,
      );
}
