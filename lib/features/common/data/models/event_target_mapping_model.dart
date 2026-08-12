import 'package:flutter_mattermost/features/common/domain/entities/event_target_mapping_entity.dart';

final class EventTargetMappingModel extends EventTargetMappingEntity {
  const EventTargetMappingModel({
    required super.assigned,
    required super.dismissed,
    required super.flagged,
    required super.removed,
  });

  factory EventTargetMappingModel.fromMap(Map<String, dynamic> map) {
    return EventTargetMappingModel(
      assigned: List<String>.from(map["assigned"] as List<dynamic>? ?? []),
      dismissed: List<String>.from(map["dismissed"] as List<dynamic>? ?? []),
      flagged: List<String>.from(map["flagged"] as List<dynamic>? ?? []),
      removed: List<String>.from(map["removed"] as List<dynamic>? ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "assigned": assigned,
      "dismissed": dismissed,
      "flagged": flagged,
      "removed": removed,
    };
  }

  factory EventTargetMappingModel.fromEntity(EventTargetMappingEntity entity) {
    return EventTargetMappingModel(
      assigned: entity.assigned,
      dismissed: entity.dismissed,
      flagged: entity.flagged,
      removed: entity.removed,
    );
  }

  @override
  EventTargetMappingModel copyWith({
    List<String>? assigned,
    List<String>? dismissed,
    List<String>? flagged,
    List<String>? removed,
  }) {
    return EventTargetMappingModel(
      assigned: assigned ?? this.assigned,
      dismissed: dismissed ?? this.dismissed,
      flagged: flagged ?? this.flagged,
      removed: removed ?? this.removed,
    );
  }

  EventTargetMappingEntity toEntity() => EventTargetMappingEntity(
        assigned: assigned,
        dismissed: dismissed,
        flagged: flagged,
        removed: removed,
      );
}
