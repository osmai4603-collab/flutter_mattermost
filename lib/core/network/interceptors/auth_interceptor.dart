import 'package:dio/dio.dart';
import 'package:flutter_mattermost/core/network/session_controller.dart';
import 'package:flutter_mattermost/core/storage/secure_storage_service.dart';

class AuthInterceptor extends Interceptor {
  final SecureStorageService _secureStorage;
  final SessionController _sessionController;

  AuthInterceptor(this._secureStorage, this._sessionController);

  /// Endpoints that should not carry session credentials (e.g. login sends its
  /// own credentials in the request body; stale cookies would confuse the server).
  static const _unauthenticatedPaths = ['/api/v4/users/login'];

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final isUnauthenticated = _unauthenticatedPaths.any(
      (p) => options.path.endsWith(p),
    );

    if (!isUnauthenticated) {
      final token = await _secureStorage.getAuthToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      final cookies = await _secureStorage.getCookies();
      if (cookies != null && cookies.isNotEmpty) {
        options.headers['Cookie'] = cookies;
        final csrf = await _secureStorage.getCsrfToken();
        if (csrf != null && csrf.isNotEmpty) {
          options.headers['X-CSRF-Token'] = csrf;
        }
      }
    }
    options.headers['X-Requested-With'] = 'XMLHttpRequest';
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      // Todo: Implement token refresh logic here when refresh tokens are saved.
      // For now, if 401 occurs, broadcast session expired.
      await _secureStorage.saveAuthToken('');
      _sessionController.emit(SessionEvent.expired);
    }
    handler.next(err);
  }
}
