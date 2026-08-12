import 'package:flutter_mattermost/features/admin/data/models/license_info_model.dart';

abstract class AdminLicenseRepository {
  Future<LicenseInfoModel> getClientLicense();
  Future<LicenseInfoModel> getServerLicense();
  Future<LicenseInfoModel> uploadLicense(String filePath);
  Future<void> removeLicense();
  Future<Map<String, dynamic>> getUsage();
  Future<void> upgradeToEnterprise();
}
