abstract class AppConfig {
  static const String appName = 'Mattermost Desktop';

  // ── بروتوكول الاتصال ────────────────────────────────
  /// تفعيل HTTPS/WSS للإنتاج. عند false يُستخدم HTTP/WS للتطوير المحلي.
  /// اتبع خطوات docs/server_setup_guide.md للتبديل إلى الإنتاج.
  static const bool useSSL = false;

  static const int defaultPort = 8065;
  static const int sslPort = 443;
  static int get activePort => useSSL ? sslPort : defaultPort;

  // عنوان خادم Mattermost.
  static const String host =
      '192.168.137.1'; // '127.0.0.1'; // 'mm.yourdomain.com' للإنتاج

  static String get defaultBaseUrl =>
      '${useSSL ? "https" : "http"}://$host${useSSL ? "" : ":$defaultPort"}/api/v4';

  static String get defaultWebSocketUrl =>
      '${useSSL ? "wss" : "ws"}://$host${useSSL ? "" : ":$defaultPort"}/api/v4/websocket';

  // ── إعدادات الاتصال العامة ──────────────────────────
  static const Duration connectionTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration webSocketPingInterval = Duration(seconds: 30);
  static const int maxRetryAttempts = 3;

  // ── WebSocket Reconnect ─────────────────────────────
  /// الحد الأقصى لمحاولات إعادة الاتصال المتتالية قبل التوقف.
  static const int maxWebSocketReconnectAttempts = 10;

  // ── إعدادات المكالمات (WebRTC) ──────────────────────
  static const String defaultStunServer = 'stun:stun.l.google.com:19302';
  // ⚠️ بيانات مؤقتة — استبدلها بقيم خادم coturn الفعلي قبل النشر (انظر
  // docs/server_setup_guide.md — إعداد coturn). اتركها null لتعطيل TURN.
  static const String? turnServerUrl = 'turn:turn.yourdomain.com:3478';
  static const String? turnUsername = 'mattermost-turn';
  static const String? turnPassword = 'CHANGE_ME_TURN_PASSWORD';
  static const int rtcdPort = 8443;
}
