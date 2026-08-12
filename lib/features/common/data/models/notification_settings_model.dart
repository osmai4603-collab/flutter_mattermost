import 'package:flutter_mattermost/features/common/domain/entities/notification_settings_entity.dart';

final class NotificationSettingsModel extends NotificationSettingsEntity {
  const NotificationSettingsModel({
    required super.EventTargetMapping,
  });

  factory NotificationSettingsModel.fromMap(Map<String, dynamic> map) {
    return NotificationSettingsModel(
      EventTargetMapping: map["EventTargetMapping"] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "EventTargetMapping": EventTargetMapping,
    };
  }

  factory NotificationSettingsModel.fromEntity(NotificationSettingsEntity entity) {
    return NotificationSettingsModel(
      EventTargetMapping: entity.EventTargetMapping,
    );
  }

  @override
  NotificationSettingsModel copyWith({
    Map<String, dynamic>? EventTargetMapping,
  }) {
    return NotificationSettingsModel(
      EventTargetMapping: EventTargetMapping ?? this.EventTargetMapping,
    );
  }

  NotificationSettingsEntity toEntity() => NotificationSettingsEntity(
        EventTargetMapping: EventTargetMapping,
      );
}
