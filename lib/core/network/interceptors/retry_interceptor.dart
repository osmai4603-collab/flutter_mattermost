import 'dart:async';
import 'dart:math';
import 'package:dio/dio.dart';

class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int maxRetries;
  final Duration initialDelay;

  RetryInterceptor({
    required this.dio,
    this.maxRetries = 3,
    this.initialDelay = const Duration(milliseconds: 500),
  });

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final requestOptions = err.requestOptions;
    final retryCount = (requestOptions.extra['retry_count'] as int? ?? 0);

    if (_shouldRetry(err) && retryCount < maxRetries) {
      requestOptions.extra['retry_count'] = retryCount + 1;

      // Exponential backoff with jitter calculation
      final delayMs = (initialDelay.inMilliseconds * pow(2, retryCount))
          .toInt();
      final jitter = Random().nextInt(200);
      final totalDelay = Duration(milliseconds: delayMs + jitter);

      await Future.delayed(totalDelay);

      try {
        final response = await dio.fetch(requestOptions);
        return handler.resolve(response);
      } on DioException catch (retryErr) {
        return super.onError(retryErr, handler);
      }
    }

    return super.onError(err, handler);
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError ||
        (err.response != null && err.response!.statusCode! >= 500);
  }
}
