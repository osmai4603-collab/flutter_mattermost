import 'package:flutter_mattermost/features/admin/domain/entities/cel_expression_entity.dart';

final class CELExpressionModel extends CELExpressionEntity {
  const CELExpressionModel({
    required super.expression,
    required super.channelId,
  });

  factory CELExpressionModel.fromMap(Map<String, dynamic> map) {
    return CELExpressionModel(
      expression: map["expression"] as String?,
      channelId: map["channelId"] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "expression": expression,
      "channelId": channelId,
    };
  }

  factory CELExpressionModel.fromEntity(CELExpressionEntity entity) {
    return CELExpressionModel(
      expression: entity.expression,
      channelId: entity.channelId,
    );
  }

  CELExpressionModel copyWith({
    String? expression,
    String? channelId,
  }) {
    return CELExpressionModel(
      expression: expression ?? this.expression,
      channelId: channelId ?? this.channelId,
    );
  }

  CELExpressionEntity toEntity() => CELExpressionEntity(
        expression: expression,
        channelId: channelId,
      );
}
