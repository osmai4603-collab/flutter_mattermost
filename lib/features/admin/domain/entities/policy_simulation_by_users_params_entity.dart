import 'package:equatable/equatable.dart';

class PolicySimulationByUsersParamsEntity extends Equatable {
  final Map<String, dynamic>? policy;
  final List<String>? actions;
  final String? rule_name;
  final String? channel_id;
  final String? team_id;
  final List<Map<String, dynamic>>? users;
  final String? evaluation_scope;

  const PolicySimulationByUsersParamsEntity({
    required this.policy,
    required this.actions,
    this.rule_name,
    this.channel_id,
    this.team_id,
    required this.users,
    this.evaluation_scope,
  });

  @override
  List<Object?> get props => [
        policy,
        actions,
        rule_name,
        channel_id,
        team_id,
        users,
        evaluation_scope,
      ];

  PolicySimulationByUsersParamsEntity copyWith({
    Map<String, dynamic>? policy,
    List<String>? actions,
    String? rule_name,
    String? channel_id,
    String? team_id,
    List<Map<String, dynamic>>? users,
    String? evaluation_scope,
  }) {
    return PolicySimulationByUsersParamsEntity(
      policy: policy ?? this.policy,
      actions: actions ?? this.actions,
      rule_name: rule_name ?? this.rule_name,
      channel_id: channel_id ?? this.channel_id,
      team_id: team_id ?? this.team_id,
      users: users ?? this.users,
      evaluation_scope: evaluation_scope ?? this.evaluation_scope,
    );
  }
}
