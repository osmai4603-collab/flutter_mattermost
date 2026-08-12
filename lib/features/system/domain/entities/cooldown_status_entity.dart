import 'package:equatable/equatable.dart';

class CooldownStatusEntity extends Equatable {
  final bool? is_active;
  final int? available_at;
  final int? retry_after_seconds;

  const CooldownStatusEntity({
    this.is_active,
    this.available_at,
    this.retry_after_seconds,
  });

  @override
  List<Object?> get props => [
        is_active,
        available_at,
        retry_after_seconds,
      ];

  CooldownStatusEntity copyWith({
    bool? is_active,
    int? available_at,
    int? retry_after_seconds,
  }) {
    return CooldownStatusEntity(
      is_active: is_active ?? this.is_active,
      available_at: available_at ?? this.available_at,
      retry_after_seconds: retry_after_seconds ?? this.retry_after_seconds,
    );
  }
}
