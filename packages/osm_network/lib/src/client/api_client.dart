import 'package:dio/dio.dart';
import '../config/network_config.dart';
import '../auth/auth_delegate.dart';
import '../session/session_controller.dart';
import '../models/api_error.dart';
import '../models/api_result.dart';
import '../interceptors/auth_interceptor.dart';
import '../interceptors/retry_interceptor.dart';

enum ContentType {
  applicationJson('application/json');

  final String value;
  const ContentType(this.value);
}

enum AcceptType {
  applicationJson('application/json');

  final String value;
  const AcceptType(this.value);
}

class OsmApiClient {
  late final Dio dio;
  final OsmAuthDelegate? _authDelegate;
  final SessionController? _sessionController;
  OsmNetworkConfig _config;

  OsmApiClient({
    required OsmNetworkConfig config,
    this._authDelegate,
    this._sessionController,
    List<Interceptor>? customInterceptors,
  }) : _config = config {
    dio = Dio(
      BaseOptions(
        baseUrl: config.baseUrl,
        connectTimeout: config.connectTimeout,
        receiveTimeout: config.receiveTimeout,
        headers: {
          'Content-Type': ContentType.applicationJson.value,
          'Accept': AcceptType.applicationJson.value,
          ...?config.defaultHeaders,
        },
      ),
    );

    if (_authDelegate != null) {
      dio.interceptors.add(
        AuthInterceptor(
          _authDelegate,
          sessionController: _sessionController,
          unauthenticatedPaths: config.unauthenticatedPaths,
        ),
      );
    }

    dio.interceptors.add(
      RetryInterceptor(dio: dio, maxRetries: config.maxRetries),
    );

    if (customInterceptors != null) {
      dio.interceptors.addAll(customInterceptors);
    }

    dio.interceptors.add(
      LogInterceptor(
        requestBody: false,
        responseBody: false,
        error: true,
        request: false,
        requestHeader: false,
        responseHeader: false,
        requestUrl: false,
        responseUrl: false,
      ),
    );
  }

  OsmNetworkConfig get config => _config;

  Future<void> updateBaseUrl(String newUrl) async {
    _config = _config.copyWith(baseUrl: newUrl);
    dio.options.baseUrl = newUrl;
  }

  String resolveEndpoint(String endpoint) {
    if (endpoint.startsWith('http://') || endpoint.startsWith('https://')) {
      return endpoint;
    }
    if (endpoint.startsWith('/plugins/com.') ||
        endpoint.startsWith('/plugins/playbooks/') ||
        endpoint.startsWith('plugins/com.') ||
        endpoint.startsWith('plugins/playbooks/')) {
      final formattedEndpoint = endpoint.startsWith('/')
          ? endpoint
          : '/$endpoint';
      final baseUri = Uri.parse(dio.options.baseUrl);
      return '${baseUri.origin}$formattedEndpoint';
    }
    return endpoint;
  }

  Future<ApiResult<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    required T Function(dynamic) fromJson,
  }) async {
    try {
      final resolvedUrl = resolveEndpoint(endpoint);
      final response = await dio.get(
        resolvedUrl,
        queryParameters: queryParameters,
      );
      return ApiSuccess(fromJson(response.data));
    } on DioException catch (e) {
      return ApiFailure(mapDioError(e));
    } catch (e) {
      return ApiFailure(UnknownError(e));
    }
  }

  Future<ApiResult<T>> post<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    required T Function(dynamic) fromJson,
  }) async {
    try {
      final resolvedUrl = resolveEndpoint(endpoint);
      final response = await dio.post(
        resolvedUrl,
        data: data,
        queryParameters: queryParameters,
      );
      return ApiSuccess(fromJson(response.data));
    } on DioException catch (e) {
      return ApiFailure(mapDioError(e));
    } catch (e) {
      return ApiFailure(UnknownError(e));
    }
  }

  Future<ApiResult<T>> head<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    required T Function(dynamic) fromJson,
  }) async {
    try {
      final resolvedUrl = resolveEndpoint(endpoint);
      final response = await dio.head(
        resolvedUrl,
        queryParameters: queryParameters,
      );
      return ApiSuccess(fromJson(response.data));
    } on DioException catch (e) {
      return ApiFailure(mapDioError(e));
    } catch (e) {
      return ApiFailure(UnknownError(e));
    }
  }

  Future<ApiResult<T>> put<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    required T Function(dynamic) fromJson,
  }) async {
    try {
      final resolvedUrl = resolveEndpoint(endpoint);
      final response = await dio.put(
        resolvedUrl,
        data: data,
        queryParameters: queryParameters,
      );
      return ApiSuccess(fromJson(response.data));
    } on DioException catch (e) {
      return ApiFailure(mapDioError(e));
    } catch (e) {
      return ApiFailure(UnknownError(e));
    }
  }

  Future<ApiResult<T>> patch<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    required T Function(dynamic) fromJson,
  }) async {
    try {
      final resolvedUrl = resolveEndpoint(endpoint);
      final response = await dio.patch(
        resolvedUrl,
        data: data,
        queryParameters: queryParameters,
      );
      return ApiSuccess(fromJson(response.data));
    } on DioException catch (e) {
      return ApiFailure(mapDioError(e));
    } catch (e) {
      return ApiFailure(UnknownError(e));
    }
  }

  Future<ApiResult<void>> delete(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    dynamic data,
  }) async {
    try {
      final resolvedUrl = resolveEndpoint(endpoint);
      await dio.delete(
        resolvedUrl,
        queryParameters: queryParameters,
        data: data,
      );
      return const ApiSuccess(null);
    } on DioException catch (e) {
      return ApiFailure(mapDioError(e));
    } catch (e) {
      return ApiFailure(UnknownError(e));
    }
  }

  ApiError mapDioError(DioException error) {
    if (error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout) {
      return const NetworkError();
    }
    if (error.response != null) {
      final statusCode = error.response!.statusCode ?? 500;
      if (statusCode == 401) {
        return const AuthError();
      }
      if (statusCode == 302) {
        return const ValidationError(
          "Login successful, it'll redirect to login page to perform the autologin",
        );
      }
      if (statusCode == 403) {
        return const PermissionError(
          'You do not have permission to perform this action',
        );
      }
      if (statusCode == 404) {
        return const ResourceError('Resource not found');
      }
      if (statusCode == 501) {
        return const FeatureError('Feature is disabled');
      }
      if (statusCode == 400) {
        final message =
            error.response?.data?['message']?.toString() ?? 'Bad Request';
        return ValidationError(
          'Invalid or missing parameters in URL or request body\n$message',
        );
      }
      return ServerError(
        code: statusCode,
        message: error.response?.statusMessage ?? 'Server Error',
      );
    }
    return UnknownError(error);
  }
}
