import 'package:flutter_mattermost/features/admin/domain/entities/scheme_entity.dart';

final class SchemeModel extends SchemeEntity {
  const SchemeModel({
    required super.id,
    required super.name,
    super.displayName,
    super.description,
    super.scope,
    super.createAt,
    super.updateAt,
    super.deleteAt,
    super.defaultTeamAdminRole,
    super.defaultTeamUserRole,
    super.defaultTeamGuestRole,
    super.defaultChannelAdminRole,
    super.defaultChannelUserRole,
    super.defaultChannelGuestRole,
  });

  factory SchemeModel.fromMap(Map<String, dynamic> data) {
    return SchemeModel(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      displayName: data['display_name'] ?? '',
      description: data['description'] ?? '',
      scope: data['scope'] ?? 'team',
      createAt: (data['create_at'] ?? 0).toInt(),
      updateAt: (data['update_at'] ?? 0).toInt(),
      deleteAt: (data['delete_at'] ?? 0).toInt(),
      defaultTeamAdminRole: data['default_team_admin_role'] ?? '',
      defaultTeamUserRole: data['default_team_user_role'] ?? '',
      defaultTeamGuestRole: data['default_team_guest_role'] ?? '',
      defaultChannelAdminRole: data['default_channel_admin_role'] ?? '',
      defaultChannelUserRole: data['default_channel_user_role'] ?? '',
      defaultChannelGuestRole: data['default_channel_guest_role'] ?? '',
    );
  }

  factory SchemeModel.fromEntity(SchemeEntity entity) {
    return SchemeModel(
      id: entity.id,
      name: entity.name,
      displayName: entity.displayName,
      description: entity.description,
      scope: entity.scope,
      createAt: entity.createAt,
      updateAt: entity.updateAt,
      deleteAt: entity.deleteAt,
      defaultTeamAdminRole: entity.defaultTeamAdminRole,
      defaultTeamUserRole: entity.defaultTeamUserRole,
      defaultTeamGuestRole: entity.defaultTeamGuestRole,
      defaultChannelAdminRole: entity.defaultChannelAdminRole,
      defaultChannelUserRole: entity.defaultChannelUserRole,
      defaultChannelGuestRole: entity.defaultChannelGuestRole,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'display_name': displayName,
      'description': description,
      'scope': scope,
      'create_at': createAt,
      'update_at': updateAt,
      'delete_at': deleteAt,
      'default_team_admin_role': defaultTeamAdminRole,
      'default_team_user_role': defaultTeamUserRole,
      'default_team_guest_role': defaultTeamGuestRole,
      'default_channel_admin_role': defaultChannelAdminRole,
      'default_channel_user_role': defaultChannelUserRole,
      'default_channel_guest_role': defaultChannelGuestRole,
    };
  }

  SchemeModel copyWith({
    String? id,
    String? name,
    String? displayName,
    String? description,
    String? scope,
    int? createAt,
    int? updateAt,
    int? deleteAt,
    String? defaultTeamAdminRole,
    String? defaultTeamUserRole,
    String? defaultTeamGuestRole,
    String? defaultChannelAdminRole,
    String? defaultChannelUserRole,
    String? defaultChannelGuestRole,
  }) {
    return SchemeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      displayName: displayName ?? this.displayName,
      description: description ?? this.description,
      scope: scope ?? this.scope,
      createAt: createAt ?? this.createAt,
      updateAt: updateAt ?? this.updateAt,
      deleteAt: deleteAt ?? this.deleteAt,
      defaultTeamAdminRole: defaultTeamAdminRole ?? this.defaultTeamAdminRole,
      defaultTeamUserRole: defaultTeamUserRole ?? this.defaultTeamUserRole,
      defaultTeamGuestRole: defaultTeamGuestRole ?? this.defaultTeamGuestRole,
      defaultChannelAdminRole: defaultChannelAdminRole ?? this.defaultChannelAdminRole,
      defaultChannelUserRole: defaultChannelUserRole ?? this.defaultChannelUserRole,
      defaultChannelGuestRole: defaultChannelGuestRole ?? this.defaultChannelGuestRole,
    );
  }

  SchemeEntity toEntity() {
    return SchemeEntity(
      id: id,
      name: name,
      displayName: displayName,
      description: description,
      scope: scope,
      createAt: createAt,
      updateAt: updateAt,
      deleteAt: deleteAt,
      defaultTeamAdminRole: defaultTeamAdminRole,
      defaultTeamUserRole: defaultTeamUserRole,
      defaultTeamGuestRole: defaultTeamGuestRole,
      defaultChannelAdminRole: defaultChannelAdminRole,
      defaultChannelUserRole: defaultChannelUserRole,
      defaultChannelGuestRole: defaultChannelGuestRole,
    );
  }
}
