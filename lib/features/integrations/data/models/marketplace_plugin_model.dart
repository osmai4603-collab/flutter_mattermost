import 'package:flutter_mattermost/features/integrations/domain/entities/marketplace_plugin_entity.dart';

final class MarketplacePluginModel extends MarketplacePluginEntity {
  const MarketplacePluginModel({
    required super.homepage_url,
    required super.icon_data,
    required super.download_url,
    required super.release_notes_url,
    required super.labels,
    required super.signature,
    required super.manifest,
    required super.installed_version,
  });

  factory MarketplacePluginModel.fromMap(Map<String, dynamic> map) {
    return MarketplacePluginModel(
      homepage_url: map["homepage_url"] as String?,
      icon_data: map["icon_data"] as String?,
      download_url: map["download_url"] as String?,
      release_notes_url: map["release_notes_url"] as String?,
      labels: List<String>.from(map["labels"] as List<dynamic>? ?? []),
      signature: map["signature"] as String?,
      manifest: map["manifest"] as Map<String, dynamic>?,
      installed_version: map["installed_version"] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "homepage_url": homepage_url,
      "icon_data": icon_data,
      "download_url": download_url,
      "release_notes_url": release_notes_url,
      "labels": labels,
      "signature": signature,
      "manifest": manifest,
      "installed_version": installed_version,
    };
  }

  factory MarketplacePluginModel.fromEntity(MarketplacePluginEntity entity) {
    return MarketplacePluginModel(
      homepage_url: entity.homepage_url,
      icon_data: entity.icon_data,
      download_url: entity.download_url,
      release_notes_url: entity.release_notes_url,
      labels: entity.labels,
      signature: entity.signature,
      manifest: entity.manifest,
      installed_version: entity.installed_version,
    );
  }

  @override
  MarketplacePluginModel copyWith({
    String? homepage_url,
    String? icon_data,
    String? download_url,
    String? release_notes_url,
    List<String>? labels,
    String? signature,
    Map<String, dynamic>? manifest,
    String? installed_version,
  }) {
    return MarketplacePluginModel(
      homepage_url: homepage_url ?? this.homepage_url,
      icon_data: icon_data ?? this.icon_data,
      download_url: download_url ?? this.download_url,
      release_notes_url: release_notes_url ?? this.release_notes_url,
      labels: labels ?? this.labels,
      signature: signature ?? this.signature,
      manifest: manifest ?? this.manifest,
      installed_version: installed_version ?? this.installed_version,
    );
  }

  MarketplacePluginEntity toEntity() => MarketplacePluginEntity(
        homepage_url: homepage_url,
        icon_data: icon_data,
        download_url: download_url,
        release_notes_url: release_notes_url,
        labels: labels,
        signature: signature,
        manifest: manifest,
        installed_version: installed_version,
      );
}
