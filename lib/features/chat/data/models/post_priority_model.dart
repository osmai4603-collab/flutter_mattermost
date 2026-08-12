import 'package:flutter_mattermost/features/chat/domain/entities/post_priority_entity.dart';

final class PostPriorityModel extends PostPriorityEntity {
  const PostPriorityModel({
    required super.priority,
    required super.requested_ack,
    required super.persistent_notifications,
  });

  factory PostPriorityModel.fromMap(Map<String, dynamic> map) {
    return PostPriorityModel(
      priority: map["priority"] as String?,
      requested_ack: map["requested_ack"] as bool?,
      persistent_notifications: map["persistent_notifications"] as bool?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "priority": priority,
      "requested_ack": requested_ack,
      "persistent_notifications": persistent_notifications,
    };
  }

  factory PostPriorityModel.fromEntity(PostPriorityEntity entity) {
    return PostPriorityModel(
      priority: entity.priority,
      requested_ack: entity.requested_ack,
      persistent_notifications: entity.persistent_notifications,
    );
  }

  @override
  PostPriorityModel copyWith({
    String? priority,
    bool? requested_ack,
    bool? persistent_notifications,
  }) {
    return PostPriorityModel(
      priority: priority ?? this.priority,
      requested_ack: requested_ack ?? this.requested_ack,
      persistent_notifications: persistent_notifications ?? this.persistent_notifications,
    );
  }

  PostPriorityEntity toEntity() => PostPriorityEntity(
        priority: priority,
        requested_ack: requested_ack,
        persistent_notifications: persistent_notifications,
      );
}
