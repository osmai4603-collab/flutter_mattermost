import 'package:flutter_mattermost/features/admin/domain/entities/policy_simulation_action_decision_entity.dart';

final class PolicySimulationActionDecisionModel extends PolicySimulationActionDecisionEntity {
  const PolicySimulationActionDecisionModel({
    required super.decision,
    required super.blame,
  });

  factory PolicySimulationActionDecisionModel.fromMap(Map<String, dynamic> map) {
    return PolicySimulationActionDecisionModel(
      decision: map["decision"] as bool?,
      blame: (map["blame"] as List<dynamic>? ?? []).map((e) => Map<String, dynamic>.from(e as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "decision": decision,
      "blame": blame,
    };
  }

  factory PolicySimulationActionDecisionModel.fromEntity(PolicySimulationActionDecisionEntity entity) {
    return PolicySimulationActionDecisionModel(
      decision: entity.decision,
      blame: entity.blame,
    );
  }

  PolicySimulationActionDecisionModel copyWith({
    bool? decision,
    List<Map<String, dynamic>>? blame,
  }) {
    return PolicySimulationActionDecisionModel(
      decision: decision ?? this.decision,
      blame: blame ?? this.blame,
    );
  }

  PolicySimulationActionDecisionEntity toEntity() => PolicySimulationActionDecisionEntity(
        decision: decision,
        blame: blame,
      );
}
