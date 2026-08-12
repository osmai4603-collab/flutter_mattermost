import 'package:flutter_mattermost/features/teams/domain/entities/team_map_entity.dart';

final class TeamMapModel extends TeamMapEntity {
  const TeamMapModel({
    required super.team_id,
  });

  factory TeamMapModel.fromMap(Map<String, dynamic> map) {
    return TeamMapModel(
      team_id: map["team_id"] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "team_id": team_id,
    };
  }

  factory TeamMapModel.fromEntity(TeamMapEntity entity) {
    return TeamMapModel(
      team_id: entity.team_id,
    );
  }

  @override
  TeamMapModel copyWith({
    Map<String, dynamic>? team_id,
  }) {
    return TeamMapModel(
      team_id: team_id ?? this.team_id,
    );
  }

  TeamMapEntity toEntity() => TeamMapEntity(
        team_id: team_id,
      );
}
