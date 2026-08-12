import 'package:flutter_mattermost/features/integrations/domain/entities/plugin_status_entity.dart';

final class PluginStatusModel extends PluginStatusEntity {
  const PluginStatusModel({
    required super.plugin_id,
    required super.name,
    required super.description,
    required super.version,
    required super.cluster_id,
    required super.plugin_path,
    required super.state,
  });

  factory PluginStatusModel.fromMap(Map<String, dynamic> map) {
    return PluginStatusModel(
      plugin_id: map["plugin_id"] as String?,
      name: map["name"] as String?,
      description: map["description"] as String?,
      version: map["version"] as String?,
      cluster_id: map["cluster_id"] as String?,
      plugin_path: map["plugin_path"] as String?,
      state: (map["state"] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "plugin_id": plugin_id,
      "name": name,
      "description": description,
      "version": version,
      "cluster_id": cluster_id,
      "plugin_path": plugin_path,
      "state": state,
    };
  }

  factory PluginStatusModel.fromEntity(PluginStatusEntity entity) {
    return PluginStatusModel(
      plugin_id: entity.plugin_id,
      name: entity.name,
      description: entity.description,
      version: entity.version,
      cluster_id: entity.cluster_id,
      plugin_path: entity.plugin_path,
      state: entity.state,
    );
  }

  @override
  PluginStatusModel copyWith({
    String? plugin_id,
    String? name,
    String? description,
    String? version,
    String? cluster_id,
    String? plugin_path,
    double? state,
  }) {
    return PluginStatusModel(
      plugin_id: plugin_id ?? this.plugin_id,
      name: name ?? this.name,
      description: description ?? this.description,
      version: version ?? this.version,
      cluster_id: cluster_id ?? this.cluster_id,
      plugin_path: plugin_path ?? this.plugin_path,
      state: state ?? this.state,
    );
  }

  PluginStatusEntity toEntity() => PluginStatusEntity(
        plugin_id: plugin_id,
        name: name,
        description: description,
        version: version,
        cluster_id: cluster_id,
        plugin_path: plugin_path,
        state: state,
      );
}
