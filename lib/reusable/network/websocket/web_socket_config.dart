/// Configuration settings for WebSocket connections.
class WebSocketConfig {
  /// Target WebSocket URI (e.g. `wss://example.com/ws`).
  final Uri uri;

  /// Headers to send during connection handshake.
  final Map<String, dynamic>? headers;

  /// Ping interval duration for sending heartbeat pings.
  final Duration pingInterval;

  /// Maximum auto-reconnect retry attempts.
  final int maxReconnectAttempts;

  /// Base delay between reconnect attempts.
  final Duration reconnectDelay;

  const WebSocketConfig({
    required this.uri,
    this.headers,
    this.pingInterval = const Duration(seconds: 30),
    this.maxReconnectAttempts = 10,
    this.reconnectDelay = const Duration(seconds: 2),
  });
}
