import 'package:flutter_mattermost/features/admin/domain/entities/policy_simulation_user_result_entity.dart';

final class PolicySimulationUserResultModel extends PolicySimulationUserResultEntity {
  const PolicySimulationUserResultModel({
    required super.user,
    required super.decisions,
    required super.sessions,
    required super.attributes,
  });

  factory PolicySimulationUserResultModel.fromMap(Map<String, dynamic> map) {
    return PolicySimulationUserResultModel(
      user: map["user"] as Map<String, dynamic>?,
      decisions: map["decisions"] as Map<String, dynamic>?,
      sessions: (map["sessions"] as List<dynamic>? ?? []).map((e) => Map<String, dynamic>.from(e as Map<String, dynamic>)).toList(),
      attributes: map["attributes"] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "user": user,
      "decisions": decisions,
      "sessions": sessions,
      "attributes": attributes,
    };
  }

  factory PolicySimulationUserResultModel.fromEntity(PolicySimulationUserResultEntity entity) {
    return PolicySimulationUserResultModel(
      user: entity.user,
      decisions: entity.decisions,
      sessions: entity.sessions,
      attributes: entity.attributes,
    );
  }

  PolicySimulationUserResultModel copyWith({
    Map<String, dynamic>? user,
    Map<String, dynamic>? decisions,
    List<Map<String, dynamic>>? sessions,
    Map<String, dynamic>? attributes,
  }) {
    return PolicySimulationUserResultModel(
      user: user ?? this.user,
      decisions: decisions ?? this.decisions,
      sessions: sessions ?? this.sessions,
      attributes: attributes ?? this.attributes,
    );
  }

  PolicySimulationUserResultEntity toEntity() => PolicySimulationUserResultEntity(
        user: user,
        decisions: decisions,
        sessions: sessions,
        attributes: attributes,
      );
}
