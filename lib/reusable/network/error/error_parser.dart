import 'package:flutter_mattermost/reusable/network/error/network_exception.dart';

/// Contract for parsing raw server error payloads into typed [NetworkException].
abstract class ErrorParser {
  /// Parses HTTP status code and response payload into a [NetworkException].
  NetworkException parse({
    required int? statusCode,
    required dynamic responseData,
    dynamic originalError,
  });
}

/// Default implementation of [ErrorParser] handling standard HTTP status codes
/// and extracting common message fields from JSON objects.
class DefaultErrorParser implements ErrorParser {
  const DefaultErrorParser();

  @override
  NetworkException parse({
    required int? statusCode,
    required dynamic responseData,
    dynamic originalError,
  }) {
    final extractedMessage = _extractMessage(responseData);

    if (statusCode == null) {
      return UnknownNetworkException(
        message: extractedMessage ?? 'An unknown network error occurred.',
        originalError: originalError,
      );
    }

    switch (statusCode) {
      case 400:
        return ValidationException(
          message: extractedMessage ?? 'Invalid request parameters.',
          errors: responseData is Map<String, dynamic> ? responseData : null,
          originalError: originalError,
        );
      case 401:
        return AuthException(
          message: extractedMessage ?? 'Unauthorized access or session expired.',
          originalError: originalError,
        );
      case 403:
        return PermissionException(
          message: extractedMessage ?? 'Access forbidden.',
          originalError: originalError,
        );
      case 404:
        return ResourceNotFoundException(
          message: extractedMessage ?? 'Resource not found.',
          originalError: originalError,
        );
      case 408:
        return TimeoutException(
          message: extractedMessage ?? 'Request timeout.',
          originalError: originalError,
        );
      default:
        if (statusCode >= 500) {
          return ServerException(
            statusCode: statusCode,
            message: extractedMessage ?? 'Server error ($statusCode)',
            originalError: originalError,
          );
        }
        return UnknownNetworkException(
          message: extractedMessage ?? 'Unexpected error occurred ($statusCode).',
          originalError: originalError,
        );
    }
  }

  String? _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      if (data.containsKey('message') && data['message'] != null) {
        return data['message'].toString();
      }
      if (data.containsKey('error') && data['error'] != null) {
        return data['error'].toString();
      }
      if (data.containsKey('detail') && data['detail'] != null) {
        return data['detail'].toString();
      }
    } else if (data is String && data.isNotEmpty) {
      return data;
    }
    return null;
  }
}
