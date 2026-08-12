import 'package:flutter_mattermost/features/common/domain/entities/property_field_patch_entity.dart';

final class PropertyFieldPatchModel extends PropertyFieldPatchEntity {
  const PropertyFieldPatchModel({
    required super.name,
    required super.type,
    required super.attrs,
    required super.linked_field_id,
  });

  factory PropertyFieldPatchModel.fromMap(Map<String, dynamic> map) {
    return PropertyFieldPatchModel(
      name: map["name"] as String?,
      type: map["type"] as String?,
      attrs: map["attrs"] as Map<String, dynamic>?,
      linked_field_id: map["linked_field_id"] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "type": type,
      "attrs": attrs,
      "linked_field_id": linked_field_id,
    };
  }

  factory PropertyFieldPatchModel.fromEntity(PropertyFieldPatchEntity entity) {
    return PropertyFieldPatchModel(
      name: entity.name,
      type: entity.type,
      attrs: entity.attrs,
      linked_field_id: entity.linked_field_id,
    );
  }

  @override
  PropertyFieldPatchModel copyWith({
    String? name,
    String? type,
    Map<String, dynamic>? attrs,
    String? linked_field_id,
  }) {
    return PropertyFieldPatchModel(
      name: name ?? this.name,
      type: type ?? this.type,
      attrs: attrs ?? this.attrs,
      linked_field_id: linked_field_id ?? this.linked_field_id,
    );
  }

  PropertyFieldPatchEntity toEntity() => PropertyFieldPatchEntity(
        name: name,
        type: type,
        attrs: attrs,
        linked_field_id: linked_field_id,
      );
}
