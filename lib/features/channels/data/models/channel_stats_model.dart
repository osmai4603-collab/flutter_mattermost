import 'package:flutter_mattermost/features/channels/domain/entities/channel_stats_entity.dart';

final class ChannelStatsModel extends ChannelStats {
  const ChannelStatsModel({
    required super.channelId,
    required super.memberCount,
  });

  factory ChannelStatsModel.fromMap(Map<String, dynamic> map) {
    return ChannelStatsModel(
      channelId: map["channel_id"] as String? ?? '',
      memberCount: (map["member_count"] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "channel_id": channelId,
      "member_count": memberCount,
    };
  }

  factory ChannelStatsModel.fromEntity(ChannelStats entity) {
    return ChannelStatsModel(
      channelId: entity.channelId,
      memberCount: entity.memberCount,
    );
  }

  ChannelStatsModel copyWith({
    String? channelId,
    int? memberCount,
  }) {
    return ChannelStatsModel(
      channelId: channelId ?? this.channelId,
      memberCount: memberCount ?? this.memberCount,
    );
  }

  ChannelStats toEntity() => ChannelStats(
        channelId: channelId,
        memberCount: memberCount,
      );
}
