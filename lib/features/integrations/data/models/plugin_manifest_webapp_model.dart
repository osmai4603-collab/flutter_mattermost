import 'package:flutter_mattermost/features/integrations/domain/entities/plugin_manifest_webapp_entity.dart';

final class PluginManifestWebappModel extends PluginManifestWebappEntity {
  const PluginManifestWebappModel({
    required super.id,
    required super.version,
    required super.webapp,
  });

  factory PluginManifestWebappModel.fromMap(Map<String, dynamic> map) {
    return PluginManifestWebappModel(
      id: map["id"] as String?,
      version: map["version"] as String?,
      webapp: map["webapp"] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "version": version,
      "webapp": webapp,
    };
  }

  factory PluginManifestWebappModel.fromEntity(PluginManifestWebappEntity entity) {
    return PluginManifestWebappModel(
      id: entity.id,
      version: entity.version,
      webapp: entity.webapp,
    );
  }

  @override
  PluginManifestWebappModel copyWith({
    String? id,
    String? version,
    Map<String, dynamic>? webapp,
  }) {
    return PluginManifestWebappModel(
      id: id ?? this.id,
      version: version ?? this.version,
      webapp: webapp ?? this.webapp,
    );
  }

  PluginManifestWebappEntity toEntity() => PluginManifestWebappEntity(
        id: id,
        version: version,
        webapp: webapp,
      );
}
