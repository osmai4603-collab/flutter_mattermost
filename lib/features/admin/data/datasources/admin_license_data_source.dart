import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/network/api_client.dart';
import 'package:flutter_mattermost/core/network/api_result.dart';
import 'package:flutter_mattermost/core/endpoints/endpoints.dart';
import 'package:flutter_mattermost/features/admin/data/models/license_info_model.dart';

abstract class AdminLicenseDataSource {
  Future<LicenseInfoModel> getClientLicense();
  Future<LicenseInfoModel> getServerLicense();
  Future<LicenseInfoModel> uploadLicense(String filePath);
  Future<void> removeLicense();
  Future<Map<String, dynamic>> getUsage();
  Future<void> upgradeToEnterprise();
  Future<void> uploadLicenseFile(String filePath);
  Future<bool> isUpgradeAllowed();
  Future<Map<String, dynamic>> getPreviousTrialLicense();
  Future<Map<String, dynamic>> requestTrialLicense({
    required bool receiveEmailsAccepted,
    required bool termsAccepted,
    required int users,
    String? features,
  });
  Future<Map<String, dynamic>> previewLicenseFile(String filePath);
  Future<Map<String, dynamic>> getUpgradeToEnterpriseStatus();
}

@LazySingleton(as: AdminLicenseDataSource)
class AdminLicenseDataSourceImpl implements AdminLicenseDataSource {
  final ApiClient _apiClient;

  AdminLicenseDataSourceImpl(this._apiClient);

  @override
  Future<LicenseInfoModel> getClientLicense() async {
    final result = await _apiClient.get<LicenseInfoModel>(
      LicenseEndPoint.client,
      fromJson: (json) => LicenseInfoModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<LicenseInfoModel>) {
      return result.data;
    }
    throw Exception('Failed to get client license');
  }

  @override
  Future<LicenseInfoModel> getServerLicense() async {
    final result = await _apiClient.get<LicenseInfoModel>(
      LicenseEndPoint.root,
      fromJson: (json) => LicenseInfoModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<LicenseInfoModel>) {
      return result.data;
    }
    throw Exception('Failed to get server license');
  }

  @override
  Future<LicenseInfoModel> uploadLicense(String filePath) async {
    final response = await _apiClient.dio.post(
      LicenseEndPoint.root,
      data: FormData.fromMap({
        'license': await MultipartFile.fromFile(filePath),
      }),
    );
    if (response.statusCode == null || response.statusCode! >= 400) {
      throw Exception('Failed to upload license');
    }
    return LicenseInfoModel.fromMap(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> removeLicense() async {
    final result = await _apiClient.delete(LicenseEndPoint.root);
    if (result is ApiFailure) {
      throw Exception('Failed to remove license');
    }
  }

  @override
  Future<Map<String, dynamic>> getUsage() async {
    final result = await _apiClient.get<Map<String, dynamic>>(
      LicenseEndPoint.loadMetric,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to get license usage');
  }

  @override
  Future<void> upgradeToEnterprise() async {
    final result = await _apiClient.post<void>(
      UpgradeToEnterpriseEndPoint.base,
      fromJson: (_) {},
    );
    if (result is ApiFailure) {
      throw Exception('Failed to request upgrade');
    }
  }

  @override
  Future<void> uploadLicenseFile(String filePath) => uploadLicense(filePath);

  @override
  Future<bool> isUpgradeAllowed() async {
    final result = await _apiClient.get<Map<String, dynamic>>(
      UpgradeToEnterpriseEndPoint.allowed,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data['allowed'] == true;
    }
    throw Exception('Failed to check upgrade eligibility');
  }

  @override
  Future<Map<String, dynamic>> getPreviousTrialLicense() async {
    final result = await _apiClient.get<Map<String, dynamic>>(
      TrialLicenseEndPoint.prev,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to get previous trial license');
  }

  @override
  Future<Map<String, dynamic>> requestTrialLicense({
    required bool receiveEmailsAccepted,
    required bool termsAccepted,
    required int users,
    String? features,
  }) async {
    final result = await _apiClient.post<Map<String, dynamic>>(
      TrialLicenseEndPoint.root,
      data: {
        'receive_emails_accepted': receiveEmailsAccepted,
        'terms_accepted': termsAccepted,
        'users': users,
        if (features != null) 'features': features,
      },
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to request trial license');
  }

  @override
  Future<Map<String, dynamic>> previewLicenseFile(String filePath) async {
    final response = await _apiClient.dio.post(
      LicenseEndPoint.preview,
      data: FormData.fromMap({
        'license': await MultipartFile.fromFile(filePath),
      }),
    );
    if (response.statusCode == null || response.statusCode! >= 400) {
      throw Exception('Failed to preview license file');
    }
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> getUpgradeToEnterpriseStatus() async {
    final result = await _apiClient.get<Map<String, dynamic>>(
      UpgradeToEnterpriseEndPoint.status,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to get upgrade to enterprise status');
  }
}
