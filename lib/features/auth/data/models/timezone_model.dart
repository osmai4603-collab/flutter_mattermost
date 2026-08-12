import 'package:flutter_mattermost/features/auth/domain/entities/timezone_entity.dart';

final class TimezoneModel extends TimezoneEntity {
  const TimezoneModel({
    required super.useAutomaticTimezone,
    required super.manualTimezone,
    required super.automaticTimezone,
  });

  factory TimezoneModel.fromMap(Map<String, dynamic> map) {
    return TimezoneModel(
      useAutomaticTimezone: map["useAutomaticTimezone"] as String?,
      manualTimezone: map["manualTimezone"] as String?,
      automaticTimezone: map["automaticTimezone"] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "useAutomaticTimezone": useAutomaticTimezone,
      "manualTimezone": manualTimezone,
      "automaticTimezone": automaticTimezone,
    };
  }

  factory TimezoneModel.fromEntity(TimezoneEntity entity) {
    return TimezoneModel(
      useAutomaticTimezone: entity.useAutomaticTimezone,
      manualTimezone: entity.manualTimezone,
      automaticTimezone: entity.automaticTimezone,
    );
  }

  @override
  TimezoneModel copyWith({
    String? useAutomaticTimezone,
    String? manualTimezone,
    String? automaticTimezone,
  }) {
    return TimezoneModel(
      useAutomaticTimezone: useAutomaticTimezone ?? this.useAutomaticTimezone,
      manualTimezone: manualTimezone ?? this.manualTimezone,
      automaticTimezone: automaticTimezone ?? this.automaticTimezone,
    );
  }

  TimezoneEntity toEntity() => TimezoneEntity(
        useAutomaticTimezone: useAutomaticTimezone,
        manualTimezone: manualTimezone,
        automaticTimezone: automaticTimezone,
      );
}
