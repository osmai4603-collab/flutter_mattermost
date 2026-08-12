import 'package:flutter_mattermost/features/admin/domain/entities/access_control_policy_entity.dart';

final class AccessControlPolicyModel extends AccessControlPolicyEntity {
  const AccessControlPolicyModel({
    required super.id,
    required super.name,
    required super.display_name,
    required super.description,
    required super.expression,
    required super.is_active,
    required super.create_at,
    required super.update_at,
    required super.delete_at,
  });

  factory AccessControlPolicyModel.fromMap(Map<String, dynamic> map) {
    return AccessControlPolicyModel(
      id: map["id"] as String?,
      name: map["name"] as String?,
      display_name: map["display_name"] as String?,
      description: map["description"] as String?,
      expression: map["expression"] as String?,
      is_active: map["is_active"] as bool?,
      create_at: (map["create_at"] as num?)?.toInt(),
      update_at: (map["update_at"] as num?)?.toInt(),
      delete_at: (map["delete_at"] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "display_name": display_name,
      "description": description,
      "expression": expression,
      "is_active": is_active,
      "create_at": create_at,
      "update_at": update_at,
      "delete_at": delete_at,
    };
  }

  factory AccessControlPolicyModel.fromEntity(AccessControlPolicyEntity entity) {
    return AccessControlPolicyModel(
      id: entity.id,
      name: entity.name,
      display_name: entity.display_name,
      description: entity.description,
      expression: entity.expression,
      is_active: entity.is_active,
      create_at: entity.create_at,
      update_at: entity.update_at,
      delete_at: entity.delete_at,
    );
  }

  AccessControlPolicyModel copyWith({
    String? id,
    String? name,
    String? display_name,
    String? description,
    String? expression,
    bool? is_active,
    int? create_at,
    int? update_at,
    int? delete_at,
  }) {
    return AccessControlPolicyModel(
      id: id ?? this.id,
      name: name ?? this.name,
      display_name: display_name ?? this.display_name,
      description: description ?? this.description,
      expression: expression ?? this.expression,
      is_active: is_active ?? this.is_active,
      create_at: create_at ?? this.create_at,
      update_at: update_at ?? this.update_at,
      delete_at: delete_at ?? this.delete_at,
    );
  }

  AccessControlPolicyEntity toEntity() => AccessControlPolicyEntity(
        id: id,
        name: name,
        display_name: display_name,
        description: description,
        expression: expression,
        is_active: is_active,
        create_at: create_at,
        update_at: update_at,
        delete_at: delete_at,
      );
}
