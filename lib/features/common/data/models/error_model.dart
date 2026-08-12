import 'package:flutter_mattermost/features/common/domain/entities/error_entity.dart';

final class ErrorModel extends ErrorEntity {
  const ErrorModel({
    required super.error,
    required super.details,
  });

  factory ErrorModel.fromMap(Map<String, dynamic> map) {
    return ErrorModel(
      error: map["error"] as String?,
      details: map["details"] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "error": error,
      "details": details,
    };
  }

  factory ErrorModel.fromEntity(ErrorEntity entity) {
    return ErrorModel(
      error: entity.error,
      details: entity.details,
    );
  }

  @override
  ErrorModel copyWith({
    String? error,
    String? details,
  }) {
    return ErrorModel(
      error: error ?? this.error,
      details: details ?? this.details,
    );
  }

  ErrorEntity toEntity() => ErrorEntity(
        error: error,
        details: details,
      );
}
