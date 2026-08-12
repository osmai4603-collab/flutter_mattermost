import 'package:equatable/equatable.dart';

class RemoteClusterInfoEntity extends Equatable {
  final String? display_name;
  final int? create_at;
  final int? last_ping_at;

  const RemoteClusterInfoEntity({
    this.display_name,
    this.create_at,
    this.last_ping_at,
  });

  @override
  List<Object?> get props => [
        display_name,
        create_at,
        last_ping_at,
      ];

  RemoteClusterInfoEntity copyWith({
    String? display_name,
    int? create_at,
    int? last_ping_at,
  }) {
    return RemoteClusterInfoEntity(
      display_name: display_name ?? this.display_name,
      create_at: create_at ?? this.create_at,
      last_ping_at: last_ping_at ?? this.last_ping_at,
    );
  }
}
