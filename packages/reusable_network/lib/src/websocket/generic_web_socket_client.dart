import 'dart:async';
import 'package:reusable_network/src/websocket/web_socket_event.dart';
import 'package:reusable_network/src/websocket/web_socket_status.dart';

/// Contract for general WebSocket operations.
abstract class GenericWebSocketClient {
  /// Current connection status.
  GenericWebSocketStatus get status;

  /// Stream of connection status changes.
  Stream<GenericWebSocketStatus> get statusStream;

  /// Stream of incoming raw WebSocket events.
  Stream<GenericWebSocketEvent> get messageStream;

  /// Establishes WebSocket connection.
  Future<void> connect({Uri? url, Map<String, dynamic>? headers});

  /// Sends a text message or serialized payload through WebSocket channel.
  void send(dynamic message);

  /// Closes connection gracefully.
  Future<void> disconnect();

  /// Releases controllers and subscriptions.
  void dispose();
}
