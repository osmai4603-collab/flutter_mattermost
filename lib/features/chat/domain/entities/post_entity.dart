import 'package:flutter_mattermost/core/entities/entity.dart';
import 'package:flutter_mattermost/core/enums/post_type.dart';
import 'package:flutter_mattermost/features/chat/domain/entities/post_metadata_entity.dart';

class PostEntity extends Entity {
  final String id;
  final int createAt;
  final int updateAt;
  final int deleteAt;
  final int editAt;
  final String userId;
  final String channelId;
  final String rootId;
  final String originalId;
  final String message;
  final PostType type;
  final Map<String, dynamic> propsData;
  final String hashtag;
  final List<String> fileIds;
  final String pendingPostId;
  final PostMetadataEntity? metadata;

  const PostEntity({
    required this.id,
    this.createAt = 0,
    this.updateAt = 0,
    this.deleteAt = 0,
    this.editAt = 0,
    this.userId = '',
    this.channelId = '',
    this.rootId = '',
    this.originalId = '',
    this.message = '',
    this.type = PostType.defaultType,
    this.propsData = const {},
    this.hashtag = '',
    this.fileIds = const [],
    this.pendingPostId = '',
    this.metadata,
  });

  @override
  List<Object?> get props => [
        id,
        createAt,
        updateAt,
        deleteAt,
        editAt,
        userId,
        channelId,
        rootId,
        originalId,
        message,
        type,
        propsData,
        hashtag,
        fileIds,
        pendingPostId,
        metadata,
      ];

  @override
  PostEntity copyWith({
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
    return PostEntity(
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
}
