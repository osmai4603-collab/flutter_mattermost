/// Sealed base class for all network-related exceptions and errors.
sealed class NetworkException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic originalError;

  const NetworkException({
    required this.message,
    this.statusCode,
    this.originalError,
  });

  @override
  String toString() => '$runtimeType(statusCode: $statusCode, message: $message)';
}

/// Thrown when there is no internet connection or socket failure.
class ConnectionException extends NetworkException {
  const ConnectionException({
    super.message = 'No internet connection available.',
    super.originalError,
  });
}

/// Thrown when a request or connection times out.
class TimeoutException extends NetworkException {
  const TimeoutException({
    super.message = 'The request timed out. Please try again.',
    super.originalError,
  });
}

/// Thrown when authentication fails (401 Unauthorized).
class AuthException extends NetworkException {
  const AuthException({
    super.message = 'Authentication failed or session expired.',
    super.statusCode = 401,
    super.originalError,
  });
}

/// Thrown when permission is denied (403 Forbidden).
class PermissionException extends NetworkException {
  const PermissionException({
    super.message = 'Access denied. You do not have permission.',
    super.statusCode = 403,
    super.originalError,
  });
}

/// Thrown when a requested resource is not found (404 Not Found).
class ResourceNotFoundException extends NetworkException {
  const ResourceNotFoundException({
    super.message = 'The requested resource was not found.',
    super.statusCode = 404,
    super.originalError,
  });
}

/// Thrown when client sends invalid parameters or bad request body (400 Bad Request).
class ValidationException extends NetworkException {
  final Map<String, dynamic>? errors;

  const ValidationException({
    super.message = 'Invalid input parameters provided.',
    super.statusCode = 400,
    this.errors,
    super.originalError,
  });
}

/// Thrown when server responds with 5xx status codes.
class ServerException extends NetworkException {
  const ServerException({
    super.message = 'Internal server error occurred.',
    required super.statusCode,
    super.originalError,
  });
}

/// Thrown when client receives response with canceled status or client-side cancellation.
class RequestCanceledException extends NetworkException {
  const RequestCanceledException({
    super.message = 'The request was canceled.',
    super.originalError,
  });
}

/// Fallback for unexpected or unhandled exceptions.
class UnknownNetworkException extends NetworkException {
  const UnknownNetworkException({
    required super.message,
    super.originalError,
  });
}
