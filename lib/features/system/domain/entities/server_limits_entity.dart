import 'package:equatable/equatable.dart';

class ServerLimitsEntity extends Equatable {
  final int? maxUsersLimit;
  final int? activeUserCount;

  const ServerLimitsEntity({
    this.maxUsersLimit,
    this.activeUserCount,
  });

  @override
  List<Object?> get props => [
        maxUsersLimit,
        activeUserCount,
      ];

  ServerLimitsEntity copyWith({
    int? maxUsersLimit,
    int? activeUserCount,
  }) {
    return ServerLimitsEntity(
      maxUsersLimit: maxUsersLimit ?? this.maxUsersLimit,
      activeUserCount: activeUserCount ?? this.activeUserCount,
    );
  }
}
