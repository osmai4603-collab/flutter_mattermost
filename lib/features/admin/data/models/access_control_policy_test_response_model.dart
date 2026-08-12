import 'package:flutter_mattermost/features/admin/domain/entities/access_control_policy_test_response_entity.dart';

final class AccessControlPolicyTestResponseModel extends AccessControlPolicyTestResponseEntity {
  const AccessControlPolicyTestResponseModel({
    required super.users,
    required super.total_count,
  });

  factory AccessControlPolicyTestResponseModel.fromMap(Map<String, dynamic> map) {
    return AccessControlPolicyTestResponseModel(
      users: (map["users"] as List<dynamic>? ?? []).map((e) => Map<String, dynamic>.from(e as Map<String, dynamic>)).toList(),
      total_count: (map["total_count"] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "users": users,
      "total_count": total_count,
    };
  }

  factory AccessControlPolicyTestResponseModel.fromEntity(AccessControlPolicyTestResponseEntity entity) {
    return AccessControlPolicyTestResponseModel(
      users: entity.users,
      total_count: entity.total_count,
    );
  }

  AccessControlPolicyTestResponseModel copyWith({
    List<Map<String, dynamic>>? users,
    int? total_count,
  }) {
    return AccessControlPolicyTestResponseModel(
      users: users ?? this.users,
      total_count: total_count ?? this.total_count,
    );
  }

  AccessControlPolicyTestResponseEntity toEntity() => AccessControlPolicyTestResponseEntity(
        users: users,
        total_count: total_count,
      );
}
