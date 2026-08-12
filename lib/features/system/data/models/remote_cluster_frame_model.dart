import 'package:flutter_mattermost/features/system/domain/entities/remote_cluster_frame_entity.dart';

final class RemoteClusterFrameModel extends RemoteClusterFrameEntity {
  const RemoteClusterFrameModel({
    required super.remote_id,
    required super.msg,
  });

  factory RemoteClusterFrameModel.fromMap(Map<String, dynamic> map) {
    return RemoteClusterFrameModel(
      remote_id: map["remote_id"] as String?,
      msg: map["msg"] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "remote_id": remote_id,
      "msg": msg,
    };
  }

  factory RemoteClusterFrameModel.fromEntity(RemoteClusterFrameEntity entity) {
    return RemoteClusterFrameModel(
      remote_id: entity.remote_id,
      msg: entity.msg,
    );
  }

  @override
  RemoteClusterFrameModel copyWith({
    String? remote_id,
    Map<String, dynamic>? msg,
  }) {
    return RemoteClusterFrameModel(
      remote_id: remote_id ?? this.remote_id,
      msg: msg ?? this.msg,
    );
  }

  RemoteClusterFrameEntity toEntity() => RemoteClusterFrameEntity(
        remote_id: remote_id,
        msg: msg,
      );
}
