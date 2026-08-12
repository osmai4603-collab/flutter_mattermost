import 'package:flutter_mattermost/features/auth/domain/entities/user_status_entity.dart';

final class UserStatusModel extends UserStatusEntity {
  const UserStatusModel({
    super.serverId,
    required super.userId,
    super.status,
    super.manual,
    super.lastActivityAt,
    super.customStatus,
  });

  factory UserStatusModel.fromMap(Map<String, dynamic> data) {
    return UserStatusModel(
      serverId: data['server_id'] ?? '',
      userId: data['user_id'] ?? '',
      status: UserStatus.fromValue(data['status']?.toString()),
      manual: data['manual'] ?? false,
      lastActivityAt: (data['last_activity_at'] ?? 0).toInt(),
      customStatus: data['custom_status'] ?? '',
    );
  }

  factory UserStatusModel.fromEntity(UserStatusEntity entity) {
    return UserStatusModel(
      serverId: entity.serverId,
      userId: entity.userId,
      status: entity.status,
      manual: entity.manual,
      lastActivityAt: entity.lastActivityAt,
      customStatus: entity.customStatus,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'server_id': serverId,
      'user_id': userId,
      'status': status.value,
      'manual': manual,
      'last_activity_at': lastActivityAt,
      'custom_status': customStatus,
    };
  }

  @override
  UserStatusModel copyWith({
    String? serverId,
    String? userId,
    UserStatus? status,
    bool? manual,
    int? lastActivityAt,
    String? customStatus,
  }) {
    return UserStatusModel(
      serverId: serverId ?? this.serverId,
      userId: userId ?? this.userId,
      status: status ?? this.status,
      manual: manual ?? this.manual,
      lastActivityAt: lastActivityAt ?? this.lastActivityAt,
      customStatus: customStatus ?? this.customStatus,
    );
  }

  UserStatusEntity toEntity() {
    return UserStatusEntity(
      serverId: serverId,
      userId: userId,
      status: status,
      manual: manual,
      lastActivityAt: lastActivityAt,
      customStatus: customStatus,
    );
  }
}
