import 'package:flutter_mattermost/features/system/domain/entities/cooldown_status_entity.dart';

final class CooldownStatusModel extends CooldownStatusEntity {
  const CooldownStatusModel({
    required super.is_active,
    required super.available_at,
    required super.retry_after_seconds,
  });

  factory CooldownStatusModel.fromMap(Map<String, dynamic> map) {
    return CooldownStatusModel(
      is_active: map["is_active"] as bool?,
      available_at: (map["available_at"] as num?)?.toInt(),
      retry_after_seconds: (map["retry_after_seconds"] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "is_active": is_active,
      "available_at": available_at,
      "retry_after_seconds": retry_after_seconds,
    };
  }

  factory CooldownStatusModel.fromEntity(CooldownStatusEntity entity) {
    return CooldownStatusModel(
      is_active: entity.is_active,
      available_at: entity.available_at,
      retry_after_seconds: entity.retry_after_seconds,
    );
  }

  @override
  CooldownStatusModel copyWith({
    bool? is_active,
    int? available_at,
    int? retry_after_seconds,
  }) {
    return CooldownStatusModel(
      is_active: is_active ?? this.is_active,
      available_at: available_at ?? this.available_at,
      retry_after_seconds: retry_after_seconds ?? this.retry_after_seconds,
    );
  }

  CooldownStatusEntity toEntity() => CooldownStatusEntity(
        is_active: is_active,
        available_at: available_at,
        retry_after_seconds: retry_after_seconds,
      );
}
