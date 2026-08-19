import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityMonitor {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  
  final StreamController<bool> _connectionChangeController = StreamController<bool>.broadcast();
  
  bool _hasConnection = false;
  final String checkHost;
  
  Stream<bool> get connectionChangeStream => _connectionChangeController.stream;
  bool get hasConnection => _hasConnection;

  ConnectivityMonitor({this.checkHost = 'google.com'}) {
    _initialize();
  }

  Future<void> _initialize() async {
    final result = await _connectivity.checkConnectivity();
    _checkConnection(result);
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_checkConnection);
  }

  Future<void> _checkConnection(List<ConnectivityResult> results) async {
    bool previousConnection = _hasConnection;

    if (results.contains(ConnectivityResult.none)) {
      _hasConnection = false;
    } else {
      _hasConnection = await _hasInternetAccess();
    }

    if (previousConnection != _hasConnection) {
      _connectionChangeController.add(_hasConnection);
    }
  }

  Future<bool> _hasInternetAccess() async {
    try {
      final result = await InternetAddress.lookup(checkHost);
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }

  void dispose() {
    _connectivitySubscription?.cancel();
    _connectionChangeController.close();
  }
}
