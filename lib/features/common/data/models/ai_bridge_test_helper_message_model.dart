import 'package:flutter_mattermost/features/common/domain/entities/ai_bridge_test_helper_message_entity.dart';

final class AIBridgeTestHelperMessageModel extends AIBridgeTestHelperMessageEntity {
  const AIBridgeTestHelperMessageModel({
    required super.role,
    required super.message,
    required super.file_ids,
  });

  factory AIBridgeTestHelperMessageModel.fromMap(Map<String, dynamic> map) {
    return AIBridgeTestHelperMessageModel(
      role: map["role"] as String?,
      message: map["message"] as String?,
      file_ids: List<String>.from(map["file_ids"] as List<dynamic>? ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "role": role,
      "message": message,
      "file_ids": file_ids,
    };
  }

  factory AIBridgeTestHelperMessageModel.fromEntity(AIBridgeTestHelperMessageEntity entity) {
    return AIBridgeTestHelperMessageModel(
      role: entity.role,
      message: entity.message,
      file_ids: entity.file_ids,
    );
  }

  @override
  AIBridgeTestHelperMessageModel copyWith({
    String? role,
    String? message,
    List<String>? file_ids,
  }) {
    return AIBridgeTestHelperMessageModel(
      role: role ?? this.role,
      message: message ?? this.message,
      file_ids: file_ids ?? this.file_ids,
    );
  }

  AIBridgeTestHelperMessageEntity toEntity() => AIBridgeTestHelperMessageEntity(
        role: role,
        message: message,
        file_ids: file_ids,
      );
}
