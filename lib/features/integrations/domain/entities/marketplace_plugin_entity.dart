import 'package:equatable/equatable.dart';

class MarketplacePluginEntity extends Equatable {
  final String? homepage_url;
  final String? icon_data;
  final String? download_url;
  final String? release_notes_url;
  final List<String>? labels;
  final String? signature;
  final Map<String, dynamic>? manifest;
  final String? installed_version;

  const MarketplacePluginEntity({
    this.homepage_url,
    this.icon_data,
    this.download_url,
    this.release_notes_url,
    this.labels,
    this.signature,
    this.manifest,
    this.installed_version,
  });

  @override
  List<Object?> get props => [
        homepage_url,
        icon_data,
        download_url,
        release_notes_url,
        labels,
        signature,
        manifest,
        installed_version,
      ];

  MarketplacePluginEntity copyWith({
    String? homepage_url,
    String? icon_data,
    String? download_url,
    String? release_notes_url,
    List<String>? labels,
    String? signature,
    Map<String, dynamic>? manifest,
    String? installed_version,
  }) {
    return MarketplacePluginEntity(
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
}
