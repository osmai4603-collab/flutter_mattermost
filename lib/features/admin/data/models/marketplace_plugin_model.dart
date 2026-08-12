import 'package:flutter_mattermost/features/admin/domain/entities/marketplace_plugin_entity.dart';

final class MarketplacePluginModel extends MarketplacePluginEntity {
  const MarketplacePluginModel({
    super.homepageUrl,
    super.iconData,
    super.download,
    super.manifestId,
    super.manifestName,
    super.manifestDescription,
    super.manifestVersion,
    super.bundle,
  });

  factory MarketplacePluginModel.fromMap(Map<String, dynamic> data) {
    return MarketplacePluginModel(
      homepageUrl: data['homepage_url'] ?? '',
      iconData: data['icon_data'] ?? '',
      download: data['download'] != null
          ? DownloadPluginModel.fromMap(data['download'] as Map<String, dynamic>)
          : null,
      manifestId: data['manifest_id'] ?? '',
      manifestName: data['manifest_name'] ?? '',
      manifestDescription: data['manifest_description'] ?? '',
      manifestVersion: data['manifest_version'] ?? '',
      bundle: data['bundle'] != null
          ? MiniBundleModel.fromMap(data['bundle'] as Map<String, dynamic>)
          : null,
    );
  }

  factory MarketplacePluginModel.fromEntity(MarketplacePluginEntity entity) {
    return MarketplacePluginModel(
      homepageUrl: entity.homepageUrl,
      iconData: entity.iconData,
      download: entity.download,
      manifestId: entity.manifestId,
      manifestName: entity.manifestName,
      manifestDescription: entity.manifestDescription,
      manifestVersion: entity.manifestVersion,
      bundle: entity.bundle,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'homepage_url': homepageUrl,
      'icon_data': iconData,
      'download': download != null ? (download as DownloadPluginModel).toMap() : null,
      'manifest_id': manifestId,
      'manifest_name': manifestName,
      'manifest_description': manifestDescription,
      'manifest_version': manifestVersion,
      'bundle': bundle != null ? (bundle as MiniBundleModel).toMap() : null,
    };
  }

  MarketplacePluginModel copyWith({
    String? homepageUrl,
    String? iconData,
    DownloadPluginEntity? download,
    String? manifestId,
    String? manifestName,
    String? manifestDescription,
    String? manifestVersion,
    MiniBundleEntity? bundle,
  }) {
    return MarketplacePluginModel(
      homepageUrl: homepageUrl ?? this.homepageUrl,
      iconData: iconData ?? this.iconData,
      download: download ?? this.download,
      manifestId: manifestId ?? this.manifestId,
      manifestName: manifestName ?? this.manifestName,
      manifestDescription: manifestDescription ?? this.manifestDescription,
      manifestVersion: manifestVersion ?? this.manifestVersion,
      bundle: bundle ?? this.bundle,
    );
  }

  MarketplacePluginEntity toEntity() {
    return MarketplacePluginEntity(
      homepageUrl: homepageUrl,
      iconData: iconData,
      download: download,
      manifestId: manifestId,
      manifestName: manifestName,
      manifestDescription: manifestDescription,
      manifestVersion: manifestVersion,
      bundle: bundle,
    );
  }
}

final class DownloadPluginModel extends DownloadPluginEntity {
  const DownloadPluginModel({
    super.url,
    super.version,
    super.signature,
    super.checksum,
  });

  factory DownloadPluginModel.fromMap(Map<String, dynamic> data) {
    return DownloadPluginModel(
      url: data['url'] ?? '',
      version: data['version'] ?? '',
      signature: data['signature'] ?? '',
      checksum: data['checksum'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'url': url,
      'version': version,
      'signature': signature,
      'checksum': checksum,
    };
  }
}

final class MiniBundleModel extends MiniBundleEntity {
  const MiniBundleModel({
    super.source,
    super.name,
    super.description,
    super.bundleName,
    super.bundleVersion,
    super.iconData,
    super.bundleModules,
  });

  factory MiniBundleModel.fromMap(Map<String, dynamic> data) {
    return MiniBundleModel(
      source: data['source'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      bundleName: data['bundle_name'] ?? '',
      bundleVersion: data['bundle_version'] ?? '',
      iconData: data['icon_data'] ?? '',
      bundleModules: List<String>.from(data['bundle_modules'] ?? const []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'source': source,
      'name': name,
      'description': description,
      'bundle_name': bundleName,
      'bundle_version': bundleVersion,
      'icon_data': iconData,
      'bundle_modules': bundleModules,
    };
  }
}
