import 'package:equatable/equatable.dart';

class TeamStatsEntity extends Equatable {
  final String? team_id;
  final int? total_member_count;

  const TeamStatsEntity({
    this.team_id,
    this.total_member_count,
  });

  @override
  List<Object?> get props => [
        team_id,
        total_member_count,
      ];

  TeamStatsEntity copyWith({
    String? team_id,
    int? total_member_count,
  }) {
    return TeamStatsEntity(
      team_id: team_id ?? this.team_id,
      total_member_count: total_member_count ?? this.total_member_count,
    );
  }
}
