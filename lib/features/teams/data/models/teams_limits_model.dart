import 'package:flutter_mattermost/features/teams/domain/entities/teams_limits_entity.dart';

final class TeamsLimitsModel extends TeamsLimitsEntity {
  const TeamsLimitsModel({
    required super.active,
  });

  factory TeamsLimitsModel.fromMap(Map<String, dynamic> map) {
    return TeamsLimitsModel(
      active: (map["active"] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "active": active,
    };
  }

  factory TeamsLimitsModel.fromEntity(TeamsLimitsEntity entity) {
    return TeamsLimitsModel(
      active: entity.active,
    );
  }

  @override
  TeamsLimitsModel copyWith({
    int? active,
  }) {
    return TeamsLimitsModel(
      active: active ?? this.active,
    );
  }

  TeamsLimitsEntity toEntity() => TeamsLimitsEntity(
        active: active,
      );
}
