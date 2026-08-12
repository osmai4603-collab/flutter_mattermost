import 'package:flutter_mattermost/features/admin/domain/entities/access_control_policy_active_update_entity.dart';

final class AccessControlPolicyActiveUpdateModel extends AccessControlPolicyActiveUpdateEntity {
  const AccessControlPolicyActiveUpdateModel({
    required super.id,
    required super.active,
  });

  factory AccessControlPolicyActiveUpdateModel.fromMap(Map<String, dynamic> map) {
    return AccessControlPolicyActiveUpdateModel(
      id: map["id"] as String?,
      active: map["active"] as bool?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "active": active,
    };
  }

  factory AccessControlPolicyActiveUpdateModel.fromEntity(AccessControlPolicyActiveUpdateEntity entity) {
    return AccessControlPolicyActiveUpdateModel(
      id: entity.id,
      active: entity.active,
    );
  }

  AccessControlPolicyActiveUpdateModel copyWith({
    String? id,
    bool? active,
  }) {
    return AccessControlPolicyActiveUpdateModel(
      id: id ?? this.id,
      active: active ?? this.active,
    );
  }

  AccessControlPolicyActiveUpdateEntity toEntity() => AccessControlPolicyActiveUpdateEntity(
        id: id,
        active: active,
      );
}
