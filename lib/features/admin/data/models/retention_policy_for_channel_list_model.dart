import 'package:flutter_mattermost/features/admin/domain/entities/retention_policy_for_channel_list_entity.dart';

final class RetentionPolicyForChannelListModel extends RetentionPolicyForChannelListEntity {
  const RetentionPolicyForChannelListModel({
    required super.policies,
    required super.total_count,
  });

  factory RetentionPolicyForChannelListModel.fromMap(Map<String, dynamic> map) {
    return RetentionPolicyForChannelListModel(
      policies: (map["policies"] as List<dynamic>? ?? []).map((e) => Map<String, dynamic>.from(e as Map<String, dynamic>)).toList(),
      total_count: (map["total_count"] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "policies": policies,
      "total_count": total_count,
    };
  }

  factory RetentionPolicyForChannelListModel.fromEntity(RetentionPolicyForChannelListEntity entity) {
    return RetentionPolicyForChannelListModel(
      policies: entity.policies,
      total_count: entity.total_count,
    );
  }

  RetentionPolicyForChannelListModel copyWith({
    List<Map<String, dynamic>>? policies,
    int? total_count,
  }) {
    return RetentionPolicyForChannelListModel(
      policies: policies ?? this.policies,
      total_count: total_count ?? this.total_count,
    );
  }

  RetentionPolicyForChannelListEntity toEntity() => RetentionPolicyForChannelListEntity(
        policies: policies,
        total_count: total_count,
      );
}
