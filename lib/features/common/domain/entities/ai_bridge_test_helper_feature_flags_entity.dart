import 'package:equatable/equatable.dart';

class AIBridgeTestHelperFeatureFlagsEntity extends Equatable {
  final bool? enable_ai_plugin_bridge;
  final bool? enable_ai_recaps;

  const AIBridgeTestHelperFeatureFlagsEntity({
    this.enable_ai_plugin_bridge,
    this.enable_ai_recaps,
  });

  @override
  List<Object?> get props => [
        enable_ai_plugin_bridge,
        enable_ai_recaps,
      ];

  AIBridgeTestHelperFeatureFlagsEntity copyWith({
    bool? enable_ai_plugin_bridge,
    bool? enable_ai_recaps,
  }) {
    return AIBridgeTestHelperFeatureFlagsEntity(
      enable_ai_plugin_bridge: enable_ai_plugin_bridge ?? this.enable_ai_plugin_bridge,
      enable_ai_recaps: enable_ai_recaps ?? this.enable_ai_recaps,
    );
  }
}
