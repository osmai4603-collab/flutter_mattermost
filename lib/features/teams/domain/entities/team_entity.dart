import 'package:flutter_mattermost/core/entities/entity.dart';
import 'package:flutter_mattermost/core/enums/team_type.dart';

class TeamEntity extends Entity {
  final String id;
  final String name;
  final String displayName;
  final String description;
  final TeamType type;
  final int createAt;
  final int updateAt;
  final int deleteAt;
  final String email;
  final String companyName;
  final String allowedDomains;
  final String inviteId;
  final bool allowOpenInvite;
  final String? schemeId;
  final bool? groupConstrained;
  final String? policyId;
  final bool cloudLimitsArchived;
  final bool policyEnforced;
  final bool policyIsActive;

  const TeamEntity({
    required this.id,
    required this.name,
    required this.displayName,
    this.description = '',
    required this.type,
    this.createAt = 0,
    this.updateAt = 0,
    this.deleteAt = 0,
    this.email = '',
    this.companyName = '',
    this.allowedDomains = '',
    this.inviteId = '',
    this.allowOpenInvite = false,
    this.schemeId,
    this.groupConstrained,
    this.policyId,
    this.cloudLimitsArchived = false,
    this.policyEnforced = false,
    this.policyIsActive = false,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        displayName,
        description,
        type,
        createAt,
        updateAt,
        deleteAt,
        email,
        companyName,
        allowedDomains,
        inviteId,
        allowOpenInvite,
        schemeId,
        groupConstrained,
        policyId,
        cloudLimitsArchived,
        policyEnforced,
        policyIsActive,
      ];

  @override
  TeamEntity copyWith({
    String? id,
    String? name,
    String? displayName,
    String? description,
    TeamType? type,
    int? createAt,
    int? updateAt,
    int? deleteAt,
    String? email,
    String? companyName,
    String? allowedDomains,
    String? inviteId,
    bool? allowOpenInvite,
    String? schemeId,
    bool? groupConstrained,
    String? policyId,
    bool? cloudLimitsArchived,
    bool? policyEnforced,
    bool? policyIsActive,
  }) {
    return TeamEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      displayName: displayName ?? this.displayName,
      description: description ?? this.description,
      type: type ?? this.type,
      createAt: createAt ?? this.createAt,
      updateAt: updateAt ?? this.updateAt,
      deleteAt: deleteAt ?? this.deleteAt,
      email: email ?? this.email,
      companyName: companyName ?? this.companyName,
      allowedDomains: allowedDomains ?? this.allowedDomains,
      inviteId: inviteId ?? this.inviteId,
      allowOpenInvite: allowOpenInvite ?? this.allowOpenInvite,
      schemeId: schemeId ?? this.schemeId,
      groupConstrained: groupConstrained ?? this.groupConstrained,
      policyId: policyId ?? this.policyId,
      cloudLimitsArchived: cloudLimitsArchived ?? this.cloudLimitsArchived,
      policyEnforced: policyEnforced ?? this.policyEnforced,
      policyIsActive: policyIsActive ?? this.policyIsActive,
    );
  }
}
