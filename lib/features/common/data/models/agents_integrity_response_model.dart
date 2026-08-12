import 'package:flutter_mattermost/features/common/domain/entities/agents_integrity_response_entity.dart';

final class AgentsIntegrityResponseModel extends AgentsIntegrityResponseEntity {
  const AgentsIntegrityResponseModel({
    required super.available,
    required super.reason,
  });

  factory AgentsIntegrityResponseModel.fromMap(Map<String, dynamic> map) {
    return AgentsIntegrityResponseModel(
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

  factory AgentsIntegrityResponseModel.fromEntity(AgentsIntegrityResponseEntity entity) {
    return AgentsIntegrityResponseModel(
      available: entity.available,
      reason: entity.reason,
    );
  }

  @override
  AgentsIntegrityResponseModel copyWith({
    bool? available,
    String? reason,
  }) {
    return AgentsIntegrityResponseModel(
      available: available ?? this.available,
      reason: reason ?? this.reason,
    );
  }

  AgentsIntegrityResponseEntity toEntity() => AgentsIntegrityResponseEntity(
        available: available,
        reason: reason,
      );
}
