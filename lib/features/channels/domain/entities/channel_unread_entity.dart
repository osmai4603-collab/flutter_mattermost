import 'package:equatable/equatable.dart';

class ChannelUnreadEntity extends Equatable {
  final String? team_id;
  final String? channel_id;
  final int? msg_count;
  final int? mention_count;

  const ChannelUnreadEntity({
    this.team_id,
    this.channel_id,
    this.msg_count,
    this.mention_count,
  });

  @override
  List<Object?> get props => [
        team_id,
        channel_id,
        msg_count,
        mention_count,
      ];

  ChannelUnreadEntity copyWith({
    String? team_id,
    String? channel_id,
    int? msg_count,
    int? mention_count,
  }) {
    return ChannelUnreadEntity(
      team_id: team_id ?? this.team_id,
      channel_id: channel_id ?? this.channel_id,
      msg_count: msg_count ?? this.msg_count,
      mention_count: mention_count ?? this.mention_count,
    );
  }
}
