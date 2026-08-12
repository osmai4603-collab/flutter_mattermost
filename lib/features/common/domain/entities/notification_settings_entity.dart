import 'package:equatable/equatable.dart';

class NotificationSettingsEntity extends Equatable {
  final Map<String, dynamic>? EventTargetMapping;

  const NotificationSettingsEntity({
    required this.EventTargetMapping,
  });

  @override
  List<Object?> get props => [
        EventTargetMapping,
      ];

  NotificationSettingsEntity copyWith({
    Map<String, dynamic>? EventTargetMapping,
  }) {
    return NotificationSettingsEntity(
      EventTargetMapping: EventTargetMapping ?? this.EventTargetMapping,
    );
  }
}
