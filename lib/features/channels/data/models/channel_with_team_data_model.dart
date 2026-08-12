import 'package:flutter_mattermost/core/enums/channel_type.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_with_team_data_entity.dart';

final class ChannelWithTeamDataModel extends ChannelWithTeamDataEntity {
  const ChannelWithTeamDataModel({
    required super.id,
    super.createAt,
    super.updateAt,
    super.deleteAt,
    required super.teamId,
    required super.type,
    required super.displayName,
    required super.name,
    super.header,
    super.purpose,
    required super.lastPostAt,
    super.totalMsgCount,
    super.extraUpdateAt,
    super.creatorId,
    super.team_display_name,
    super.team_name,
    super.team_update_at,
    super.policy_id,
  });

  factory ChannelWithTeamDataModel.fromMap(Map<String, dynamic> map) {
    return ChannelWithTeamDataModel(
      id: map["id"] as String? ?? '',
      createAt: (map["create_at"] as num?)?.toInt() ?? 0,
      updateAt: (map["update_at"] as num?)?.toInt() ?? 0,
      deleteAt: (map["delete_at"] as num?)?.toInt() ?? 0,
      teamId: map["team_id"] as String? ?? '',
      type: ChannelType.fromValue(map["type"] as String? ?? 'O'),
      displayName: map["display_name"] as String? ?? '',
      name: map["name"] as String? ?? '',
      header: map["header"] as String? ?? '',
      purpose: map["purpose"] as String? ?? '',
      lastPostAt: (map["last_post_at"] as num?)?.toInt() ?? 0,
      totalMsgCount: (map["total_msg_count"] as num?)?.toInt() ?? 0,
      extraUpdateAt: (map["extra_update_at"] as num?)?.toInt() ?? 0,
      creatorId: map["creator_id"] as String? ?? '',
      team_display_name: map["team_display_name"] as String?,
      team_name: map["team_name"] as String?,
      team_update_at: (map["team_update_at"] as num?)?.toInt(),
      policy_id: map["policy_id"] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "create_at": createAt,
      "update_at": updateAt,
      "delete_at": deleteAt,
      "team_id": teamId,
      "type": type.value,
      "display_name": displayName,
      "name": name,
      "header": header,
      "purpose": purpose,
      "last_post_at": lastPostAt,
      "total_msg_count": totalMsgCount,
      "extra_update_at": extraUpdateAt,
      "creator_id": creatorId,
      "team_display_name": team_display_name,
      "team_name": team_name,
      "team_update_at": team_update_at,
      "policy_id": policy_id,
    };
  }

  factory ChannelWithTeamDataModel.fromEntity(ChannelWithTeamDataEntity entity) {
    return ChannelWithTeamDataModel(
      id: entity.id,
      createAt: entity.createAt,
      updateAt: entity.updateAt,
      deleteAt: entity.deleteAt,
      teamId: entity.teamId,
      type: entity.type,
      displayName: entity.displayName,
      name: entity.name,
      header: entity.header,
      purpose: entity.purpose,
      lastPostAt: entity.lastPostAt,
      totalMsgCount: entity.totalMsgCount,
      extraUpdateAt: entity.extraUpdateAt,
      creatorId: entity.creatorId,
      team_display_name: entity.team_display_name,
      team_name: entity.team_name,
      team_update_at: entity.team_update_at,
      policy_id: entity.policy_id,
    );
  }

  @override
  ChannelWithTeamDataModel copyWith({
    String? id,
    int? createAt,
    int? updateAt,
    int? deleteAt,
    String? teamId,
    ChannelType? type,
    String? displayName,
    String? name,
    String? header,
    String? purpose,
    int? lastPostAt,
    int? totalMsgCount,
    int? extraUpdateAt,
    String? creatorId,
    String? team_display_name,
    String? team_name,
    int? team_update_at,
    String? policy_id,
  }) {
    return ChannelWithTeamDataModel(
      id: id ?? this.id,
      createAt: createAt ?? this.createAt,
      updateAt: updateAt ?? this.updateAt,
      deleteAt: deleteAt ?? this.deleteAt,
      teamId: teamId ?? this.teamId,
      type: type ?? this.type,
      displayName: displayName ?? this.displayName,
      name: name ?? this.name,
      header: header ?? this.header,
      purpose: purpose ?? this.purpose,
      lastPostAt: lastPostAt ?? this.lastPostAt,
      totalMsgCount: totalMsgCount ?? this.totalMsgCount,
      extraUpdateAt: extraUpdateAt ?? this.extraUpdateAt,
      creatorId: creatorId ?? this.creatorId,
      team_display_name: team_display_name ?? this.team_display_name,
      team_name: team_name ?? this.team_name,
      team_update_at: team_update_at ?? this.team_update_at,
      policy_id: policy_id ?? this.policy_id,
    );
  }

  ChannelWithTeamDataEntity toEntity() => ChannelWithTeamDataEntity(
        id: id,
        createAt: createAt,
        updateAt: updateAt,
        deleteAt: deleteAt,
        teamId: teamId,
        type: type,
        displayName: displayName,
        name: name,
        header: header,
        purpose: purpose,
        lastPostAt: lastPostAt,
        totalMsgCount: totalMsgCount,
        extraUpdateAt: extraUpdateAt,
        creatorId: creatorId,
        team_display_name: team_display_name,
        team_name: team_name,
        team_update_at: team_update_at,
        policy_id: policy_id,
      );
}
