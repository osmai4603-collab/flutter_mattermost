import 'package:flutter_mattermost/features/admin/domain/entities/agent_status_entity.dart';

final class AgentStatusModel extends AgentStatusEntity {
  const AgentStatusModel({
    required super.agent_id,
    required super.team_id,
    required super.status,
    required super.capabilities,
    required super.last_status_update_at,
    required super.last_capability_update_at,
    required super.retry_loop_count,
  });

  factory AgentStatusModel.fromMap(Map<String, dynamic> map) {
    return AgentStatusModel(
      agent_id: map["agent_id"] as String?,
      team_id: map["team_id"] as String?,
      status: map["status"] as String?,
      capabilities: (map["capabilities"] as List<dynamic>? ?? []).cast<String>(),
      last_status_update_at: (map["last_status_update_at"] as num?)?.toInt(),
      last_capability_update_at: (map["last_capability_update_at"] as num?)?.toInt(),
      retry_loop_count: (map["retry_loop_count"] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "agent_id": agent_id,
      "team_id": team_id,
      "status": status,
      "capabilities": capabilities,
      "last_status_update_at": last_status_update_at,
      "last_capability_update_at": last_capability_update_at,
      "retry_loop_count": retry_loop_count,
    };
  }

  factory AgentStatusModel.fromEntity(AgentStatusEntity entity) {
    return AgentStatusModel(
      agent_id: entity.agent_id,
      team_id: entity.team_id,
      status: entity.status,
      capabilities: entity.capabilities,
      last_status_update_at: entity.last_status_update_at,
      last_capability_update_at: entity.last_capability_update_at,
      retry_loop_count: entity.retry_loop_count,
    );
  }

  AgentStatusModel copyWith({
    String? agent_id,
    String? team_id,
    String? status,
    List<String>? capabilities,
    int? last_status_update_at,
    int? last_capability_update_at,
    int? retry_loop_count,
  }) {
    return AgentStatusModel(
      agent_id: agent_id ?? this.agent_id,
      team_id: team_id ?? this.team_id,
      status: status ?? this.status,
      capabilities: capabilities ?? this.capabilities,
      last_status_update_at: last_status_update_at ?? this.last_status_update_at,
      last_capability_update_at: last_capability_update_at ?? this.last_capability_update_at,
      retry_loop_count: retry_loop_count ?? this.retry_loop_count,
    );
  }

  AgentStatusEntity toEntity() => AgentStatusEntity(
        agent_id: agent_id,
        team_id: team_id,
        status: status,
        capabilities: capabilities,
        last_status_update_at: last_status_update_at,
        last_capability_update_at: last_capability_update_at,
        retry_loop_count: retry_loop_count,
      );
}
