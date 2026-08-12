import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/network/api_client.dart';
import 'package:flutter_mattermost/core/network/api_result.dart';
import 'package:flutter_mattermost/core/endpoints/endpoints.dart';
import 'package:flutter_mattermost/features/admin/data/models/marketplace_plugin_model.dart';
import 'package:flutter_mattermost/features/admin/data/models/plugin_model.dart';
import 'package:flutter_mattermost/features/integrations/data/models/plugin_manifest_webapp_model.dart';
import 'package:flutter_mattermost/features/integrations/data/models/plugin_status_model.dart';

abstract class AdminPluginsDataSource {
  Future<List<PluginModel>> getActivePlugins();
  Future<List<PluginModel>> getInactivePlugins();
  Future<List<MarketplacePluginModel>> getMarketplacePlugins({
    String? filter,
    int page = 0,
    int perPage = 60,
  });
  Future<void> installPluginFromUrl(String url, {bool force = false});
  Future<void> enablePlugin(String id);
  Future<void> disablePlugin(String id);
  Future<void> removePlugin(String id);
  Future<Map<String, dynamic>> getPluginWebappStatus(String id);
  Future<List<PluginStatusModel>> getPluginsStatuses();
  Future<void> detachPlugin(String pluginId);
  Future<void> reattachPlugin();
  Future<void> markMarketplaceFirstAdminVisit();
  Future<List<PluginManifestWebappModel>> getPluginWebappManifest();

  // Missing operations from docs
  Future<bool> getMarketplaceVisitedByAdmin();
  Future<List<PluginManifestWebappModel>> getWebappPlugins();
  Future<void> installMarketplacePlugin(String id, String version);
  Future<void> uploadPlugin(String filePath);
}

@LazySingleton(as: AdminPluginsDataSource)
class AdminPluginsDataSourceImpl implements AdminPluginsDataSource {
  final ApiClient _apiClient;

  AdminPluginsDataSourceImpl(this._apiClient);

  @override
  Future<List<PluginModel>> getActivePlugins() async {
    final result = await _apiClient.get<Map<String, dynamic>>(
      PluginsEndPoint.root,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      final active = result.data['active'];
      if (active is List) {
        return active
            .map((e) => PluginModel.fromMap(e as Map<String, dynamic>, active: true))
            .toList();
      }
      return [];
    }
    throw Exception('Failed to get plugins');
  }

  @override
  Future<List<PluginModel>> getInactivePlugins() async {
    final result = await _apiClient.get<Map<String, dynamic>>(
      PluginsEndPoint.root,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      final inactive = result.data['inactive'];
      if (inactive is List) {
        return inactive
            .map((e) => PluginModel.fromMap(e as Map<String, dynamic>, active: false))
            .toList();
      }
      return [];
    }
    throw Exception('Failed to load plugins');
  }

  @override
  Future<List<MarketplacePluginModel>> getMarketplacePlugins({
    String? filter,
    int page = 0,
    int perPage = 60,
  }) async {
    final result = await _apiClient.get<List<MarketplacePluginModel>>(
      PluginsEndPoint.marketplace,
      queryParameters: {'filter': filter, 'page': page, 'per_page': perPage},
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => MarketplacePluginModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<MarketplacePluginModel>>) {
      return result.data;
    }
    throw Exception('Failed to load marketplace plugins');
  }

  @override
  Future<void> installPluginFromUrl(String id, {bool force = false}) async {
    final result = await _apiClient.post<void>(
      PluginsEndPoint.installFromUrl,
      data: {'plugin_id': id, 'force': force},
      fromJson: (_) {},
    );
    if (result is ApiFailure) {
      throw Exception('Failed to install plugin');
    }
  }

  @override
  Future<void> enablePlugin(String id) async {
    final result = await _apiClient.post<void>(
      PluginsEndPoint.enable(id),
      fromJson: (_) {},
    );
    if (result is ApiFailure) {
      throw Exception('Failed to enable plugin');
    }
  }

  @override
  Future<void> disablePlugin(String id) async {
    final result = await _apiClient.post<void>(
      PluginsEndPoint.disable(id),
      fromJson: (_) {},
    );
    if (result is ApiFailure) {
      throw Exception('Failed to disable plugin');
    }
  }

  @override
  Future<void> removePlugin(String id) async {
    final result = await _apiClient.delete(PluginsEndPoint.byPluginId(id));
    if (result is ApiFailure) {
      throw Exception('Failed to remove plugin');
    }
  }

  @override
  Future<Map<String, dynamic>> getPluginWebappStatus(String id) async {
    final result = await _apiClient.get<Map<String, dynamic>>(
      PluginsEndPoint.webappById(id),
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to get plugin webapp status');
  }

  @override
  Future<List<PluginStatusModel>> getPluginsStatuses() async {
    final result = await _apiClient.get<List<PluginStatusModel>>(
      PluginsEndPoint.statuses,
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => PluginStatusModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<PluginStatusModel>>) {
      return result.data;
    }
    throw Exception('Failed to get plugins statuses');
  }

  @override
  Future<void> detachPlugin(String pluginId) async {
    final result = await _apiClient.post<void>(
      PluginsEndPoint.detach(pluginId),
      fromJson: (_) {},
    );
    if (result is ApiFailure) {
      throw Exception('Failed to detach plugin');
    }
  }

  @override
  Future<void> reattachPlugin() async {
    final result = await _apiClient.post<void>(
      PluginsEndPoint.reattach,
      fromJson: (_) {},
    );
    if (result is ApiFailure) {
      throw Exception('Failed to reattach plugins');
    }
  }

  @override
  Future<void> markMarketplaceFirstAdminVisit() async {
    final result = await _apiClient.post<void>(
      PluginsEndPoint.marketplaceFirstAdminVisit,
      fromJson: (_) {},
    );
    if (result is ApiFailure) {
      throw Exception('Failed to mark marketplace visit');
    }
  }

  @override
  Future<List<PluginManifestWebappModel>> getPluginWebappManifest() async {
    final result = await _apiClient.get<List<PluginManifestWebappModel>>(
      PluginsEndPoint.webapp,
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => PluginManifestWebappModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<PluginManifestWebappModel>>) {
      return result.data;
    }
    throw Exception('Failed to get plugin webapp manifests');
  }

  @override
  Future<bool> getMarketplaceVisitedByAdmin() async {
    final result = await _apiClient.get<Map<String, dynamic>>(
      PluginsEndPoint.marketplaceVisited,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return (result.data['visited'] as bool?) ?? false;
    }
    throw Exception('Failed to check marketplace visited status');
  }

  @override
  Future<List<PluginManifestWebappModel>> getWebappPlugins() => getPluginWebappManifest();

  @override
  Future<void> installMarketplacePlugin(String id, String version) async {
    await _apiClient.post<void>(
      PluginsEndPoint.marketplace,
      data: {'id': id, 'version': version},
      fromJson: (_) {},
    );
  }

  @override
  Future<void> uploadPlugin(String filePath) async {
    final result = await _apiClient.dio.post(
      PluginsEndPoint.root,
      data: FormData.fromMap({'plugin': await MultipartFile.fromFile(filePath)}),
      options: Options(headers: {'Content-Type': 'multipart/form-data'}),
    );
    if (result.statusCode == null || result.statusCode! >= 400) {
      throw Exception('Failed to upload plugin');
    }
  }
}
