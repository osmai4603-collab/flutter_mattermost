import 'package:equatable/equatable.dart';

class SubscriptionStatsEntity extends Equatable {
  final int? remaining_seats;
  final String? is_paid_tier;

  const SubscriptionStatsEntity({
    this.remaining_seats,
    this.is_paid_tier,
  });

  @override
  List<Object?> get props => [
        remaining_seats,
        is_paid_tier,
      ];

  SubscriptionStatsEntity copyWith({
    int? remaining_seats,
    String? is_paid_tier,
  }) {
    return SubscriptionStatsEntity(
      remaining_seats: remaining_seats ?? this.remaining_seats,
      is_paid_tier: is_paid_tier ?? this.is_paid_tier,
    );
  }
}
