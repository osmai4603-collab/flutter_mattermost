import 'package:equatable/equatable.dart';

class ChannelMemberCountByGroupEntity extends Equatable {
  final String? group_id;
  final double? channel_member_count;
  final double? channel_member_timezones_count;

  const ChannelMemberCountByGroupEntity({
    this.group_id,
    this.channel_member_count,
    this.channel_member_timezones_count,
  });

  @override
  List<Object?> get props => [
        group_id,
        channel_member_count,
        channel_member_timezones_count,
      ];

  ChannelMemberCountByGroupEntity copyWith({
    String? group_id,
    double? channel_member_count,
    double? channel_member_timezones_count,
  }) {
    return ChannelMemberCountByGroupEntity(
      group_id: group_id ?? this.group_id,
      channel_member_count: channel_member_count ?? this.channel_member_count,
      channel_member_timezones_count: channel_member_timezones_count ?? this.channel_member_timezones_count,
    );
  }
}
