import 'package:flutter_mattermost/features/auth/domain/entities/users_stats_entity.dart';

final class UsersStatsModel extends UsersStatsEntity {
  const UsersStatsModel({
    required super.total_users_count,
  });

  factory UsersStatsModel.fromMap(Map<String, dynamic> map) {
    return UsersStatsModel(
      total_users_count: (map["total_users_count"] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "total_users_count": total_users_count,
    };
  }

  factory UsersStatsModel.fromEntity(UsersStatsEntity entity) {
    return UsersStatsModel(
      total_users_count: entity.total_users_count,
    );
  }

  @override
  UsersStatsModel copyWith({
    int? total_users_count,
  }) {
    return UsersStatsModel(
      total_users_count: total_users_count ?? this.total_users_count,
    );
  }

  UsersStatsEntity toEntity() => UsersStatsEntity(
        total_users_count: total_users_count,
      );
}
