import 'package:flutter_mattermost/features/admin/domain/entities/custom_attribute_value_entity.dart';

final class CustomAttributeValueModel extends CustomAttributeValueEntity {
  const CustomAttributeValueModel({
    required super.id,
    required super.post_id,
    required super.attr_id,
    required super.value,
    required super.create_at,
    required super.update_at,
  });

  factory CustomAttributeValueModel.fromMap(Map<String, dynamic> map) {
    return CustomAttributeValueModel(
      id: map["id"] as String?,
      post_id: map["post_id"] as String?,
      attr_id: map["attr_id"] as String?,
      value: map["value"] as String?,
      create_at: (map["create_at"] as num?)?.toInt(),
      update_at: (map["update_at"] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "post_id": post_id,
      "attr_id": attr_id,
      "value": value,
      "create_at": create_at,
      "update_at": update_at,
    };
  }

  factory CustomAttributeValueModel.fromEntity(CustomAttributeValueEntity entity) {
    return CustomAttributeValueModel(
      id: entity.id,
      post_id: entity.post_id,
      attr_id: entity.attr_id,
      value: entity.value,
      create_at: entity.create_at,
      update_at: entity.update_at,
    );
  }

  CustomAttributeValueModel copyWith({
    String? id,
    String? post_id,
    String? attr_id,
    String? value,
    int? create_at,
    int? update_at,
  }) {
    return CustomAttributeValueModel(
      id: id ?? this.id,
      post_id: post_id ?? this.post_id,
      attr_id: attr_id ?? this.attr_id,
      value: value ?? this.value,
      create_at: create_at ?? this.create_at,
      update_at: update_at ?? this.update_at,
    );
  }

  CustomAttributeValueEntity toEntity() => CustomAttributeValueEntity(
        id: id,
        post_id: post_id,
        attr_id: attr_id,
        value: value,
        create_at: create_at,
        update_at: update_at,
      );
}
