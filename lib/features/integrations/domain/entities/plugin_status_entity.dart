import 'package:equatable/equatable.dart';

class PluginStatusEntity extends Equatable {
  final String? plugin_id;
  final String? name;
  final String? description;
  final String? version;
  final String? cluster_id;
  final String? plugin_path;
  final double? state;

  const PluginStatusEntity({
    this.plugin_id,
    this.name,
    this.description,
    this.version,
    this.cluster_id,
    this.plugin_path,
    this.state,
  });

  @override
  List<Object?> get props => [
        plugin_id,
        name,
        description,
        version,
        cluster_id,
        plugin_path,
        state,
      ];

  PluginStatusEntity copyWith({
    String? plugin_id,
    String? name,
    String? description,
    String? version,
    String? cluster_id,
    String? plugin_path,
    double? state,
  }) {
    return PluginStatusEntity(
      plugin_id: plugin_id ?? this.plugin_id,
      name: name ?? this.name,
      description: description ?? this.description,
      version: version ?? this.version,
      cluster_id: cluster_id ?? this.cluster_id,
      plugin_path: plugin_path ?? this.plugin_path,
      state: state ?? this.state,
    );
  }
}
