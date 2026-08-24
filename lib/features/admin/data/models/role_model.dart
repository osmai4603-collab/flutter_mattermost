import 'package:flutter_mattermost/features/admin/domain/entities/role_entity.dart';

final class RoleModel extends RoleEntity {
  const RoleModel({
    required super.id,
    required super.name,
    super.displayName,
    super.description,
    super.permissions,
    super.schemeManaged,
    super.builtIn,
    super.schemeId,
  });

  factory RoleModel.fromMap(Map<String, dynamic> data) {
    return RoleModel(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      displayName: data['display_name'] ?? '',
      description: data['description'] ?? '',
      permissions: List<String>.from(data['permissions'] ?? const []),
      schemeManaged: data['scheme_managed'] ?? false,
      builtIn: data['built_in'] ?? false,
      schemeId: data['scheme_id'],
    );
  }

  factory RoleModel.fromEntity(RoleEntity entity) {
    return RoleModel(
      id: entity.id,
      name: entity.name,
      displayName: entity.displayName,
      description: entity.description,
      permissions: entity.permissions,
      schemeManaged: entity.schemeManaged,
      builtIn: entity.builtIn,
      schemeId: entity.schemeId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'display_name': displayName,
      'description': description,
      'permissions': permissions,
      'scheme_managed': schemeManaged,
      'built_in': builtIn,
      'scheme_id': schemeId,
    };
  }

  @override
  RoleModel copyWith({
    String? id,
    String? name,
    String? displayName,
    String? description,
    List<String>? permissions,
    bool? schemeManaged,
    bool? builtIn,
    String? schemeId,
  }) {
    return RoleModel(
      id: id ?? this.id,
      name: name ?? this.name,
      displayName: displayName ?? this.displayName,
      description: description ?? this.description,
      permissions: permissions ?? this.permissions,
      schemeManaged: schemeManaged ?? this.schemeManaged,
      builtIn: builtIn ?? this.builtIn,
      schemeId: schemeId ?? this.schemeId,
    );
  }

  RoleEntity toEntity() {
    return RoleEntity(
      id: id,
      name: name,
      displayName: displayName,
      description: description,
      permissions: permissions,
      schemeManaged: schemeManaged,
      builtIn: builtIn,
      schemeId: schemeId,
    );
  }
}
