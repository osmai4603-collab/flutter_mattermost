import 'package:dio/dio.dart';
import 'package:flutter_mattermost/reusable/network/connectivity/connectivity_service.dart';

/// Interceptor that rejects outgoing requests when device has no network connection.
class GenericConnectivityInterceptor extends Interceptor {
  final ConnectivityService _connectivityService;

  GenericConnectivityInterceptor(this._connectivityService);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final isConnected = await _connectivityService.checkConnection();
    if (!isConnected) {
      return handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.connectionError,
          error: 'No internet or network connection available.',
        ),
      );
    }
    return handler.next(options);
  }
}
