import 'package:equatable/equatable.dart';

class RecapLimitStatusEntity extends Equatable {
  final Map<String, dynamic>? effective_limits;
  final Map<String, dynamic>? daily;
  final Map<String, dynamic>? cooldown;

  const RecapLimitStatusEntity({
    this.effective_limits,
    this.daily,
    this.cooldown,
  });

  @override
  List<Object?> get props => [
        effective_limits,
        daily,
        cooldown,
      ];

  RecapLimitStatusEntity copyWith({
    Map<String, dynamic>? effective_limits,
    Map<String, dynamic>? daily,
    Map<String, dynamic>? cooldown,
  }) {
    return RecapLimitStatusEntity(
      effective_limits: effective_limits ?? this.effective_limits,
      daily: daily ?? this.daily,
      cooldown: cooldown ?? this.cooldown,
    );
  }
}
