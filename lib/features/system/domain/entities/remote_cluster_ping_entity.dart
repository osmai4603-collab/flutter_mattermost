import 'package:equatable/equatable.dart';

class RemoteClusterPingEntity extends Equatable {
  final int? sent_at;
  final int? recv_at;

  const RemoteClusterPingEntity({
    this.sent_at,
    this.recv_at,
  });

  @override
  List<Object?> get props => [
        sent_at,
        recv_at,
      ];

  RemoteClusterPingEntity copyWith({
    int? sent_at,
    int? recv_at,
  }) {
    return RemoteClusterPingEntity(
      sent_at: sent_at ?? this.sent_at,
      recv_at: recv_at ?? this.recv_at,
    );
  }
}
