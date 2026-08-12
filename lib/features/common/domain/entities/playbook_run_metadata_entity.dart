import 'package:equatable/equatable.dart';

class PlaybookRunMetadataEntity extends Equatable {
  final String? channel_name;
  final String? channel_display_name;
  final String? team_name;
  final int? num_members;
  final int? total_posts;

  const PlaybookRunMetadataEntity({
    this.channel_name,
    this.channel_display_name,
    this.team_name,
    this.num_members,
    this.total_posts,
  });

  @override
  List<Object?> get props => [
        channel_name,
        channel_display_name,
        team_name,
        num_members,
        total_posts,
      ];

  PlaybookRunMetadataEntity copyWith({
    String? channel_name,
    String? channel_display_name,
    String? team_name,
    int? num_members,
    int? total_posts,
  }) {
    return PlaybookRunMetadataEntity(
      channel_name: channel_name ?? this.channel_name,
      channel_display_name: channel_display_name ?? this.channel_display_name,
      team_name: team_name ?? this.team_name,
      num_members: num_members ?? this.num_members,
      total_posts: total_posts ?? this.total_posts,
    );
  }
}
