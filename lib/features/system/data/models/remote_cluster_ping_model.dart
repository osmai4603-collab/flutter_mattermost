import 'package:flutter_mattermost/features/system/domain/entities/remote_cluster_ping_entity.dart';

final class RemoteClusterPingModel extends RemoteClusterPingEntity {
  const RemoteClusterPingModel({
    required super.sent_at,
    required super.recv_at,
  });

  factory RemoteClusterPingModel.fromMap(Map<String, dynamic> map) {
    return RemoteClusterPingModel(
      sent_at: (map["sent_at"] as num?)?.toInt(),
      recv_at: (map["recv_at"] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "sent_at": sent_at,
      "recv_at": recv_at,
    };
  }

  factory RemoteClusterPingModel.fromEntity(RemoteClusterPingEntity entity) {
    return RemoteClusterPingModel(
      sent_at: entity.sent_at,
      recv_at: entity.recv_at,
    );
  }

  @override
  RemoteClusterPingModel copyWith({
    int? sent_at,
    int? recv_at,
  }) {
    return RemoteClusterPingModel(
      sent_at: sent_at ?? this.sent_at,
      recv_at: recv_at ?? this.recv_at,
    );
  }

  RemoteClusterPingEntity toEntity() => RemoteClusterPingEntity(
        sent_at: sent_at,
        recv_at: recv_at,
      );
}
