import 'package:flutter_mattermost/features/common/domain/entities/property_field_entity.dart';

final class PropertyFieldModel extends PropertyFieldEntity {
  const PropertyFieldModel({
    required super.id,
    required super.type,
    required super.name,
    required super.description,
    required super.create_at,
    required super.update_at,
    required super.delete_at,
    required super.attrs,
  });

  factory PropertyFieldModel.fromMap(Map<String, dynamic> map) {
    return PropertyFieldModel(
      id: map["id"] as String?,
      type: map["type"] as String?,
      name: map["name"] as String?,
      description: map["description"] as String?,
      create_at: (map["create_at"] as num?)?.toInt(),
      update_at: (map["update_at"] as num?)?.toInt(),
      delete_at: (map["delete_at"] as num?)?.toInt(),
      attrs: map["attrs"] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "type": type,
      "name": name,
      "description": description,
      "create_at": create_at,
      "update_at": update_at,
      "delete_at": delete_at,
      "attrs": attrs,
    };
  }

  factory PropertyFieldModel.fromEntity(PropertyFieldEntity entity) {
    return PropertyFieldModel(
      id: entity.id,
      type: entity.type,
      name: entity.name,
      description: entity.description,
      create_at: entity.create_at,
      update_at: entity.update_at,
      delete_at: entity.delete_at,
      attrs: entity.attrs,
    );
  }

  @override
  PropertyFieldModel copyWith({
    String? id,
    String? type,
    String? name,
    String? description,
    int? create_at,
    int? update_at,
    int? delete_at,
    Map<String, dynamic>? attrs,
  }) {
    return PropertyFieldModel(
      id: id ?? this.id,
      type: type ?? this.type,
      name: name ?? this.name,
      description: description ?? this.description,
      create_at: create_at ?? this.create_at,
      update_at: update_at ?? this.update_at,
      delete_at: delete_at ?? this.delete_at,
      attrs: attrs ?? this.attrs,
    );
  }

  PropertyFieldEntity toEntity() => PropertyFieldEntity(
        id: id,
        type: type,
        name: name,
        description: description,
        create_at: create_at,
        update_at: update_at,
        delete_at: delete_at,
        attrs: attrs,
      );
}
