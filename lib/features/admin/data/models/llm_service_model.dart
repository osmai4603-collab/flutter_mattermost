import 'package:flutter_mattermost/features/admin/domain/entities/llm_service_entity.dart';

final class LlmServiceModel extends LlmServiceEntity {
  const LlmServiceModel({
    required super.display_name,
    required super.name,
    required super.isDefault,
    required super.description,
  });

  factory LlmServiceModel.fromMap(Map<String, dynamic> map) {
    return LlmServiceModel(
      display_name: map["display_name"] as String?,
      name: map["name"] as String?,
      isDefault: map["default"] as bool?,
      description: map["description"] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "display_name": display_name,
      "name": name,
      "default": isDefault,
      "description": description,
    };
  }

  factory LlmServiceModel.fromEntity(LlmServiceEntity entity) {
    return LlmServiceModel(
      display_name: entity.display_name,
      name: entity.name,
      isDefault: entity.isDefault,
      description: entity.description,
    );
  }

  LlmServiceModel copyWith({
    String? display_name,
    String? name,
    bool? isDefault,
    String? description,
  }) {
    return LlmServiceModel(
      display_name: display_name ?? this.display_name,
      name: name ?? this.name,
      isDefault: isDefault ?? this.isDefault,
      description: description ?? this.description,
    );
  }

  LlmServiceEntity toEntity() => LlmServiceEntity(
        display_name: display_name,
        name: name,
        isDefault: isDefault,
        description: description,
      );
}
