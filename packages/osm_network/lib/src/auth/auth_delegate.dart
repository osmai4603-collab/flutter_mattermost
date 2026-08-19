import 'dart:async';

/// Abstract contract for authentication data retrieval and session handling.
abstract class OsmAuthDelegate {
  /// Retrieves the current bearer auth token, if available.
  Future<String?> getAuthToken();

  /// Retrieves current session cookies, if available.
  Future<String?> getCookies();

  /// Retrieves CSRF token, if available.
  Future<String?> getCsrfToken();

  /// Called when an authentication failure (e.g., 401 Unauthorized) occurs.
  Future<void> onAuthenticationError();
}
