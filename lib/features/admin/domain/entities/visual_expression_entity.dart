import 'package:equatable/equatable.dart';

class VisualExpressionEntity extends Equatable {
  final List<Map<String, dynamic>>? conditions;

  const VisualExpressionEntity({
    this.conditions,
  });

  @override
  List<Object?> get props => [
        conditions,
      ];

  VisualExpressionEntity copyWith({
    List<Map<String, dynamic>>? conditions,
  }) {
    return VisualExpressionEntity(
      conditions: conditions ?? this.conditions,
    );
  }
}
