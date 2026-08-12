import 'package:flutter_mattermost/core/entities/entity.dart';
import 'package:flutter_mattermost/core/enums/channel_bookmark_type.dart';

class ChannelBookmarkEntity extends Entity {
  final String id;
  final String channelId;
  final String ownerId;
  final ChannelBookmarkType type;
  final String displayName;
  final String linkUrl;
  final String imageUrl;
  final String emoji;
  final int sortOrder;
  final int createAt;
  final int updateAt;
  final int deleteAt;
  final String fileId;
  final String targetId;
  final String originalId;
  final String parentId;

  @override
  List<Object?> get props => [
        id,
        channelId,
        ownerId,
        type,
        displayName,
        linkUrl,
        imageUrl,
        emoji,
        sortOrder,
        createAt,
        updateAt,
        deleteAt,
        fileId,
        targetId,
        originalId,
        parentId,
      ];

  const ChannelBookmarkEntity({
    required this.id,
    required this.channelId,
    this.ownerId = '',
    this.type = ChannelBookmarkType.link,
    this.displayName = '',
    this.linkUrl = '',
    this.imageUrl = '',
    this.emoji = '',
    this.sortOrder = 0,
    this.createAt = 0,
    this.updateAt = 0,
    this.deleteAt = 0,
    this.fileId = '',
    this.targetId = '',
    this.originalId = '',
    this.parentId = '',
  });

  @override
  ChannelBookmarkEntity copyWith({
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
    return ChannelBookmarkEntity(
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
}
