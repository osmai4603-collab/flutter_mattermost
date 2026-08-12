import 'package:flutter_mattermost/core/entities/entity.dart';

class MarketplacePluginEntity extends Entity {
  final String homepageUrl;
  final String iconData;
  final DownloadPluginEntity? download;
  final String manifestId;
  final String manifestName;
  final String manifestDescription;
  final String manifestVersion;
  final MiniBundleEntity? bundle;

  const MarketplacePluginEntity({
    this.homepageUrl = '',
    this.iconData = '',
    this.download,
    this.manifestId = '',
    this.manifestName = '',
    this.manifestDescription = '',
    this.manifestVersion = '',
    this.bundle,
  });

  @override
  List<Object?> get props => [
        homepageUrl,
        iconData,
        download,
        manifestId,
        manifestName,
        manifestDescription,
        manifestVersion,
        bundle,
      ];

  MarketplacePluginEntity copyWith({
    String? homepageUrl,
    String? iconData,
    DownloadPluginEntity? download,
    String? manifestId,
    String? manifestName,
    String? manifestDescription,
    String? manifestVersion,
    MiniBundleEntity? bundle,
  }) {
    return MarketplacePluginEntity(
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
}

class DownloadPluginEntity extends Entity {
  final String url;
  final String version;
  final String signature;
  final String checksum;

  const DownloadPluginEntity({
    this.url = '',
    this.version = '',
    this.signature = '',
    this.checksum = '',
  });

  @override
  List<Object?> get props => [url, version, signature, checksum];

  DownloadPluginEntity copyWith({
    String? url,
    String? version,
    String? signature,
    String? checksum,
  }) {
    return DownloadPluginEntity(
      url: url ?? this.url,
      version: version ?? this.version,
      signature: signature ?? this.signature,
      checksum: checksum ?? this.checksum,
    );
  }
}

class MiniBundleEntity extends Entity {
  final String source;
  final String name;
  final String description;
  final String bundleName;
  final String bundleVersion;
  final String iconData;
  final List<String> bundleModules;

  const MiniBundleEntity({
    this.source = '',
    this.name = '',
    this.description = '',
    this.bundleName = '',
    this.bundleVersion = '',
    this.iconData = '',
    this.bundleModules = const [],
  });

  @override
  List<Object?> get props => [
        source,
        name,
        description,
        bundleName,
        bundleVersion,
        iconData,
        bundleModules,
      ];

  MiniBundleEntity copyWith({
    String? source,
    String? name,
    String? description,
    String? bundleName,
    String? bundleVersion,
    String? iconData,
    List<String>? bundleModules,
  }) {
    return MiniBundleEntity(
      source: source ?? this.source,
      name: name ?? this.name,
      description: description ?? this.description,
      bundleName: bundleName ?? this.bundleName,
      bundleVersion: bundleVersion ?? this.bundleVersion,
      iconData: iconData ?? this.iconData,
      bundleModules: bundleModules ?? this.bundleModules,
    );
  }
}
