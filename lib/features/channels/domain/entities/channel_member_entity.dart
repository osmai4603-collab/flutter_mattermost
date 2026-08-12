import 'package:flutter_mattermost/core/entities/entity.dart';

class ChannelMemberEntity extends Entity {
  final String serverId;
  final String channelId;
  final String userId;
  final String roles;
  final int lastViewedAt;
  final int msgCount;
  final int mentionCount;
  final Map<String, dynamic> notifyProps;
  final int lastUpdateAt;

  const ChannelMemberEntity({
    required this.serverId,
    required this.channelId,
    required this.userId,
    this.roles = '',
    this.lastViewedAt = 0,
    this.msgCount = 0,
    this.mentionCount = 0,
    this.notifyProps = const {},
    this.lastUpdateAt = 0,
  });

  @override
  List<Object?> get props => [
        serverId,
        channelId,
        userId,
        roles,
        lastViewedAt,
        msgCount,
        mentionCount,
        notifyProps,
        lastUpdateAt,
      ];

  @override
  ChannelMemberEntity copyWith({
    String? serverId,
    String? channelId,
    String? userId,
    String? roles,
    int? lastViewedAt,
    int? msgCount,
    int? mentionCount,
    Map<String, dynamic>? notifyProps,
    int? lastUpdateAt,
  }) {
    return ChannelMemberEntity(
      serverId: serverId ?? this.serverId,
      channelId: channelId ?? this.channelId,
      userId: userId ?? this.userId,
      roles: roles ?? this.roles,
      lastViewedAt: lastViewedAt ?? this.lastViewedAt,
      msgCount: msgCount ?? this.msgCount,
      mentionCount: mentionCount ?? this.mentionCount,
      notifyProps: notifyProps ?? this.notifyProps,
      lastUpdateAt: lastUpdateAt ?? this.lastUpdateAt,
    );
  }
}
