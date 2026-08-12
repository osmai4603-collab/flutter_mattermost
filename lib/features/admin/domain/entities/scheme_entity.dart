import 'package:flutter_mattermost/core/entities/entity.dart';

class SchemeEntity extends Entity {
  final String id;
  final String name;
  final String displayName;
  final String description;
  final String scope;
  final int createAt;
  final int updateAt;
  final int deleteAt;
  final String defaultTeamAdminRole;
  final String defaultTeamUserRole;
  final String defaultTeamGuestRole;
  final String defaultChannelAdminRole;
  final String defaultChannelUserRole;
  final String defaultChannelGuestRole;

  const SchemeEntity({
    required this.id,
    required this.name,
    this.displayName = '',
    this.description = '',
    this.scope = 'team',
    this.createAt = 0,
    this.updateAt = 0,
    this.deleteAt = 0,
    this.defaultTeamAdminRole = '',
    this.defaultTeamUserRole = '',
    this.defaultTeamGuestRole = '',
    this.defaultChannelAdminRole = '',
    this.defaultChannelUserRole = '',
    this.defaultChannelGuestRole = '',
  });

  @override
  List<Object?> get props => [
        id,
        name,
        displayName,
        description,
        scope,
        createAt,
        updateAt,
        deleteAt,
        defaultTeamAdminRole,
        defaultTeamUserRole,
        defaultTeamGuestRole,
        defaultChannelAdminRole,
        defaultChannelUserRole,
        defaultChannelGuestRole,
      ];

  SchemeEntity copyWith({
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
    return SchemeEntity(
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
}
