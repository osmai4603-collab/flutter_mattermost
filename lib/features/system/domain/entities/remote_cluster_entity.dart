import 'package:equatable/equatable.dart';

class RemoteClusterEntity extends Equatable {
  final String? remote_id;
  final String? remote_team_id;
  final String? name;
  final String? display_name;
  final String? site_url;
  final String? default_team_id;
  final int? create_at;
  final int? delete_at;
  final int? last_ping_at;
  final String? token;
  final String? remote_token;
  final String? topics;
  final String? creator_id;
  final String? plugin_id;
  final int? options;

  const RemoteClusterEntity({
    this.remote_id,
    this.remote_team_id,
    this.name,
    this.display_name,
    this.site_url,
    this.default_team_id,
    this.create_at,
    this.delete_at,
    this.last_ping_at,
    this.token,
    this.remote_token,
    this.topics,
    this.creator_id,
    this.plugin_id,
    this.options,
  });

  @override
  List<Object?> get props => [
        remote_id,
        remote_team_id,
        name,
        display_name,
        site_url,
        default_team_id,
        create_at,
        delete_at,
        last_ping_at,
        token,
        remote_token,
        topics,
        creator_id,
        plugin_id,
        options,
      ];

  RemoteClusterEntity copyWith({
    String? remote_id,
    String? remote_team_id,
    String? name,
    String? display_name,
    String? site_url,
    String? default_team_id,
    int? create_at,
    int? delete_at,
    int? last_ping_at,
    String? token,
    String? remote_token,
    String? topics,
    String? creator_id,
    String? plugin_id,
    int? options,
  }) {
    return RemoteClusterEntity(
      remote_id: remote_id ?? this.remote_id,
      remote_team_id: remote_team_id ?? this.remote_team_id,
      name: name ?? this.name,
      display_name: display_name ?? this.display_name,
      site_url: site_url ?? this.site_url,
      default_team_id: default_team_id ?? this.default_team_id,
      create_at: create_at ?? this.create_at,
      delete_at: delete_at ?? this.delete_at,
      last_ping_at: last_ping_at ?? this.last_ping_at,
      token: token ?? this.token,
      remote_token: remote_token ?? this.remote_token,
      topics: topics ?? this.topics,
      creator_id: creator_id ?? this.creator_id,
      plugin_id: plugin_id ?? this.plugin_id,
      options: options ?? this.options,
    );
  }
}
