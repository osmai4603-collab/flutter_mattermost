import 'package:equatable/equatable.dart';

class ErrorEntity extends Equatable {
  final String? error;
  final String? details;

  const ErrorEntity({
    required this.error,
    required this.details,
  });

  @override
  List<Object?> get props => [
        error,
        details,
      ];

  ErrorEntity copyWith({
    String? error,
    String? details,
  }) {
    return ErrorEntity(
      error: error ?? this.error,
      details: details ?? this.details,
    );
  }
}
