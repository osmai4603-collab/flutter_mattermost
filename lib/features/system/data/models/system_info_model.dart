import 'package:flutter_mattermost/features/system/domain/entities/system_info_entity.dart';

final class SystemInfoModel extends SystemInfoEntity {
  const SystemInfoModel({
    required super.version,
    required super.maxFileSizeBytes,
    required super.isScheduledPostsEnabled,
    required super.isGuestAccountsEnabled,
    required super.isLicensed,
    required super.isTrial,
    required super.skuShortName,
  });

  factory SystemInfoModel.fromMap(Map<String, dynamic> map) {
    return SystemInfoModel(
      version: map["Version"] as String? ?? 'unknown',
      maxFileSizeBytes:
          int.tryParse(map["MaxFileSize"] as String? ?? '') ?? 50 * 1024 * 1024,
      isScheduledPostsEnabled:
          (map["FeatureScheduledPosts"] as String? ?? '').toLowerCase() ==
              'true',
      isGuestAccountsEnabled:
          (map["EnableGuestAccounts"] as String? ?? '').toLowerCase() ==
                  'true' ||
              (map["FeatureGuestAccounts"] as String? ?? '').toLowerCase() ==
                  'true',
      isLicensed: (map["IsLicensed"] as String? ?? '').toLowerCase() == 'true',
      isTrial: (map["IsTrial"] as String? ?? '').toLowerCase() == 'true',
      skuShortName: map["SkuShortName"] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "Version": version,
      "MaxFileSize": maxFileSizeBytes.toString(),
      "FeatureScheduledPosts": isScheduledPostsEnabled.toString(),
      "EnableGuestAccounts": isGuestAccountsEnabled.toString(),
      "IsLicensed": isLicensed.toString(),
      "IsTrial": isTrial.toString(),
      "SkuShortName": skuShortName,
    };
  }

  factory SystemInfoModel.fromEntity(SystemInfoEntity entity) {
    return SystemInfoModel(
      version: entity.version,
      maxFileSizeBytes: entity.maxFileSizeBytes,
      isScheduledPostsEnabled: entity.isScheduledPostsEnabled,
      isGuestAccountsEnabled: entity.isGuestAccountsEnabled,
      isLicensed: entity.isLicensed,
      isTrial: entity.isTrial,
      skuShortName: entity.skuShortName,
    );
  }

  SystemInfoModel copyWith({
    String? version,
    int? maxFileSizeBytes,
    bool? isScheduledPostsEnabled,
    bool? isGuestAccountsEnabled,
    bool? isLicensed,
    bool? isTrial,
    String? skuShortName,
  }) {
    return SystemInfoModel(
      version: version ?? this.version,
      maxFileSizeBytes: maxFileSizeBytes ?? this.maxFileSizeBytes,
      isScheduledPostsEnabled:
          isScheduledPostsEnabled ?? this.isScheduledPostsEnabled,
      isGuestAccountsEnabled:
          isGuestAccountsEnabled ?? this.isGuestAccountsEnabled,
      isLicensed: isLicensed ?? this.isLicensed,
      isTrial: isTrial ?? this.isTrial,
      skuShortName: skuShortName ?? this.skuShortName,
    );
  }

  SystemInfoEntity toEntity() => SystemInfoEntity(
        version: version,
        maxFileSizeBytes: maxFileSizeBytes,
        isScheduledPostsEnabled: isScheduledPostsEnabled,
        isGuestAccountsEnabled: isGuestAccountsEnabled,
        isLicensed: isLicensed,
        isTrial: isTrial,
        skuShortName: skuShortName,
      );
}
