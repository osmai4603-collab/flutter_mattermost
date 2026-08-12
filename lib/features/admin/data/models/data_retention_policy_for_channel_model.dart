import 'package:flutter_mattermost/features/admin/domain/entities/data_retention_policy_for_channel_entity.dart';

final class DataRetentionPolicyForChannelModel extends DataRetentionPolicyForChannelEntity {
  const DataRetentionPolicyForChannelModel({
    required super.channel_id,
    required super.post_duration,
  });

  factory DataRetentionPolicyForChannelModel.fromMap(Map<String, dynamic> map) {
    return DataRetentionPolicyForChannelModel(
      channel_id: map["channel_id"] as String?,
      post_duration: (map["post_duration"] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "channel_id": channel_id,
      "post_duration": post_duration,
    };
  }

  factory DataRetentionPolicyForChannelModel.fromEntity(DataRetentionPolicyForChannelEntity entity) {
    return DataRetentionPolicyForChannelModel(
      channel_id: entity.channel_id,
      post_duration: entity.post_duration,
    );
  }

  DataRetentionPolicyForChannelModel copyWith({
    String? channel_id,
    int? post_duration,
  }) {
    return DataRetentionPolicyForChannelModel(
      channel_id: channel_id ?? this.channel_id,
      post_duration: post_duration ?? this.post_duration,
    );
  }

  DataRetentionPolicyForChannelEntity toEntity() => DataRetentionPolicyForChannelEntity(
        channel_id: channel_id,
        post_duration: post_duration,
      );
}
