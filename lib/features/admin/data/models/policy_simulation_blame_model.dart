import 'package:flutter_mattermost/features/admin/domain/entities/policy_simulation_blame_entity.dart';

final class PolicySimulationBlameModel extends PolicySimulationBlameEntity {
  const PolicySimulationBlameModel({
    required super.source,
    required super.outcome,
    required super.policy_id,
    required super.policy_name,
    required super.rule_name,
    required super.role,
    required super.expression,
    required super.evaluation_tree,
  });

  factory PolicySimulationBlameModel.fromMap(Map<String, dynamic> map) {
    return PolicySimulationBlameModel(
      source: map["source"] as String?,
      outcome: map["outcome"] as String?,
      policy_id: map["policy_id"] as String?,
      policy_name: map["policy_name"] as String?,
      rule_name: map["rule_name"] as String?,
      role: map["role"] as String?,
      expression: map["expression"] as String?,
      evaluation_tree: map["evaluation_tree"] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "source": source,
      "outcome": outcome,
      "policy_id": policy_id,
      "policy_name": policy_name,
      "rule_name": rule_name,
      "role": role,
      "expression": expression,
      "evaluation_tree": evaluation_tree,
    };
  }

  factory PolicySimulationBlameModel.fromEntity(PolicySimulationBlameEntity entity) {
    return PolicySimulationBlameModel(
      source: entity.source,
      outcome: entity.outcome,
      policy_id: entity.policy_id,
      policy_name: entity.policy_name,
      rule_name: entity.rule_name,
      role: entity.role,
      expression: entity.expression,
      evaluation_tree: entity.evaluation_tree,
    );
  }

  PolicySimulationBlameModel copyWith({
    String? source,
    String? outcome,
    String? policy_id,
    String? policy_name,
    String? rule_name,
    String? role,
    String? expression,
    Map<String, dynamic>? evaluation_tree,
  }) {
    return PolicySimulationBlameModel(
      source: source ?? this.source,
      outcome: outcome ?? this.outcome,
      policy_id: policy_id ?? this.policy_id,
      policy_name: policy_name ?? this.policy_name,
      rule_name: rule_name ?? this.rule_name,
      role: role ?? this.role,
      expression: expression ?? this.expression,
      evaluation_tree: evaluation_tree ?? this.evaluation_tree,
    );
  }

  PolicySimulationBlameEntity toEntity() => PolicySimulationBlameEntity(
        source: source,
        outcome: outcome,
        policy_id: policy_id,
        policy_name: policy_name,
        rule_name: rule_name,
        role: role,
        expression: expression,
        evaluation_tree: evaluation_tree,
      );
}
