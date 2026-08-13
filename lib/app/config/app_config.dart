abstract class AppConfig {
  static const String appName = 'Mattermost Desktop';
  static const String defaultBaseUrl = 'http://$host:8065/api/v4';
  // 'http://127.0.0.1:8065/api/v4';
  static const String defaultWebSocketUrl = 'ws://$host:8065/api/v4/websocket';

  static const host = '192.168.137.1'; // '127.0.0.1';

  static const Duration connectionTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration webSocketPingInterval = Duration(seconds: 30);
  static const int maxRetryAttempts = 3;
}
