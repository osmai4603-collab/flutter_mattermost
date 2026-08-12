import 'package:flutter_mattermost/features/chat/domain/entities/file_info_list_entity.dart';

final class FileInfoListModel extends FileInfoListEntity {
  const FileInfoListModel({
    required super.order,
    required super.file_infos,
    required super.next_file_id,
    required super.prev_file_id,
  });

  factory FileInfoListModel.fromMap(Map<String, dynamic> map) {
    return FileInfoListModel(
      order: List<String>.from(map["order"] as List<dynamic>? ?? []),
      file_infos: map["file_infos"] as Map<String, dynamic>?,
      next_file_id: map["next_file_id"] as String?,
      prev_file_id: map["prev_file_id"] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "order": order,
      "file_infos": file_infos,
      "next_file_id": next_file_id,
      "prev_file_id": prev_file_id,
    };
  }

  factory FileInfoListModel.fromEntity(FileInfoListEntity entity) {
    return FileInfoListModel(
      order: entity.order,
      file_infos: entity.file_infos,
      next_file_id: entity.next_file_id,
      prev_file_id: entity.prev_file_id,
    );
  }

  @override
  FileInfoListModel copyWith({
    List<String>? order,
    Map<String, dynamic>? file_infos,
    String? next_file_id,
    String? prev_file_id,
  }) {
    return FileInfoListModel(
      order: order ?? this.order,
      file_infos: file_infos ?? this.file_infos,
      next_file_id: next_file_id ?? this.next_file_id,
      prev_file_id: prev_file_id ?? this.prev_file_id,
    );
  }

  FileInfoListEntity toEntity() => FileInfoListEntity(
        order: order,
        file_infos: file_infos,
        next_file_id: next_file_id,
        prev_file_id: prev_file_id,
      );
}
