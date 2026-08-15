/// Encapsulates metadata and options for individual HTTP network requests.
class NetworkRequestOptions {
  final Map<String, dynamic>? queryParameters;
  final Map<String, String>? headers;
  final Duration? timeout;
  final bool? followRedirects;
  final Map<String, dynamic>? extra;

  const NetworkRequestOptions({
    this.queryParameters,
    this.headers,
    this.timeout,
    this.followRedirects,
    this.extra,
  });
}
