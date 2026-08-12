import 'package:equatable/equatable.dart';

class QueryExpressionParamsEntity extends Equatable {
  final String? expression;
  final String? term;
  final int? limit;
  final String? after;
  final String? channelId;

  const QueryExpressionParamsEntity({
    this.expression,
    this.term,
    this.limit,
    this.after,
    this.channelId,
  });

  @override
  List<Object?> get props => [
        expression,
        term,
        limit,
        after,
        channelId,
      ];

  QueryExpressionParamsEntity copyWith({
    String? expression,
    String? term,
    int? limit,
    String? after,
    String? channelId,
  }) {
    return QueryExpressionParamsEntity(
      expression: expression ?? this.expression,
      term: term ?? this.term,
      limit: limit ?? this.limit,
      after: after ?? this.after,
      channelId: channelId ?? this.channelId,
    );
  }
}
