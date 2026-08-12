import 'package:flutter_mattermost/features/integrations/domain/entities/plugin_reattach_request_entity.dart';

final class PluginReattachRequestModel extends PluginReattachRequestEntity {
  const PluginReattachRequestModel({
    required super.Manifest,
    required super.PluginReattachConfig,
  });

  factory PluginReattachRequestModel.fromMap(Map<String, dynamic> map) {
    return PluginReattachRequestModel(
      Manifest: map["Manifest"] as Map<String, dynamic>?,
      PluginReattachConfig: map["PluginReattachConfig"] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "Manifest": Manifest,
      "PluginReattachConfig": PluginReattachConfig,
    };
  }

  factory PluginReattachRequestModel.fromEntity(PluginReattachRequestEntity entity) {
    return PluginReattachRequestModel(
      Manifest: entity.Manifest,
      PluginReattachConfig: entity.PluginReattachConfig,
    );
  }

  @override
  PluginReattachRequestModel copyWith({
    Map<String, dynamic>? Manifest,
    Map<String, dynamic>? PluginReattachConfig,
  }) {
    return PluginReattachRequestModel(
      Manifest: Manifest ?? this.Manifest,
      PluginReattachConfig: PluginReattachConfig ?? this.PluginReattachConfig,
    );
  }

  PluginReattachRequestEntity toEntity() => PluginReattachRequestEntity(
        Manifest: Manifest,
        PluginReattachConfig: PluginReattachConfig,
      );
}
