import 'package:dio/dio.dart';
import 'package:flutter_mattermost/reusable/network/auth/auth_interceptor.dart';
import 'package:flutter_mattermost/reusable/network/auth/auth_token_provider.dart';
import 'package:flutter_mattermost/reusable/network/client/network_client.dart';
import 'package:flutter_mattermost/reusable/network/client/network_request.dart';
import 'package:flutter_mattermost/reusable/network/config/network_config.dart';
import 'package:flutter_mattermost/reusable/network/error/error_parser.dart';
import 'package:flutter_mattermost/reusable/network/error/network_exception.dart';
import 'package:flutter_mattermost/reusable/network/interceptors/retry_interceptor.dart';
import 'package:flutter_mattermost/reusable/network/result/network_result.dart';

/// Default realization of [NetworkClient] powered by [Dio].
class DioNetworkClient implements NetworkClient {
  late final Dio _dio;
  final ErrorParser _errorParser;

  DioNetworkClient({
    required NetworkConfig config,
    AuthTokenProvider? tokenProvider,
    this._errorParser = const DefaultErrorParser(),
    List<Interceptor>? customInterceptors,
    Dio? dioOverride,
  }) {
    _dio =
        dioOverride ??
        Dio(
          BaseOptions(
            baseUrl: config.baseUrl,
            connectTimeout: config.connectTimeout,
            receiveTimeout: config.receiveTimeout,
            sendTimeout: config.sendTimeout,
            headers: config.defaultHeaders,
          ),
        );

    // Attach authentication interceptor if token provider is supplied
    if (tokenProvider != null) {
      _dio.interceptors.add(GenericAuthInterceptor(tokenProvider));
    }

    // Attach custom interceptors
    if (customInterceptors != null && customInterceptors.isNotEmpty) {
      _dio.interceptors.addAll(customInterceptors);
    }

    // Attach retry interceptor if maxRetries > 0
    if (config.maxRetries > 0) {
      _dio.interceptors.add(
        GenericRetryInterceptor(dio: _dio, maxRetries: config.maxRetries),
      );
    }

    // Attach logging interceptor if enabled
    if (config.enableLogging) {
      _dio.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true, error: true),
      );
    }
  }

  @override
  String get baseUrl => _dio.options.baseUrl;

  @override
  void updateBaseUrl(String newBaseUrl) {
    _dio.options.baseUrl = newBaseUrl;
  }

  @override
  Future<NetworkResult<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    NetworkRequestOptions? options,
    required T Function(dynamic json) fromJson,
  }) async {
    return _safeRequest(
      () => _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: _toDioOptions(options),
      ),
      fromJson: fromJson,
    );
  }

  @override
  Future<NetworkResult<T>> post<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    NetworkRequestOptions? options,
    required T Function(dynamic json) fromJson,
  }) async {
    return _safeRequest(
      () => _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: _toDioOptions(options),
      ),
      fromJson: fromJson,
    );
  }

  @override
  Future<NetworkResult<T>> put<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    NetworkRequestOptions? options,
    required T Function(dynamic json) fromJson,
  }) async {
    return _safeRequest(
      () => _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: _toDioOptions(options),
      ),
      fromJson: fromJson,
    );
  }

  @override
  Future<NetworkResult<T>> patch<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    NetworkRequestOptions? options,
    required T Function(dynamic json) fromJson,
  }) async {
    return _safeRequest(
      () => _dio.patch(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: _toDioOptions(options),
      ),
      fromJson: fromJson,
    );
  }

  @override
  Future<NetworkResult<T>> delete<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    NetworkRequestOptions? options,
    required T Function(dynamic json) fromJson,
  }) async {
    return _safeRequest(
      () => _dio.delete(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: _toDioOptions(options),
      ),
      fromJson: fromJson,
    );
  }

  @override
  Future<NetworkResult<T>> head<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    NetworkRequestOptions? options,
    required T Function(dynamic json) fromJson,
  }) async {
    return _safeRequest(
      () => _dio.head(
        endpoint,
        queryParameters: queryParameters,
        options: _toDioOptions(options),
      ),
      fromJson: fromJson,
    );
  }

  Future<NetworkResult<T>> _safeRequest<T>(
    Future<Response> Function() requestCall, {
    required T Function(dynamic json) fromJson,
  }) async {
    try {
      final response = await requestCall();
      final parsedData = fromJson(response.data);
      return NetworkSuccess(parsedData);
    } on DioException catch (e) {
      return NetworkFailure(_mapDioError(e));
    } catch (e) {
      return NetworkFailure(
        UnknownNetworkException(message: e.toString(), originalError: e),
      );
    }
  }

  NetworkException _mapDioError(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return TimeoutException(originalError: error);
    }
    if (error.type == DioExceptionType.connectionError) {
      return ConnectionException(originalError: error);
    }
    if (error.type == DioExceptionType.cancel) {
      return RequestCanceledException(originalError: error);
    }

    if (error.response != null) {
      return _errorParser.parse(
        statusCode: error.response?.statusCode,
        responseData: error.response?.data,
        originalError: error,
      );
    }

    return UnknownNetworkException(
      message: error.message ?? 'Unknown DioException occurred.',
      originalError: error,
    );
  }

  Options? _toDioOptions(NetworkRequestOptions? options) {
    if (options == null) return null;
    return Options(
      headers: options.headers,
      sendTimeout: options.timeout,
      receiveTimeout: options.timeout,
      followRedirects: options.followRedirects,
      extra: options.extra,
    );
  }
}
