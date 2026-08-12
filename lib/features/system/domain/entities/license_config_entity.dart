import 'package:flutter_mattermost/core/entities/entity.dart';

class LicenseConfigEntity extends Entity {
  final String licensed;
  final String licenseId;
  final String trial;
  final String skuName;
  final String skuShortName;
  final String skuEdition;
  final String enterpriseBuild;
  final String cloud;
  final Map<String, dynamic> features;
  final Map<String, dynamic> license;

  const LicenseConfigEntity({
    this.licensed = 'false',
    this.licenseId = '',
    this.trial = 'false',
    this.skuName = '',
    this.skuShortName = '',
    this.skuEdition = '',
    this.enterpriseBuild = 'false',
    this.cloud = 'false',
    this.features = const {},
    this.license = const {},
  });

  @override
  List<Object?> get props => [
        licensed,
        licenseId,
        trial,
        skuName,
        skuShortName,
        skuEdition,
        enterpriseBuild,
        cloud,
        features,
        license,
      ];

  @override
  LicenseConfigEntity copyWith({
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
    return LicenseConfigEntity(
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

  bool get isLicensed => licensed.toLowerCase() == 'true';
  bool get isTrial => trial.toLowerCase() == 'true';

  bool isFeatureEnabled(String featureName) {
    final value = features[featureName];
    if (value is String) {
      return value.toLowerCase() == 'true';
    }
    return value is bool && value;
  }
}
