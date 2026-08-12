import 'package:flutter_mattermost/features/admin/domain/entities/query_expression_params_entity.dart';

final class QueryExpressionParamsModel extends QueryExpressionParamsEntity {
  const QueryExpressionParamsModel({
    required super.expression,
    required super.term,
    required super.limit,
    required super.after,
    required super.channelId,
  });

  factory QueryExpressionParamsModel.fromMap(Map<String, dynamic> map) {
    return QueryExpressionParamsModel(
      expression: map["expression"] as String?,
      term: map["term"] as String?,
      limit: (map["limit"] as num?)?.toInt(),
      after: map["after"] as String?,
      channelId: map["channelId"] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "expression": expression,
      "term": term,
      "limit": limit,
      "after": after,
      "channelId": channelId,
    };
  }

  factory QueryExpressionParamsModel.fromEntity(QueryExpressionParamsEntity entity) {
    return QueryExpressionParamsModel(
      expression: entity.expression,
      term: entity.term,
      limit: entity.limit,
      after: entity.after,
      channelId: entity.channelId,
    );
  }

  QueryExpressionParamsModel copyWith({
    String? expression,
    String? term,
    int? limit,
    String? after,
    String? channelId,
  }) {
    return QueryExpressionParamsModel(
      expression: expression ?? this.expression,
      term: term ?? this.term,
      limit: limit ?? this.limit,
      after: after ?? this.after,
      channelId: channelId ?? this.channelId,
    );
  }

  QueryExpressionParamsEntity toEntity() => QueryExpressionParamsEntity(
        expression: expression,
        term: term,
        limit: limit,
        after: after,
        channelId: channelId,
      );
}
