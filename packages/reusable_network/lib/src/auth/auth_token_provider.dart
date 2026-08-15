import 'dart:async';

/// Contract for providing authentication credentials to the network layer
/// and handling authorization life-cycle events.
abstract class AuthTokenProvider {
  /// Retrieves the current authentication bearer token.
  Future<String?> getAuthToken();

  /// Retrieves optional cookies string (if applicable).
  Future<String?> getCookies() async => null;

  /// Retrieves optional CSRF token (if applicable).
  Future<String?> getCsrfToken() async => null;

  /// List of relative paths or endpoints that should NOT include authentication headers.
  /// (e.g. ['/login', '/register']).
  List<String> get unauthenticatedPaths => const [];

  /// Callback triggered when server returns 401 Unauthorized or token is invalid/expired.
  Future<void> onSessionExpired();

  /// Optional token refresh logic. Returns `true` if refreshed successfully.
  Future<bool> refreshToken() async => false;
}
