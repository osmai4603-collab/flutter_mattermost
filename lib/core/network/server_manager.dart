import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/app/config/app_config.dart';
import 'package:flutter_mattermost/core/network/api_client.dart';

@singleton
class ServerManager {
  final ApiClient _apiClient;

  String? _activeServerUrl;

  ServerManager(this._apiClient);

  String get activeServerUrl => _activeServerUrl ?? AppConfig.defaultBaseUrl;

  Future<void> initialize() async {
    // For now, load default or last saved server URL from storage
    _activeServerUrl = AppConfig.defaultBaseUrl;
    await _apiClient.updateBaseUrl(_activeServerUrl!);
  }

  Future<void> switchServer(String serverUrl) async {
    _activeServerUrl = serverUrl;
    await _apiClient.updateBaseUrl(serverUrl);
    // TODO: Switch active token based on server
  }
}
