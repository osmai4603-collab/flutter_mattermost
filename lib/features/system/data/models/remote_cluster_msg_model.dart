import 'package:flutter_mattermost/features/system/domain/entities/remote_cluster_msg_entity.dart';

final class RemoteClusterMsgModel extends RemoteClusterMsgEntity {
  const RemoteClusterMsgModel({
    required super.id,
    required super.topic,
    required super.create_at,
    required super.payload,
  });

  factory RemoteClusterMsgModel.fromMap(Map<String, dynamic> map) {
    return RemoteClusterMsgModel(
      id: map["id"] as String?,
      topic: map["topic"] as String?,
      create_at: (map["create_at"] as num?)?.toInt(),
      payload: map["payload"] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "topic": topic,
      "create_at": create_at,
      "payload": payload,
    };
  }

  factory RemoteClusterMsgModel.fromEntity(RemoteClusterMsgEntity entity) {
    return RemoteClusterMsgModel(
      id: entity.id,
      topic: entity.topic,
      create_at: entity.create_at,
      payload: entity.payload,
    );
  }

  @override
  RemoteClusterMsgModel copyWith({
    String? id,
    String? topic,
    int? create_at,
    Map<String, dynamic>? payload,
  }) {
    return RemoteClusterMsgModel(
      id: id ?? this.id,
      topic: topic ?? this.topic,
      create_at: create_at ?? this.create_at,
      payload: payload ?? this.payload,
    );
  }

  RemoteClusterMsgEntity toEntity() => RemoteClusterMsgEntity(
        id: id,
        topic: topic,
        create_at: create_at,
        payload: payload,
      );
}
