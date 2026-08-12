import 'package:flutter_mattermost/features/system/domain/entities/ai_bridge_test_helper_config_entity.dart';

final class AIBridgeTestHelperConfigModel
    extends AIBridgeTestHelperConfigEntity {
  const AIBridgeTestHelperConfigModel({
    required super.status,
    required super.agents,
    required super.services,
    required super.agent_completions,
    required super.feature_flags,
    required super.record_requests,
  });

  factory AIBridgeTestHelperConfigModel.fromMap(Map<String, dynamic> map) {
    return AIBridgeTestHelperConfigModel(
      status: map["status"] as Map<String, dynamic>?,
      agents: List<Map<String, dynamic>>.from(map["agents"] as List<dynamic>? ?? []),
      services: List<Map<String, dynamic>>.from(map["services"] as List<dynamic>? ?? []),
      agent_completions: map["agent_completions"] as Map<String, dynamic>?,
      feature_flags: map["feature_flags"] as Map<String, dynamic>?,
      record_requests: map["record_requests"] as bool?,
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
    };
  }

  factory AIBridgeTestHelperConfigModel.fromEntity(
    AIBridgeTestHelperConfigEntity entity,
  ) {
    return AIBridgeTestHelperConfigModel(
      status: entity.status,
      agents: entity.agents,
      services: entity.services,
      agent_completions: entity.agent_completions,
      feature_flags: entity.feature_flags,
      record_requests: entity.record_requests,
    );
  }

  @override
  AIBridgeTestHelperConfigModel copyWith({
    Map<String, dynamic>? status,
    List<Map<String, dynamic>>? agents,
    List<Map<String, dynamic>>? services,
    Map<String, dynamic>? agent_completions,
    Map<String, dynamic>? feature_flags,
    bool? record_requests,
  }) {
    return AIBridgeTestHelperConfigModel(
      status: status ?? this.status,
      agents: agents ?? this.agents,
      services: services ?? this.services,
      agent_completions: agent_completions ?? this.agent_completions,
      feature_flags: feature_flags ?? this.feature_flags,
      record_requests: record_requests ?? this.record_requests,
    );
  }

  AIBridgeTestHelperConfigEntity toEntity() => AIBridgeTestHelperConfigEntity(
    status: status,
    agents: agents,
    services: services,
    agent_completions: agent_completions,
    feature_flags: feature_flags,
    record_requests: record_requests,
  );
}
