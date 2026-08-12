import 'package:flutter_mattermost/features/system/domain/entities/license_config_entity.dart';

final class LicenseConfigModel extends LicenseConfigEntity {
  const LicenseConfigModel({
    super.licensed,
    super.licenseId,
    super.trial,
    super.skuName,
    super.skuShortName,
    super.skuEdition,
    super.enterpriseBuild,
    super.cloud,
    super.features,
    super.license,
  });

  factory LicenseConfigModel.fromMap(Map<String, dynamic> data) {
    return LicenseConfigModel(
      licensed: data['IsLicensed'] ?? 'false',
      licenseId: data['LicenseID'] ?? '',
      trial: data['IsTrial'] ?? 'false',
      skuName: data['SkuName'] ?? '',
      skuShortName: data['SkuShortName'] ?? '',
      skuEdition: data['SkuEdition'] ?? '',
      enterpriseBuild: data['EnterpriseBuild'] ?? 'false',
      cloud: data['Cloud'] ?? 'false',
      features: Map<String, dynamic>.from(data['Features'] ?? const {}),
      license: Map<String, dynamic>.from(data['License'] ?? const {}),
    );
  }

  factory LicenseConfigModel.fromEntity(LicenseConfigEntity entity) {
    return LicenseConfigModel(
      licensed: entity.licensed,
      licenseId: entity.licenseId,
      trial: entity.trial,
      skuName: entity.skuName,
      skuShortName: entity.skuShortName,
      skuEdition: entity.skuEdition,
      enterpriseBuild: entity.enterpriseBuild,
      cloud: entity.cloud,
      features: entity.features,
      license: entity.license,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'IsLicensed': licensed,
      'LicenseID': licenseId,
      'IsTrial': trial,
      'SkuName': skuName,
      'SkuShortName': skuShortName,
      'SkuEdition': skuEdition,
      'EnterpriseBuild': enterpriseBuild,
      'Cloud': cloud,
      'Features': features,
      'License': license,
    };
  }

  @override
  LicenseConfigModel copyWith({
    String? licensed,
    String? licenseId,
    String? trial,
    String? skuName,
    String? skuShortName,
    String? skuEdition,
    String? enterpriseBuild,
    String? cloud,
    Map<String, dynamic>? features,
    Map<String, dynamic>? license,
  }) {
    return LicenseConfigModel(
      licensed: licensed ?? this.licensed,
      licenseId: licenseId ?? this.licenseId,
      trial: trial ?? this.trial,
      skuName: skuName ?? this.skuName,
      skuShortName: skuShortName ?? this.skuShortName,
      skuEdition: skuEdition ?? this.skuEdition,
      enterpriseBuild: enterpriseBuild ?? this.enterpriseBuild,
      cloud: cloud ?? this.cloud,
      features: features ?? this.features,
      license: license ?? this.license,
    );
  }

  LicenseConfigEntity toEntity() {
    return LicenseConfigEntity(
      licensed: licensed,
      licenseId: licenseId,
      trial: trial,
      skuName: skuName,
      skuShortName: skuShortName,
      skuEdition: skuEdition,
      enterpriseBuild: enterpriseBuild,
      cloud: cloud,
      features: features,
      license: license,
    );
  }
}
