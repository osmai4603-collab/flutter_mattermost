import 'package:flutter_mattermost/features/admin/domain/entities/policy_simulation_by_users_params_entity.dart';

final class PolicySimulationByUsersParamsModel extends PolicySimulationByUsersParamsEntity {
  const PolicySimulationByUsersParamsModel({
    required super.policy,
    required super.actions,
    required super.rule_name,
    required super.channel_id,
    required super.team_id,
    required super.users,
    required super.evaluation_scope,
  });

  factory PolicySimulationByUsersParamsModel.fromMap(Map<String, dynamic> map) {
    return PolicySimulationByUsersParamsModel(
      policy: map["policy"] as Map<String, dynamic>?,
      actions: List<String>.from(map["actions"] as List<dynamic>? ?? []),
      rule_name: map["rule_name"] as String?,
      channel_id: map["channel_id"] as String?,
      team_id: map["team_id"] as String?,
      users: (map["users"] as List<dynamic>? ?? []).map((e) => Map<String, dynamic>.from(e as Map<String, dynamic>)).toList(),
      evaluation_scope: map["evaluation_scope"] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "policy": policy,
      "actions": actions,
      "rule_name": rule_name,
      "channel_id": channel_id,
      "team_id": team_id,
      "users": users,
      "evaluation_scope": evaluation_scope,
    };
  }

  factory PolicySimulationByUsersParamsModel.fromEntity(PolicySimulationByUsersParamsEntity entity) {
    return PolicySimulationByUsersParamsModel(
      policy: entity.policy,
      actions: entity.actions,
      rule_name: entity.rule_name,
      channel_id: entity.channel_id,
      team_id: entity.team_id,
      users: entity.users,
      evaluation_scope: entity.evaluation_scope,
    );
  }

  PolicySimulationByUsersParamsModel copyWith({
    Map<String, dynamic>? policy,
    List<String>? actions,
    String? rule_name,
    String? channel_id,
    String? team_id,
    List<Map<String, dynamic>>? users,
    String? evaluation_scope,
  }) {
    return PolicySimulationByUsersParamsModel(
      policy: policy ?? this.policy,
      actions: actions ?? this.actions,
      rule_name: rule_name ?? this.rule_name,
      channel_id: channel_id ?? this.channel_id,
      team_id: team_id ?? this.team_id,
      users: users ?? this.users,
      evaluation_scope: evaluation_scope ?? this.evaluation_scope,
    );
  }

  PolicySimulationByUsersParamsEntity toEntity() => PolicySimulationByUsersParamsEntity(
        policy: policy,
        actions: actions,
        rule_name: rule_name,
        channel_id: channel_id,
        team_id: team_id,
        users: users,
        evaluation_scope: evaluation_scope,
      );
}
