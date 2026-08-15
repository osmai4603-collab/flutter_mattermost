import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_mattermost/reusable/network/connectivity/connectivity_service.dart';

/// Default implementation of [ConnectivityService] using `connectivity_plus`
/// and optional socket ping for LAN or custom server reachability verification.
class DefaultConnectivityService implements ConnectivityService {
  final Connectivity _connectivity;
  final String? _pingHost;
  final int? _pingPort;

  StreamSubscription<List<ConnectivityResult>>? _subscription;
  final StreamController<bool> _controller = StreamController<bool>.broadcast();

  bool _hasConnection = false;

  @override
  bool get hasConnection => _hasConnection;

  @override
  Stream<bool> get onConnectivityChanged => _controller.stream;

  DefaultConnectivityService({
    Connectivity? connectivity,
    this._pingHost,
    this._pingPort,
  })  : _connectivity = connectivity ?? Connectivity() {
    _initialize();
  }

  Future<void> _initialize() async {
    final results = await _connectivity.checkConnectivity();
    await _checkResults(results);
    _subscription = _connectivity.onConnectivityChanged.listen(_checkResults);
  }

  Future<void> _checkResults(List<ConnectivityResult> results) async {
    final previousStatus = _hasConnection;

    if (results.contains(ConnectivityResult.none)) {
      _hasConnection = false;
    } else {
      _hasConnection = await _verifyReachability();
    }

    if (previousStatus != _hasConnection) {
      _controller.add(_hasConnection);
    }
  }

  Future<bool> _verifyReachability() async {
    final host = _pingHost;
    final port = _pingPort;
    if (host == null || port == null) {
      return true;
    }

    try {
      final socket = await Socket.connect(
        host,
        port,
      ).timeout(const Duration(seconds: 3));
      socket.destroy();
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> checkConnection() async {
    final results = await _connectivity.checkConnectivity();
    await _checkResults(results);
    return _hasConnection;
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _controller.close();
  }
}
