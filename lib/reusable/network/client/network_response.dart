/// Reusable HTTP response wrapper.
class NetworkResponse<T> {
  final T? data;
  final int statusCode;
  final String? statusMessage;
  final Map<String, List<String>> headers;

  const NetworkResponse({
    this.data,
    required this.statusCode,
    this.statusMessage,
    this.headers = const {},
  });

  bool get isSuccess => statusCode >= 200 && statusCode < 300;
}
