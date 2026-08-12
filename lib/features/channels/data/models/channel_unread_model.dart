import 'package:flutter_mattermost/features/channels/domain/entities/channel_unread_entity.dart';

final class ChannelUnreadModel extends ChannelUnreadEntity {
  const ChannelUnreadModel({
    required super.team_id,
    required super.channel_id,
    required super.msg_count,
    required super.mention_count,
  });

  factory ChannelUnreadModel.fromMap(Map<String, dynamic> map) {
    return ChannelUnreadModel(
      team_id: map["team_id"] as String?,
      channel_id: map["channel_id"] as String?,
      msg_count: (map["msg_count"] as num?)?.toInt(),
      mention_count: (map["mention_count"] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "team_id": team_id,
      "channel_id": channel_id,
      "msg_count": msg_count,
      "mention_count": mention_count,
    };
  }

  factory ChannelUnreadModel.fromEntity(ChannelUnreadEntity entity) {
    return ChannelUnreadModel(
      team_id: entity.team_id,
      channel_id: entity.channel_id,
      msg_count: entity.msg_count,
      mention_count: entity.mention_count,
    );
  }

  @override
  ChannelUnreadModel copyWith({
    String? team_id,
    String? channel_id,
    int? msg_count,
    int? mention_count,
  }) {
    return ChannelUnreadModel(
      team_id: team_id ?? this.team_id,
      channel_id: channel_id ?? this.channel_id,
      msg_count: msg_count ?? this.msg_count,
      mention_count: mention_count ?? this.mention_count,
    );
  }

  ChannelUnreadEntity toEntity() => ChannelUnreadEntity(
        team_id: team_id,
        channel_id: channel_id,
        msg_count: msg_count,
        mention_count: mention_count,
      );
}
