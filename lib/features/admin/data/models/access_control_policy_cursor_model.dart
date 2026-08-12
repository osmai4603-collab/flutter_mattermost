import 'package:flutter_mattermost/features/admin/domain/entities/access_control_policy_cursor_entity.dart';

final class AccessControlPolicyCursorModel extends AccessControlPolicyCursorEntity {
  const AccessControlPolicyCursorModel({
    required super.id,
  });

  factory AccessControlPolicyCursorModel.fromMap(Map<String, dynamic> map) {
    return AccessControlPolicyCursorModel(
      id: map["id"] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
    };
  }

  factory AccessControlPolicyCursorModel.fromEntity(AccessControlPolicyCursorEntity entity) {
    return AccessControlPolicyCursorModel(
      id: entity.id,
    );
  }

  AccessControlPolicyCursorModel copyWith({
    String? id,
  }) {
    return AccessControlPolicyCursorModel(
      id: id ?? this.id,
    );
  }

  AccessControlPolicyCursorEntity toEntity() => AccessControlPolicyCursorEntity(
        id: id,
      );
}
