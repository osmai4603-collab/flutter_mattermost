import 'package:equatable/equatable.dart';

class AIBridgeTestHelperStatusEntity extends Equatable {
  final bool? available;
  final String? reason;

  const AIBridgeTestHelperStatusEntity({
    this.available,
    this.reason,
  });

  @override
  List<Object?> get props => [
        available,
        reason,
      ];

  AIBridgeTestHelperStatusEntity copyWith({
    bool? available,
    String? reason,
  }) {
    return AIBridgeTestHelperStatusEntity(
      available: available ?? this.available,
      reason: reason ?? this.reason,
    );
  }
}
