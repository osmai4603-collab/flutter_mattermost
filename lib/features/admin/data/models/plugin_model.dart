import 'package:flutter_mattermost/features/admin/domain/entities/plugin_entity.dart';

final class PluginModel extends PluginEntity {
  const PluginModel({
    required super.id,
    required super.name,
    super.description,
    super.version,
    super.active,
  });

  factory PluginModel.fromMap(Map<String, dynamic> data, {bool active = false}) {
    return PluginModel(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      version: data['version'] ?? '',
      active: data['active'] ?? active,
    );
  }

  factory PluginModel.fromEntity(PluginEntity entity) {
    return PluginModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      version: entity.version,
      active: entity.active,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'version': version,
      'active': active,
    };
  }

  PluginModel copyWith({
    String? id,
    String? name,
    String? description,
    String? version,
    bool? active,
  }) {
    return PluginModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      version: version ?? this.version,
      active: active ?? this.active,
    );
  }

  PluginEntity toEntity() {
    return PluginEntity(
      id: id,
      name: name,
      description: description,
      version: version,
      active: active,
    );
  }
}
