import 'package:flutter_mattermost/features/system/domain/entities/ai_bridge_test_helper_state_entity.dart';

final class AIBridgeTestHelperStateModel extends AIBridgeTestHelperStateEntity {
  const AIBridgeTestHelperStateModel({
    required super.status,
    required super.agents,
    required super.services,
    required super.agent_completions,
    required super.feature_flags,
    required super.record_requests,
    required super.recorded_requests,
  });

  factory AIBridgeTestHelperStateModel.fromMap(Map<String, dynamic> map) {
    return AIBridgeTestHelperStateModel(
      status: map["status"] as Map<String, dynamic>?,
      agents: (map["agents"] as List<dynamic>? ?? []).map((e) => Map<String, dynamic>.from(e as Map<String, dynamic>)).toList(),
      services: (map["services"] as List<dynamic>? ?? []).map((e) => Map<String, dynamic>.from(e as Map<String, dynamic>)).toList(),
      agent_completions: map["agent_completions"] as Map<String, dynamic>?,
      feature_flags: map["feature_flags"] as Map<String, dynamic>?,
      record_requests: map["record_requests"] as bool?,
      recorded_requests: (map["recorded_requests"] as List<dynamic>? ?? []).map((e) => Map<String, dynamic>.from(e as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "status": status,
      "agents": agents,
      "services": services,
      "agent_completions": agent_completions,
      "feature_flags": feature_flags,
      "record_requests": record_requests,
      "recorded_requests": recorded_requests,
    };
  }

  factory AIBridgeTestHelperStateModel.fromEntity(AIBridgeTestHelperStateEntity entity) {
    return AIBridgeTestHelperStateModel(
      status: entity.status,
      agents: entity.agents,
      services: entity.services,
      agent_completions: entity.agent_completions,
      feature_flags: entity.feature_flags,
      record_requests: entity.record_requests,
      recorded_requests: entity.recorded_requests,
    );
  }

  @override
  AIBridgeTestHelperStateModel copyWith({
    Map<String, dynamic>? status,
    List<Map<String, dynamic>>? agents,
    List<Map<String, dynamic>>? services,
    Map<String, dynamic>? agent_completions,
    Map<String, dynamic>? feature_flags,
    bool? record_requests,
    List<Map<String, dynamic>>? recorded_requests,
  }) {
    return AIBridgeTestHelperStateModel(
      status: status ?? this.status,
      agents: agents ?? this.agents,
      services: services ?? this.services,
      agent_completions: agent_completions ?? this.agent_completions,
      feature_flags: feature_flags ?? this.feature_flags,
      record_requests: record_requests ?? this.record_requests,
      recorded_requests: recorded_requests ?? this.recorded_requests,
    );
  }

  AIBridgeTestHelperStateEntity toEntity() => AIBridgeTestHelperStateEntity(
        status: status,
        agents: agents,
        services: services,
        agent_completions: agent_completions,
        feature_flags: feature_flags,
        record_requests: record_requests,
        recorded_requests: recorded_requests,
      );
}
