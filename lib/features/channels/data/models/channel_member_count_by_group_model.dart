import 'package:flutter_mattermost/features/channels/domain/entities/channel_member_count_by_group_entity.dart';

final class ChannelMemberCountByGroupModel extends ChannelMemberCountByGroupEntity {
  const ChannelMemberCountByGroupModel({
    required super.group_id,
    required super.channel_member_count,
    required super.channel_member_timezones_count,
  });

  factory ChannelMemberCountByGroupModel.fromMap(Map<String, dynamic> map) {
    return ChannelMemberCountByGroupModel(
      group_id: map["group_id"] as String?,
      channel_member_count: (map["channel_member_count"] as num?)?.toDouble(),
      channel_member_timezones_count: (map["channel_member_timezones_count"] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "group_id": group_id,
      "channel_member_count": channel_member_count,
      "channel_member_timezones_count": channel_member_timezones_count,
    };
  }

  factory ChannelMemberCountByGroupModel.fromEntity(ChannelMemberCountByGroupEntity entity) {
    return ChannelMemberCountByGroupModel(
      group_id: entity.group_id,
      channel_member_count: entity.channel_member_count,
      channel_member_timezones_count: entity.channel_member_timezones_count,
    );
  }

  @override
  ChannelMemberCountByGroupModel copyWith({
    String? group_id,
    double? channel_member_count,
    double? channel_member_timezones_count,
  }) {
    return ChannelMemberCountByGroupModel(
      group_id: group_id ?? this.group_id,
      channel_member_count: channel_member_count ?? this.channel_member_count,
      channel_member_timezones_count: channel_member_timezones_count ?? this.channel_member_timezones_count,
    );
  }

  ChannelMemberCountByGroupEntity toEntity() => ChannelMemberCountByGroupEntity(
        group_id: group_id,
        channel_member_count: channel_member_count,
        channel_member_timezones_count: channel_member_timezones_count,
      );
}
