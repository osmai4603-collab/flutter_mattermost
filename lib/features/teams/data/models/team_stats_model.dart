import 'package:flutter_mattermost/features/teams/domain/entities/team_stats_entity.dart';

final class TeamStatsModel extends TeamStatsEntity {
  const TeamStatsModel({
    required super.team_id,
    required super.total_member_count,
  });

  factory TeamStatsModel.fromMap(Map<String, dynamic> map) {
    return TeamStatsModel(
      team_id: map["team_id"] as String?,
      total_member_count: (map["total_member_count"] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "team_id": team_id,
      "total_member_count": total_member_count,
    };
  }

  factory TeamStatsModel.fromEntity(TeamStatsEntity entity) {
    return TeamStatsModel(
      team_id: entity.team_id,
      total_member_count: entity.total_member_count,
    );
  }

  @override
  TeamStatsModel copyWith({
    String? team_id,
    int? total_member_count,
  }) {
    return TeamStatsModel(
      team_id: team_id ?? this.team_id,
      total_member_count: total_member_count ?? this.total_member_count,
    );
  }

  TeamStatsEntity toEntity() => TeamStatsEntity(
        team_id: team_id,
        total_member_count: total_member_count,
      );
}
