import 'package:flutter_mattermost/features/system/domain/entities/remote_cluster_entity.dart';

final class RemoteClusterModel extends RemoteClusterEntity {
  const RemoteClusterModel({
    required super.remote_id,
    required super.remote_team_id,
    required super.name,
    required super.display_name,
    required super.site_url,
    required super.default_team_id,
    required super.create_at,
    required super.delete_at,
    required super.last_ping_at,
    required super.token,
    required super.remote_token,
    required super.topics,
    required super.creator_id,
    required super.plugin_id,
    required super.options,
  });

  factory RemoteClusterModel.fromMap(Map<String, dynamic> map) {
    return RemoteClusterModel(
      remote_id: map["remote_id"] as String?,
      remote_team_id: map["remote_team_id"] as String?,
      name: map["name"] as String?,
      display_name: map["display_name"] as String?,
      site_url: map["site_url"] as String?,
      default_team_id: map["default_team_id"] as String?,
      create_at: (map["create_at"] as num?)?.toInt(),
      delete_at: (map["delete_at"] as num?)?.toInt(),
      last_ping_at: (map["last_ping_at"] as num?)?.toInt(),
      token: map["token"] as String?,
      remote_token: map["remote_token"] as String?,
      topics: map["topics"] as String?,
      creator_id: map["creator_id"] as String?,
      plugin_id: map["plugin_id"] as String?,
      options: (map["options"] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "remote_id": remote_id,
      "remote_team_id": remote_team_id,
      "name": name,
      "display_name": display_name,
      "site_url": site_url,
      "default_team_id": default_team_id,
      "create_at": create_at,
      "delete_at": delete_at,
      "last_ping_at": last_ping_at,
      "token": token,
      "remote_token": remote_token,
      "topics": topics,
      "creator_id": creator_id,
      "plugin_id": plugin_id,
      "options": options,
    };
  }

  factory RemoteClusterModel.fromEntity(RemoteClusterEntity entity) {
    return RemoteClusterModel(
      remote_id: entity.remote_id,
      remote_team_id: entity.remote_team_id,
      name: entity.name,
      display_name: entity.display_name,
      site_url: entity.site_url,
      default_team_id: entity.default_team_id,
      create_at: entity.create_at,
      delete_at: entity.delete_at,
      last_ping_at: entity.last_ping_at,
      token: entity.token,
      remote_token: entity.remote_token,
      topics: entity.topics,
      creator_id: entity.creator_id,
      plugin_id: entity.plugin_id,
      options: entity.options,
    );
  }

  @override
  RemoteClusterModel copyWith({
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
    return RemoteClusterModel(
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

  RemoteClusterEntity toEntity() => RemoteClusterEntity(
        remote_id: remote_id,
        remote_team_id: remote_team_id,
        name: name,
        display_name: display_name,
        site_url: site_url,
        default_team_id: default_team_id,
        create_at: create_at,
        delete_at: delete_at,
        last_ping_at: last_ping_at,
        token: token,
        remote_token: remote_token,
        topics: topics,
        creator_id: creator_id,
        plugin_id: plugin_id,
        options: options,
      );
}
