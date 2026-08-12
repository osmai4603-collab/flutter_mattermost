import 'package:flutter_mattermost/features/channels/domain/entities/channel_member_with_team_data_entity.dart';

final class ChannelMemberWithTeamDataModel extends ChannelMemberWithTeamDataEntity {
  const ChannelMemberWithTeamDataModel({
    super.serverId = '',
    super.channelId = '',
    super.userId = '',
    super.roles = '',
    super.lastViewedAt = 0,
    super.msgCount = 0,
    super.mentionCount = 0,
    super.notifyProps = const {},
    super.lastUpdateAt = 0,
    super.team_display_name,
    super.team_name,
    super.team_update_at,
  });

  factory ChannelMemberWithTeamDataModel.fromMap(Map<String, dynamic> map) {
    return ChannelMemberWithTeamDataModel(
      serverId: map['server_id'] as String? ?? '',
      channelId: map['channel_id'] as String? ?? '',
      userId: map['user_id'] as String? ?? '',
      roles: map['roles'] as String? ?? '',
      lastViewedAt: (map['last_viewed_at'] as num?)?.toInt() ?? 0,
      msgCount: (map['msg_count'] as num?)?.toInt() ?? 0,
      mentionCount: (map['mention_count'] as num?)?.toInt() ?? 0,
      notifyProps: Map<String, dynamic>.from(map['notify_props'] ?? const {}),
      lastUpdateAt: (map['last_update_at'] as num?)?.toInt() ?? 0,
      team_display_name: map['team_display_name'] as String?,
      team_name: map['team_name'] as String?,
      team_update_at: (map['team_update_at'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'server_id': serverId,
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
      serverId: entity.serverId,
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
    Map<String, dynamic>? notifyProps,
    int? lastUpdateAt,
    String? team_display_name,
    String? team_name,
    int? team_update_at,
  }) {
    return ChannelMemberWithTeamDataModel(
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

  ChannelMemberWithTeamDataEntity toEntity() => ChannelMemberWithTeamDataEntity(
        serverId: serverId,
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
