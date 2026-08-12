import 'package:equatable/equatable.dart';

class CELExpressionEntity extends Equatable {
  final String? expression;
  final String? channelId;

  const CELExpressionEntity({
    this.expression,
    this.channelId,
  });

  @override
  List<Object?> get props => [
        expression,
        channelId,
      ];

  CELExpressionEntity copyWith({
    String? expression,
    String? channelId,
  }) {
    return CELExpressionEntity(
      expression: expression ?? this.expression,
      channelId: channelId ?? this.channelId,
    );
  }
}
