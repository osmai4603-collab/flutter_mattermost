import 'package:flutter_mattermost/core/enums/post_type.dart';
import 'package:flutter_mattermost/features/chat/domain/entities/post_entity.dart';
import 'package:flutter_mattermost/features/chat/domain/entities/post_metadata_entity.dart';
import 'package:flutter_mattermost/features/chat/data/models/post_metadata_model.dart';

final class PostModel extends PostEntity {
  const PostModel({
    required super.id,
    required super.createAt,
    required super.updateAt,
    required super.deleteAt,
    required super.editAt,
    required super.userId,
    required super.channelId,
    required super.rootId,
    required super.originalId,
    required super.message,
    required super.type,
    required super.propsData,
    required super.hashtag,
    required super.fileIds,
    required super.pendingPostId,
    super.metadata,
  });

  factory PostModel.fromMap(Map<String, dynamic> data) {
    return PostModel(
      id: data['id'] ?? '',
      createAt: (data['create_at'] ?? 0).toInt(),
      updateAt: (data['update_at'] ?? 0).toInt(),
      deleteAt: (data['delete_at'] ?? 0).toInt(),
      editAt: (data['edit_at'] ?? 0).toInt(),
      userId: data['user_id'] ?? '',
      channelId: data['channel_id'] ?? '',
      rootId: data['root_id'] ?? '',
      originalId: data['original_id'] ?? '',
      message: data['message'] ?? '',
      type: PostType.fromValue(data['type']),
      propsData: Map<String, dynamic>.from(data['props'] ?? const {}),
      hashtag: data['hashtag'] ?? '',
      fileIds: List<String>.from(data['file_ids'] ?? const []),
      pendingPostId: data['pending_post_id'] ?? '',
      metadata: data['metadata'] != null
          ? PostMetadataModel.fromMap(data['metadata'] as Map<String, dynamic>)
          : null,
    );
  }

  factory PostModel.fromEntity(PostEntity entity) {
    return PostModel(
      id: entity.id,
      createAt: entity.createAt,
      updateAt: entity.updateAt,
      deleteAt: entity.deleteAt,
      editAt: entity.editAt,
      userId: entity.userId,
      channelId: entity.channelId,
      rootId: entity.rootId,
      originalId: entity.originalId,
      message: entity.message,
      type: entity.type,
      propsData: entity.propsData,
      hashtag: entity.hashtag,
      fileIds: entity.fileIds,
      pendingPostId: entity.pendingPostId,
      metadata: entity.metadata,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'create_at': createAt,
      'update_at': updateAt,
      'delete_at': deleteAt,
      'edit_at': editAt,
      'user_id': userId,
      'channel_id': channelId,
      'root_id': rootId,
      'original_id': originalId,
      'message': message,
      'type': type.value,
      'props': propsData,
      'hashtag': hashtag,
      'file_ids': fileIds,
      'pending_post_id': pendingPostId,
      'metadata': metadata != null ? PostMetadataModel.fromEntity(metadata!).toMap() : null,
    };
  }

  @override
  PostModel copyWith({
    String? id,
    int? createAt,
    int? updateAt,
    int? deleteAt,
    int? editAt,
    String? userId,
    String? channelId,
    String? rootId,
    String? originalId,
    String? message,
    PostType? type,
    Map<String, dynamic>? propsData,
    String? hashtag,
    List<String>? fileIds,
    String? pendingPostId,
    PostMetadataEntity? metadata,
  }) {
    return PostModel(
      id: id ?? this.id,
      createAt: createAt ?? this.createAt,
      updateAt: updateAt ?? this.updateAt,
      deleteAt: deleteAt ?? this.deleteAt,
      editAt: editAt ?? this.editAt,
      userId: userId ?? this.userId,
      channelId: channelId ?? this.channelId,
      rootId: rootId ?? this.rootId,
      originalId: originalId ?? this.originalId,
      message: message ?? this.message,
      type: type ?? this.type,
      propsData: propsData ?? this.propsData,
      hashtag: hashtag ?? this.hashtag,
      fileIds: fileIds ?? this.fileIds,
      pendingPostId: pendingPostId ?? this.pendingPostId,
      metadata: metadata ?? this.metadata,
    );
  }

  PostEntity toEntity() {
    return PostEntity(
      id: id,
      createAt: createAt,
      updateAt: updateAt,
      deleteAt: deleteAt,
      editAt: editAt,
      userId: userId,
      channelId: channelId,
      rootId: rootId,
      originalId: originalId,
      message: message,
      type: type,
      propsData: propsData,
      hashtag: hashtag,
      fileIds: fileIds,
      pendingPostId: pendingPostId,
      metadata: metadata,
    );
  }
}
