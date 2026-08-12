import 'package:flutter_mattermost/features/common/domain/entities/property_value_request_entity.dart';

final class PropertyValueRequestModel extends PropertyValueRequestEntity {
  const PropertyValueRequestModel({
    required super.value,
  });

  factory PropertyValueRequestModel.fromMap(Map<String, dynamic> map) {
    return PropertyValueRequestModel(
      value: map["value"] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "value": value,
    };
  }

  factory PropertyValueRequestModel.fromEntity(PropertyValueRequestEntity entity) {
    return PropertyValueRequestModel(
      value: entity.value,
    );
  }

  @override
  PropertyValueRequestModel copyWith({
    String? value,
  }) {
    return PropertyValueRequestModel(
      value: value ?? this.value,
    );
  }

  PropertyValueRequestEntity toEntity() => PropertyValueRequestEntity(
        value: value,
      );
}
