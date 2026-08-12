import 'package:flutter_mattermost/features/chat/domain/entities/scheduled_post_entity.dart';

final class ScheduledPostModel extends ScheduledPostEntity {
  const ScheduledPostModel({
    super.id,
    super.createAt,
    super.updateAt,
    super.userId,
    super.channelId,
    super.teamId,
    super.rootId,
    super.message,
    super.propsData,
    super.priority,
    super.fileIds,
    super.scheduledAt,
    super.processedAt,
    super.deleteAt,
    super.error,
    super.errorCode,
    super.metadata,
  });

  factory ScheduledPostModel.fromMap(Map<String, dynamic> data) {
    return ScheduledPostModel(
      id: data['id'] ?? '',
      createAt: (data['create_at'] ?? 0).toInt(),
      updateAt: (data['update_at'] ?? 0).toInt(),
      userId: data['user_id'] ?? '',
      channelId: data['channel_id'] ?? '',
      teamId: data['team_id'] ?? '',
      rootId: data['root_id'] ?? '',
      message: data['message'] ?? '',
      propsData: Map<String, dynamic>.from(data['props'] ?? const {}),
      priority: Map<String, dynamic>.from(data['priority'] ?? const {}),
      fileIds: List<String>.from(data['file_ids'] ?? const []),
      scheduledAt: (data['scheduled_at'] ?? 0).toInt(),
      processedAt: (data['processed_at'] ?? 0).toInt(),
      deleteAt: (data['delete_at'] ?? 0).toInt(),
      error: data['error'] ?? '',
      errorCode: data['error_code'] ?? '',
      metadata: Map<String, dynamic>.from(data['metadata'] ?? const {}),
    );
  }

  factory ScheduledPostModel.fromEntity(ScheduledPostEntity entity) {
    return ScheduledPostModel(
      id: entity.id,
      createAt: entity.createAt,
      updateAt: entity.updateAt,
      userId: entity.userId,
      channelId: entity.channelId,
      teamId: entity.teamId,
      rootId: entity.rootId,
      message: entity.message,
      propsData: entity.propsData,
      priority: entity.priority,
      fileIds: entity.fileIds,
      scheduledAt: entity.scheduledAt,
      processedAt: entity.processedAt,
      deleteAt: entity.deleteAt,
      error: entity.error,
      errorCode: entity.errorCode,
      metadata: entity.metadata,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'create_at': createAt,
      'update_at': updateAt,
      'user_id': userId,
      'channel_id': channelId,
      'team_id': teamId,
      'root_id': rootId,
      'message': message,
      'props': propsData,
      'priority': priority,
      'file_ids': fileIds,
      'scheduled_at': scheduledAt,
      'processed_at': processedAt,
      'delete_at': deleteAt,
      'error': error,
      'error_code': errorCode,
      'metadata': metadata,
    };
  }

  @override
  ScheduledPostModel copyWith({
    String? id,
    int? createAt,
    int? updateAt,
    String? userId,
    String? channelId,
    String? teamId,
    String? rootId,
    String? message,
    Map<String, dynamic>? propsData,
    Map<String, dynamic>? priority,
    List<String>? fileIds,
    int? scheduledAt,
    int? processedAt,
    int? deleteAt,
    String? error,
    String? errorCode,
    Map<String, dynamic>? metadata,
  }) {
    return ScheduledPostModel(
      id: id ?? this.id,
      createAt: createAt ?? this.createAt,
      updateAt: updateAt ?? this.updateAt,
      userId: userId ?? this.userId,
      channelId: channelId ?? this.channelId,
      teamId: teamId ?? this.teamId,
      rootId: rootId ?? this.rootId,
      message: message ?? this.message,
      propsData: propsData ?? this.propsData,
      priority: priority ?? this.priority,
      fileIds: fileIds ?? this.fileIds,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      processedAt: processedAt ?? this.processedAt,
      deleteAt: deleteAt ?? this.deleteAt,
      error: error ?? this.error,
      errorCode: errorCode ?? this.errorCode,
      metadata: metadata ?? this.metadata,
    );
  }

  ScheduledPostEntity toEntity() {
    return ScheduledPostEntity(
      id: id,
      createAt: createAt,
      updateAt: updateAt,
      userId: userId,
      channelId: channelId,
      teamId: teamId,
      rootId: rootId,
      message: message,
      propsData: propsData,
      priority: priority,
      fileIds: fileIds,
      scheduledAt: scheduledAt,
      processedAt: processedAt,
      deleteAt: deleteAt,
      error: error,
      errorCode: errorCode,
      metadata: metadata,
    );
  }
}
