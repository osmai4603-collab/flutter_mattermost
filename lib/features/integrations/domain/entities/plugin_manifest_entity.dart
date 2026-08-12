import 'package:equatable/equatable.dart';

class PluginManifestEntity extends Equatable {
  final String? id;
  final String? name;
  final String? description;
  final String? version;
  final String? min_server_version;
  final Map<String, dynamic>? backend;
  final Map<String, dynamic>? server;
  final Map<String, dynamic>? webapp;
  final Map<String, dynamic>? settings_schema;

  const PluginManifestEntity({
    this.id,
    this.name,
    this.description,
    this.version,
    this.min_server_version,
    this.backend,
    this.server,
    this.webapp,
    this.settings_schema,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        version,
        min_server_version,
        backend,
        server,
        webapp,
        settings_schema,
      ];

  PluginManifestEntity copyWith({
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
    return PluginManifestEntity(
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
}
