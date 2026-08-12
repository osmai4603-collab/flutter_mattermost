import 'package:flutter_mattermost/core/enums/channel_bookmark_type.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_bookmark_entity.dart';

class ChannelBookmarkWithFileInfoEntity extends ChannelBookmarkEntity {
  final Map<String, dynamic> fileData;

  const ChannelBookmarkWithFileInfoEntity({
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
    this.fileData = const {},
  });

  @override
  List<Object?> get props => [
        ...super.props,
        fileData,
      ];

  @override
  ChannelBookmarkWithFileInfoEntity copyWith({
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
    return ChannelBookmarkWithFileInfoEntity(
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
}
