import 'package:flutter_mattermost/core/enums/channel_bookmark_type.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_bookmark_entity.dart';

final class ChannelBookmarkModel extends ChannelBookmarkEntity {
  const ChannelBookmarkModel({
    required super.id,
    required super.channelId,
    required super.ownerId,
    required super.type,
    required super.displayName,
    required super.linkUrl,
    required super.imageUrl,
    required super.emoji,
    required super.sortOrder,
    required super.createAt,
    required super.updateAt,
    required super.deleteAt,
    required super.fileId,
    required super.targetId,
    required super.originalId,
    required super.parentId,
  });

  factory ChannelBookmarkModel.fromMap(Map<String, dynamic> map) {
    return ChannelBookmarkModel(
      id: map["id"] as String? ?? '',
      channelId: map["channel_id"] as String? ?? '',
      ownerId: map["owner_id"] as String? ?? map["user_id"] as String? ?? '',
      type: ChannelBookmarkType.fromValue(map["type"] as String? ?? 'link'),
      displayName: map["display_name"] as String? ?? '',
      linkUrl: map["link_url"] as String? ?? '',
      imageUrl: map["image_url"] as String? ?? '',
      emoji: map["emoji"] as String? ?? '',
      sortOrder: (map["sort_order"] as num?)?.toInt() ?? 0,
      createAt: (map["create_at"] as num?)?.toInt() ?? 0,
      updateAt: (map["update_at"] as num?)?.toInt() ?? 0,
      deleteAt: (map["delete_at"] as num?)?.toInt() ?? 0,
      fileId: map["file_id"] as String? ?? '',
      targetId: map["target_id"] as String? ?? '',
      originalId: map["original_id"] as String? ?? '',
      parentId: map["parent_id"] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "channel_id": channelId,
      "owner_id": ownerId,
      "type": type.value,
      "display_name": displayName,
      "link_url": linkUrl,
      "image_url": imageUrl,
      "emoji": emoji,
      "sort_order": sortOrder,
      "create_at": createAt,
      "update_at": updateAt,
      "delete_at": deleteAt,
      "file_id": fileId,
      "target_id": targetId,
      "original_id": originalId,
      "parent_id": parentId,
    };
  }

  factory ChannelBookmarkModel.fromEntity(ChannelBookmarkEntity entity) {
    return ChannelBookmarkModel(
      id: entity.id,
      channelId: entity.channelId,
      ownerId: entity.ownerId,
      type: entity.type,
      displayName: entity.displayName,
      linkUrl: entity.linkUrl,
      imageUrl: entity.imageUrl,
      emoji: entity.emoji,
      sortOrder: entity.sortOrder,
      createAt: entity.createAt,
      updateAt: entity.updateAt,
      deleteAt: entity.deleteAt,
      fileId: entity.fileId,
      targetId: entity.targetId,
      originalId: entity.originalId,
      parentId: entity.parentId,
    );
  }

  @override
  ChannelBookmarkModel copyWith({
    String? id,
    String? channelId,
    String? ownerId,
    ChannelBookmarkType? type,
    String? displayName,
    String? linkUrl,
    String? imageUrl,
    String? emoji,
    int? sortOrder,
    int? createAt,
    int? updateAt,
    int? deleteAt,
    String? fileId,
    String? targetId,
    String? originalId,
    String? parentId,
  }) {
    return ChannelBookmarkModel(
      id: id ?? this.id,
      channelId: channelId ?? this.channelId,
      ownerId: ownerId ?? this.ownerId,
      type: type ?? this.type,
      displayName: displayName ?? this.displayName,
      linkUrl: linkUrl ?? this.linkUrl,
      imageUrl: imageUrl ?? this.imageUrl,
      emoji: emoji ?? this.emoji,
      sortOrder: sortOrder ?? this.sortOrder,
      createAt: createAt ?? this.createAt,
      updateAt: updateAt ?? this.updateAt,
      deleteAt: deleteAt ?? this.deleteAt,
      fileId: fileId ?? this.fileId,
      targetId: targetId ?? this.targetId,
      originalId: originalId ?? this.originalId,
      parentId: parentId ?? this.parentId,
    );
  }

  ChannelBookmarkEntity toEntity() => ChannelBookmarkEntity(
        id: id,
        channelId: channelId,
        ownerId: ownerId,
        type: type,
        displayName: displayName,
        linkUrl: linkUrl,
        imageUrl: imageUrl,
        emoji: emoji,
        sortOrder: sortOrder,
        createAt: createAt,
        updateAt: updateAt,
        deleteAt: deleteAt,
        fileId: fileId,
        targetId: targetId,
        originalId: originalId,
        parentId: parentId,
      );
}
