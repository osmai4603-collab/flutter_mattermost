import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../auth/auth_delegate.dart';

enum WebSocketStatus { disconnected, connecting, connected, error }

class OsmWebSocketClient {
  final OsmAuthDelegate authDelegate;
  final String Function() baseUrlProvider;
  
  WebSocketChannel? _channel;
  StreamSubscription? _subscription;
  
  final _statusController = StreamController<WebSocketStatus>.broadcast();
  WebSocketStatus _currentStatus = WebSocketStatus.disconnected;
  
  final _rawEventController = StreamController<Map<String, dynamic>>.broadcast();
  
  Timer? _reconnectTimer;
  Timer? _pingTimer;
  int _reconnectAttempts = 0;
  bool _isDisposed = false;
  bool _manualDisconnect = false;

  OsmWebSocketClient({
    required this.authDelegate,
    required this.baseUrlProvider,
  });

  Stream<WebSocketStatus> get statusStream => _statusController.stream;
  WebSocketStatus get currentStatus => _currentStatus;
  Stream<Map<String, dynamic>> get rawEventStream => _rawEventController.stream;

  Future<void> connect() async {
    if (_isDisposed || _currentStatus == WebSocketStatus.connecting || _currentStatus == WebSocketStatus.connected) {
      return;
    }

    _manualDisconnect = false;
    _updateStatus(WebSocketStatus.connecting);

    try {
      final token = await authDelegate.getAuthToken();
      if (token == null || token.isEmpty) {
        debugPrint('[OsmWebSocketClient] Cannot connect: No token available.');
        _updateStatus(WebSocketStatus.disconnected);
        return;
      }

      final baseUrl = baseUrlProvider();
      final wsUrl = _buildWebSocketUrl(baseUrl);
      debugPrint('[OsmWebSocketClient] Connecting to: $wsUrl');

      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));

      _subscription = _channel!.stream.listen(
        _onMessageReceived,
        onError: _onError,
        onDone: _onDone,
        cancelOnError: true,
      );

      _authenticate(token);
      _updateStatus(WebSocketStatus.connected);
      _reconnectAttempts = 0;
      _startPingTimer();

    } catch (e) {
      debugPrint('[OsmWebSocketClient] Connection error: $e');
      _updateStatus(WebSocketStatus.error);
      _scheduleReconnect();
    }
  }

  void _authenticate(String token) {
    send({
      'seq': 1,
      'action': 'authentication_challenge',
      'data': {'token': token},
    });
  }

  void send(Map<String, dynamic> data) {
    if (_channel != null && _currentStatus == WebSocketStatus.connected) {
      try {
        _channel!.sink.add(jsonEncode(data));
      } catch (e) {
        debugPrint('[OsmWebSocketClient] Error sending message: $e');
      }
    } else {
      debugPrint('[OsmWebSocketClient] Cannot send message: WebSocket not connected.');
    }
  }

  void _onMessageReceived(dynamic message) {
    try {
      if (message is String) {
        final data = jsonDecode(message);
        if (data is Map<String, dynamic>) {
          if (data['event'] == 'pong' || data['action'] == 'pong') {
            return;
          }
          _rawEventController.add(data);
        }
      }
    } catch (e) {
      debugPrint('[OsmWebSocketClient] Error decoding message: $e');
    }
  }

  void _onError(dynamic error) {
    debugPrint('[OsmWebSocketClient] WebSocket stream error: $error');
    _updateStatus(WebSocketStatus.error);
  }

  void _onDone() {
    debugPrint('[OsmWebSocketClient] WebSocket stream closed.');
    _updateStatus(WebSocketStatus.disconnected);
    _stopPingTimer();
    
    if (!_manualDisconnect && !_isDisposed) {
      _scheduleReconnect();
    }
  }

  void disconnect() {
    _manualDisconnect = true;
    _stopPingTimer();
    _reconnectTimer?.cancel();
    _subscription?.cancel();
    _subscription = null;
    _channel?.sink.close();
    _channel = null;
    _updateStatus(WebSocketStatus.disconnected);
  }

  void _scheduleReconnect() {
    if (_manualDisconnect || _isDisposed) return;

    _reconnectTimer?.cancel();
    _reconnectAttempts++;

    final delaySeconds = min(pow(2, _reconnectAttempts).toInt(), 30);
    debugPrint('[OsmWebSocketClient] Scheduling reconnect attempt #$_reconnectAttempts in $delaySeconds seconds...');

    _reconnectTimer = Timer(Duration(seconds: delaySeconds), () {
      if (!_manualDisconnect && !_isDisposed) {
        connect();
      }
    });
  }

  void _startPingTimer() {
    _stopPingTimer();
    _pingTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (_currentStatus == WebSocketStatus.connected) {
        send({'seq': 1, 'action': 'ping'});
      }
    });
  }

  void _stopPingTimer() {
    _pingTimer?.cancel();
    _pingTimer = null;
  }

  void _updateStatus(WebSocketStatus status) {
    if (_currentStatus != status) {
      _currentStatus = status;
      _statusController.add(status);
    }
  }

  String _buildWebSocketUrl(String baseUrl) {
    Uri uri = Uri.parse(baseUrl);
    final scheme = uri.scheme == 'https' ? 'wss' : 'ws';
    final path = uri.path.endsWith('/') ? '${uri.path}api/v4/websocket' : '${uri.path}/api/v4/websocket';
    return Uri(scheme: scheme, host: uri.host, port: uri.hasPort ? uri.port : null, path: path).toString();
  }

  void dispose() {
    _isDisposed = true;
    disconnect();
    _statusController.close();
    _rawEventController.close();
  }
}
