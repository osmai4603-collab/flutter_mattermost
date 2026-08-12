import 'package:flutter_mattermost/core/enums/team_type.dart';
import 'package:flutter_mattermost/features/teams/domain/entities/team_entity.dart';

final class TeamModel extends TeamEntity {
  const TeamModel({
    required super.id,
    required super.name,
    required super.displayName,
    required super.description,
    required super.type,
    required super.createAt,
    required super.updateAt,
    required super.deleteAt,
    required super.email,
    required super.companyName,
    required super.allowedDomains,
    required super.inviteId,
    required super.allowOpenInvite,
    super.schemeId,
    super.groupConstrained,
    super.policyId,
    required super.cloudLimitsArchived,
    required super.policyEnforced,
    required super.policyIsActive,
  });

  factory TeamModel.fromMap(Map<String, dynamic> data) {
    return TeamModel(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      displayName: data['display_name'] ?? '',
      description: data['description'] ?? '',
      type: TeamType.fromValue(data['type'] ?? 'O'),
      createAt: (data['create_at'] ?? 0).toInt(),
      updateAt: (data['update_at'] ?? 0).toInt(),
      deleteAt: (data['delete_at'] ?? 0).toInt(),
      email: data['email'] ?? '',
      companyName: data['company_name'] ?? '',
      allowedDomains: data['allowed_domains'] ?? '',
      inviteId: data['invite_id'] ?? '',
      allowOpenInvite: data['allow_open_invite'] ?? false,
      schemeId: data['scheme_id'],
      groupConstrained: data['group_constrained'],
      policyId: data['policy_id'],
      cloudLimitsArchived: data['cloud_limits_archived'] ?? false,
      policyEnforced: data['policy_enforced'] ?? false,
      policyIsActive: data['policy_is_active'] ?? false,
    );
  }

  factory TeamModel.fromEntity(TeamEntity entity) {
    return TeamModel(
      id: entity.id,
      name: entity.name,
      displayName: entity.displayName,
      description: entity.description,
      type: entity.type,
      createAt: entity.createAt,
      updateAt: entity.updateAt,
      deleteAt: entity.deleteAt,
      email: entity.email,
      companyName: entity.companyName,
      allowedDomains: entity.allowedDomains,
      inviteId: entity.inviteId,
      allowOpenInvite: entity.allowOpenInvite,
      schemeId: entity.schemeId,
      groupConstrained: entity.groupConstrained,
      policyId: entity.policyId,
      cloudLimitsArchived: entity.cloudLimitsArchived,
      policyEnforced: entity.policyEnforced,
      policyIsActive: entity.policyIsActive,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'display_name': displayName,
      'description': description,
      'type': type.value,
      'create_at': createAt,
      'update_at': updateAt,
      'delete_at': deleteAt,
      'email': email,
      'company_name': companyName,
      'allowed_domains': allowedDomains,
      'invite_id': inviteId,
      'allow_open_invite': allowOpenInvite,
      'scheme_id': schemeId,
      'group_constrained': groupConstrained,
      'policy_id': policyId,
      'cloud_limits_archived': cloudLimitsArchived,
      'policy_enforced': policyEnforced,
      'policy_is_active': policyIsActive,
    };
  }

  @override
  TeamModel copyWith({
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
    return TeamModel(
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

  TeamEntity toEntity() {
    return TeamEntity(
      id: id,
      name: name,
      displayName: displayName,
      description: description,
      type: type,
      createAt: createAt,
      updateAt: updateAt,
      deleteAt: deleteAt,
      email: email,
      companyName: companyName,
      allowedDomains: allowedDomains,
      inviteId: inviteId,
      allowOpenInvite: allowOpenInvite,
      schemeId: schemeId,
      groupConstrained: groupConstrained,
      policyId: policyId,
      cloudLimitsArchived: cloudLimitsArchived,
      policyEnforced: policyEnforced,
      policyIsActive: policyIsActive,
    );
  }
}
