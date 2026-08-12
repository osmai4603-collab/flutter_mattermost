import 'package:flutter_mattermost/core/entities/entity.dart';

enum UserStatus {
  offline,
  online,
  away,
  dnd;

  static UserStatus fromValue(String? value) {
    switch ((value ?? '').toLowerCase()) {
      case 'online':
        return UserStatus.online;
      case 'away':
        return UserStatus.away;
      case 'dnd':
        return UserStatus.dnd;
      case 'offline':
      default:
        return UserStatus.offline;
    }
  }

  String get value => name;
}

class UserStatusEntity extends Entity {
  final String serverId;
  final String userId;
  final UserStatus status;
  final bool manual;
  final int lastActivityAt;
  final String customStatus;

  const UserStatusEntity({
    this.serverId = '',
    required this.userId,
    this.status = UserStatus.offline,
    this.manual = false,
    this.lastActivityAt = 0,
    this.customStatus = '',
  });

  @override
  List<Object?> get props => [
        serverId,
        userId,
        status,
        manual,
        lastActivityAt,
        customStatus,
      ];

  UserStatusEntity copyWith({
    String? serverId,
    String? userId,
    UserStatus? status,
    bool? manual,
    int? lastActivityAt,
    String? customStatus,
  }) {
    return UserStatusEntity(
      serverId: serverId ?? this.serverId,
      userId: userId ?? this.userId,
      status: status ?? this.status,
      manual: manual ?? this.manual,
      lastActivityAt: lastActivityAt ?? this.lastActivityAt,
      customStatus: customStatus ?? this.customStatus,
    );
  }
}
