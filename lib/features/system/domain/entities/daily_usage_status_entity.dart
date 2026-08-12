import 'package:equatable/equatable.dart';

class DailyUsageStatusEntity extends Equatable {
  final int? used;
  final int? limit;
  final int? reset_at;

  const DailyUsageStatusEntity({
    this.used,
    this.limit,
    this.reset_at,
  });

  @override
  List<Object?> get props => [
        used,
        limit,
        reset_at,
      ];

  DailyUsageStatusEntity copyWith({
    int? used,
    int? limit,
    int? reset_at,
  }) {
    return DailyUsageStatusEntity(
      used: used ?? this.used,
      limit: limit ?? this.limit,
      reset_at: reset_at ?? this.reset_at,
    );
  }
}
