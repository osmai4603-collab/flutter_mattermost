import 'package:equatable/equatable.dart';

class EffectiveRecapLimitsEntity extends Equatable {
  final int? max_recaps_per_day;
  final int? max_scheduled_recaps;
  final int? max_channels_per_recap;
  final int? max_posts_per_recap;
  final int? max_tokens_per_recap;
  final int? max_posts_per_day;
  final int? cooldown_minutes;
  final String? source;
  final String? source_id;

  const EffectiveRecapLimitsEntity({
    this.max_recaps_per_day,
    this.max_scheduled_recaps,
    this.max_channels_per_recap,
    this.max_posts_per_recap,
    this.max_tokens_per_recap,
    this.max_posts_per_day,
    this.cooldown_minutes,
    this.source,
    this.source_id,
  });

  @override
  List<Object?> get props => [
        max_recaps_per_day,
        max_scheduled_recaps,
        max_channels_per_recap,
        max_posts_per_recap,
        max_tokens_per_recap,
        max_posts_per_day,
        cooldown_minutes,
        source,
        source_id,
      ];

  EffectiveRecapLimitsEntity copyWith({
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
    return EffectiveRecapLimitsEntity(
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
}
