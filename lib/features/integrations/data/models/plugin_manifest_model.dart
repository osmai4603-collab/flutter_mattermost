import 'package:flutter_mattermost/features/integrations/domain/entities/plugin_manifest_entity.dart';

final class PluginManifestModel extends PluginManifestEntity {
  const PluginManifestModel({
    required super.id,
    required super.name,
    required super.description,
    required super.version,
    required super.min_server_version,
    required super.backend,
    required super.server,
    required super.webapp,
    required super.settings_schema,
  });

  factory PluginManifestModel.fromMap(Map<String, dynamic> map) {
    return PluginManifestModel(
      id: map["id"] as String?,
      name: map["name"] as String?,
      description: map["description"] as String?,
      version: map["version"] as String?,
      min_server_version: map["min_server_version"] as String?,
      backend: map["backend"] as Map<String, dynamic>?,
      server: map["server"] as Map<String, dynamic>?,
      webapp: map["webapp"] as Map<String, dynamic>?,
      settings_schema: map["settings_schema"] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "version": version,
      "min_server_version": min_server_version,
      "backend": backend,
      "server": server,
      "webapp": webapp,
      "settings_schema": settings_schema,
    };
  }

  factory PluginManifestModel.fromEntity(PluginManifestEntity entity) {
    return PluginManifestModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      version: entity.version,
      min_server_version: entity.min_server_version,
      backend: entity.backend,
      server: entity.server,
      webapp: entity.webapp,
      settings_schema: entity.settings_schema,
    );
  }

  @override
  PluginManifestModel copyWith({
    String? id,
    String? name,
    String? description,
    String? version,
    String? min_server_version,
    Map<String, dynamic>? backend,
    Map<String, dynamic>? server,
    Map<String, dynamic>? webapp,
    Map<String, dynamic>? settings_schema,
  }) {
    return PluginManifestModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      version: version ?? this.version,
      min_server_version: min_server_version ?? this.min_server_version,
      backend: backend ?? this.backend,
      server: server ?? this.server,
      webapp: webapp ?? this.webapp,
      settings_schema: settings_schema ?? this.settings_schema,
    );
  }

  PluginManifestEntity toEntity() => PluginManifestEntity(
        id: id,
        name: name,
        description: description,
        version: version,
        min_server_version: min_server_version,
        backend: backend,
        server: server,
        webapp: webapp,
        settings_schema: settings_schema,
      );
}
