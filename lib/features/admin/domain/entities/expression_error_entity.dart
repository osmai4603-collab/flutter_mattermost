import 'package:equatable/equatable.dart';

class ExpressionErrorEntity extends Equatable {
  final String? message;
  final String? field;
  final int? line;
  final int? column;

  const ExpressionErrorEntity({
    this.message,
    this.field,
    this.line,
    this.column,
  });

  @override
  List<Object?> get props => [
        message,
        field,
        line,
        column,
      ];

  ExpressionErrorEntity copyWith({
    String? message,
    String? field,
    int? line,
    int? column,
  }) {
    return ExpressionErrorEntity(
      message: message ?? this.message,
      field: field ?? this.field,
      line: line ?? this.line,
      column: column ?? this.column,
    );
  }
}
