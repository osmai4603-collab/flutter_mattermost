import 'package:equatable/equatable.dart';

class AIBridgeTestHelperConfigEntity extends Equatable {
  final Map<String, dynamic>? status;
  final List<Map<String, dynamic>>? agents;
  final List<Map<String, dynamic>>? services;
  final Map<String, dynamic>? agent_completions;
  final Map<String, dynamic>? feature_flags;
  final bool? record_requests;

  const AIBridgeTestHelperConfigEntity({
    this.status,
    this.agents,
    this.services,
    this.agent_completions,
    this.feature_flags,
    this.record_requests,
  });

  @override
  List<Object?> get props => [
        status,
        agents,
        services,
        agent_completions,
        feature_flags,
        record_requests,
      ];

  AIBridgeTestHelperConfigEntity copyWith({
    Map<String, dynamic>? status,
    List<Map<String, dynamic>>? agents,
    List<Map<String, dynamic>>? services,
    Map<String, dynamic>? agent_completions,
    Map<String, dynamic>? feature_flags,
    bool? record_requests,
  }) {
    return AIBridgeTestHelperConfigEntity(
      status: status ?? this.status,
      agents: agents ?? this.agents,
      services: services ?? this.services,
      agent_completions: agent_completions ?? this.agent_completions,
      feature_flags: feature_flags ?? this.feature_flags,
      record_requests: record_requests ?? this.record_requests,
    );
  }
}
