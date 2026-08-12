import 'package:flutter_mattermost/features/system/domain/entities/server_limits_entity.dart';

final class ServerLimitsModel extends ServerLimitsEntity {
  const ServerLimitsModel({
    required super.maxUsersLimit,
    required super.activeUserCount,
  });

  factory ServerLimitsModel.fromMap(Map<String, dynamic> map) {
    return ServerLimitsModel(
      maxUsersLimit: (map["maxUsersLimit"] as num?)?.toInt(),
      activeUserCount: (map["activeUserCount"] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "maxUsersLimit": maxUsersLimit,
      "activeUserCount": activeUserCount,
    };
  }

  factory ServerLimitsModel.fromEntity(ServerLimitsEntity entity) {
    return ServerLimitsModel(
      maxUsersLimit: entity.maxUsersLimit,
      activeUserCount: entity.activeUserCount,
    );
  }

  @override
  ServerLimitsModel copyWith({
    int? maxUsersLimit,
    int? activeUserCount,
  }) {
    return ServerLimitsModel(
      maxUsersLimit: maxUsersLimit ?? this.maxUsersLimit,
      activeUserCount: activeUserCount ?? this.activeUserCount,
    );
  }

  ServerLimitsEntity toEntity() => ServerLimitsEntity(
        maxUsersLimit: maxUsersLimit,
        activeUserCount: activeUserCount,
      );
}
