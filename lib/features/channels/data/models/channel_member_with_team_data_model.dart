import 'package:flutter_mattermost/features/channels/data/models/channel_member_model.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_member_entity.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_member_with_team_data_entity.dart';

final class ChannelMemberWithTeamDataModel
    extends ChannelMemberWithTeamDataEntity {
  const ChannelMemberWithTeamDataModel({
    super.channelId = '',
    super.userId = '',
    super.roles = '',
    super.lastViewedAt = 0,
    super.msgCount = 0,
    super.mentionCount = 0,
    super.notifyProps,
    super.lastUpdateAt = 0,
    super.team_display_name,
    super.team_name,
    super.team_update_at,
  });

  factory ChannelMemberWithTeamDataModel.fromMap(Map<String, dynamic> map) {
    return ChannelMemberWithTeamDataModel(
      channelId: map['channel_id'] as String? ?? '',
      userId: map['user_id'] as String? ?? '',
      roles: map['roles'] as String? ?? '',
      lastViewedAt: (map['last_viewed_at'] as num?)?.toInt() ?? 0,
      msgCount: (map['msg_count'] as num?)?.toInt() ?? 0,
      mentionCount: (map['mention_count'] as num?)?.toInt() ?? 0,
      notifyProps: ChannelMemberNofigyPropsModel.fromJson(
        map['notify_props'] ?? const {},
      ),
      lastUpdateAt: (map['last_update_at'] as num?)?.toInt() ?? 0,
      team_display_name: map['team_display_name'] as String?,
      team_name: map['team_name'] as String?,
      team_update_at: (map['team_update_at'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'channel_id': channelId,
      'user_id': userId,
      'roles': roles,
      'last_viewed_at': lastViewedAt,
      'msg_count': msgCount,
      'mention_count': mentionCount,
      'notify_props': notifyProps,
      'last_update_at': lastUpdateAt,
      'team_display_name': team_display_name,
      'team_name': team_name,
      'team_update_at': team_update_at,
    };
  }

  factory ChannelMemberWithTeamDataModel.fromEntity(
    ChannelMemberWithTeamDataEntity entity,
  ) {
    return ChannelMemberWithTeamDataModel(
      channelId: entity.channelId,
      userId: entity.userId,
      roles: entity.roles,
      lastViewedAt: entity.lastViewedAt,
      msgCount: entity.msgCount,
      mentionCount: entity.mentionCount,
      notifyProps: entity.notifyProps,
      lastUpdateAt: entity.lastUpdateAt,
      team_display_name: entity.team_display_name,
      team_name: entity.team_name,
      team_update_at: entity.team_update_at,
    );
  }

  @override
  ChannelMemberWithTeamDataModel copyWith({
    String? serverId,
    String? channelId,
    String? userId,
    String? roles,
    int? lastViewedAt,
    int? msgCount,
    int? mentionCount,
    ChannelMemeberNotifyProps? notifyProps,
    int? lastUpdateAt,
    String? team_display_name,
    String? team_name,
    int? team_update_at,
  }) {
    return ChannelMemberWithTeamDataModel(
      channelId: channelId ?? super.channelId,
      userId: userId ?? super.userId,
      roles: roles ?? super.roles,
      lastViewedAt: lastViewedAt ?? super.lastViewedAt,
      msgCount: msgCount ?? super.msgCount,
      mentionCount: mentionCount ?? super.mentionCount,
      notifyProps: notifyProps ?? super.notifyProps,
      lastUpdateAt: lastUpdateAt ?? super.lastUpdateAt,
      team_display_name: team_display_name ?? super.team_display_name,
      team_name: team_name ?? super.team_name,
      team_update_at: team_update_at ?? super.team_update_at,
    );
  }

  ChannelMemberWithTeamDataEntity toEntity() => ChannelMemberWithTeamDataEntity(
    channelId: channelId,
    userId: userId,
    roles: roles,
    lastViewedAt: lastViewedAt,
    msgCount: msgCount,
    mentionCount: mentionCount,
    notifyProps: notifyProps,
    lastUpdateAt: lastUpdateAt,
    team_display_name: team_display_name,
    team_name: team_name,
    team_update_at: team_update_at,
  );
}
