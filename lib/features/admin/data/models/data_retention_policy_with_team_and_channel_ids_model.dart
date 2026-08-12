import 'package:flutter_mattermost/features/admin/domain/entities/data_retention_policy_with_team_and_channel_ids_entity.dart';

final class DataRetentionPolicyWithTeamAndChannelIdsModel
    extends DataRetentionPolicyWithTeamAndChannelIdsEntity {
  const DataRetentionPolicyWithTeamAndChannelIdsModel({
    super.display_name,
    super.post_duration,
    super.team_ids,
    super.channel_ids,
  });

  factory DataRetentionPolicyWithTeamAndChannelIdsModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return DataRetentionPolicyWithTeamAndChannelIdsModel(
      display_name: map["display_name"] as String?,
      post_duration: (map["post_duration"] as num?)?.toInt(),
      team_ids: List<String>.from(map["team_ids"] as List<dynamic>? ?? []),
      channel_ids:
          List<String>.from(map["channel_ids"] as List<dynamic>? ?? []),
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

  factory DataRetentionPolicyWithTeamAndChannelIdsModel.fromEntity(
    DataRetentionPolicyWithTeamAndChannelIdsEntity entity,
  ) {
    return DataRetentionPolicyWithTeamAndChannelIdsModel(
      display_name: entity.display_name,
      post_duration: entity.post_duration,
      team_ids: entity.team_ids,
      channel_ids: entity.channel_ids,
    );
  }

  DataRetentionPolicyWithTeamAndChannelIdsModel copyWith({
    String? display_name,
    int? post_duration,
    List<String>? team_ids,
    List<String>? channel_ids,
  }) {
    return DataRetentionPolicyWithTeamAndChannelIdsModel(
      display_name: display_name ?? this.display_name,
      post_duration: post_duration ?? this.post_duration,
      team_ids: team_ids ?? this.team_ids,
      channel_ids: channel_ids ?? this.channel_ids,
    );
  }

  DataRetentionPolicyWithTeamAndChannelIdsEntity toEntity() =>
      DataRetentionPolicyWithTeamAndChannelIdsEntity(
        display_name: display_name,
        post_duration: post_duration,
        team_ids: team_ids,
        channel_ids: channel_ids,
      );
}
