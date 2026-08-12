import 'package:flutter_mattermost/features/admin/domain/entities/data_retention_policy_with_team_and_channel_counts_entity.dart';

final class DataRetentionPolicyWithTeamAndChannelCountsModel
    extends DataRetentionPolicyWithTeamAndChannelCountsEntity {
  const DataRetentionPolicyWithTeamAndChannelCountsModel({
    super.display_name,
    super.post_duration,
    super.id,
    super.team_count,
    super.channel_count,
  });

  factory DataRetentionPolicyWithTeamAndChannelCountsModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return DataRetentionPolicyWithTeamAndChannelCountsModel(
      display_name: map["display_name"] as String?,
      post_duration: (map["post_duration"] as num?)?.toInt(),
      id: map["id"] as String?,
      team_count: (map["team_count"] as num?)?.toInt(),
      channel_count: (map["channel_count"] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "display_name": display_name,
      "post_duration": post_duration,
      "id": id,
      "team_count": team_count,
      "channel_count": channel_count,
    };
  }

  factory DataRetentionPolicyWithTeamAndChannelCountsModel.fromEntity(
    DataRetentionPolicyWithTeamAndChannelCountsEntity entity,
  ) {
    return DataRetentionPolicyWithTeamAndChannelCountsModel(
      display_name: entity.display_name,
      post_duration: entity.post_duration,
      id: entity.id,
      team_count: entity.team_count,
      channel_count: entity.channel_count,
    );
  }

  DataRetentionPolicyWithTeamAndChannelCountsModel copyWith({
    String? display_name,
    int? post_duration,
    String? id,
    int? team_count,
    int? channel_count,
  }) {
    return DataRetentionPolicyWithTeamAndChannelCountsModel(
      display_name: display_name ?? this.display_name,
      post_duration: post_duration ?? this.post_duration,
      id: id ?? this.id,
      team_count: team_count ?? this.team_count,
      channel_count: channel_count ?? this.channel_count,
    );
  }

  DataRetentionPolicyWithTeamAndChannelCountsEntity toEntity() =>
      DataRetentionPolicyWithTeamAndChannelCountsEntity(
        display_name: display_name,
        post_duration: post_duration,
        id: id,
        team_count: team_count,
        channel_count: channel_count,
      );
}
