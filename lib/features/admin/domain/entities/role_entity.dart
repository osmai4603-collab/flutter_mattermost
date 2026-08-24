import 'package:flutter_mattermost/core/entities/entity.dart';

class RoleEntity extends Entity {
  final String id;
  final String name;
  final String displayName;
  final String description;
  final List<String> permissions;
  final bool schemeManaged;
  final bool builtIn;
  final String? schemeId;

  const RoleEntity({
    required this.id,
    required this.name,
    this.displayName = '',
    this.description = '',
    this.permissions = const [],
    this.schemeManaged = false,
    this.builtIn = false,
    this.schemeId,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    displayName,
    description,
    permissions,
    schemeManaged,
    builtIn,
    schemeId,
  ];

  RoleEntity copyWith({
    String? id,
    String? name,
    String? displayName,
    String? description,
    List<String>? permissions,
    bool? schemeManaged,
    bool? builtIn,
    String? schemeId,
  }) {
    return RoleEntity(
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

  bool hasPermission(dynamic permission) =>
      permissions.contains(permission.toString());

  bool canReadAdminConsole() {
    return permissions.any(
      (permission) => permission.contains('sysconsole_read'),
    );
  }

  bool canWriteAdminConsole() {
    return permissions.any(
      (permission) => permission.contains('sysconsole_write'),
    );
  }
}
