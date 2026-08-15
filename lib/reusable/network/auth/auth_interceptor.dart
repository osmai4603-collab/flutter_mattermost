import 'package:dio/dio.dart';
import 'package:flutter_mattermost/reusable/network/auth/auth_token_provider.dart';

/// Generic Interceptor that attaches Bearer tokens, cookies, and custom security headers
/// obtained via [AuthTokenProvider], and handles 401 Unauthorized session expiration.
class GenericAuthInterceptor extends Interceptor {
  final AuthTokenProvider _tokenProvider;

  GenericAuthInterceptor(this._tokenProvider);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final isUnauthenticated = _tokenProvider.unauthenticatedPaths.any(
      (path) => options.path.endsWith(path),
    );

    if (!isUnauthenticated) {
      final token = await _tokenProvider.getAuthToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }

      final cookies = await _tokenProvider.getCookies();
      if (cookies != null && cookies.isNotEmpty) {
        options.headers['Cookie'] = cookies;
      }

      final csrf = await _tokenProvider.getCsrfToken();
      if (csrf != null && csrf.isNotEmpty) {
        options.headers['X-CSRF-Token'] = csrf;
      }
    }

    options.headers['X-Requested-With'] = 'XMLHttpRequest';
    return handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      final refreshed = await _tokenProvider.refreshToken();
      if (!refreshed) {
        await _tokenProvider.onSessionExpired();
      }
    }
    return handler.next(err);
  }
}
