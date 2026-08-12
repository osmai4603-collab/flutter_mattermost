import 'package:flutter_mattermost/core/enums/draft_type.dart';
import 'package:flutter_mattermost/features/chat/domain/entities/draft_entity.dart';

final class DraftModel extends DraftEntity {
  const DraftModel({
    required super.channelId,
    required super.rootId,
    required super.userId,
    required super.message,
    required super.type,
    required super.propsData,
    required super.fileIds,
    required super.metadata,
    required super.priority,
    required super.createAt,
    required super.updateAt,
    required super.deleteAt,
    required super.fileInfos,
    required super.uploadsInProgress,
  });

  factory DraftModel.fromMap(Map<String, dynamic> map) {
    return DraftModel(
      channelId: map["channel_id"] as String? ?? '',
      rootId: map["root_id"] as String? ?? '',
      userId: map["user_id"] as String? ?? '',
      message: map["message"] as String? ?? '',
      type: DraftType.fromValue(map["type"] as String?),
      propsData: Map<String, dynamic>.from(
        map["props"] as Map<String, dynamic>? ?? const {},
      ),
      fileIds: (map["file_ids"] as List<dynamic>? ?? [])
          .map((e) => e as String)
          .toList(),
      metadata: Map<String, dynamic>.from(
        map["metadata"] as Map<String, dynamic>? ?? const {},
      ),
      priority: Map<String, dynamic>.from(
        map["priority"] as Map<String, dynamic>? ?? const {},
      ),
      createAt: (map["create_at"] as num?)?.toInt() ?? 0,
      updateAt: (map["update_at"] as num?)?.toInt() ?? 0,
      deleteAt: (map["delete_at"] as num?)?.toInt() ?? 0,
      fileInfos: (map["file_infos"] as List<dynamic>? ?? [])
          .map((e) => Map<String, dynamic>.from(e as Map<String, dynamic>))
          .toList(),
      uploadsInProgress: (map["uploads_in_progress"] as List<dynamic>? ?? [])
          .map((e) => Map<String, dynamic>.from(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "channel_id": channelId,
      "root_id": rootId,
      "user_id": userId,
      "message": message,
      "type": type.value,
      "props": propsData,
      "file_ids": fileIds,
      "metadata": metadata,
      "priority": priority,
      "create_at": createAt,
      "update_at": updateAt,
      "delete_at": deleteAt,
      "file_infos": fileInfos,
      "uploads_in_progress": uploadsInProgress,
    };
  }

  factory DraftModel.fromEntity(DraftEntity entity) {
    return DraftModel(
      channelId: entity.channelId,
      rootId: entity.rootId,
      userId: entity.userId,
      message: entity.message,
      type: entity.type,
      propsData: entity.propsData,
      fileIds: entity.fileIds,
      metadata: entity.metadata,
      priority: entity.priority,
      createAt: entity.createAt,
      updateAt: entity.updateAt,
      deleteAt: entity.deleteAt,
      fileInfos: entity.fileInfos,
      uploadsInProgress: entity.uploadsInProgress,
    );
  }

  @override
  DraftModel copyWith({
    String? channelId,
    String? rootId,
    String? userId,
    String? message,
    DraftType? type,
    Map<String, dynamic>? propsData,
    List<String>? fileIds,
    Map<String, dynamic>? metadata,
    Map<String, dynamic>? priority,
    int? createAt,
    int? updateAt,
    int? deleteAt,
    List<Map<String, dynamic>>? fileInfos,
    List<Map<String, dynamic>>? uploadsInProgress,
  }) {
    return DraftModel(
      channelId: channelId ?? this.channelId,
      rootId: rootId ?? this.rootId,
      userId: userId ?? this.userId,
      message: message ?? this.message,
      type: type ?? this.type,
      propsData: propsData ?? this.propsData,
      fileIds: fileIds ?? this.fileIds,
      metadata: metadata ?? this.metadata,
      priority: priority ?? this.priority,
      createAt: createAt ?? this.createAt,
      updateAt: updateAt ?? this.updateAt,
      deleteAt: deleteAt ?? this.deleteAt,
      fileInfos: fileInfos ?? this.fileInfos,
      uploadsInProgress: uploadsInProgress ?? this.uploadsInProgress,
    );
  }

  DraftEntity toEntity() => DraftEntity(
        channelId: channelId,
        rootId: rootId,
        userId: userId,
        message: message,
        type: type,
        propsData: propsData,
        fileIds: fileIds,
        metadata: metadata,
        priority: priority,
        createAt: createAt,
        updateAt: updateAt,
        deleteAt: deleteAt,
        fileInfos: fileInfos,
        uploadsInProgress: uploadsInProgress,
      );
}