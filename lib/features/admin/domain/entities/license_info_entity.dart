import 'package:flutter_mattermost/core/entities/entity.dart';

class LicenseInfoEntity extends Entity {
  final String id;
  final String isLicensed;
  final int issuedAt;
  final int startsAt;
  final int expiresAt;
  final bool remotelyTruncated;
  final int users;
  final String name;
  final String company;
  final String skuName;
  final String skuShortName;
  final String skuEdition;
  final String isTrial;
  final String isCloud;
  final String features;

  const LicenseInfoEntity({
    this.id = '',
    this.isLicensed = 'false',
    this.issuedAt = 0,
    this.startsAt = 0,
    this.expiresAt = 0,
    this.remotelyTruncated = false,
    this.users = 0,
    this.name = '',
    this.company = '',
    this.skuName = '',
    this.skuShortName = '',
    this.skuEdition = '',
    this.isTrial = 'false',
    this.isCloud = 'false',
    this.features = '',
  });

  @override
  List<Object?> get props => [
        id,
        isLicensed,
        issuedAt,
        startsAt,
        expiresAt,
        remotelyTruncated,
        users,
        name,
        company,
        skuName,
        skuShortName,
        skuEdition,
        isTrial,
        isCloud,
        features,
      ];

  LicenseInfoEntity copyWith({
    String? id,
    String? isLicensed,
    int? issuedAt,
    int? startsAt,
    int? expiresAt,
    bool? remotelyTruncated,
    int? users,
    String? name,
    String? company,
    String? skuName,
    String? skuShortName,
    String? skuEdition,
    String? isTrial,
    String? isCloud,
    String? features,
  }) {
    return LicenseInfoEntity(
      id: id ?? this.id,
      isLicensed: isLicensed ?? this.isLicensed,
      issuedAt: issuedAt ?? this.issuedAt,
      startsAt: startsAt ?? this.startsAt,
      expiresAt: expiresAt ?? this.expiresAt,
      remotelyTruncated: remotelyTruncated ?? this.remotelyTruncated,
      users: users ?? this.users,
      name: name ?? this.name,
      company: company ?? this.company,
      skuName: skuName ?? this.skuName,
      skuShortName: skuShortName ?? this.skuShortName,
      skuEdition: skuEdition ?? this.skuEdition,
      isTrial: isTrial ?? this.isTrial,
      isCloud: isCloud ?? this.isCloud,
      features: features ?? this.features,
    );
  }

  bool get licensed => isLicensed.toLowerCase() == 'true';
  bool get trial => isTrial.toLowerCase() == 'true';
  bool get cloud => isCloud.toLowerCase() == 'true';

  bool hasFeature(String featureName) {
    if (features.contains('=')) {
      final entry = features.split(',').where((e) => e.startsWith('$featureName='));
      if (entry.isNotEmpty) {
        return entry.first.split('=')[1].toLowerCase() == 'true';
      }
      return false;
    }
    return features.split(',').contains(featureName);
  }

  DateTime? get expiresAtDate => expiresAt != 0
      ? DateTime.fromMillisecondsSinceEpoch(expiresAt * 1000)
      : null;
}

