import 'package:flutter_mattermost/features/channels/domain/entities/channel_stats_entity.dart';

final class ChannelStatsModel extends ChannelStats {
  const ChannelStatsModel({
    required super.channelId,
    required super.memberCount,
    super.guestsCount = 0,
    super.pinnedPostsCount = 0,
  });

  factory ChannelStatsModel.fromMap(Map<String, dynamic> map) {
    return ChannelStatsModel(
      channelId: map["channel_id"] as String? ?? '',
      memberCount: (map["member_count"] as num?)?.toInt() ?? 0,
      guestsCount: (map["guests_count"] as num?)?.toInt() ?? 0,
      pinnedPostsCount: (map["pinnedpost_count"] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "channel_id": channelId,
      "member_count": memberCount,
      "guests_count": guestsCount,
      "pinnedpost_count": pinnedPostsCount,
    };
  }

  factory ChannelStatsModel.fromEntity(ChannelStats entity) {
    return ChannelStatsModel(
      channelId: entity.channelId,
      memberCount: entity.memberCount,
      guestsCount: entity.guestsCount,
      pinnedPostsCount: entity.pinnedPostsCount,
    );
  }

  ChannelStatsModel copyWith({
    String? channelId,
    int? memberCount,
    int? guestsCount,
    int? pinnedPostsCount,
  }) {
    return ChannelStatsModel(
      channelId: channelId ?? this.channelId,
      memberCount: memberCount ?? this.memberCount,
      guestsCount: guestsCount ?? this.guestsCount,
      pinnedPostsCount: pinnedPostsCount ?? this.pinnedPostsCount,
    );
  }

  ChannelStats toEntity() => ChannelStats(
        channelId: channelId,
        memberCount: memberCount,
        guestsCount: guestsCount,
        pinnedPostsCount: pinnedPostsCount,
      );
}