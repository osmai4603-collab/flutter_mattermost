import 'package:flutter_mattermost/features/admin/domain/entities/data_retention_policy_create_entity.dart';

final class DataRetentionPolicyCreateModel extends DataRetentionPolicyCreateEntity {
  const DataRetentionPolicyCreateModel({
    required super.display_name,
    required super.post_duration,
    required super.team_ids,
    required super.channel_ids,
  });

  factory DataRetentionPolicyCreateModel.fromMap(Map<String, dynamic> map) {
    return DataRetentionPolicyCreateModel(
      display_name: map["display_name"] as String?,
      post_duration: (map["post_duration"] as num?)?.toInt(),
      team_ids: List<String>.from(map["team_ids"] as List<dynamic>? ?? []),
      channel_ids: List<String>.from(map["channel_ids"] as List<dynamic>? ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "display_name": display_name,
      "post_duration": post_duration,
      "team_ids": team_ids,
      "channel_ids": channel_ids,
    };
  }

  factory DataRetentionPolicyCreateModel.fromEntity(
    DataRetentionPolicyCreateEntity entity,
  ) {
    return DataRetentionPolicyCreateModel(
      display_name: entity.display_name,
      post_duration: entity.post_duration,
      team_ids: entity.team_ids,
      channel_ids: entity.channel_ids,
    );
  }

  DataRetentionPolicyCreateModel copyWith({
    String? display_name,
    int? post_duration,
    List<String>? team_ids,
    List<String>? channel_ids,
  }) {
    return DataRetentionPolicyCreateModel(
      display_name: display_name ?? this.display_name,
      post_duration: post_duration ?? this.post_duration,
      team_ids: team_ids ?? this.team_ids,
      channel_ids: channel_ids ?? this.channel_ids,
    );
  }

  DataRetentionPolicyCreateEntity toEntity() => DataRetentionPolicyCreateEntity(
        display_name: display_name,
        post_duration: post_duration,
        team_ids: team_ids,
        channel_ids: channel_ids,
      );
}
