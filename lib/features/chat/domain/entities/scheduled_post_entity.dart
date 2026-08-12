import 'package:flutter_mattermost/core/entities/entity.dart';

class ScheduledPostEntity extends Entity {
  final String id;
  final int createAt;
  final int updateAt;
  final String userId;
  final String channelId;
  final String teamId;
  final String rootId;
  final String message;
  final Map<String, dynamic> propsData;
  final Map<String, dynamic> priority;
  final List<String> fileIds;
  final int scheduledAt;
  final int processedAt;
  final int deleteAt;
  final String error;
  final String errorCode;
  final Map<String, dynamic> metadata;

  const ScheduledPostEntity({
    this.id = '',
    this.createAt = 0,
    this.updateAt = 0,
    this.userId = '',
    this.channelId = '',
    this.teamId = '',
    this.rootId = '',
    this.message = '',
    this.propsData = const {},
    this.priority = const {},
    this.fileIds = const [],
    this.scheduledAt = 0,
    this.processedAt = 0,
    this.deleteAt = 0,
    this.error = '',
    this.errorCode = '',
    this.metadata = const {},
  });

  @override
  List<Object?> get props => [
        id,
        createAt,
        updateAt,
        userId,
        channelId,
        teamId,
        rootId,
        message,
        propsData,
        priority,
        fileIds,
        scheduledAt,
        processedAt,
        deleteAt,
        error,
        errorCode,
        metadata,
      ];

  @override
  ScheduledPostEntity copyWith({
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
    return ScheduledPostEntity(
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
}

