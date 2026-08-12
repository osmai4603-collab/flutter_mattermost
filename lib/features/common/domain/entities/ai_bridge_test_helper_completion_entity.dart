import 'package:equatable/equatable.dart';

class AIBridgeTestHelperCompletionEntity extends Equatable {
  final String? completion;
  final String? error;
  final int? status_code;

  const AIBridgeTestHelperCompletionEntity({
    this.completion,
    this.error,
    this.status_code,
  });

  @override
  List<Object?> get props => [
        completion,
        error,
        status_code,
      ];

  AIBridgeTestHelperCompletionEntity copyWith({
    String? completion,
    String? error,
    int? status_code,
  }) {
    return AIBridgeTestHelperCompletionEntity(
      completion: completion ?? this.completion,
      error: error ?? this.error,
      status_code: status_code ?? this.status_code,
    );
  }
}
