import 'package:equatable/equatable.dart';

class PluginReattachRequestEntity extends Equatable {
  final Map<String, dynamic>? Manifest;
  final Map<String, dynamic>? PluginReattachConfig;

  const PluginReattachRequestEntity({
    required this.Manifest,
    required this.PluginReattachConfig,
  });

  @override
  List<Object?> get props => [
        Manifest,
        PluginReattachConfig,
      ];

  PluginReattachRequestEntity copyWith({
    Map<String, dynamic>? Manifest,
    Map<String, dynamic>? PluginReattachConfig,
  }) {
    return PluginReattachRequestEntity(
      Manifest: Manifest ?? this.Manifest,
      PluginReattachConfig: PluginReattachConfig ?? this.PluginReattachConfig,
    );
  }
}
