import 'package:equatable/equatable.dart';

class PolicySimulationBlameEntity extends Equatable {
  final String? source;
  final String? outcome;
  final String? policy_id;
  final String? policy_name;
  final String? rule_name;
  final String? role;
  final String? expression;
  final Map<String, dynamic>? evaluation_tree;

  const PolicySimulationBlameEntity({
    this.source,
    this.outcome,
    this.policy_id,
    this.policy_name,
    this.rule_name,
    this.role,
    this.expression,
    this.evaluation_tree,
  });

  @override
  List<Object?> get props => [
        source,
        outcome,
        policy_id,
        policy_name,
        rule_name,
        role,
        expression,
        evaluation_tree,
      ];

  PolicySimulationBlameEntity copyWith({
    String? source,
    String? outcome,
    String? policy_id,
    String? policy_name,
    String? rule_name,
    String? role,
    String? expression,
    Map<String, dynamic>? evaluation_tree,
  }) {
    return PolicySimulationBlameEntity(
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
}
