/// Generic container for raw WebSocket messages.
class GenericWebSocketEvent {
  /// Raw message content (usually `String` or `List<int>`).
  final dynamic data;

  /// Time when event was received locally.
  final DateTime timestamp;

  GenericWebSocketEvent({
    required this.data,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  /// Attempts to parse raw data as JSON map, or returns null.
  Map<String, dynamic>? asJsonMap() {
    if (data is Map<String, dynamic>) return data as Map<String, dynamic>;
    return null;
  }
}
