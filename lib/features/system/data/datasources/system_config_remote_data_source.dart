import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/network/api_client.dart';
import 'package:flutter_mattermost/core/network/api_result.dart';
import 'package:flutter_mattermost/features/system/data/models/client_config_model.dart';
import 'package:flutter_mattermost/features/system/data/models/integrity_check_result_model.dart';
import 'package:flutter_mattermost/features/system/data/models/license_config_model.dart';

import 'package:flutter_mattermost/core/endpoints/endpoints.dart';

abstract class SystemConfigRemoteDataSource {
  Future<ClientConfigModel> getClientConfig();
  Future<LicenseConfigModel> getLicenseConfig();
  Future<Map<String, dynamic>> ping({int? timeoutSeconds});
  Future<String> getServerVersion();
  Future<List<String>> getTimezoneList();
  Future<Map<String, dynamic>> getSchemaVersion();
  Future<Map<String, dynamic>> getE2eAiBridge();
  Future<List<IntegrityCheckResultModel>> checkIntegrity();
  Future<Map<String, dynamic>> getServerBusyExpires();
  Future<void> clearServerBusy();
  Future<void> setServerBusy({int? seconds});
  Future<Map<String, dynamic>> getRedirectLocation(String url);
  Future<void> submitPerformanceReport(Map<String, dynamic> report);
}

@LazySingleton(as: SystemConfigRemoteDataSource)
class SystemConfigRemoteDataSourceImpl implements SystemConfigRemoteDataSource {
  final ApiClient _apiClient;

  SystemConfigRemoteDataSourceImpl(this._apiClient);

  @override
  Future<ClientConfigModel> getClientConfig() async {
    final result = await _apiClient.get<ClientConfigModel>(
      ConfigEndPoint.client,
      fromJson: (json) =>
          ClientConfigModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<ClientConfigModel>) {
      return result.data;
    }
    throw Exception('Failed to get client config');
  }

  @override
  Future<LicenseConfigModel> getLicenseConfig() async {
    final result = await _apiClient.get<LicenseConfigModel>(
      LicenseEndPoint.client,
      queryParameters: const {'format': 'old'},
      fromJson: (json) =>
          LicenseConfigModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<LicenseConfigModel>) {
      return result.data;
    }
    throw Exception('Failed to get license config');
  }

  @override
  Future<Map<String, dynamic>> ping({int? timeoutSeconds}) async {
    final result = await _apiClient.get<Map<String, dynamic>>(
      SystemEndPoint.ping,
      queryParameters: {if (timeoutSeconds != null) 'timeout': timeoutSeconds},
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to ping server');
  }

  @override
  Future<String> getServerVersion() async {
    final pong = await ping();
    final version = pong['version'] as String?;
    if (version != null && version.isNotEmpty) {
      return version;
    }
    // v11+: ping لم يعد يُرجع version، نقرؤها من إعدادات العميل.
    final clientConfig = await getClientConfig();
    if (clientConfig.version.isNotEmpty) {
      return clientConfig.version;
    }
    throw Exception('Server version not present in ping response');
  }

  @override
  Future<List<String>> getTimezoneList() async {
    final result = await _apiClient.get<List<String>>(
      SystemEndPoint.timezones,
      fromJson: (json) => (json as List<dynamic>).cast<String>(),
    );
    if (result is ApiSuccess<List<String>>) {
      return result.data;
    }
    throw Exception('Failed to get timezones');
  }

  @override
  Future<Map<String, dynamic>> getSchemaVersion() async {
    final result = await _apiClient.get<Map<String, dynamic>>(
      SystemEndPoint.schemaVersion,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to get schema version');
  }

  @override
  Future<Map<String, dynamic>> getE2eAiBridge() async {
    final result = await _apiClient.get<Map<String, dynamic>>(
      SystemEndPoint.e2eAiBridge,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to get e2e AI bridge config');
  }

  @override
  Future<List<IntegrityCheckResultModel>> checkIntegrity() async {
    final result = await _apiClient.post<List<IntegrityCheckResultModel>>(
      IntegrityEndPoint.root,
      fromJson: (json) => (json as List<dynamic>)
          .map((e) =>
              IntegrityCheckResultModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<IntegrityCheckResultModel>>) {
      return result.data;
    }
    throw Exception('Database integrity check failed');
  }

  @override
  Future<Map<String, dynamic>> getServerBusyExpires() async {
    final result = await _apiClient.get<Map<String, dynamic>>(
      ServerBusyEndPoint.root,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to get server busy expires');
  }

  @override
  Future<void> clearServerBusy() async {
    final result = await _apiClient.delete(ServerBusyEndPoint.root);
    if (result is ApiFailure) {
      throw Exception('Failed to clear server busy flag');
    }
  }

  @override
  Future<void> setServerBusy({int? seconds}) async {
    final result = await _apiClient.post<void>(
      ServerBusyEndPoint.root,
      queryParameters: {if (seconds != null) 'seconds': seconds},
      fromJson: (_) {},
    );
    if (result is ApiFailure) {
      throw Exception('Failed to set server busy flag');
    }
  }

  @override
  Future<Map<String, dynamic>> getRedirectLocation(String url) async {
    final result = await _apiClient.get<Map<String, dynamic>>(
      RedirectLocationEndPoint.root,
      queryParameters: {'url': url},
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to get redirect location');
  }

  @override
  Future<void> submitPerformanceReport(Map<String, dynamic> report) async {
    final result = await _apiClient.post<void>(
      ClientPerfEndPoint.root,
      data: report,
      fromJson: (_) {},
    );
    if (result is ApiFailure) {
      throw Exception('Failed to submit performance report');
    }
  }
}
