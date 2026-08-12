import 'package:flutter_mattermost/features/chat/domain/entities/file_info_entity.dart';

final class FileInfoModel extends FileInfoEntity {
  const FileInfoModel({
    super.serverId,
    required super.id,
    super.postId,
    super.userId,
    super.name,
    super.extension,
    super.size,
    super.mimeType,
    super.width,
    super.height,
    super.updateAt,
    super.createAt,
    super.deleteAt,
    super.hasPreviewImage,
    super.localPath,
  });

  factory FileInfoModel.fromMap(Map<String, dynamic> data) {
    return FileInfoModel(
      serverId: data['server_id'] ?? '',
      id: data['id'] ?? '',
      postId: data['post_id'] ?? '',
      userId: data['user_id'] ?? '',
      name: data['name'] ?? '',
      extension: data['extension'] ?? '',
      size: (data['size'] ?? 0).toInt(),
      mimeType: data['mime_type'] ?? '',
      width: (data['width'] ?? 0).toInt(),
      height: (data['height'] ?? 0).toInt(),
      updateAt: (data['update_at'] ?? 0).toInt(),
      createAt: (data['create_at'] ?? 0).toInt(),
      deleteAt: (data['delete_at'] ?? 0).toInt(),
      hasPreviewImage: data['has_preview_image'] ?? false,
      localPath: data['local_path'] ?? '',
    );
  }

  factory FileInfoModel.fromEntity(FileInfoEntity entity) {
    return FileInfoModel(
      serverId: entity.serverId,
      id: entity.id,
      postId: entity.postId,
      userId: entity.userId,
      name: entity.name,
      extension: entity.extension,
      size: entity.size,
      mimeType: entity.mimeType,
      width: entity.width,
      height: entity.height,
      updateAt: entity.updateAt,
      createAt: entity.createAt,
      deleteAt: entity.deleteAt,
      hasPreviewImage: entity.hasPreviewImage,
      localPath: entity.localPath,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'server_id': serverId,
      'id': id,
      'post_id': postId,
      'user_id': userId,
      'name': name,
      'extension': extension,
      'size': size,
      'mime_type': mimeType,
      'width': width,
      'height': height,
      'update_at': updateAt,
      'create_at': createAt,
      'delete_at': deleteAt,
      'has_preview_image': hasPreviewImage,
      'local_path': localPath,
    };
  }

  @override
  FileInfoModel copyWith({
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
    return FileInfoModel(
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

  FileInfoEntity toEntity() {
    return FileInfoEntity(
      serverId: serverId,
      id: id,
      postId: postId,
      userId: userId,
      name: name,
      extension: extension,
      size: size,
      mimeType: mimeType,
      width: width,
      height: height,
      updateAt: updateAt,
      createAt: createAt,
      deleteAt: deleteAt,
      hasPreviewImage: hasPreviewImage,
      localPath: localPath,
    );
  }
}
