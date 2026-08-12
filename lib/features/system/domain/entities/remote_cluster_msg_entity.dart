import 'package:equatable/equatable.dart';

class RemoteClusterMsgEntity extends Equatable {
  final String? id;
  final String? topic;
  final int? create_at;
  final Map<String, dynamic>? payload;

  const RemoteClusterMsgEntity({
    this.id,
    this.topic,
    this.create_at,
    this.payload,
  });

  @override
  List<Object?> get props => [
        id,
        topic,
        create_at,
        payload,
      ];

  RemoteClusterMsgEntity copyWith({
    String? id,
    String? topic,
    int? create_at,
    Map<String, dynamic>? payload,
  }) {
    return RemoteClusterMsgEntity(
      id: id ?? this.id,
      topic: topic ?? this.topic,
      create_at: create_at ?? this.create_at,
      payload: payload ?? this.payload,
    );
  }
}
