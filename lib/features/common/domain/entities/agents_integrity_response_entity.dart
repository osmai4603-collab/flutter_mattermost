import 'package:equatable/equatable.dart';

class AgentsIntegrityResponseEntity extends Equatable {
  final bool? available;
  final String? reason;

  const AgentsIntegrityResponseEntity({
    this.available,
    this.reason,
  });

  @override
  List<Object?> get props => [
        available,
        reason,
      ];

  AgentsIntegrityResponseEntity copyWith({
    bool? available,
    String? reason,
  }) {
    return AgentsIntegrityResponseEntity(
      available: available ?? this.available,
      reason: reason ?? this.reason,
    );
  }
}
