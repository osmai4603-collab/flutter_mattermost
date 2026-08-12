import 'package:flutter_mattermost/features/admin/domain/entities/agent_entity.dart';

final class AgentModel extends AgentEntity {
  const AgentModel({
    required super.agent_id,
    required super.display_name,
    required super.name,
    required super.type,
    required super.description,
    required super.icon,
    required super.model,
    required super.provider_name,
    required super.isDefault,
  });

  factory AgentModel.fromMap(Map<String, dynamic> map) {
    return AgentModel(
      agent_id: map["agent_id"] as String?,
      display_name: map["display_name"] as String?,
      name: map["name"] as String?,
      type: map["type"] as String?,
      description: map["description"] as String?,
      icon: map["icon"] as String?,
      model: map["model"] as String?,
      provider_name: map["provider_name"] as String?,
      isDefault: map["default"] as bool?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "agent_id": agent_id,
      "display_name": display_name,
      "name": name,
      "type": type,
      "description": description,
      "icon": icon,
      "model": model,
      "provider_name": provider_name,
      "default": isDefault,
    };
  }

  factory AgentModel.fromEntity(AgentEntity entity) {
    return AgentModel(
      agent_id: entity.agent_id,
      display_name: entity.display_name,
      name: entity.name,
      type: entity.type,
      description: entity.description,
      icon: entity.icon,
      model: entity.model,
      provider_name: entity.provider_name,
      isDefault: entity.isDefault,
    );
  }

  AgentModel copyWith({
    String? agent_id,
    String? display_name,
    String? name,
    String? type,
    String? description,
    String? icon,
    String? model,
    String? provider_name,
    bool? isDefault,
  }) {
    return AgentModel(
      agent_id: agent_id ?? this.agent_id,
      display_name: display_name ?? this.display_name,
      name: name ?? this.name,
      type: type ?? this.type,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      model: model ?? this.model,
      provider_name: provider_name ?? this.provider_name,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  AgentEntity toEntity() => AgentEntity(
        agent_id: agent_id,
        display_name: display_name,
        name: name,
        type: type,
        description: description,
        icon: icon,
        model: model,
        provider_name: provider_name,
        isDefault: isDefault,
      );
}
