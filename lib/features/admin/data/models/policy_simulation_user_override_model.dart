import 'package:flutter_mattermost/features/admin/domain/entities/policy_simulation_user_override_entity.dart';

final class PolicySimulationUserOverrideModel extends PolicySimulationUserOverrideEntity {
  const PolicySimulationUserOverrideModel({
    required super.user_id,
    required super.use_active_session,
    required super.session_overrides,
  });

  factory PolicySimulationUserOverrideModel.fromMap(Map<String, dynamic> map) {
    return PolicySimulationUserOverrideModel(
      user_id: map["user_id"] as String?,
      use_active_session: map["use_active_session"] as bool?,
      session_overrides: map["session_overrides"] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "user_id": user_id,
      "use_active_session": use_active_session,
      "session_overrides": session_overrides,
    };
  }

  factory PolicySimulationUserOverrideModel.fromEntity(PolicySimulationUserOverrideEntity entity) {
    return PolicySimulationUserOverrideModel(
      user_id: entity.user_id,
      use_active_session: entity.use_active_session,
      session_overrides: entity.session_overrides,
    );
  }

  PolicySimulationUserOverrideModel copyWith({
    String? user_id,
    bool? use_active_session,
    Map<String, dynamic>? session_overrides,
  }) {
    return PolicySimulationUserOverrideModel(
      user_id: user_id ?? this.user_id,
      use_active_session: use_active_session ?? this.use_active_session,
      session_overrides: session_overrides ?? this.session_overrides,
    );
  }

  PolicySimulationUserOverrideEntity toEntity() => PolicySimulationUserOverrideEntity(
        user_id: user_id,
        use_active_session: use_active_session,
        session_overrides: session_overrides,
      );
}
