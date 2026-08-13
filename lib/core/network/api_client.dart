import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/app/config/app_config.dart';
import 'package:flutter_mattermost/core/network/interceptors/auth_interceptor.dart';
import 'package:flutter_mattermost/core/network/interceptors/retry_interceptor.dart';
import 'package:flutter_mattermost/core/network/api_error.dart';
import 'package:flutter_mattermost/core/network/api_result.dart';
import 'package:flutter_mattermost/core/network/session_controller.dart';
import 'package:flutter_mattermost/core/storage/secure_storage_service.dart';

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

@lazySingleton
class ApiClient {
  late final Dio dio;
  final SecureStorageService _secureStorage;
  final SessionController _sessionController;

  ApiClient(
    this._secureStorage,
    this._sessionController, {
    ContentType contentType = .applicationJson,
    AcceptType acceptType = .applicationJson,
  }) {
    dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.defaultBaseUrl,
        connectTimeout: AppConfig.connectionTimeout,
        receiveTimeout: AppConfig.receiveTimeout,
        headers: {
          'Content-Type': contentType.value,
          'Accept': acceptType.value,
        },
      ),
    );

    dio.interceptors.addAll([
      AuthInterceptor(_secureStorage, _sessionController),
      RetryInterceptor(dio: dio, maxRetries: AppConfig.maxRetryAttempts),
      LogInterceptor(requestBody: true, responseBody: true, error: true),
    ]);
  }

  Future<void> updateBaseUrl(String newUrl) async {
    dio.options.baseUrl = newUrl;
  }

  Future<ApiResult<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    required T Function(dynamic) fromJson,
  }) async {
    try {
      final response = await dio.get(
        endpoint,
        queryParameters: queryParameters,
      );
      return ApiSuccess(fromJson(response.data));
    } on DioException catch (e) {
      return ApiFailure(_mapDioError(e));
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
      final response = await dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );
      return ApiSuccess(fromJson(response.data));
    } on DioException catch (e) {
      return ApiFailure(_mapDioError(e));
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
      final response = await dio.head(
        endpoint,
        queryParameters: queryParameters,
      );
      return ApiSuccess(fromJson(response.data));
    } on DioException catch (e) {
      return ApiFailure(_mapDioError(e));
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
      final response = await dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );
      return ApiSuccess(fromJson(response.data));
    } on DioException catch (e) {
      return ApiFailure(_mapDioError(e));
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
      final response = await dio.patch(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );
      return ApiSuccess(fromJson(response.data));
    } on DioException catch (e) {
      return ApiFailure(_mapDioError(e));
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
      await dio.delete(endpoint, queryParameters: queryParameters, data: data);
      return const ApiSuccess(null);
    } on DioException catch (e) {
      return ApiFailure(_mapDioError(e));
    } catch (e) {
      return ApiFailure(UnknownError(e));
    }
  }

  ApiError _mapDioError(DioException error) {
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
