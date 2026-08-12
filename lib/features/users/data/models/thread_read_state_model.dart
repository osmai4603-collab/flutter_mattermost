import 'package:flutter_mattermost/features/users/domain/entities/thread_read_state_entity.dart';

final class ThreadReadStateModel extends ThreadReadStateEntity {
  const ThreadReadStateModel({
    required super.threadId,
    required super.timestamp,
  });

  factory ThreadReadStateModel.fromMap(Map<String, dynamic> data) {
    return ThreadReadStateModel(
      threadId: (data['thread_id'] ?? data['id'] ?? '').toString(),
      timestamp: (data['timestamp'] ?? data['last_viewed_at'] ?? 0).toInt(),
    );
  }

  factory ThreadReadStateModel.fromEntity(ThreadReadStateEntity entity) {
    return ThreadReadStateModel(
      threadId: entity.threadId,
      timestamp: entity.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'thread_id': threadId,
      'timestamp': timestamp,
    };
  }

  @override
  ThreadReadStateModel copyWith({
    String? threadId,
    int? timestamp,
  }) {
    return ThreadReadStateModel(
      threadId: threadId ?? this.threadId,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  ThreadReadStateEntity toEntity() => ThreadReadStateEntity(
    threadId: threadId,
    timestamp: timestamp,
  );
}