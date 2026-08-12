import 'package:flutter_mattermost/features/common/domain/entities/property_value_entity.dart';

final class PropertyValueModel extends PropertyValueEntity {
  const PropertyValueModel({
    required super.id,
    required super.field_id,
    required super.value,
    required super.create_at,
    required super.update_at,
    required super.delete_at,
  });

  factory PropertyValueModel.fromMap(Map<String, dynamic> map) {
    return PropertyValueModel(
      id: map["id"] as String?,
      field_id: map["field_id"] as String?,
      value: map["value"] as String?,
      create_at: (map["create_at"] as num?)?.toInt(),
      update_at: (map["update_at"] as num?)?.toInt(),
      delete_at: (map["delete_at"] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "field_id": field_id,
      "value": value,
      "create_at": create_at,
      "update_at": update_at,
      "delete_at": delete_at,
    };
  }

  factory PropertyValueModel.fromEntity(PropertyValueEntity entity) {
    return PropertyValueModel(
      id: entity.id,
      field_id: entity.field_id,
      value: entity.value,
      create_at: entity.create_at,
      update_at: entity.update_at,
      delete_at: entity.delete_at,
    );
  }

  @override
  PropertyValueModel copyWith({
    String? id,
    String? field_id,
    String? value,
    int? create_at,
    int? update_at,
    int? delete_at,
  }) {
    return PropertyValueModel(
      id: id ?? this.id,
      field_id: field_id ?? this.field_id,
      value: value ?? this.value,
      create_at: create_at ?? this.create_at,
      update_at: update_at ?? this.update_at,
      delete_at: delete_at ?? this.delete_at,
    );
  }

  PropertyValueEntity toEntity() => PropertyValueEntity(
        id: id,
        field_id: field_id,
        value: value,
        create_at: create_at,
        update_at: update_at,
        delete_at: delete_at,
      );
}
