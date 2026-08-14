import 'package:dio/dio.dart';
import 'package:flutter_mattermost/features/admin/data/models/analytics_model.dart';
import 'package:flutter_mattermost/features/admin/data/models/installation_model.dart';
import 'package:flutter_mattermost/features/admin/domain/entities/analytics_entity.dart';
import 'package:flutter_mattermost/features/system/data/models/client_config_model.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/network/api_client.dart';
import 'package:flutter_mattermost/core/network/api_result.dart';
import 'package:flutter_mattermost/core/endpoints/endpoints.dart';
import 'package:flutter_mattermost/features/admin/data/models/agent_model.dart';
import 'package:flutter_mattermost/features/admin/data/models/agent_status_model.dart';
import 'package:flutter_mattermost/features/admin/data/models/llm_service_model.dart';
import 'package:flutter_mattermost/features/admin/data/models/log_entry_model.dart';
import 'package:flutter_mattermost/features/system/data/models/notice_model.dart';

abstract class AdminConfigDataSource {
  Future<Map<String, dynamic>> getConfig();
  Future<Map<String, dynamic>> updateConfig(Map<String, dynamic> config);
  Future<Map<String, dynamic>> patchConfig(Map<String, dynamic> patch);
  Future<ClientConfigModel> getClientConfig();
  Future<Map<String, dynamic>> getEnvironmentConfig();
  Future<void> reloadConfig();
  Future<AnalyticsEntity> getAnalytics();
  Future<List<String>> getPlainLogs({int page = 0, int perPage = 100});
  Future<List<LogEntryModel>> getLogs({
    int page = 0,
    int perPage = 100,
    String? level,
    String? filter,
  });
  Future<Map<String, dynamic>> getClusterStatus();
  Future<void> recycleDatabase();
  Future<void> invalidateCaches();
  Future<void> restartServer();
  Future<void> testSiteURL();
  Future<void> testEmail();
  Future<void> sendTestNotification();
  Future<void> testS3Connection();
  Future<void> testFileStoreConnection();
  Future<void> purgeElasticsearchIndexes();
  Future<void> testElasticsearch();
  Future<Map<String, dynamic>> getServerLimits();
  Future<List<LlmServiceModel>> getLLMServices();
  Future<List<AgentModel>> getAgents();
  Future<List<AgentStatusModel>> getAgentsStatus();
  Future<void> uploadBrandImage(String filePath);
  Future<void> removeBrandImage();
  Future<Map<String, dynamic>> ping();
  Future<Map<String, dynamic>> migrateConfig(
    Map<String, dynamic> migrationData,
  );
  Future<Map<String, dynamic>> getAppliedSchemaMigrations();
  Future<bool> getFirstAdminSetupComplete();
  Future<void> completeSetup();
  Future<List<NoticeModel>> getInProductNotices(String teamId);
  Future<void> updateNoticesAsViewed(List<NoticeModel> notices);
  Future<void> downloadLogs(String savePath);

  // Missing operations from docs
  Future<InstallationModel> checkCWSConnection();
  Future<void> deleteAIBridgeTestHelper();
  Future<void> generateSupportPacket(String savePath);
  Future<Map<String, dynamic>> getAIBridgeTestHelper();
  Future<String> getLatestVersion();
  Future<Map<String, dynamic>> getLicenseLoadMetric();
  Future<Map<String, dynamic>> getPrevTrialLicense();
  Future<bool> isAllowedToUpgradeToEnterprise();
  Future<void> manualTest();
  Future<void> postLog(Map<String, dynamic> log);
  Future<void> setAIBridgeTestHelper(Map<String, dynamic> data);
  Future<void> updateMarketplaceVisitedByAdmin();
}

@LazySingleton(as: AdminConfigDataSource)
class AdminConfigDataSourceImpl implements AdminConfigDataSource {
  final ApiClient _apiClient;

  AdminConfigDataSourceImpl(this._apiClient);

