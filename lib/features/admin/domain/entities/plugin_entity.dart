import 'package:flutter_mattermost/core/entities/entity.dart';

class PluginEntity extends Entity {
  final String id;
  final String name;
  final String description;
  final String version;
  final bool active;

  const PluginEntity({
    required this.id,
    required this.name,
    this.description = '',
    this.version = '',
    this.active = false,
  });

  @override
  List<Object?> get props => [id, name, description, version, active];

  PluginEntity copyWith({
    String? id,
    String? name,
    String? description,
    String? version,
    bool? active,
  }) {
    return PluginEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      version: version ?? this.version,
      active: active ?? this.active,
    );
  }
}
