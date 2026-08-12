import 'package:flutter_mattermost/core/entities/entity.dart';

class TeamMemberEntity extends Entity {
  final String userId;
  final String teamId;
  final String roles;
  final int createAt;
  final int deleteAt;
  final int msgCount;
  final int mentionCount;
  final Map<String, dynamic> notifyProps;
  final int lastUpdateAt;
  final bool schemeUser;
  final bool schemeAdmin;
  final bool schemeGuest;
  final String explicitRoles;

  const TeamMemberEntity({
    required this.userId,
    required this.teamId,
    this.roles = '',
    this.createAt = 0,
    this.deleteAt = 0,
    this.msgCount = 0,
    this.mentionCount = 0,
    this.notifyProps = const {},
    this.lastUpdateAt = 0,
    this.schemeUser = true,
    this.schemeAdmin = false,
    this.schemeGuest = false,
    this.explicitRoles = '',
  });

  @override
  List<Object?> get props => [
        userId,
        teamId,
        roles,
        createAt,
        deleteAt,
        msgCount,
        mentionCount,
        notifyProps,
        lastUpdateAt,
        schemeUser,
        schemeAdmin,
        schemeGuest,
        explicitRoles,
      ];

  @override
  TeamMemberEntity copyWith({
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
    return TeamMemberEntity(
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
}
