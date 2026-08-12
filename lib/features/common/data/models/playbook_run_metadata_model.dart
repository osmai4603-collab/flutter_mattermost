import 'package:flutter_mattermost/features/common/domain/entities/playbook_run_metadata_entity.dart';

final class PlaybookRunMetadataModel extends PlaybookRunMetadataEntity {
  const PlaybookRunMetadataModel({
    required super.channel_name,
    required super.channel_display_name,
    required super.team_name,
    required super.num_members,
    required super.total_posts,
  });

  factory PlaybookRunMetadataModel.fromMap(Map<String, dynamic> map) {
    return PlaybookRunMetadataModel(
      channel_name: map["channel_name"] as String?,
      channel_display_name: map["channel_display_name"] as String?,
      team_name: map["team_name"] as String?,
      num_members: (map["num_members"] as num?)?.toInt(),
      total_posts: (map["total_posts"] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "channel_name": channel_name,
      "channel_display_name": channel_display_name,
      "team_name": team_name,
      "num_members": num_members,
      "total_posts": total_posts,
    };
  }

  factory PlaybookRunMetadataModel.fromEntity(PlaybookRunMetadataEntity entity) {
    return PlaybookRunMetadataModel(
      channel_name: entity.channel_name,
      channel_display_name: entity.channel_display_name,
      team_name: entity.team_name,
      num_members: entity.num_members,
      total_posts: entity.total_posts,
    );
  }

  @override
  PlaybookRunMetadataModel copyWith({
    String? channel_name,
    String? channel_display_name,
    String? team_name,
    int? num_members,
    int? total_posts,
  }) {
    return PlaybookRunMetadataModel(
      channel_name: channel_name ?? this.channel_name,
      channel_display_name: channel_display_name ?? this.channel_display_name,
      team_name: team_name ?? this.team_name,
      num_members: num_members ?? this.num_members,
      total_posts: total_posts ?? this.total_posts,
    );
  }

  PlaybookRunMetadataEntity toEntity() => PlaybookRunMetadataEntity(
        channel_name: channel_name,
        channel_display_name: channel_display_name,
        team_name: team_name,
        num_members: num_members,
        total_posts: total_posts,
      );
}
