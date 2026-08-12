import 'package:equatable/equatable.dart';

class TeamUnreadEntity extends Equatable {
  final String? team_id;
  final int? msg_count;
  final int? mention_count;
  final int? urgent_mention_count;

  const TeamUnreadEntity({
    this.team_id,
    this.msg_count,
    this.mention_count,
    this.urgent_mention_count,
  });

  @override
  List<Object?> get props => [
        team_id,
        msg_count,
        mention_count,
        urgent_mention_count,
      ];

  TeamUnreadEntity copyWith({
    String? team_id,
    int? msg_count,
    int? mention_count,
    int? urgent_mention_count,
  }) {
    return TeamUnreadEntity(
      team_id: team_id ?? this.team_id,
      msg_count: msg_count ?? this.msg_count,
      mention_count: mention_count ?? this.mention_count,
      urgent_mention_count: urgent_mention_count ?? this.urgent_mention_count,
    );
  }
}
