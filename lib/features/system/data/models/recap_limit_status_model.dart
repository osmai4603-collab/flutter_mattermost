import 'package:flutter_mattermost/features/system/domain/entities/recap_limit_status_entity.dart';

final class RecapLimitStatusModel extends RecapLimitStatusEntity {
  const RecapLimitStatusModel({
    required super.effective_limits,
    required super.daily,
    required super.cooldown,
  });

  factory RecapLimitStatusModel.fromMap(Map<String, dynamic> map) {
    return RecapLimitStatusModel(
      effective_limits: map["effective_limits"] as Map<String, dynamic>?,
      daily: map["daily"] as Map<String, dynamic>?,
      cooldown: map["cooldown"] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "effective_limits": effective_limits,
      "daily": daily,
      "cooldown": cooldown,
    };
  }

  factory RecapLimitStatusModel.fromEntity(RecapLimitStatusEntity entity) {
    return RecapLimitStatusModel(
      effective_limits: entity.effective_limits,
      daily: entity.daily,
      cooldown: entity.cooldown,
    );
  }

  @override
  RecapLimitStatusModel copyWith({
    Map<String, dynamic>? effective_limits,
    Map<String, dynamic>? daily,
    Map<String, dynamic>? cooldown,
  }) {
    return RecapLimitStatusModel(
      effective_limits: effective_limits ?? this.effective_limits,
      daily: daily ?? this.daily,
      cooldown: cooldown ?? this.cooldown,
    );
  }

  RecapLimitStatusEntity toEntity() => RecapLimitStatusEntity(
        effective_limits: effective_limits,
        daily: daily,
        cooldown: cooldown,
      );
}