  @override
  Future<Map<String, dynamic>> getConfig() async {
    final result = await _apiClient.get<Map<String, dynamic>>(
      ConfigEndPoint.root,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to get configuration');
  }

  @override
  Future<Map<String, dynamic>> updateConfig(Map<String, dynamic> config) async {
    final result = await _apiClient.put<Map<String, dynamic>>(
      ConfigEndPoint.root,
      data: config,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to update configuration');
  }

  @override
  Future<Map<String, dynamic>> patchConfig(Map<String, dynamic> patch) async {
    final result = await _apiClient.put<Map<String, dynamic>>(
      ConfigEndPoint.patch,
      data: patch,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to patch configuration');
  }

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
    throw Exception('Failed to get client configuration');
  }

  @override
  Future<Map<String, dynamic>> getEnvironmentConfig() async {
    final result = await _apiClient.get<Map<String, dynamic>>(
      ConfigEndPoint.environment,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to get environment configuration');
  }

  @override
  Future<void> reloadConfig() async {
    final result = await _apiClient.post<void>(
      ConfigEndPoint.reload,
      fromJson: (_) {},
    );
    if (result is ApiFailure) {
      throw Exception('Failed to reload configuration');
    }
  }

  @override
  Future<AnalyticsEntity> getAnalytics() async {
    final result = await _apiClient.get<List<AnalyticsItemModel>>(
      AnalyticsEndPoint.old,
      fromJson: (list) => (list as List<dynamic>? ?? [])
          .map(
            (data) => AnalyticsItemModel.fromMap(data as Map<String, dynamic>),
          )
          .toList(),
    );
    if (result is ApiSuccess<List<AnalyticsItemModel>>) {
      return AnalyticsEntity(items: result.data);
    }
    throw Exception('Failed to get analytics: ');
  }

  @override
  Future<List<String>> getPlainLogs({int page = 0, int perPage = 100}) async {
    final result = await _apiClient.get<List<String>>(
      LogsEndPoint.root,
      queryParameters: {'page': page, 'logs_per_page': perPage},
      fromJson: (json) =>
          (json as List<dynamic>).map((e) => e.toString()).toList(),
    );
    if (result is ApiSuccess<List<String>>) {
      return result.data;
    }
    throw Exception('Failed to get logs');
  }

  @override
  Future<List<LogEntryModel>> getLogs({
    int page = 0,
    int perPage = 100,
    String? level,
    String? filter,
  }) async {
    final result = await _apiClient.post<List<LogEntryModel>>(
      LogsEndPoint.query,
      queryParameters: {'page': page, 'logs_per_page': perPage},
      data: {'level': ?level, 'filter': ?filter},
      fromJson: (json) {
        if (json is Map<String, dynamic>) {
          final list = <LogEntryModel>[];
          for (final entries in json.values) {
            if (entries is List) {
              for (final e in entries) {
                if (e is Map<String, dynamic>) {
                  list.add(LogEntryModel.fromMap(e));
                }
              }
            }
          }
          return list;
        } else if (json is List) {
          return json
              .whereType<Map<String, dynamic>>()
              .map((e) => LogEntryModel.fromMap(e))
              .toList();
        }
        return [];
      },
    );
    if (result is ApiSuccess<List<LogEntryModel>>) {
      return result.data;
    }
    throw Exception('Failed to query logs');
  }

  @override
  Future<Map<String, dynamic>> getClusterStatus() async {
    final result = await _apiClient.get<Map<String, dynamic>>(
      ClusterEndPoint.status,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to get cluster status');
  }

  @override
  Future<void> recycleDatabase() async {
    final result = await _apiClient.post<void>(
      DatabaseEndPoint.recycle,
      fromJson: (_) {},
    );
    if (result is ApiFailure) {
      throw Exception('Failed to recycle database');
    }
  }

  @override
  Future<void> invalidateCaches() async {
    final result = await _apiClient.post<void>(
      CachesEndPoint.invalidate,
      fromJson: (_) {},
    );
    if (result is ApiFailure) {
      throw Exception('Failed to invalidate caches');
    }
  }

  @override
  Future<void> restartServer() async {
    final result = await _apiClient.post<void>(
      RestartEndPoint.root,
      fromJson: (_) {},
    );
    if (result is ApiFailure) {
      throw Exception('Failed to restart server');
    }
  }

  @override
  Future<void> testSiteURL() async {
    final result = await _apiClient.post<void>(
      SiteUrlEndPoint.test,
      fromJson: (_) {},
    );
    if (result is ApiFailure) {
      throw Exception('Failed to test site URL');
    }
  }

  @override
  Future<void> testEmail() async {
    final result = await _apiClient.post<void>(
      EmailEndPoint.test,
      fromJson: (_) {},
    );
    if (result is ApiFailure) {
      throw Exception('Failed to test email connection');
    }
  }

  @override
  Future<void> sendTestNotification() async {
    final result = await _apiClient.post<void>(
      NotificationsEndPoint.test,
      fromJson: (_) {},
    );
    if (result is ApiFailure) {
      throw Exception('Failed to send test notification');
    }
  }

  @override
  Future<void> testS3Connection() async {
    final result = await _apiClient.post<void>(
      FileEndPoint.s3Test,
      fromJson: (_) {},
    );
    if (result is ApiFailure) {
      throw Exception('Failed to test S3 connection');
    }
  }

  @override
  Future<void> testFileStoreConnection() async {
    final result = await _apiClient.post<void>(
      FileEndPoint.test,
      fromJson: (_) {},
    );
    if (result is ApiFailure) {
      throw Exception('Failed to test file store connection');
    }
  }

  @override
  Future<void> purgeElasticsearchIndexes() async {
    final result = await _apiClient.post<void>(
      ElasticsearchEndPoint.purgeIndexes,
      fromJson: (_) {},
    );
    if (result is ApiFailure) {
      throw Exception('Failed to purge Elasticsearch indexes');
    }
  }

  @override
  Future<void> testElasticsearch() async {
    final result = await _apiClient.post<void>(
      ElasticsearchEndPoint.test,
      fromJson: (_) {},
    );
    if (result is ApiFailure) {
      throw Exception('Failed to test Elasticsearch');
    }
  }

  @override
  Future<Map<String, dynamic>> getServerLimits() async {
    final result = await _apiClient.get<Map<String, dynamic>>(
      LimitsEndPoint.server,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to get server limits');
  }

  @override
  Future<List<LlmServiceModel>> getLLMServices() async {
    final result = await _apiClient.get<List<LlmServiceModel>>(
      LLMServicesEndPoint.root,
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => LlmServiceModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<LlmServiceModel>>) {
      return result.data;
    }
    throw Exception('Failed to get LLM services');
  }

  @override
  Future<List<AgentModel>> getAgents() async {
    final result = await _apiClient.get<List<AgentModel>>(
      AgentsEndPoint.root,
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => AgentModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<AgentModel>>) {
      return result.data;
    }
    throw Exception('Failed to get agents');
  }

  @override
  Future<List<AgentStatusModel>> getAgentsStatus() async {
    final result = await _apiClient.get<List<AgentStatusModel>>(
      AgentsEndPoint.status,
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => AgentStatusModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<AgentStatusModel>>) {
      return result.data;
    }
    throw Exception('Failed to get agents status');
  }

  @override
  Future<void> uploadBrandImage(String filePath) async {
    final result = await _apiClient.dio.post(
      BrandEndPoint.image,
      data: FormData.fromMap({'image': await MultipartFile.fromFile(filePath)}),
    );
    if (result.statusCode == null || result.statusCode! >= 400) {
      throw Exception('Failed to upload brand image');
    }
  }

  @override
  Future<void> removeBrandImage() async {
    final result = await _apiClient.delete(BrandEndPoint.image);
    if (result is ApiFailure) {
      throw Exception('Failed to remove brand image');
    }
  }

  @override
  Future<Map<String, dynamic>> ping() async {
    final result = await _apiClient.get<Map<String, dynamic>>(
      SystemEndPoint.ping,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Server ping failed');
  }

  @override
  Future<Map<String, dynamic>> getAppliedSchemaMigrations() async {
    final result = await _apiClient.get<Map<String, dynamic>>(
      SystemEndPoint.schemaVersion,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to get schema migrations');
  }

  @override
  Future<bool> getFirstAdminSetupComplete() async {
    final result = await _apiClient.get<Map<String, dynamic>>(
      SystemEndPoint.onboardingComplete,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return (result.data['complete'] as bool?) ?? false;
    }
    throw Exception('Failed to get first admin setup status');
  }

  @override
  Future<void> completeSetup() async {
    final result = await _apiClient.post<void>(
      SystemEndPoint.onboardingComplete,
      data: const {'complete': true, 'signup_form': 'email'},
      fromJson: (_) {},
    );
    if (result is ApiFailure) {
      throw Exception('Failed to complete setup');
    }
  }

  @override
  Future<List<NoticeModel>> getInProductNotices(String teamId) async {
    final result = await _apiClient.get<List<NoticeModel>>(
      SystemEndPoint.notices(teamId),
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => NoticeModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<NoticeModel>>) {
      return result.data;
    }
    throw Exception('Failed to get in-product notices');
  }

  @override
  Future<void> updateNoticesAsViewed(List<NoticeModel> notices) async {
    final result = await _apiClient.post<void>(
      SystemEndPoint.noticesView,
      data: notices.map((n) => n.toMap()).toList(),
      fromJson: (_) {},
    );
    if (result is ApiFailure) {
      throw Exception('Failed to update notices as viewed');
    }
  }

  @override
  Future<void> downloadLogs(String savePath) async {
    final response = await _apiClient.dio.download(
      LogsEndPoint.download,
      savePath,
    );
    if (response.statusCode == null || response.statusCode! >= 400) {
      throw Exception('Failed to download logs');
    }
  }

  @override
  Future<Map<String, dynamic>> migrateConfig(
    Map<String, dynamic> migrationData,
  ) async {
    final result = await _apiClient.post<Map<String, dynamic>>(
      ConfigEndPoint.migrate,
      data: migrationData,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to migrate config');
  }

  @override
  Future<InstallationModel> checkCWSConnection() async {
    final result = await _apiClient.get<InstallationModel>(
      CloudEndPoint.connection,
      fromJson: (json) =>
          InstallationModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<InstallationModel>) {
      return result.data;
    }
    throw Exception('Failed to check CWS connection');
  }

  @override
  Future<void> deleteAIBridgeTestHelper() async {
    await _apiClient.delete(SystemEndPoint.e2eAiBridge);
  }

  @override
  Future<void> generateSupportPacket(String savePath) async {
    await _apiClient.dio.download(SystemEndPoint.supportPacket, savePath);
  }

  @override
  Future<Map<String, dynamic>> getAIBridgeTestHelper() async {
    final result = await _apiClient.get<Map<String, dynamic>>(
      SystemEndPoint.e2eAiBridge,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to get AI bridge test helper');
  }

  @override
  Future<String> getLatestVersion() async {
    final result = await _apiClient.get<Map<String, dynamic>>(
      SystemEndPoint.latestVersion,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data['version'] as String? ?? '';
    }
    throw Exception('Failed to get latest version');
  }

  @override
  Future<Map<String, dynamic>> getLicenseLoadMetric() async {
    final result = await _apiClient.get<Map<String, dynamic>>(
      LicenseEndPoint.loadMetric,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to get license load metric');
  }

  @override
  Future<Map<String, dynamic>> getPrevTrialLicense() async {
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
  Future<bool> isAllowedToUpgradeToEnterprise() async {
    final result = await _apiClient.get<Map<String, dynamic>>(
      UpgradeToEnterpriseEndPoint.allowed,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data['allowed'] as bool? ?? false;
    }
    throw Exception('Failed to check if upgrade is allowed');
  }

  @override
  Future<void> manualTest() async {
    await _apiClient.get('${SystemEndPoint.root}test', fromJson: (_) {});
  }

  @override
  Future<void> postLog(Map<String, dynamic> log) async {
    await _apiClient.post<void>(LogsEndPoint.root, data: log, fromJson: (_) {});
  }

  @override
  Future<void> setAIBridgeTestHelper(Map<String, dynamic> data) async {
    await _apiClient.post<void>(
      SystemEndPoint.e2eAiBridge,
      data: data,
      fromJson: (_) {},
    );
  }

  @override
  Future<void> updateMarketplaceVisitedByAdmin() async {
    await _apiClient.post<void>(
      PluginsEndPoint.marketplaceVisited,
      fromJson: (_) {},
    );
  }
}
