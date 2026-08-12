import 'package:flutter_mattermost/features/admin/domain/entities/data_retention_policy_entity.dart';

/// سياسة احتفاظ مع عدد الفرق والقنوات (DataRetentionPolicyWithTeamAndChannelCounts):
/// جميع حقول DataRetentionPolicy إضافة إلى team_count و channel_count.
class DataRetentionPolicyWithTeamAndChannelCountsEntity
    extends DataRetentionPolicyEntity {
  final int? team_count;
  final int? channel_count;

  const DataRetentionPolicyWithTeamAndChannelCountsEntity({
    super.display_name,
    super.post_duration,
    super.id,
    this.team_count,
    this.channel_count,
  });

  @override
  List<Object?> get props => [
        ...super.props,
        team_count,
        channel_count,
      ];

  @override
  DataRetentionPolicyWithTeamAndChannelCountsEntity copyWith({
    String? display_name,
    int? post_duration,
    String? id,
    int? team_count,
    int? channel_count,
  }) {
    return DataRetentionPolicyWithTeamAndChannelCountsEntity(
      display_name: display_name ?? this.display_name,
      post_duration: post_duration ?? this.post_duration,
      id: id ?? this.id,
      team_count: team_count ?? this.team_count,
      channel_count: channel_count ?? this.channel_count,
    );
  }
}
