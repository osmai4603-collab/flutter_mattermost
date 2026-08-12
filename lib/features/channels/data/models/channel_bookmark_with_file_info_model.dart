import 'package:flutter_mattermost/core/enums/channel_bookmark_type.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_bookmark_with_file_info_entity.dart';

final class ChannelBookmarkWithFileInfoModel extends ChannelBookmarkWithFileInfoEntity {
  const ChannelBookmarkWithFileInfoModel({
    required super.id,
    super.createAt,
    super.updateAt,
    super.deleteAt,
    required super.channelId,
    super.ownerId,
    super.fileId,
    super.displayName,
    super.sortOrder,
    super.type,
    super.linkUrl,
    super.imageUrl,
    super.emoji,
    super.targetId,
    super.originalId,
    super.parentId,
    super.fileData,
  });

  factory ChannelBookmarkWithFileInfoModel.fromMap(Map<String, dynamic> data) {
    return ChannelBookmarkWithFileInfoModel(
      id: data['id'] ?? '',
      createAt: (data['create_at'] ?? 0).toInt(),
      updateAt: (data['update_at'] ?? 0).toInt(),
      deleteAt: (data['delete_at'] ?? 0).toInt(),
      channelId: data['channel_id'] ?? '',
      ownerId: data['owner_id'] ?? '',
      fileId: data['file_id'] ?? '',
      displayName: data['display_name'] ?? '',
      sortOrder: (data['sort_order'] ?? 0).toInt(),
      type: ChannelBookmarkType.fromValue(data['type'] ?? 'link'),
      linkUrl: data['link_url'] ?? '',
      imageUrl: data['image_url'] ?? '',
      emoji: data['emoji'] ?? '',
      targetId: data['target_id'] ?? '',
      originalId: data['original_id'] ?? '',
      parentId: data['parent_id'] ?? '',
      fileData: Map<String, dynamic>.from(data['file'] ?? const {}),
    );
  }

  factory ChannelBookmarkWithFileInfoModel.fromEntity(
    ChannelBookmarkWithFileInfoEntity entity,
  ) {
    return ChannelBookmarkWithFileInfoModel(
      id: entity.id,
      createAt: entity.createAt,
      updateAt: entity.updateAt,
      deleteAt: entity.deleteAt,
      channelId: entity.channelId,
      ownerId: entity.ownerId,
      fileId: entity.fileId,
      displayName: entity.displayName,
      sortOrder: entity.sortOrder,
      type: entity.type,
      linkUrl: entity.linkUrl,
      imageUrl: entity.imageUrl,
      emoji: entity.emoji,
      targetId: entity.targetId,
      originalId: entity.originalId,
      parentId: entity.parentId,
      fileData: entity.fileData,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'create_at': createAt,
      'update_at': updateAt,
      'delete_at': deleteAt,
      'channel_id': channelId,
      'owner_id': ownerId,
      'file_id': fileId,
      'display_name': displayName,
      'sort_order': sortOrder,
      'type': type.value,
      'link_url': linkUrl,
      'image_url': imageUrl,
      'emoji': emoji,
      'target_id': targetId,
      'original_id': originalId,
      'parent_id': parentId,
      'file': fileData,
    };
  }

  @override
  ChannelBookmarkWithFileInfoModel copyWith({
    String? id,
    int? createAt,
    int? updateAt,
    int? deleteAt,
    String? channelId,
    String? ownerId,
    String? fileId,
    String? displayName,
    int? sortOrder,
    ChannelBookmarkType? type,
    String? linkUrl,
    String? imageUrl,
    String? emoji,
    String? targetId,
    String? originalId,
    String? parentId,
    Map<String, dynamic>? fileData,
  }) {
    return ChannelBookmarkWithFileInfoModel(
      id: id ?? this.id,
      createAt: createAt ?? this.createAt,
      updateAt: updateAt ?? this.updateAt,
      deleteAt: deleteAt ?? this.deleteAt,
      channelId: channelId ?? this.channelId,
      ownerId: ownerId ?? this.ownerId,
      fileId: fileId ?? this.fileId,
      displayName: displayName ?? this.displayName,
      sortOrder: sortOrder ?? this.sortOrder,
      type: type ?? this.type,
      linkUrl: linkUrl ?? this.linkUrl,
      imageUrl: imageUrl ?? this.imageUrl,
      emoji: emoji ?? this.emoji,
      targetId: targetId ?? this.targetId,
      originalId: originalId ?? this.originalId,
      parentId: parentId ?? this.parentId,
      fileData: fileData ?? this.fileData,
    );
  }

  ChannelBookmarkWithFileInfoEntity toEntity() {
    return ChannelBookmarkWithFileInfoEntity(
      id: id,
      createAt: createAt,
      updateAt: updateAt,
      deleteAt: deleteAt,
      channelId: channelId,
      ownerId: ownerId,
      fileId: fileId,
      displayName: displayName,
      sortOrder: sortOrder,
      type: type,
      linkUrl: linkUrl,
      imageUrl: imageUrl,
      emoji: emoji,
      targetId: targetId,
      originalId: originalId,
      parentId: parentId,
      fileData: fileData,
    );
  }
}
