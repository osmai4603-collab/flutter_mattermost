import 'package:flutter_mattermost/features/system/domain/entities/status_entity.dart';

final class StatusModel extends StatusEntity {
  const StatusModel({
    required super.user_id,
    required super.status,
    required super.manual,
    required super.last_activity_at,
  });

  factory StatusModel.fromMap(Map<String, dynamic> map) {
    return StatusModel(
      user_id: map["user_id"] as String?,
      status: map["status"] as String?,
      manual: map["manual"] as bool?,
      last_activity_at: (map["last_activity_at"] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "user_id": user_id,
      "status": status,
      "manual": manual,
      "last_activity_at": last_activity_at,
    };
  }

  factory StatusModel.fromEntity(StatusEntity entity) {
    return StatusModel(
      user_id: entity.user_id,
      status: entity.status,
      manual: entity.manual,
      last_activity_at: entity.last_activity_at,
    );
  }

  @override
  StatusModel copyWith({
    String? user_id,
    String? status,
    bool? manual,
    int? last_activity_at,
  }) {
    return StatusModel(
      user_id: user_id ?? this.user_id,
      status: status ?? this.status,
      manual: manual ?? this.manual,
      last_activity_at: last_activity_at ?? this.last_activity_at,
    );
  }

  StatusEntity toEntity() => StatusEntity(
        user_id: user_id,
        status: status,
        manual: manual,
        last_activity_at: last_activity_at,
      );
}
