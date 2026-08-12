import 'package:flutter_mattermost/features/admin/data/models/marketplace_plugin_model.dart';
import 'package:flutter_mattermost/features/admin/domain/entities/plugin_entity.dart';

abstract class AdminPluginsRepository {
  Future<List<PluginEntity>> getInstalledPlugins();
  Future<List<MarketplacePluginModel>> getMarketplacePlugins({String? filter});
  Future<void> installPlugin(String id);
  Future<void> enablePlugin(String id);
  Future<void> disablePlugin(String id);
  Future<void> removePlugin(String id);
}
