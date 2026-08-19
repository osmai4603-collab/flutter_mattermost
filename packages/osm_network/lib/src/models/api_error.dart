sealed class ApiError {
  const ApiError();
}

class NetworkError extends ApiError {
  const NetworkError();
}

class ServerError extends ApiError {
  final int code;
  final String message;
  const ServerError({required this.code, required this.message});
}

class AuthError extends ApiError {
  final String message;
  const AuthError([this.message = 'No access token provided']);
}

class ValidationError extends ApiError {
  final String message;
  const ValidationError(this.message);
}

class TimeoutError extends ApiError {
  const TimeoutError();
}

class PermissionError extends ApiError {
  final String message;
  const PermissionError(this.message);
}

class ResourceError extends ApiError {
  final String message;
  const ResourceError(this.message);
}

class FeatureError extends ApiError {
  final String message;
  const FeatureError(this.message);
}

class UnknownError extends ApiError {
  final Object error;
  const UnknownError(this.error);
}
