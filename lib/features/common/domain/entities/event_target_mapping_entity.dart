import 'package:equatable/equatable.dart';

class EventTargetMappingEntity extends Equatable {
  final List<String>? assigned;
  final List<String>? dismissed;
  final List<String>? flagged;
  final List<String>? removed;

  const EventTargetMappingEntity({
    required this.assigned,
    required this.dismissed,
    required this.flagged,
    required this.removed,
  });

  @override
  List<Object?> get props => [
        assigned,
        dismissed,
        flagged,
        removed,
      ];

  EventTargetMappingEntity copyWith({
    List<String>? assigned,
    List<String>? dismissed,
    List<String>? flagged,
    List<String>? removed,
  }) {
    return EventTargetMappingEntity(
      assigned: assigned ?? this.assigned,
      dismissed: dismissed ?? this.dismissed,
      flagged: flagged ?? this.flagged,
      removed: removed ?? this.removed,
    );
  }
}
