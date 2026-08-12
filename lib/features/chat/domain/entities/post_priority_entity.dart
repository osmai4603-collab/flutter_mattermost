import 'package:equatable/equatable.dart';

class PostPriorityEntity extends Equatable {
  final String? priority;
  final bool? requested_ack;
  final bool? persistent_notifications;

  const PostPriorityEntity({
    this.priority,
    this.requested_ack,
    this.persistent_notifications,
  });

  @override
  List<Object?> get props => [
        priority,
        requested_ack,
        persistent_notifications,
      ];

  PostPriorityEntity copyWith({
    String? priority,
    bool? requested_ack,
    bool? persistent_notifications,
  }) {
    return PostPriorityEntity(
      priority: priority ?? this.priority,
      requested_ack: requested_ack ?? this.requested_ack,
      persistent_notifications: persistent_notifications ?? this.persistent_notifications,
    );
  }
}
