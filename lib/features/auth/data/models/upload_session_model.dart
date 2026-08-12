import 'package:flutter_mattermost/features/auth/domain/entities/upload_session_entity.dart';

final class UploadSessionModel extends UploadSessionEntity {
  const UploadSessionModel({
    required super.id,
    required super.type,
    required super.create_at,
    required super.user_id,
    required super.channel_id,
    required super.filename,
    required super.file_size,
    required super.file_offset,
  });

  factory UploadSessionModel.fromMap(Map<String, dynamic> map) {
    return UploadSessionModel(
      id: map["id"] as String?,
      type: map["type"] as String?,
      create_at: (map["create_at"] as num?)?.toInt(),
      user_id: map["user_id"] as String?,
      channel_id: map["channel_id"] as String?,
      filename: map["filename"] as String?,
      file_size: (map["file_size"] as num?)?.toInt(),
      file_offset: (map["file_offset"] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "type": type,
      "create_at": create_at,
      "user_id": user_id,
      "channel_id": channel_id,
      "filename": filename,
      "file_size": file_size,
      "file_offset": file_offset,
    };
  }

  factory UploadSessionModel.fromEntity(UploadSessionEntity entity) {
    return UploadSessionModel(
      id: entity.id,
      type: entity.type,
      create_at: entity.create_at,
      user_id: entity.user_id,
      channel_id: entity.channel_id,
      filename: entity.filename,
      file_size: entity.file_size,
      file_offset: entity.file_offset,
    );
  }

  @override
  UploadSessionModel copyWith({
    String? id,
    String? type,
    int? create_at,
    String? user_id,
    String? channel_id,
    String? filename,
    int? file_size,
    int? file_offset,
  }) {
    return UploadSessionModel(
      id: id ?? this.id,
      type: type ?? this.type,
      create_at: create_at ?? this.create_at,
      user_id: user_id ?? this.user_id,
      channel_id: channel_id ?? this.channel_id,
      filename: filename ?? this.filename,
      file_size: file_size ?? this.file_size,
      file_offset: file_offset ?? this.file_offset,
    );
  }

  UploadSessionEntity toEntity() => UploadSessionEntity(
        id: id,
        type: type,
        create_at: create_at,
        user_id: user_id,
        channel_id: channel_id,
        filename: filename,
        file_size: file_size,
        file_offset: file_offset,
      );
}
