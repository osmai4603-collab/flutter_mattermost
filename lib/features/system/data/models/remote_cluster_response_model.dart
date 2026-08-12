import 'package:flutter_mattermost/features/system/domain/entities/remote_cluster_response_entity.dart';

final class RemoteClusterResponseModel extends RemoteClusterResponseEntity {
  const RemoteClusterResponseModel({
    required super.status,
    required super.err,
    required super.payload,
  });

  factory RemoteClusterResponseModel.fromMap(Map<String, dynamic> map) {
    return RemoteClusterResponseModel(
      status: map["status"] as String?,
      err: map["err"] as String?,
      payload: map["payload"] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "status": status,
      "err": err,
      "payload": payload,
    };
  }

  factory RemoteClusterResponseModel.fromEntity(RemoteClusterResponseEntity entity) {
    return RemoteClusterResponseModel(
      status: entity.status,
      err: entity.err,
      payload: entity.payload,
    );
  }

  @override
  RemoteClusterResponseModel copyWith({
    String? status,
    String? err,
    Map<String, dynamic>? payload,
  }) {
    return RemoteClusterResponseModel(
      status: status ?? this.status,
      err: err ?? this.err,
      payload: payload ?? this.payload,
    );
  }

  RemoteClusterResponseEntity toEntity() => RemoteClusterResponseEntity(
        status: status,
        err: err,
        payload: payload,
      );
}
