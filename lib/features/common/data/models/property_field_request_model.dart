import 'package:flutter_mattermost/features/common/domain/entities/property_field_request_entity.dart';

final class PropertyFieldRequestModel extends PropertyFieldRequestEntity {
  const PropertyFieldRequestModel({
    required super.name,
    required super.type,
    required super.attrs,
  });

  factory PropertyFieldRequestModel.fromMap(Map<String, dynamic> map) {
    return PropertyFieldRequestModel(
      name: map["name"] as String?,
      type: map["type"] as String?,
      attrs: map["attrs"] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "type": type,
      "attrs": attrs,
    };
  }

  factory PropertyFieldRequestModel.fromEntity(PropertyFieldRequestEntity entity) {
    return PropertyFieldRequestModel(
      name: entity.name,
      type: entity.type,
      attrs: entity.attrs,
    );
  }

  @override
  PropertyFieldRequestModel copyWith({
    String? name,
    String? type,
    Map<String, dynamic>? attrs,
  }) {
    return PropertyFieldRequestModel(
      name: name ?? this.name,
      type: type ?? this.type,
      attrs: attrs ?? this.attrs,
    );
  }

  PropertyFieldRequestEntity toEntity() => PropertyFieldRequestEntity(
        name: name,
        type: type,
        attrs: attrs,
      );
}
