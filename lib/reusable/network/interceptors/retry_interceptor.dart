import 'dart:async';
import 'dart:math';
import 'package:dio/dio.dart';

/// Function signature for evaluating whether an error should trigger a retry.
typedef RetryEvaluator = bool Function(DioException error);

/// Reusable Retry Interceptor with exponential backoff and jitter.
class GenericRetryInterceptor extends Interceptor {
  final Dio dio;
  final int maxRetries;
  final Duration initialDelay;
  final RetryEvaluator? retryEvaluator;

  GenericRetryInterceptor({
    required this.dio,
    this.maxRetries = 3,
    this.initialDelay = const Duration(milliseconds: 500),
    this.retryEvaluator,
  });

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final requestOptions = err.requestOptions;
    final retryCount = (requestOptions.extra['retry_count'] as int? ?? 0);

    final shouldRetry = retryEvaluator?.call(err) ?? _defaultShouldRetry(err);

    if (shouldRetry && retryCount < maxRetries) {
      requestOptions.extra['retry_count'] = retryCount + 1;

      // Exponential backoff calculation with jitter
      final delayMs = (initialDelay.inMilliseconds * pow(2, retryCount)).toInt();
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

  bool _defaultShouldRetry(DioException err) {
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError) {
      return true;
    }
    final statusCode = err.response?.statusCode;
    if (statusCode != null) {
      // Retry transient server errors (500, 502, 503, 504)
      return statusCode == 500 ||
          statusCode == 502 ||
          statusCode == 503 ||
          statusCode == 504;
    }
    return false;
  }
}
