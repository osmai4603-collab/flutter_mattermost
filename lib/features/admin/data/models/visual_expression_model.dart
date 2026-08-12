import 'package:flutter_mattermost/features/admin/domain/entities/visual_expression_entity.dart';

final class VisualExpressionModel extends VisualExpressionEntity {
  const VisualExpressionModel({
    required super.conditions,
  });

  factory VisualExpressionModel.fromMap(Map<String, dynamic> map) {
    return VisualExpressionModel(
      conditions: (map["conditions"] as List<dynamic>? ?? []).map((e) => Map<String, dynamic>.from(e as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "conditions": conditions,
    };
  }

  factory VisualExpressionModel.fromEntity(VisualExpressionEntity entity) {
    return VisualExpressionModel(
      conditions: entity.conditions,
    );
  }

  VisualExpressionModel copyWith({
    List<Map<String, dynamic>>? conditions,
  }) {
    return VisualExpressionModel(
      conditions: conditions ?? this.conditions,
    );
  }

  VisualExpressionEntity toEntity() => VisualExpressionEntity(
        conditions: conditions,
      );
}
