import 'package:flutter_mattermost/features/channels/domain/entities/remote_cluster_info_entity.dart';

final class RemoteClusterInfoModel extends RemoteClusterInfoEntity {
  const RemoteClusterInfoModel({
    required super.display_name,
    required super.create_at,
    required super.last_ping_at,
  });

  factory RemoteClusterInfoModel.fromMap(Map<String, dynamic> map) {
    return RemoteClusterInfoModel(
      display_name: map["display_name"] as String?,
      create_at: (map["create_at"] as num?)?.toInt(),
      last_ping_at: (map["last_ping_at"] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "display_name": display_name,
      "create_at": create_at,
      "last_ping_at": last_ping_at,
    };
  }

  factory RemoteClusterInfoModel.fromEntity(RemoteClusterInfoEntity entity) {
    return RemoteClusterInfoModel(
      display_name: entity.display_name,
      create_at: entity.create_at,
      last_ping_at: entity.last_ping_at,
    );
  }

  @override
  RemoteClusterInfoModel copyWith({
    String? display_name,
    int? create_at,
    int? last_ping_at,
  }) {
    return RemoteClusterInfoModel(
      display_name: display_name ?? this.display_name,
      create_at: create_at ?? this.create_at,
      last_ping_at: last_ping_at ?? this.last_ping_at,
    );
  }

  RemoteClusterInfoEntity toEntity() => RemoteClusterInfoEntity(
        display_name: display_name,
        create_at: create_at,
        last_ping_at: last_ping_at,
      );
}
