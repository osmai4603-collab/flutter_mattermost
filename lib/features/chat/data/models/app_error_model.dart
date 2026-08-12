import 'package:flutter_mattermost/features/chat/domain/entities/app_error_entity.dart';

final class AppErrorModel extends AppErrorEntity {
  const AppErrorModel({
    required super.status_code,
    required super.id,
    required super.message,
    required super.request_id,
  });

  factory AppErrorModel.fromMap(Map<String, dynamic> map) {
    return AppErrorModel(
      status_code: (map["status_code"] as num?)?.toInt(),
      id: map["id"] as String?,
      message: map["message"] as String?,
      request_id: map["request_id"] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "status_code": status_code,
      "id": id,
      "message": message,
      "request_id": request_id,
    };
  }

  factory AppErrorModel.fromEntity(AppErrorEntity entity) {
    return AppErrorModel(
      status_code: entity.status_code,
      id: entity.id,
      message: entity.message,
      request_id: entity.request_id,
    );
  }

  @override
  AppErrorModel copyWith({
    int? status_code,
    String? id,
    String? message,
    String? request_id,
  }) {
    return AppErrorModel(
      status_code: status_code ?? this.status_code,
      id: id ?? this.id,
      message: message ?? this.message,
      request_id: request_id ?? this.request_id,
    );
  }

  AppErrorEntity toEntity() => AppErrorEntity(
        status_code: status_code,
        id: id,
        message: message,
        request_id: request_id,
      );
}
