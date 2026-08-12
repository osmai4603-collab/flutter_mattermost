import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/features/admin/data/datasources/admin_plugins_data_source.dart';
import 'package:flutter_mattermost/features/admin/data/models/marketplace_plugin_model.dart';
import 'package:flutter_mattermost/features/admin/domain/entities/plugin_entity.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_plugins_repository.dart';

@Injectable(as: AdminPluginsRepository)
class AdminPluginsRepositoryImpl implements AdminPluginsRepository {
  final AdminPluginsDataSource _dataSource;

  AdminPluginsRepositoryImpl(this._dataSource);

  @override
  Future<List<PluginEntity>> getInstalledPlugins() async {
    final results = await Future.wait([
      _dataSource.getActivePlugins(),
      _dataSource.getInactivePlugins(),
    ]);
    return [
      ...results[0].map((e) => e.toEntity()),
      ...results[1].map((e) => e.toEntity()),
    ];
  }

  @override
  Future<List<MarketplacePluginModel>> getMarketplacePlugins({String? filter}) =>
      _dataSource.getMarketplacePlugins(filter: filter);

  @override
  Future<void> installPlugin(String id) => _dataSource.installPluginFromUrl(id);

  @override
  Future<void> enablePlugin(String id) => _dataSource.enablePlugin(id);

  @override
  Future<void> disablePlugin(String id) => _dataSource.disablePlugin(id);

  @override
  Future<void> removePlugin(String id) => _dataSource.removePlugin(id);
}
