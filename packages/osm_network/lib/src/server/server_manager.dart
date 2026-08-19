import '../client/api_client.dart';

class ServerManager {
  final OsmApiClient _apiClient;
  String? _activeServerUrl;

  ServerManager(this._apiClient, {String? initialServerUrl})
      : _activeServerUrl = initialServerUrl ?? _apiClient.config.baseUrl;

  String get activeServerUrl => _activeServerUrl ?? _apiClient.config.baseUrl;

  Future<void> initialize({String? defaultUrl}) async {
    final targetUrl = defaultUrl ?? _activeServerUrl ?? _apiClient.config.baseUrl;
    _activeServerUrl = targetUrl;
    await _apiClient.updateBaseUrl(targetUrl);
  }

  Future<void> switchServer(String serverUrl) async {
    _activeServerUrl = serverUrl;
    await _apiClient.updateBaseUrl(serverUrl);
  }
}
