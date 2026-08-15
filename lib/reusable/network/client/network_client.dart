import 'package:flutter_mattermost/reusable/network/client/network_request.dart';
import 'package:flutter_mattermost/reusable/network/result/network_result.dart';

/// Abstract contract for performing HTTP operations.
abstract class NetworkClient {
  /// Base URL of the API.
  String get baseUrl;

  /// Updates base URL dynamically (e.g. server switching).
  void updateBaseUrl(String newBaseUrl);

  /// Executes an HTTP GET request.
  Future<NetworkResult<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    NetworkRequestOptions? options,
    required T Function(dynamic json) fromJson,
  });

  /// Executes an HTTP POST request.
  Future<NetworkResult<T>> post<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    NetworkRequestOptions? options,
    required T Function(dynamic json) fromJson,
  });

  /// Executes an HTTP PUT request.
  Future<NetworkResult<T>> put<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    NetworkRequestOptions? options,
    required T Function(dynamic json) fromJson,
  });

  /// Executes an HTTP PATCH request.
  Future<NetworkResult<T>> patch<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    NetworkRequestOptions? options,
    required T Function(dynamic json) fromJson,
  });

  /// Executes an HTTP DELETE request.
  Future<NetworkResult<T>> delete<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    NetworkRequestOptions? options,
    required T Function(dynamic json) fromJson,
  });

  /// Executes an HTTP HEAD request.
  Future<NetworkResult<T>> head<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    NetworkRequestOptions? options,
    required T Function(dynamic json) fromJson,
  });
}
