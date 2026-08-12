import 'package:flutter_mattermost/features/admin/domain/entities/access_control_policies_with_count_entity.dart';

final class AccessControlPoliciesWithCountModel extends AccessControlPoliciesWithCountEntity {
  const AccessControlPoliciesWithCountModel({
    required super.policies,
    required super.total_count,
  });

  factory AccessControlPoliciesWithCountModel.fromMap(Map<String, dynamic> map) {
    return AccessControlPoliciesWithCountModel(
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

  factory AccessControlPoliciesWithCountModel.fromEntity(AccessControlPoliciesWithCountEntity entity) {
    return AccessControlPoliciesWithCountModel(
      policies: entity.policies,
      total_count: entity.total_count,
    );
  }

  AccessControlPoliciesWithCountModel copyWith({
    List<Map<String, dynamic>>? policies,
    int? total_count,
  }) {
    return AccessControlPoliciesWithCountModel(
      policies: policies ?? this.policies,
      total_count: total_count ?? this.total_count,
    );
  }

  AccessControlPoliciesWithCountEntity toEntity() => AccessControlPoliciesWithCountEntity(
        policies: policies,
        total_count: total_count,
      );
}
