import 'package:flutter_mattermost/core/enums/channel_type.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_entity.dart';

/// قناة مع بيانات فريقها (ChannelWithTeamData):
/// جميع حقول Channel إضافة إلى بيانات الفريق.
class ChannelWithTeamDataEntity extends ChannelEntity {
  final String? team_display_name;
  final String? team_name;
  final int? team_update_at;
  final String? policy_id;

  const ChannelWithTeamDataEntity({
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
    this.team_display_name,
    this.team_name,
    this.team_update_at,
    this.policy_id,
  });
  @override
  ChannelWithTeamDataEntity copyWith({
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
    return ChannelWithTeamDataEntity(
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
}
