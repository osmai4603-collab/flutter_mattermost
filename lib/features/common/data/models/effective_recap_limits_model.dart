import 'package:flutter_mattermost/features/common/domain/entities/effective_recap_limits_entity.dart';

final class EffectiveRecapLimitsModel extends EffectiveRecapLimitsEntity {
  const EffectiveRecapLimitsModel({
    required super.max_recaps_per_day,
    required super.max_scheduled_recaps,
    required super.max_channels_per_recap,
    required super.max_posts_per_recap,
    required super.max_tokens_per_recap,
    required super.max_posts_per_day,
    required super.cooldown_minutes,
    required super.source,
    required super.source_id,
  });

  factory EffectiveRecapLimitsModel.fromMap(Map<String, dynamic> map) {
    return EffectiveRecapLimitsModel(
      max_recaps_per_day: (map["max_recaps_per_day"] as num?)?.toInt(),
      max_scheduled_recaps: (map["max_scheduled_recaps"] as num?)?.toInt(),
      max_channels_per_recap: (map["max_channels_per_recap"] as num?)?.toInt(),
      max_posts_per_recap: (map["max_posts_per_recap"] as num?)?.toInt(),
      max_tokens_per_recap: (map["max_tokens_per_recap"] as num?)?.toInt(),
      max_posts_per_day: (map["max_posts_per_day"] as num?)?.toInt(),
      cooldown_minutes: (map["cooldown_minutes"] as num?)?.toInt(),
      source: map["source"] as String?,
      source_id: map["source_id"] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "max_recaps_per_day": max_recaps_per_day,
      "max_scheduled_recaps": max_scheduled_recaps,
      "max_channels_per_recap": max_channels_per_recap,
      "max_posts_per_recap": max_posts_per_recap,
      "max_tokens_per_recap": max_tokens_per_recap,
      "max_posts_per_day": max_posts_per_day,
      "cooldown_minutes": cooldown_minutes,
      "source": source,
      "source_id": source_id,
    };
  }

  factory EffectiveRecapLimitsModel.fromEntity(EffectiveRecapLimitsEntity entity) {
    return EffectiveRecapLimitsModel(
      max_recaps_per_day: entity.max_recaps_per_day,
      max_scheduled_recaps: entity.max_scheduled_recaps,
      max_channels_per_recap: entity.max_channels_per_recap,
      max_posts_per_recap: entity.max_posts_per_recap,
      max_tokens_per_recap: entity.max_tokens_per_recap,
      max_posts_per_day: entity.max_posts_per_day,
      cooldown_minutes: entity.cooldown_minutes,
      source: entity.source,
      source_id: entity.source_id,
    );
  }

  @override
  EffectiveRecapLimitsModel copyWith({
    int? max_recaps_per_day,
    int? max_scheduled_recaps,
    int? max_channels_per_recap,
    int? max_posts_per_recap,
    int? max_tokens_per_recap,
    int? max_posts_per_day,
    int? cooldown_minutes,
    String? source,
    String? source_id,
  }) {
    return EffectiveRecapLimitsModel(
      max_recaps_per_day: max_recaps_per_day ?? this.max_recaps_per_day,
      max_scheduled_recaps: max_scheduled_recaps ?? this.max_scheduled_recaps,
      max_channels_per_recap: max_channels_per_recap ?? this.max_channels_per_recap,
      max_posts_per_recap: max_posts_per_recap ?? this.max_posts_per_recap,
      max_tokens_per_recap: max_tokens_per_recap ?? this.max_tokens_per_recap,
      max_posts_per_day: max_posts_per_day ?? this.max_posts_per_day,
      cooldown_minutes: cooldown_minutes ?? this.cooldown_minutes,
      source: source ?? this.source,
      source_id: source_id ?? this.source_id,
    );
  }

  EffectiveRecapLimitsEntity toEntity() => EffectiveRecapLimitsEntity(
        max_recaps_per_day: max_recaps_per_day,
        max_scheduled_recaps: max_scheduled_recaps,
        max_channels_per_recap: max_channels_per_recap,
        max_posts_per_recap: max_posts_per_recap,
        max_tokens_per_recap: max_tokens_per_recap,
        max_posts_per_day: max_posts_per_day,
        cooldown_minutes: cooldown_minutes,
        source: source,
        source_id: source_id,
      );
}
