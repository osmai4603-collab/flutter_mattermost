import 'package:flutter_mattermost/features/teams/domain/entities/team_member_entity.dart';

final class TeamMemberModel extends TeamMemberEntity {
  const TeamMemberModel({
    required super.userId,
    required super.teamId,
    super.roles,
    super.createAt,
    super.deleteAt,
    super.msgCount,
    super.mentionCount,
    super.notifyProps,
    super.lastUpdateAt,
    super.schemeUser,
    super.schemeAdmin,
    super.schemeGuest,
    super.explicitRoles,
  });

  factory TeamMemberModel.fromMap(Map<String, dynamic> data) {
    return TeamMemberModel(
      userId: data['user_id'] ?? '',
      teamId: data['team_id'] ?? '',
      roles: data['roles'] ?? '',
      createAt: (data['create_at'] ?? 0).toInt(),
      deleteAt: (data['delete_at'] ?? 0).toInt(),
      msgCount: (data['msg_count'] ?? 0).toInt(),
      mentionCount: (data['mention_count'] ?? 0).toInt(),
      notifyProps: Map<String, dynamic>.from(data['notify_props'] ?? const {}),
      lastUpdateAt: (data['last_update_at'] ?? 0).toInt(),
      schemeUser: data['scheme_user'] ?? true,
      schemeAdmin: data['scheme_admin'] ?? false,
      schemeGuest: data['scheme_guest'] ?? false,
      explicitRoles: data['explicit_roles'] ?? '',
    );
  }

  factory TeamMemberModel.fromEntity(TeamMemberEntity entity) {
    return TeamMemberModel(
      userId: entity.userId,
      teamId: entity.teamId,
      roles: entity.roles,
      createAt: entity.createAt,
      deleteAt: entity.deleteAt,
      msgCount: entity.msgCount,
      mentionCount: entity.mentionCount,
      notifyProps: entity.notifyProps,
      lastUpdateAt: entity.lastUpdateAt,
      schemeUser: entity.schemeUser,
      schemeAdmin: entity.schemeAdmin,
      schemeGuest: entity.schemeGuest,
      explicitRoles: entity.explicitRoles,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'team_id': teamId,
      'roles': roles,
      'create_at': createAt,
      'delete_at': deleteAt,
      'msg_count': msgCount,
      'mention_count': mentionCount,
      'notify_props': notifyProps,
      'last_update_at': lastUpdateAt,
      'scheme_user': schemeUser,
      'scheme_admin': schemeAdmin,
      'scheme_guest': schemeGuest,
      'explicit_roles': explicitRoles,
    };
  }

  @override
  TeamMemberModel copyWith({
    String? userId,
    String? teamId,
    String? roles,
    int? createAt,
    int? deleteAt,
    int? msgCount,
    int? mentionCount,
    Map<String, dynamic>? notifyProps,
    int? lastUpdateAt,
    bool? schemeUser,
    bool? schemeAdmin,
    bool? schemeGuest,
    String? explicitRoles,
  }) {
    return TeamMemberModel(
      userId: userId ?? this.userId,
      teamId: teamId ?? this.teamId,
      roles: roles ?? this.roles,
      createAt: createAt ?? this.createAt,
      deleteAt: deleteAt ?? this.deleteAt,
      msgCount: msgCount ?? this.msgCount,
      mentionCount: mentionCount ?? this.mentionCount,
      notifyProps: notifyProps ?? this.notifyProps,
      lastUpdateAt: lastUpdateAt ?? this.lastUpdateAt,
      schemeUser: schemeUser ?? this.schemeUser,
      schemeAdmin: schemeAdmin ?? this.schemeAdmin,
      schemeGuest: schemeGuest ?? this.schemeGuest,
      explicitRoles: explicitRoles ?? this.explicitRoles,
    );
  }

  TeamMemberEntity toEntity() {
    return TeamMemberEntity(
      userId: userId,
      teamId: teamId,
      roles: roles,
      createAt: createAt,
      deleteAt: deleteAt,
      msgCount: msgCount,
      mentionCount: mentionCount,
      notifyProps: notifyProps,
      lastUpdateAt: lastUpdateAt,
      schemeUser: schemeUser,
      schemeAdmin: schemeAdmin,
      schemeGuest: schemeGuest,
      explicitRoles: explicitRoles,
    );
  }
}
