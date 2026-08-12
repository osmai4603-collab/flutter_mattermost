import 'package:flutter_mattermost/features/common/domain/entities/subscription_stats_entity.dart';

final class SubscriptionStatsModel extends SubscriptionStatsEntity {
  const SubscriptionStatsModel({
    required super.remaining_seats,
    required super.is_paid_tier,
  });

  factory SubscriptionStatsModel.fromMap(Map<String, dynamic> map) {
    return SubscriptionStatsModel(
      remaining_seats: (map["remaining_seats"] as num?)?.toInt(),
      is_paid_tier: map["is_paid_tier"] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "remaining_seats": remaining_seats,
      "is_paid_tier": is_paid_tier,
    };
  }

  factory SubscriptionStatsModel.fromEntity(SubscriptionStatsEntity entity) {
    return SubscriptionStatsModel(
      remaining_seats: entity.remaining_seats,
      is_paid_tier: entity.is_paid_tier,
    );
  }

  @override
  SubscriptionStatsModel copyWith({
    int? remaining_seats,
    String? is_paid_tier,
  }) {
    return SubscriptionStatsModel(
      remaining_seats: remaining_seats ?? this.remaining_seats,
      is_paid_tier: is_paid_tier ?? this.is_paid_tier,
    );
  }

  SubscriptionStatsEntity toEntity() => SubscriptionStatsEntity(
        remaining_seats: remaining_seats,
        is_paid_tier: is_paid_tier,
      );
}
