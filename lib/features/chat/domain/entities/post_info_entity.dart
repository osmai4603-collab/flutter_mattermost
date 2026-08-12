import 'package:equatable/equatable.dart';

class PostInfoEntity extends Equatable {
  final String? channel_id;
  final String? channel_type;
  final String? channel_display_name;
  final bool? has_joined_channel;
  final String? team_id;
  final String? team_type;
  final String? team_display_name;
  final bool? has_joined_team;

  const PostInfoEntity({
    this.channel_id,
    this.channel_type,
    this.channel_display_name,
    this.has_joined_channel,
    this.team_id,
    this.team_type,
    this.team_display_name,
    this.has_joined_team,
  });

  @override
  List<Object?> get props => [
        channel_id,
        channel_type,
        channel_display_name,
        has_joined_channel,
        team_id,
        team_type,
        team_display_name,
        has_joined_team,
      ];

  PostInfoEntity copyWith({
    String? channel_id,
    String? channel_type,
    String? channel_display_name,
    bool? has_joined_channel,
    String? team_id,
    String? team_type,
    String? team_display_name,
    bool? has_joined_team,
  }) {
    return PostInfoEntity(
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
}
