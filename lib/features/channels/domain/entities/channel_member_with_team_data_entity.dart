import 'package:flutter_mattermost/features/channels/domain/entities/channel_member_entity.dart';

class ChannelMemberWithTeamDataEntity extends ChannelMemberEntity {
  final String? team_display_name;
  final String? team_name;
  final int? team_update_at;

  const ChannelMemberWithTeamDataEntity({
    super.serverId = '',
    super.channelId = '',
    super.userId = '',
    super.roles = '',
    super.lastViewedAt = 0,
    super.msgCount = 0,
    super.mentionCount = 0,
    super.notifyProps = const {},
    super.lastUpdateAt = 0,
    this.team_display_name,
    this.team_name,
    this.team_update_at,
  });

  @override
  List<Object?> get props => [
        ...super.props,
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
    Map<String, dynamic>? notifyProps,
    int? lastUpdateAt,
    String? team_display_name,
    String? team_name,
    int? team_update_at,
  }) {
    return ChannelMemberWithTeamDataEntity(
      serverId: serverId ?? this.serverId,
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
