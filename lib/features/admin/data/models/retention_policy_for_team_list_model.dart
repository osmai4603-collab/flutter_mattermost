import 'package:flutter_mattermost/features/admin/domain/entities/retention_policy_for_team_list_entity.dart';

final class RetentionPolicyForTeamListModel extends RetentionPolicyForTeamListEntity {
  const RetentionPolicyForTeamListModel({
    required super.policies,
    required super.total_count,
  });

  factory RetentionPolicyForTeamListModel.fromMap(Map<String, dynamic> map) {
    return RetentionPolicyForTeamListModel(
      policies: (map["policies"] as List<dynamic>? ?? []).map((e) => Map<String, dynamic>.from(e as Map<String, dynamic>)).toList(),
      total_count: (map["total_count"] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "policies": policies,
      "total_count": total_count,
    };
  }

  factory RetentionPolicyForTeamListModel.fromEntity(RetentionPolicyForTeamListEntity entity) {
    return RetentionPolicyForTeamListModel(
      policies: entity.policies,
      total_count: entity.total_count,
    );
  }

  RetentionPolicyForTeamListModel copyWith({
    List<Map<String, dynamic>>? policies,
    int? total_count,
  }) {
    return RetentionPolicyForTeamListModel(
      policies: policies ?? this.policies,
      total_count: total_count ?? this.total_count,
    );
  }

  RetentionPolicyForTeamListEntity toEntity() => RetentionPolicyForTeamListEntity(
        policies: policies,
        total_count: total_count,
      );
}
