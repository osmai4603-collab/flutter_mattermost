import 'package:flutter_mattermost/features/auth/domain/entities/user_threads_entity.dart';

final class UserThreadsModel extends UserThreadsEntity {
  const UserThreadsModel({
    required super.total,
    required super.threads,
  });

  factory UserThreadsModel.fromMap(Map<String, dynamic> map) {
    return UserThreadsModel(
      total: (map["total"] as num?)?.toInt(),
      threads: (map["threads"] as List<dynamic>? ?? []).map((e) => Map<String, dynamic>.from(e as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "total": total,
      "threads": threads,
    };
  }

  factory UserThreadsModel.fromEntity(UserThreadsEntity entity) {
    return UserThreadsModel(
      total: entity.total,
      threads: entity.threads,
    );
  }

  @override
  UserThreadsModel copyWith({
    int? total,
    List<Map<String, dynamic>>? threads,
  }) {
    return UserThreadsModel(
      total: total ?? this.total,
      threads: threads ?? this.threads,
    );
  }

  UserThreadsEntity toEntity() => UserThreadsEntity(
        total: total,
        threads: threads,
      );
}
