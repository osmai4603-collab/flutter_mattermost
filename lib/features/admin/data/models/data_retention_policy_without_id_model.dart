import 'package:flutter_mattermost/features/admin/domain/entities/data_retention_policy_without_id_entity.dart';

final class DataRetentionPolicyWithoutIdModel extends DataRetentionPolicyWithoutIdEntity {
  const DataRetentionPolicyWithoutIdModel({
    required super.display_name,
    required super.post_duration,
  });

  factory DataRetentionPolicyWithoutIdModel.fromMap(Map<String, dynamic> map) {
    return DataRetentionPolicyWithoutIdModel(
      display_name: map["display_name"] as String?,
      post_duration: (map["post_duration"] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "display_name": display_name,
      "post_duration": post_duration,
    };
  }

  factory DataRetentionPolicyWithoutIdModel.fromEntity(DataRetentionPolicyWithoutIdEntity entity) {
    return DataRetentionPolicyWithoutIdModel(
      display_name: entity.display_name,
      post_duration: entity.post_duration,
    );
  }

  DataRetentionPolicyWithoutIdModel copyWith({
    String? display_name,
    int? post_duration,
  }) {
    return DataRetentionPolicyWithoutIdModel(
      display_name: display_name ?? this.display_name,
      post_duration: post_duration ?? this.post_duration,
    );
  }

  DataRetentionPolicyWithoutIdEntity toEntity() => DataRetentionPolicyWithoutIdEntity(
        display_name: display_name,
        post_duration: post_duration,
      );
}
