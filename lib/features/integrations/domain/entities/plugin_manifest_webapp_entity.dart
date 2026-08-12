import 'package:equatable/equatable.dart';

class PluginManifestWebappEntity extends Equatable {
  final String? id;
  final String? version;
  final Map<String, dynamic>? webapp;

  const PluginManifestWebappEntity({
    this.id,
    this.version,
    this.webapp,
  });

  @override
  List<Object?> get props => [
        id,
        version,
        webapp,
      ];

  PluginManifestWebappEntity copyWith({
    String? id,
    String? version,
    Map<String, dynamic>? webapp,
  }) {
    return PluginManifestWebappEntity(
      id: id ?? this.id,
      version: version ?? this.version,
      webapp: webapp ?? this.webapp,
    );
  }
}
