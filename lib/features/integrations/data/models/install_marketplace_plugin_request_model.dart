import 'package:flutter_mattermost/features/integrations/domain/entities/install_marketplace_plugin_request_entity.dart';

final class InstallMarketplacePluginRequestModel extends InstallMarketplacePluginRequestEntity {
  const InstallMarketplacePluginRequestModel({
    required super.id,
    required super.version,
  });

  factory InstallMarketplacePluginRequestModel.fromMap(Map<String, dynamic> map) {
    return InstallMarketplacePluginRequestModel(
      id: map["id"] as String?,
      version: map["version"] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "version": version,
    };
  }

  factory InstallMarketplacePluginRequestModel.fromEntity(InstallMarketplacePluginRequestEntity entity) {
    return InstallMarketplacePluginRequestModel(
      id: entity.id,
      version: entity.version,
    );
  }

  @override
  InstallMarketplacePluginRequestModel copyWith({
    String? id,
    String? version,
  }) {
    return InstallMarketplacePluginRequestModel(
      id: id ?? this.id,
      version: version ?? this.version,
    );
  }

  InstallMarketplacePluginRequestEntity toEntity() => InstallMarketplacePluginRequestEntity(
        id: id,
        version: version,
      );
}
