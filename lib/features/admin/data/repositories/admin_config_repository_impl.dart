import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/features/admin/data/datasources/admin_config_data_source.dart';
import 'package:flutter_mattermost/features/admin/data/models/log_entry_model.dart';
import 'package:flutter_mattermost/features/admin/domain/entities/analytics_entity.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_config_repository.dart';

@LazySingleton(as: AdminConfigRepository)
class AdminConfigRepositoryImpl implements AdminConfigRepository {
  final AdminConfigDataSource _dataSource;

  AdminConfigRepositoryImpl(this._dataSource);

  @override
  Future<Map<String, dynamic>> getConfig() => _dataSource.getConfig();

  @override
  Future<Map<String, dynamic>> updateConfig(Map<String, dynamic> config) =>
      _dataSource.updateConfig(config);

  @override
  Future<Map<String, dynamic>> patchConfig(Map<String, dynamic> patch) =>
      _dataSource.patchConfig(patch);

  @override
  Future<AnalyticsEntity> getAnalytics() => _dataSource.getAnalytics();

  @override
  Future<List<LogEntryModel>> getLogs({
    int page = 0,
    int perPage = 100,
    String? level,
    String? filter,
  }) => _dataSource.getLogs(
    page: page,
    perPage: perPage,
    level: level,
    filter: filter,
  );

  @override
  Future<void> testEmail() => _dataSource.testEmail();

  @override
  Future<void> testSiteURL() => _dataSource.testSiteURL();

  @override
  Future<void> sendTestNotification() => _dataSource.sendTestNotification();

  @override
  Future<void> reloadConfig() => _dataSource.reloadConfig();

  @override
  Future<Map<String, dynamic>> getServerLimits() =>
      _dataSource.getServerLimits();

  @override
  Future<void> downloadLogs(String savePath) =>
      _dataSource.downloadLogs(savePath);
}
