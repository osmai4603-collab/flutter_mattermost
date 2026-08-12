import 'package:flutter_mattermost/features/admin/domain/entities/license_info_entity.dart';

final class LicenseInfoModel extends LicenseInfoEntity {
  const LicenseInfoModel({
    super.id,
    super.isLicensed,
    super.issuedAt,
    super.startsAt,
    super.expiresAt,
    super.remotelyTruncated,
    super.users,
    super.name,
    super.company,
    super.skuName,
    super.skuShortName,
    super.skuEdition,
    super.isTrial,
    super.isCloud,
    super.features,
  });

  factory LicenseInfoModel.fromMap(Map<String, dynamic> data) {
    return LicenseInfoModel(
      id: data['Id'] ?? '',
      isLicensed: data['IsLicensed'] ?? 'false',
      issuedAt: (data['IssuedAt'] ?? 0).toInt(),
      startsAt: (data['StartsAt'] ?? 0).toInt(),
      expiresAt: (data['ExpiresAt'] ?? 0).toInt(),
      remotelyTruncated: data['RemotelyTruncated'] ?? false,
      users: (data['Users'] ?? 0).toInt(),
      name: data['Name'] ?? '',
      company: data['Company'] ?? '',
      skuName: data['SkuName'] ?? '',
      skuShortName: data['SkuShortName'] ?? '',
      skuEdition: data['SkuEdition'] ?? '',
      isTrial: data['IsTrial'] ?? 'false',
      isCloud: data['IsCloud'] ?? 'false',
      features: data['Features'] ?? '',
    );
  }

  factory LicenseInfoModel.fromEntity(LicenseInfoEntity entity) {
    return LicenseInfoModel(
      id: entity.id,
      isLicensed: entity.isLicensed,
      issuedAt: entity.issuedAt,
      startsAt: entity.startsAt,
      expiresAt: entity.expiresAt,
      remotelyTruncated: entity.remotelyTruncated,
      users: entity.users,
      name: entity.name,
      company: entity.company,
      skuName: entity.skuName,
      skuShortName: entity.skuShortName,
      skuEdition: entity.skuEdition,
      isTrial: entity.isTrial,
      isCloud: entity.isCloud,
      features: entity.features,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Id': id,
      'IsLicensed': isLicensed,
      'IssuedAt': issuedAt,
      'StartsAt': startsAt,
      'ExpiresAt': expiresAt,
      'RemotelyTruncated': remotelyTruncated,
      'Users': users,
      'Name': name,
      'Company': company,
      'SkuName': skuName,
      'SkuShortName': skuShortName,
      'SkuEdition': skuEdition,
      'IsTrial': isTrial,
      'IsCloud': isCloud,
      'Features': features,
    };
  }

  LicenseInfoModel copyWith({
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
    return LicenseInfoModel(
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

  LicenseInfoEntity toEntity() {
    return LicenseInfoEntity(
      id: id,
      isLicensed: isLicensed,
      issuedAt: issuedAt,
      startsAt: startsAt,
      expiresAt: expiresAt,
      remotelyTruncated: remotelyTruncated,
      users: users,
      name: name,
      company: company,
      skuName: skuName,
      skuShortName: skuShortName,
      skuEdition: skuEdition,
      isTrial: isTrial,
      isCloud: isCloud,
      features: features,
    );
  }
}
