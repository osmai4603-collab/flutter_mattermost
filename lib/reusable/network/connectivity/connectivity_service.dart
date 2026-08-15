import 'dart:async';

/// Abstract interface for network connectivity monitoring.
abstract class ConnectivityService {
  /// Current connection status.
  bool get hasConnection;

  /// Stream emitting connectivity status changes (`true` for online, `false` for offline).
  Stream<bool> get onConnectivityChanged;

  /// Check internet or host reachability asynchronously.
  Future<bool> checkConnection();

  /// Dispose resources/subscriptions.
  void dispose();
}
