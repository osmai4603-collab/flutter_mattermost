import 'dart:async';
import 'dart:math';
import 'package:flutter_mattermost/reusable/network/websocket/generic_web_socket_client.dart';
import 'package:flutter_mattermost/reusable/network/websocket/web_socket_config.dart';
import 'package:flutter_mattermost/reusable/network/websocket/web_socket_event.dart';
import 'package:flutter_mattermost/reusable/network/websocket/web_socket_status.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// Default implementation of [GenericWebSocketClient] using `web_socket_channel`.
class DefaultWebSocketClient implements GenericWebSocketClient {
  final WebSocketConfig config;

  WebSocketChannel? _channel;
  StreamSubscription? _channelSubscription;
  Timer? _reconnectTimer;
  Timer? _pingTimer;

  int _reconnectAttempts = 0;
  GenericWebSocketStatus _status = GenericWebSocketStatus.disconnected;

  final StreamController<GenericWebSocketStatus> _statusController =
      StreamController<GenericWebSocketStatus>.broadcast();
  final StreamController<GenericWebSocketEvent> _messageController =
      StreamController<GenericWebSocketEvent>.broadcast();

  DefaultWebSocketClient({required this.config});

  @override
  GenericWebSocketStatus get status => _status;

  @override
  Stream<GenericWebSocketStatus> get statusStream => _statusController.stream;

  @override
  Stream<GenericWebSocketEvent> get messageStream => _messageController.stream;

  @override
  Future<void> connect({Uri? url, Map<String, dynamic>? headers}) async {
    if (_status == GenericWebSocketStatus.connected ||
        _status == GenericWebSocketStatus.connecting) {
      return;
    }

    _updateStatus(
      _reconnectAttempts > 0
          ? GenericWebSocketStatus.reconnecting
          : GenericWebSocketStatus.connecting,
    );

    final targetUri = url ?? config.uri;

    try {
      _channel = WebSocketChannel.connect(
        targetUri,
      );

      await _channel?.ready;
      _reconnectAttempts = 0;
      _updateStatus(GenericWebSocketStatus.connected);
      _startHeartbeat();

      _channelSubscription = _channel?.stream.listen(
        (data) {
          _messageController.add(GenericWebSocketEvent(data: data));
        },
        onError: (error) {
          _updateStatus(GenericWebSocketStatus.error);
          _scheduleReconnect();
        },
        onDone: () {
          if (_status != GenericWebSocketStatus.disconnected) {
            _updateStatus(GenericWebSocketStatus.disconnected);
            _scheduleReconnect();
          }
        },
      );
    } catch (e) {
      _updateStatus(GenericWebSocketStatus.error);
      _scheduleReconnect();
    }
  }

  @override
  void send(dynamic message) {
    if (_status == GenericWebSocketStatus.connected && _channel != null) {
      _channel!.sink.add(message);
    }
  }

  @override
  Future<void> disconnect() async {
    _reconnectTimer?.cancel();
    _pingTimer?.cancel();
    await _channelSubscription?.cancel();
    await _channel?.sink.close();
    _channel = null;
    _updateStatus(GenericWebSocketStatus.disconnected);
  }

  void _startHeartbeat() {
    _pingTimer?.cancel();
    _pingTimer = Timer.periodic(config.pingInterval, (_) {
      if (_status == GenericWebSocketStatus.connected) {
        send('{"type":"ping"}');
      }
    });
  }

  void _scheduleReconnect() {
    _pingTimer?.cancel();
    _channelSubscription?.cancel();

    if (_reconnectAttempts >= config.maxReconnectAttempts) {
      _updateStatus(GenericWebSocketStatus.disconnected);
      return;
    }

    _reconnectAttempts++;
    final delaySeconds = pow(2, min(_reconnectAttempts, 5)).toInt();
    final delay = Duration(seconds: delaySeconds);

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(delay, () {
      connect();
    });
  }

  void _updateStatus(GenericWebSocketStatus newStatus) {
    if (_status != newStatus) {
      _status = newStatus;
      _statusController.add(_status);
    }
  }

  @override
  void dispose() {
    disconnect();
    _statusController.close();
    _messageController.close();
  }
}
