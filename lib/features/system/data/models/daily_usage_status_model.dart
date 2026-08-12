import 'package:flutter_mattermost/features/system/domain/entities/daily_usage_status_entity.dart';

final class DailyUsageStatusModel extends DailyUsageStatusEntity {
  const DailyUsageStatusModel({
    required super.used,
    required super.limit,
    required super.reset_at,
  });

  factory DailyUsageStatusModel.fromMap(Map<String, dynamic> map) {
    return DailyUsageStatusModel(
      used: (map["used"] as num?)?.toInt(),
      limit: (map["limit"] as num?)?.toInt(),
      reset_at: (map["reset_at"] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "used": used,
      "limit": limit,
      "reset_at": reset_at,
    };
  }

  factory DailyUsageStatusModel.fromEntity(DailyUsageStatusEntity entity) {
    return DailyUsageStatusModel(
      used: entity.used,
      limit: entity.limit,
      reset_at: entity.reset_at,
    );
  }

  @override
  DailyUsageStatusModel copyWith({
    int? used,
    int? limit,
    int? reset_at,
  }) {
    return DailyUsageStatusModel(
      used: used ?? this.used,
      limit: limit ?? this.limit,
      reset_at: reset_at ?? this.reset_at,
    );
  }

  DailyUsageStatusEntity toEntity() => DailyUsageStatusEntity(
        used: used,
        limit: limit,
        reset_at: reset_at,
      );
}
