import 'package:flutter_mattermost/features/admin/domain/entities/data_retention_policy_entity.dart';

final class DataRetentionPolicyModel extends DataRetentionPolicyEntity {
  const DataRetentionPolicyModel({
    super.display_name,
    super.post_duration,
    super.id,
  });

  factory DataRetentionPolicyModel.fromMap(Map<String, dynamic> map) {
    return DataRetentionPolicyModel(
      display_name: map["display_name"] as String?,
      post_duration: (map["post_duration"] as num?)?.toInt(),
      id: map["id"] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "display_name": display_name,
      "post_duration": post_duration,
      "id": id,
    };
  }

  factory DataRetentionPolicyModel.fromEntity(DataRetentionPolicyEntity entity) {
    return DataRetentionPolicyModel(
      display_name: entity.display_name,
      post_duration: entity.post_duration,
      id: entity.id,
    );
  }

  DataRetentionPolicyModel copyWith({
    String? display_name,
    int? post_duration,
    String? id,
  }) {
    return DataRetentionPolicyModel(
      display_name: display_name ?? this.display_name,
      post_duration: post_duration ?? this.post_duration,
      id: id ?? this.id,
    );
  }

  DataRetentionPolicyEntity toEntity() => DataRetentionPolicyEntity(
        display_name: display_name,
        post_duration: post_duration,
        id: id,
      );
}
