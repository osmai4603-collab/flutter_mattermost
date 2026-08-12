import 'package:flutter_mattermost/features/channels/domain/entities/channel_member_entity.dart';

final class ChannelMemberModel extends ChannelMemberEntity {
  const ChannelMemberModel({
    required super.serverId,
    required super.channelId,
    required super.userId,
    required super.roles,
    required super.lastViewedAt,
    required super.msgCount,
    required super.mentionCount,
    required super.notifyProps,
    required super.lastUpdateAt,
  });

  factory ChannelMemberModel.fromMap(Map<String, dynamic> data) {
    return ChannelMemberModel(
      serverId: data['server_id'] ?? '',
      channelId: data['channel_id'] ?? '',
      userId: data['user_id'] ?? '',
      roles: data['roles'] ?? '',
      lastViewedAt: (data['last_viewed_at'] ?? 0).toInt(),
      msgCount: (data['msg_count'] ?? 0).toInt(),
      mentionCount: (data['mention_count'] ?? 0).toInt(),
      notifyProps: Map<String, dynamic>.from(data['notify_props'] ?? const {}),
      lastUpdateAt: (data['last_update_at'] ?? 0).toInt(),
    );
  }

  factory ChannelMemberModel.fromEntity(ChannelMemberEntity entity) {
    return ChannelMemberModel(
      serverId: entity.serverId,
      channelId: entity.channelId,
      userId: entity.userId,
      roles: entity.roles,
      lastViewedAt: entity.lastViewedAt,
      msgCount: entity.msgCount,
      mentionCount: entity.mentionCount,
      notifyProps: entity.notifyProps,
      lastUpdateAt: entity.lastUpdateAt,
    );
  }

  @override
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
    };
  }

  @override
  ChannelMemberModel copyWith({
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
    return ChannelMemberModel(
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

  ChannelMemberEntity toEntity() {
    return ChannelMemberEntity(
      serverId: serverId,
      channelId: channelId,
      userId: userId,
      roles: roles,
      lastViewedAt: lastViewedAt,
      msgCount: msgCount,
      mentionCount: mentionCount,
      notifyProps: notifyProps,
      lastUpdateAt: lastUpdateAt,
    );
  }
}
