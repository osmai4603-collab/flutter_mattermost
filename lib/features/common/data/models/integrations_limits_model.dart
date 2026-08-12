import 'package:flutter_mattermost/features/common/domain/entities/integrations_limits_entity.dart';

final class IntegrationsLimitsModel extends IntegrationsLimitsEntity {
  const IntegrationsLimitsModel({
    required super.enabled,
  });

  factory IntegrationsLimitsModel.fromMap(Map<String, dynamic> map) {
    return IntegrationsLimitsModel(
      enabled: (map["enabled"] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "enabled": enabled,
    };
  }

  factory IntegrationsLimitsModel.fromEntity(IntegrationsLimitsEntity entity) {
    return IntegrationsLimitsModel(
      enabled: entity.enabled,
    );
  }

  @override
  IntegrationsLimitsModel copyWith({
    int? enabled,
  }) {
    return IntegrationsLimitsModel(
      enabled: enabled ?? this.enabled,
    );
  }

  IntegrationsLimitsEntity toEntity() => IntegrationsLimitsEntity(
        enabled: enabled,
      );
}
