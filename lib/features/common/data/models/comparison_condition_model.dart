import 'package:flutter_mattermost/features/common/domain/entities/comparison_condition_entity.dart';

final class ComparisonConditionModel extends ComparisonConditionEntity {
  const ComparisonConditionModel({
    required super.field_id,
    required super.value,
  });

  factory ComparisonConditionModel.fromMap(Map<String, dynamic> map) {
    return ComparisonConditionModel(
      field_id: map["field_id"] as String?,
      value: map["value"] ?? null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "field_id": field_id,
      "value": value,
    };
  }

  factory ComparisonConditionModel.fromEntity(ComparisonConditionEntity entity) {
    return ComparisonConditionModel(
      field_id: entity.field_id,
      value: entity.value,
    );
  }

  @override
  ComparisonConditionModel copyWith({
    String? field_id,
    dynamic value,
  }) {
    return ComparisonConditionModel(
      field_id: field_id ?? this.field_id,
      value: value ?? this.value,
    );
  }

  ComparisonConditionEntity toEntity() => ComparisonConditionEntity(
        field_id: field_id,
        value: value,
      );
}
