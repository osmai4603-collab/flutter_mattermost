import 'package:flutter_mattermost/core/entities/entity.dart';

class ThreadReadStateEntity extends Entity {
  const ThreadReadStateEntity({
    required this.threadId,
    required this.timestamp,
  });

  final String threadId;
  final int timestamp;

  @override
  List<Object?> get props => [threadId, timestamp];

  @override
  ThreadReadStateEntity copyWith({
    String? threadId,
    int? timestamp,
  }) {
    return ThreadReadStateEntity(
      threadId: threadId ?? this.threadId,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
