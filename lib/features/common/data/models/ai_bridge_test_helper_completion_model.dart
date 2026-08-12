import 'package:flutter_mattermost/features/common/domain/entities/ai_bridge_test_helper_completion_entity.dart';

final class AIBridgeTestHelperCompletionModel extends AIBridgeTestHelperCompletionEntity {
  const AIBridgeTestHelperCompletionModel({
    required super.completion,
    required super.error,
    required super.status_code,
  });

  factory AIBridgeTestHelperCompletionModel.fromMap(Map<String, dynamic> map) {
    return AIBridgeTestHelperCompletionModel(
      completion: map["completion"] as String?,
      error: map["error"] as String?,
      status_code: (map["status_code"] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "completion": completion,
      "error": error,
      "status_code": status_code,
    };
  }

  factory AIBridgeTestHelperCompletionModel.fromEntity(AIBridgeTestHelperCompletionEntity entity) {
    return AIBridgeTestHelperCompletionModel(
      completion: entity.completion,
      error: entity.error,
      status_code: entity.status_code,
    );
  }

  @override
  AIBridgeTestHelperCompletionModel copyWith({
    String? completion,
    String? error,
    int? status_code,
  }) {
    return AIBridgeTestHelperCompletionModel(
      completion: completion ?? this.completion,
      error: error ?? this.error,
      status_code: status_code ?? this.status_code,
    );
  }

  AIBridgeTestHelperCompletionEntity toEntity() => AIBridgeTestHelperCompletionEntity(
        completion: completion,
        error: error,
        status_code: status_code,
      );
}
