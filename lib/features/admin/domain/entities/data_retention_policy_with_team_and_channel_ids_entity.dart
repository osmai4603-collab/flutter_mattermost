import 'package:flutter_mattermost/features/admin/domain/entities/data_retention_policy_without_id_entity.dart';

/// سياسة احتفاظ مع معرّفات الفرق والقنوات (DataRetentionPolicyWithTeamAndChannelIds):
/// جميع حقول DataRetentionPolicyWithoutId إضافة إلى team_ids و channel_ids.
class DataRetentionPolicyWithTeamAndChannelIdsEntity
    extends DataRetentionPolicyWithoutIdEntity {
  final List<String>? team_ids;
  final List<String>? channel_ids;

  const DataRetentionPolicyWithTeamAndChannelIdsEntity({
    super.display_name,
    super.post_duration,
    this.team_ids,
    this.channel_ids,
  });

  @override
  List<Object?> get props => [
        ...super.props,
        team_ids,
        channel_ids,
      ];

  @override
  DataRetentionPolicyWithTeamAndChannelIdsEntity copyWith({
    String? display_name,
    int? post_duration,
    List<String>? team_ids,
    List<String>? channel_ids,
  }) {
    return DataRetentionPolicyWithTeamAndChannelIdsEntity(
      display_name: display_name ?? this.display_name,
      post_duration: post_duration ?? this.post_duration,
      team_ids: team_ids ?? this.team_ids,
      channel_ids: channel_ids ?? this.channel_ids,
    );
  }
}
