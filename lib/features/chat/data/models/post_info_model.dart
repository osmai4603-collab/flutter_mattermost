import 'package:flutter_mattermost/features/chat/domain/entities/post_info_entity.dart';

final class PostInfoModel extends PostInfoEntity {
  const PostInfoModel({
    required super.channel_id,
    required super.channel_type,
    required super.channel_display_name,
    required super.has_joined_channel,
    required super.team_id,
    required super.team_type,
    required super.team_display_name,
    required super.has_joined_team,
  });

  factory PostInfoModel.fromMap(Map<String, dynamic> map) {
    return PostInfoModel(
      channel_id: map["channel_id"] as String?,
      channel_type: map["channel_type"] as String?,
      channel_display_name: map["channel_display_name"] as String?,
      has_joined_channel: map["has_joined_channel"] as bool?,
      team_id: map["team_id"] as String?,
      team_type: map["team_type"] as String?,
      team_display_name: map["team_display_name"] as String?,
      has_joined_team: map["has_joined_team"] as bool?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "channel_id": channel_id,
      "channel_type": channel_type,
      "channel_display_name": channel_display_name,
      "has_joined_channel": has_joined_channel,
      "team_id": team_id,
      "team_type": team_type,
      "team_display_name": team_display_name,
      "has_joined_team": has_joined_team,
    };
  }

  factory PostInfoModel.fromEntity(PostInfoEntity entity) {
    return PostInfoModel(
      channel_id: entity.channel_id,
      channel_type: entity.channel_type,
      channel_display_name: entity.channel_display_name,
      has_joined_channel: entity.has_joined_channel,
      team_id: entity.team_id,
      team_type: entity.team_type,
      team_display_name: entity.team_display_name,
      has_joined_team: entity.has_joined_team,
    );
  }

  @override
  PostInfoModel copyWith({
    String? channel_id,
    String? channel_type,
    String? channel_display_name,
    bool? has_joined_channel,
    String? team_id,
    String? team_type,
    String? team_display_name,
    bool? has_joined_team,
  }) {
    return PostInfoModel(
      channel_id: channel_id ?? this.channel_id,
      channel_type: channel_type ?? this.channel_type,
      channel_display_name: channel_display_name ?? this.channel_display_name,
      has_joined_channel: has_joined_channel ?? this.has_joined_channel,
      team_id: team_id ?? this.team_id,
      team_type: team_type ?? this.team_type,
      team_display_name: team_display_name ?? this.team_display_name,
      has_joined_team: has_joined_team ?? this.has_joined_team,
    );
  }

  PostInfoEntity toEntity() => PostInfoEntity(
        channel_id: channel_id,
        channel_type: channel_type,
        channel_display_name: channel_display_name,
        has_joined_channel: has_joined_channel,
        team_id: team_id,
        team_type: team_type,
        team_display_name: team_display_name,
        has_joined_team: has_joined_team,
      );
}
