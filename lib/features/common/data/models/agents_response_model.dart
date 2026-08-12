import 'package:flutter_mattermost/features/common/domain/entities/agents_response_entity.dart';

final class AgentsResponseModel extends AgentsResponseEntity {
  const AgentsResponseModel({
    required super.agents,
  });

  factory AgentsResponseModel.fromMap(Map<String, dynamic> map) {
    return AgentsResponseModel(
      agents: (map["agents"] as List<dynamic>? ?? []).map((e) => Map<String, dynamic>.from(e as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "agents": agents,
    };
  }

  factory AgentsResponseModel.fromEntity(AgentsResponseEntity entity) {
    return AgentsResponseModel(
      agents: entity.agents,
    );
  }

  @override
  AgentsResponseModel copyWith({
    List<Map<String, dynamic>>? agents,
  }) {
    return AgentsResponseModel(
      agents: agents ?? this.agents,
    );
  }

  AgentsResponseEntity toEntity() => AgentsResponseEntity(
        agents: agents,
      );
}
