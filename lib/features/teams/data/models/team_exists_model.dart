import 'package:flutter_mattermost/features/teams/domain/entities/team_exists_entity.dart';

final class TeamExistsModel extends TeamExistsEntity {
  const TeamExistsModel({
    required super.exists,
  });

  factory TeamExistsModel.fromMap(Map<String, dynamic> map) {
    return TeamExistsModel(
      exists: map["exists"] as bool?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "exists": exists,
    };
  }

  factory TeamExistsModel.fromEntity(TeamExistsEntity entity) {
    return TeamExistsModel(
      exists: entity.exists,
    );
  }

  @override
  TeamExistsModel copyWith({
    bool? exists,
  }) {
    return TeamExistsModel(
      exists: exists ?? this.exists,
    );
  }

  TeamExistsEntity toEntity() => TeamExistsEntity(
        exists: exists,
      );
}
