import 'package:flutter_mattermost/features/channels/domain/entities/channel_unread_at_entity.dart';

final class ChannelUnreadAtModel extends ChannelUnreadAtEntity {
  const ChannelUnreadAtModel({
    required super.team_id,
    required super.channel_id,
    required super.msg_count,
    required super.mention_count,
    required super.last_viewed_at,
  });

  factory ChannelUnreadAtModel.fromMap(Map<String, dynamic> map) {
    return ChannelUnreadAtModel(
      team_id: map["team_id"] as String?,
      channel_id: map["channel_id"] as String?,
      msg_count: (map["msg_count"] as num?)?.toInt(),
      mention_count: (map["mention_count"] as num?)?.toInt(),
      last_viewed_at: (map["last_viewed_at"] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "team_id": team_id,
      "channel_id": channel_id,
      "msg_count": msg_count,
      "mention_count": mention_count,
      "last_viewed_at": last_viewed_at,
    };
  }

  factory ChannelUnreadAtModel.fromEntity(ChannelUnreadAtEntity entity) {
    return ChannelUnreadAtModel(
      team_id: entity.team_id,
      channel_id: entity.channel_id,
      msg_count: entity.msg_count,
      mention_count: entity.mention_count,
      last_viewed_at: entity.last_viewed_at,
    );
  }

  @override
  ChannelUnreadAtModel copyWith({
    String? team_id,
    String? channel_id,
    int? msg_count,
    int? mention_count,
    int? last_viewed_at,
  }) {
    return ChannelUnreadAtModel(
      team_id: team_id ?? this.team_id,
      channel_id: channel_id ?? this.channel_id,
      msg_count: msg_count ?? this.msg_count,
      mention_count: mention_count ?? this.mention_count,
      last_viewed_at: last_viewed_at ?? this.last_viewed_at,
    );
  }

  ChannelUnreadAtEntity toEntity() => ChannelUnreadAtEntity(
        team_id: team_id,
        channel_id: channel_id,
        msg_count: msg_count,
        mention_count: mention_count,
        last_viewed_at: last_viewed_at,
      );
}
