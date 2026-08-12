import 'package:equatable/equatable.dart';

class ComparisonConditionEntity extends Equatable {
  final String? field_id;
  final dynamic value;

  const ComparisonConditionEntity({
    required this.field_id,
    required this.value,
  });

  @override
  List<Object?> get props => [
        field_id,
        value,
      ];

  ComparisonConditionEntity copyWith({
    String? field_id,
    dynamic value,
  }) {
    return ComparisonConditionEntity(
      field_id: field_id ?? this.field_id,
      value: value ?? this.value,
    );
  }
}
