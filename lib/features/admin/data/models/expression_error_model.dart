import 'package:flutter_mattermost/features/admin/domain/entities/expression_error_entity.dart';

final class ExpressionErrorModel extends ExpressionErrorEntity {
  const ExpressionErrorModel({
    required super.message,
    required super.field,
    required super.line,
    required super.column,
  });

  factory ExpressionErrorModel.fromMap(Map<String, dynamic> map) {
    return ExpressionErrorModel(
      message: map["message"] as String?,
      field: map["field"] as String?,
      line: (map["line"] as num?)?.toInt(),
      column: (map["column"] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {"message": message, "field": field, "line": line, "column": column};
  }

  factory ExpressionErrorModel.fromEntity(ExpressionErrorEntity entity) {
    return ExpressionErrorModel(
      message: entity.message,
      field: entity.field,
      line: entity.line,
      column: entity.column,
    );
  }

  ExpressionErrorModel copyWith({
    String? message,
    String? field,
    int? line,
    int? column,
  }) {
    return ExpressionErrorModel(
      message: message ?? this.message,
      field: field ?? this.field,
      line: line ?? this.line,
      column: column ?? this.column,
    );
  }

  ExpressionErrorEntity toEntity() => ExpressionErrorEntity(
    message: message,
    field: field,
    line: line,
    column: column,
  );
}
