/// Connection state lifecycle for WebSocket connection.
enum GenericWebSocketStatus {
  disconnected,
  connecting,
  connected,
  reconnecting,
  error;

  bool get isConnected => this == GenericWebSocketStatus.connected;
  bool get isDisconnected => this == GenericWebSocketStatus.disconnected;
}
