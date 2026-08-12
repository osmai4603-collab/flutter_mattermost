import 'package:flutter_mattermost/features/chat/domain/entities/files_limits_entity.dart';

final class FilesLimitsModel extends FilesLimitsEntity {
  const FilesLimitsModel({
    required super.total_storage,
  });

  factory FilesLimitsModel.fromMap(Map<String, dynamic> map) {
    return FilesLimitsModel(
      total_storage: (map["total_storage"] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "total_storage": total_storage,
    };
  }

  factory FilesLimitsModel.fromEntity(FilesLimitsEntity entity) {
    return FilesLimitsModel(
      total_storage: entity.total_storage,
    );
  }

  @override
  FilesLimitsModel copyWith({
    int? total_storage,
  }) {
    return FilesLimitsModel(
      total_storage: total_storage ?? this.total_storage,
    );
  }

  FilesLimitsEntity toEntity() => FilesLimitsEntity(
        total_storage: total_storage,
      );
}
