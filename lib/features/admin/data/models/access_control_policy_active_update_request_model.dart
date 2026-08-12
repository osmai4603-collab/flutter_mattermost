import 'package:flutter_mattermost/features/admin/domain/entities/access_control_policy_active_update_request_entity.dart';

final class AccessControlPolicyActiveUpdateRequestModel extends AccessControlPolicyActiveUpdateRequestEntity {
  const AccessControlPolicyActiveUpdateRequestModel({
    required super.entries,
  });

  factory AccessControlPolicyActiveUpdateRequestModel.fromMap(Map<String, dynamic> map) {
    return AccessControlPolicyActiveUpdateRequestModel(
      entries: (map["entries"] as List<dynamic>? ?? []).map((e) => Map<String, dynamic>.from(e as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "entries": entries,
    };
  }

  factory AccessControlPolicyActiveUpdateRequestModel.fromEntity(AccessControlPolicyActiveUpdateRequestEntity entity) {
    return AccessControlPolicyActiveUpdateRequestModel(
      entries: entity.entries,
    );
  }

  AccessControlPolicyActiveUpdateRequestModel copyWith({
    List<Map<String, dynamic>>? entries,
  }) {
    return AccessControlPolicyActiveUpdateRequestModel(
      entries: entries ?? this.entries,
    );
  }

  AccessControlPolicyActiveUpdateRequestEntity toEntity() => AccessControlPolicyActiveUpdateRequestEntity(
        entries: entries,
      );
}
