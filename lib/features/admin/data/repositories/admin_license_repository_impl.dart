import 'package:flutter_mattermost/features/admin/data/models/license_info_model.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/features/admin/data/datasources/admin_license_data_source.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_license_repository.dart';

@LazySingleton(as: AdminLicenseRepository)
class AdminLicenseRepositoryImpl implements AdminLicenseRepository {
  final AdminLicenseDataSource _dataSource;

  AdminLicenseRepositoryImpl(this._dataSource);

  @override
  Future<LicenseInfoModel> getClientLicense() => _dataSource.getClientLicense();

  @override
  Future<LicenseInfoModel> getServerLicense() => _dataSource.getServerLicense();

  @override
  Future<LicenseInfoModel> uploadLicense(String filePath) =>
      _dataSource.uploadLicense(filePath);

  @override
  Future<void> removeLicense() => _dataSource.removeLicense();

  @override
  Future<Map<String, dynamic>> getUsage() => _dataSource.getUsage();

  @override
  Future<void> upgradeToEnterprise() => _dataSource.upgradeToEnterprise();
}
