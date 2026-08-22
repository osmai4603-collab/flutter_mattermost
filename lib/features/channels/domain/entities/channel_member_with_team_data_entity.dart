import 'package:flutter_mattermost/core/entities/entity.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_member_entity.dart';

class ChannelMemberWithTeamDataEntity extends Entity {
  final String channelId;
  final String userId;
  final String roles;
  final int lastViewedAt;
  final int msgCount;
  final int mentionCount;
  final ChannelMemeberNotifyProps? notifyProps;
  final int lastUpdateAt;
  final String? team_display_name;
  final String? team_name;
  final int? team_update_at;

  const ChannelMemberWithTeamDataEntity({
    this.channelId = '',
    this.userId = '',
    this.roles = '',
    this.lastViewedAt = 0,
    this.msgCount = 0,
    this.mentionCount = 0,
    this.notifyProps,
    this.lastUpdateAt = 0,
    this.team_display_name,
    this.team_name,
    this.team_update_at,
  });

  @override
  List<Object?> get props => [
    ...this.props,
    team_display_name,
    team_name,
    team_update_at,
  ];

  @override
  ChannelMemberWithTeamDataEntity copyWith({
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
    return ChannelMemberWithTeamDataEntity(
      channelId: channelId ?? this.channelId,
      userId: userId ?? this.userId,
      roles: roles ?? this.roles,
      lastViewedAt: lastViewedAt ?? this.lastViewedAt,
      msgCount: msgCount ?? this.msgCount,
      mentionCount: mentionCount ?? this.mentionCount,
      notifyProps: notifyProps ?? this.notifyProps,
      lastUpdateAt: lastUpdateAt ?? this.lastUpdateAt,
      team_display_name: team_display_name ?? this.team_display_name,
      team_name: team_name ?? this.team_name,
      team_update_at: team_update_at ?? this.team_update_at,
    );
  }
}
