import 'package:flutter_mattermost/core/entities/entity.dart';

class FileInfoEntity extends Entity {
  final String serverId;
  final String id;
  final String postId;
  final String userId;
  final String name;
  final String extension;
  final int size;
  final String mimeType;
  final int width;
  final int height;
  final int updateAt;
  final int createAt;
  final int deleteAt;
  final bool hasPreviewImage;
  final String localPath;

  const FileInfoEntity({
    this.serverId = '',
    required this.id,
    this.postId = '',
    this.userId = '',
    this.name = '',
    this.extension = '',
    this.size = 0,
    this.mimeType = '',
    this.width = 0,
    this.height = 0,
    this.updateAt = 0,
    this.createAt = 0,
    this.deleteAt = 0,
    this.hasPreviewImage = false,
    this.localPath = '',
  });

  @override
  List<Object?> get props => [
        serverId,
        id,
        postId,
        userId,
        name,
        extension,
        size,
        mimeType,
        width,
        height,
        updateAt,
        createAt,
        deleteAt,
        hasPreviewImage,
        localPath,
      ];

  @override
  FileInfoEntity copyWith({
    String? serverId,
    String? id,
    String? postId,
    String? userId,
    String? name,
    String? extension,
    int? size,
    String? mimeType,
    int? width,
    int? height,
    int? createAt,
    int? updateAt,
    int? deleteAt,
    bool? hasPreviewImage,
    String? localPath,
  }) {
    return FileInfoEntity(
      serverId: serverId ?? this.serverId,
      id: id ?? this.id,
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      extension: extension ?? this.extension,
      size: size ?? this.size,
      mimeType: mimeType ?? this.mimeType,
      width: width ?? this.width,
      height: height ?? this.height,
      createAt: createAt ?? this.createAt,
      updateAt: updateAt ?? this.updateAt,
      deleteAt: deleteAt ?? this.deleteAt,
      hasPreviewImage: hasPreviewImage ?? this.hasPreviewImage,
      localPath: localPath ?? this.localPath,
    );
  }
}
