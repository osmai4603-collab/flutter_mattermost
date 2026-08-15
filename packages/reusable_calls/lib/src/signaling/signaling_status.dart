/// Status lifecycle of WebRTC signaling transport.
enum SignalingStatus {
  disconnected,
  connecting,
  connected,
  reconnecting,
  error;

  bool get isConnected => this == SignalingStatus.connected;
}
