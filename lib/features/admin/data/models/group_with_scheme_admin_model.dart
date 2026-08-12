import 'package:flutter_mattermost/features/admin/domain/entities/group_with_scheme_admin_entity.dart';

final class GroupWithSchemeAdminModel extends GroupWithSchemeAdminEntity {
  const GroupWithSchemeAdminModel({
    required super.group,
    required super.scheme_admin,
  });

  factory GroupWithSchemeAdminModel.fromMap(Map<String, dynamic> map) {
    return GroupWithSchemeAdminModel(
      group: map["group"] as Map<String, dynamic>?,
      scheme_admin: map["scheme_admin"] as bool?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "group": group,
      "scheme_admin": scheme_admin,
    };
  }

  factory GroupWithSchemeAdminModel.fromEntity(GroupWithSchemeAdminEntity entity) {
    return GroupWithSchemeAdminModel(
      group: entity.group,
      scheme_admin: entity.scheme_admin,
    );
  }

  GroupWithSchemeAdminModel copyWith({
    Map<String, dynamic>? group,
    bool? scheme_admin,
  }) {
    return GroupWithSchemeAdminModel(
      group: group ?? this.group,
      scheme_admin: scheme_admin ?? this.scheme_admin,
    );
  }

  GroupWithSchemeAdminEntity toEntity() => GroupWithSchemeAdminEntity(
        group: group,
        scheme_admin: scheme_admin,
      );
}
