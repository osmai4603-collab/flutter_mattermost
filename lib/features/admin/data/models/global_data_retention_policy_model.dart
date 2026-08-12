import 'package:flutter_mattermost/features/admin/domain/entities/global_data_retention_policy_entity.dart';

final class GlobalDataRetentionPolicyModel extends GlobalDataRetentionPolicyEntity {
  const GlobalDataRetentionPolicyModel({
    required super.message_deletion_enabled,
    required super.file_deletion_enabled,
    required super.message_retention_cutoff,
    required super.file_retention_cutoff,
  });

  factory GlobalDataRetentionPolicyModel.fromMap(Map<String, dynamic> map) {
    return GlobalDataRetentionPolicyModel(
      message_deletion_enabled: map["message_deletion_enabled"] as bool?,
      file_deletion_enabled: map["file_deletion_enabled"] as bool?,
      message_retention_cutoff: (map["message_retention_cutoff"] as num?)?.toInt(),
      file_retention_cutoff: (map["file_retention_cutoff"] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "message_deletion_enabled": message_deletion_enabled,
      "file_deletion_enabled": file_deletion_enabled,
      "message_retention_cutoff": message_retention_cutoff,
      "file_retention_cutoff": file_retention_cutoff,
    };
  }

  factory GlobalDataRetentionPolicyModel.fromEntity(GlobalDataRetentionPolicyEntity entity) {
    return GlobalDataRetentionPolicyModel(
      message_deletion_enabled: entity.message_deletion_enabled,
      file_deletion_enabled: entity.file_deletion_enabled,
      message_retention_cutoff: entity.message_retention_cutoff,
      file_retention_cutoff: entity.file_retention_cutoff,
    );
  }

  GlobalDataRetentionPolicyModel copyWith({
    bool? message_deletion_enabled,
    bool? file_deletion_enabled,
    int? message_retention_cutoff,
    int? file_retention_cutoff,
  }) {
    return GlobalDataRetentionPolicyModel(
      message_deletion_enabled: message_deletion_enabled ?? this.message_deletion_enabled,
      file_deletion_enabled: file_deletion_enabled ?? this.file_deletion_enabled,
      message_retention_cutoff: message_retention_cutoff ?? this.message_retention_cutoff,
      file_retention_cutoff: file_retention_cutoff ?? this.file_retention_cutoff,
    );
  }

  GlobalDataRetentionPolicyEntity toEntity() => GlobalDataRetentionPolicyEntity(
        message_deletion_enabled: message_deletion_enabled,
        file_deletion_enabled: file_deletion_enabled,
        message_retention_cutoff: message_retention_cutoff,
        file_retention_cutoff: file_retention_cutoff,
      );
}
