import 'package:flutter_mattermost/reusable/network/error/network_exception.dart';

/// Represents the result of a network operation.
///
/// Can be either [NetworkSuccess] containing [data] of type [T]
/// or [NetworkFailure] containing a [NetworkException].
sealed class NetworkResult<T> {
  const NetworkResult();

  /// Returns `true` if the result is [NetworkSuccess].
  bool get isSuccess => this is NetworkSuccess<T>;

  /// Returns `true` if the result is [NetworkFailure].
  bool get isFailure => this is NetworkFailure<T>;

  /// Extracts the data if [NetworkSuccess], or `null` if [NetworkFailure].
  T? getOrNull() {
    return switch (this) {
      NetworkSuccess<T>(:final data) => data,
      NetworkFailure<T>() => null,
    };
  }

  /// Extracts the error if [NetworkFailure], or `null` if [NetworkSuccess].
  NetworkException? exceptionOrNull() {
    return switch (this) {
      NetworkSuccess<T>() => null,
      NetworkFailure<T>(:final exception) => exception,
    };
  }

  /// Transforms [NetworkSuccess] data using [transform].
  NetworkResult<R> map<R>(R Function(T data) transform) {
    return switch (this) {
      NetworkSuccess<T>(:final data) => NetworkSuccess(transform(data)),
      NetworkFailure<T>(:final exception) => NetworkFailure(exception),
    };
  }

  /// Functional fold to handle both success and failure cases.
  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(NetworkException exception) onFailure,
  }) {
    return switch (this) {
      NetworkSuccess<T>(:final data) => onSuccess(data),
      NetworkFailure<T>(:final exception) => onFailure(exception),
    };
  }

  /// Pattern matching handler for success and failure cases.
  R when<R>({
    required R Function(T data) success,
    required R Function(NetworkException exception) failure,
  }) {
    return fold(onSuccess: success, onFailure: failure);
  }
}

/// Successful network operation result wrapper.
class NetworkSuccess<T> extends NetworkResult<T> {
  final T data;

  const NetworkSuccess(this.data);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NetworkSuccess<T> &&
          runtimeType == other.runtimeType &&
          data == other.data;

  @override
  int get hashCode => data.hashCode;

  @override
  String toString() => 'NetworkSuccess(data: $data)';
}

/// Failed network operation result wrapper.
class NetworkFailure<T> extends NetworkResult<T> {
  final NetworkException exception;

  const NetworkFailure(this.exception);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NetworkFailure<T> &&
          runtimeType == other.runtimeType &&
          exception == other.exception;

  @override
  int get hashCode => exception.hashCode;

  @override
  String toString() => 'NetworkFailure(exception: $exception)';
}
