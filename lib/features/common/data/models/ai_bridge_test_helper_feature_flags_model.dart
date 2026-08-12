import 'package:flutter_mattermost/features/common/domain/entities/ai_bridge_test_helper_feature_flags_entity.dart';

final class AIBridgeTestHelperFeatureFlagsModel extends AIBridgeTestHelperFeatureFlagsEntity {
  const AIBridgeTestHelperFeatureFlagsModel({
    required super.enable_ai_plugin_bridge,
    required super.enable_ai_recaps,
  });

  factory AIBridgeTestHelperFeatureFlagsModel.fromMap(Map<String, dynamic> map) {
    return AIBridgeTestHelperFeatureFlagsModel(
      enable_ai_plugin_bridge: map["enable_ai_plugin_bridge"] as bool?,
      enable_ai_recaps: map["enable_ai_recaps"] as bool?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "enable_ai_plugin_bridge": enable_ai_plugin_bridge,
      "enable_ai_recaps": enable_ai_recaps,
    };
  }

  factory AIBridgeTestHelperFeatureFlagsModel.fromEntity(AIBridgeTestHelperFeatureFlagsEntity entity) {
    return AIBridgeTestHelperFeatureFlagsModel(
      enable_ai_plugin_bridge: entity.enable_ai_plugin_bridge,
      enable_ai_recaps: entity.enable_ai_recaps,
    );
  }

  @override
  AIBridgeTestHelperFeatureFlagsModel copyWith({
    bool? enable_ai_plugin_bridge,
    bool? enable_ai_recaps,
  }) {
    return AIBridgeTestHelperFeatureFlagsModel(
      enable_ai_plugin_bridge: enable_ai_plugin_bridge ?? this.enable_ai_plugin_bridge,
      enable_ai_recaps: enable_ai_recaps ?? this.enable_ai_recaps,
    );
  }

  AIBridgeTestHelperFeatureFlagsEntity toEntity() => AIBridgeTestHelperFeatureFlagsEntity(
        enable_ai_plugin_bridge: enable_ai_plugin_bridge,
        enable_ai_recaps: enable_ai_recaps,
      );
}
