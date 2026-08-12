import 'package:equatable/equatable.dart';

class RemoteClusterResponseEntity extends Equatable {
  final String? status;
  final String? err;
  final Map<String, dynamic>? payload;

  const RemoteClusterResponseEntity({
    this.status,
    this.err,
    this.payload,
  });

  @override
  List<Object?> get props => [
        status,
        err,
        payload,
      ];

  RemoteClusterResponseEntity copyWith({
    String? status,
    String? err,
    Map<String, dynamic>? payload,
  }) {
    return RemoteClusterResponseEntity(
      status: status ?? this.status,
      err: err ?? this.err,
      payload: payload ?? this.payload,
    );
  }
}
