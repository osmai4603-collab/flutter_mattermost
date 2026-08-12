import 'package:flutter_mattermost/features/admin/domain/entities/custom_attribute_field_entity.dart';

final class CustomAttributeFieldModel extends CustomAttributeFieldEntity {
  const CustomAttributeFieldModel({
    required super.id,
    required super.name,
    required super.type,
    required super.group_id,
    required super.attrs,
    required super.create_at,
    required super.update_at,
    required super.delete_at,
  });

  factory CustomAttributeFieldModel.fromMap(Map<String, dynamic> map) {
    return CustomAttributeFieldModel(
      id: map["id"] as String?,
      name: map["name"] as String?,
      type: map["type"] as String?,
      group_id: map["group_id"] as String?,
      attrs: map["attrs"] as Map<String, dynamic>?,
      create_at: (map["create_at"] as num?)?.toInt(),
      update_at: (map["update_at"] as num?)?.toInt(),
      delete_at: (map["delete_at"] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "type": type,
      "group_id": group_id,
      "attrs": attrs,
      "create_at": create_at,
      "update_at": update_at,
      "delete_at": delete_at,
    };
  }

  factory CustomAttributeFieldModel.fromEntity(CustomAttributeFieldEntity entity) {
    return CustomAttributeFieldModel(
      id: entity.id,
      name: entity.name,
      type: entity.type,
      group_id: entity.group_id,
      attrs: entity.attrs,
      create_at: entity.create_at,
      update_at: entity.update_at,
      delete_at: entity.delete_at,
    );
  }

  CustomAttributeFieldModel copyWith({
    String? id,
    String? name,
    String? type,
    String? group_id,
    Map<String,dynamic>? attrs,
    int? create_at,
    int? update_at,
    int? delete_at,
  }) {
    return CustomAttributeFieldModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      group_id: group_id ?? this.group_id,
      attrs: attrs ?? this.attrs,
      create_at: create_at ?? this.create_at,
      update_at: update_at ?? this.update_at,
      delete_at: delete_at ?? this.delete_at,
    );
  }

  CustomAttributeFieldEntity toEntity() => CustomAttributeFieldEntity(
        id: id,
        name: name,
        type: type,
        group_id: group_id,
        attrs: attrs,
        create_at: create_at,
        update_at: update_at,
        delete_at: delete_at,
      );
}
