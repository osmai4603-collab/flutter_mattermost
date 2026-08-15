import 'package:reusable_network/src/config/content_type.dart';

/// Configuration properties for initializing a network client.
class NetworkConfig {
  /// Base URL of the API endpoints.
  final String baseUrl;

  /// Maximum duration to establish a server connection.
  final Duration connectTimeout;

  /// Maximum duration to wait for receiving data from server.
  final Duration receiveTimeout;

  /// Maximum duration to wait for sending data to server.
  final Duration sendTimeout;

  /// Default HTTP headers included with every request.
  final Map<String, String> defaultHeaders;

  /// Maximum number of automatic retries on transient network errors.
  final int maxRetries;

  /// Enable logging of requests, responses, and errors.
  final bool enableLogging;

  const NetworkConfig({
    required this.baseUrl,
    this.connectTimeout = const Duration(seconds: 30),
    this.receiveTimeout = const Duration(seconds: 30),
    this.sendTimeout = const Duration(seconds: 30),
    this.defaultHeaders = const {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
    this.maxRetries = 3,
    this.enableLogging = true,
  });

  /// Factory for standard JSON configuration.
  factory NetworkConfig.json({
    required String baseUrl,
    Duration connectTimeout = const Duration(seconds: 30),
    Duration receiveTimeout = const Duration(seconds: 30),
    Map<String, String>? customHeaders,
    int maxRetries = 3,
    bool enableLogging = true,
  }) {
    return NetworkConfig(
      baseUrl: baseUrl,
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
      defaultHeaders: {
        'Content-Type': NetworkContentType.json.value,
        'Accept': NetworkAcceptType.json.value,
        ...?customHeaders,
      },
      maxRetries: maxRetries,
      enableLogging: enableLogging,
    );
  }

  /// Creates a copy of this config with modified properties.
  NetworkConfig copyWith({
    String? baseUrl,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Duration? sendTimeout,
    Map<String, String>? defaultHeaders,
    int? maxRetries,
    bool? enableLogging,
  }) {
    return NetworkConfig(
      baseUrl: baseUrl ?? this.baseUrl,
      connectTimeout: connectTimeout ?? this.connectTimeout,
      receiveTimeout: receiveTimeout ?? this.receiveTimeout,
      sendTimeout: sendTimeout ?? this.sendTimeout,
      defaultHeaders: defaultHeaders ?? this.defaultHeaders,
      maxRetries: maxRetries ?? this.maxRetries,
      enableLogging: enableLogging ?? this.enableLogging,
    );
  }
}
