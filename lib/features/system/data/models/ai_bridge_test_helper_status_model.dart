import 'package:flutter_mattermost/features/system/domain/entities/ai_bridge_test_helper_status_entity.dart';

final class AIBridgeTestHelperStatusModel extends AIBridgeTestHelperStatusEntity {
  const AIBridgeTestHelperStatusModel({
    required super.available,
    required super.reason,
  });

  factory AIBridgeTestHelperStatusModel.fromMap(Map<String, dynamic> map) {
    return AIBridgeTestHelperStatusModel(
      available: map["available"] as bool?,
      reason: map["reason"] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "available": available,
      "reason": reason,
    };
  }

  factory AIBridgeTestHelperStatusModel.fromEntity(AIBridgeTestHelperStatusEntity entity) {
    return AIBridgeTestHelperStatusModel(
      available: entity.available,
      reason: entity.reason,
    );
  }

  @override
  AIBridgeTestHelperStatusModel copyWith({
    bool? available,
    String? reason,
  }) {
    return AIBridgeTestHelperStatusModel(
      available: available ?? this.available,
      reason: reason ?? this.reason,
    );
  }

  AIBridgeTestHelperStatusEntity toEntity() => AIBridgeTestHelperStatusEntity(
        available: available,
        reason: reason,
      );
}
