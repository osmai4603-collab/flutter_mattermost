import 'package:equatable/equatable.dart';

class RemoteClusterFrameEntity extends Equatable {
  final String? remote_id;
  final Map<String, dynamic>? msg;

  const RemoteClusterFrameEntity({
    this.remote_id,
    this.msg,
  });

  @override
  List<Object?> get props => [
        remote_id,
        msg,
      ];

  RemoteClusterFrameEntity copyWith({
    String? remote_id,
    Map<String, dynamic>? msg,
  }) {
    return RemoteClusterFrameEntity(
      remote_id: remote_id ?? this.remote_id,
      msg: msg ?? this.msg,
    );
  }
}
