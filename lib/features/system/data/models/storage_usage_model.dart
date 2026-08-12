import 'package:flutter_mattermost/features/system/domain/entities/storage_usage_entity.dart';

final class StorageUsageModel extends StorageUsageEntity {
  const StorageUsageModel({
    required super.bytes,
  });

  factory StorageUsageModel.fromMap(Map<String, dynamic> map) {
    return StorageUsageModel(
      bytes: (map["bytes"] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "bytes": bytes,
    };
  }

  factory StorageUsageModel.fromEntity(StorageUsageEntity entity) {
    return StorageUsageModel(
      bytes: entity.bytes,
    );
  }

  @override
  StorageUsageModel copyWith({
    double? bytes,
  }) {
    return StorageUsageModel(
      bytes: bytes ?? this.bytes,
    );
  }

  StorageUsageEntity toEntity() => StorageUsageEntity(
        bytes: bytes,
      );
}
