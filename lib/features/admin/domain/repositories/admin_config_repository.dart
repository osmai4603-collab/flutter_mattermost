import 'package:flutter_mattermost/features/admin/data/models/log_entry_model.dart';
import 'package:flutter_mattermost/features/admin/domain/entities/analytics_entity.dart';

abstract class AdminConfigRepository {
  Future<Map<String, dynamic>> getConfig();
  Future<Map<String, dynamic>> updateConfig(Map<String, dynamic> config);
  Future<Map<String, dynamic>> patchConfig(Map<String, dynamic> patch);
  Future<AnalyticsEntity> getAnalytics({String? teamId});
  Future<List<String>> getPlainLogs({int page = 0, int perPage = 100});
  Future<List<LogEntryModel>> getLogs({
    int page = 0,
    int perPage = 100,
    String? level,
    String? filter,
  });
  Future<void> testEmail();
  Future<void> testSiteURL();
  Future<void> sendTestNotification();
  Future<void> reloadConfig();
  Future<Map<String, dynamic>> getServerLimits();
  Future<void> downloadLogs(String savePath);
  Future<String> getLatestVersion();
  Future<Map<String, dynamic>> ping();
  Future<void> testElasticsearch();
  Future<List<Map<String, dynamic>>> getDataRetentionPoliciesCount();
}
