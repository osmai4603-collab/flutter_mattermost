import 'package:flutter_mattermost/features/auth/domain/entities/status_ok_entity.dart';

final class StatusOKModel extends StatusOKEntity {
  const StatusOKModel({
    required super.status,
  });

  factory StatusOKModel.fromMap(Map<String, dynamic> map) {
    return StatusOKModel(
      status: map["status"] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "status": status,
    };
  }

  factory StatusOKModel.fromEntity(StatusOKEntity entity) {
    return StatusOKModel(
      status: entity.status,
    );
  }

  @override
  StatusOKModel copyWith({
    String? status,
  }) {
    return StatusOKModel(
      status: status ?? this.status,
    );
  }

  StatusOKEntity toEntity() => StatusOKEntity(
        status: status,
      );
}
