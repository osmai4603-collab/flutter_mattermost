import 'package:dio/dio.dart';
import '../auth/auth_delegate.dart';
import '../session/session_controller.dart';

class AuthInterceptor extends Interceptor {
  final OsmAuthDelegate _authDelegate;
  final SessionController? _sessionController;
  final List<String> unauthenticatedPaths;

  AuthInterceptor(
    this._authDelegate, {
    this._sessionController,
    this.unauthenticatedPaths = const ['/api/v4/users/login'],
  });

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final isUnauthenticated = unauthenticatedPaths.any(
      (p) => options.path.endsWith(p),
    );

    if (!isUnauthenticated) {
      final token = await _authDelegate.getAuthToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      final cookies = await _authDelegate.getCookies();
      if (cookies != null && cookies.isNotEmpty) {
        options.headers['Cookie'] = cookies;
        final csrf = await _authDelegate.getCsrfToken();
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
      await _authDelegate.onAuthenticationError();
      _sessionController?.emit(SessionEvent.expired);
    }
    handler.next(err);
  }
}
