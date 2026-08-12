import 'package:flutter_mattermost/features/admin/domain/entities/data_retention_policy_for_team_entity.dart';

final class DataRetentionPolicyForTeamModel extends DataRetentionPolicyForTeamEntity {
  const DataRetentionPolicyForTeamModel({
    required super.team_id,
    required super.post_duration,
  });

  factory DataRetentionPolicyForTeamModel.fromMap(Map<String, dynamic> map) {
    return DataRetentionPolicyForTeamModel(
      team_id: map["team_id"] as String?,
      post_duration: (map["post_duration"] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "team_id": team_id,
      "post_duration": post_duration,
    };
  }

  factory DataRetentionPolicyForTeamModel.fromEntity(DataRetentionPolicyForTeamEntity entity) {
    return DataRetentionPolicyForTeamModel(
      team_id: entity.team_id,
      post_duration: entity.post_duration,
    );
  }

  DataRetentionPolicyForTeamModel copyWith({
    String? team_id,
    int? post_duration,
  }) {
    return DataRetentionPolicyForTeamModel(
      team_id: team_id ?? this.team_id,
      post_duration: post_duration ?? this.post_duration,
    );
  }

  DataRetentionPolicyForTeamEntity toEntity() => DataRetentionPolicyForTeamEntity(
        team_id: team_id,
        post_duration: post_duration,
      );
}
