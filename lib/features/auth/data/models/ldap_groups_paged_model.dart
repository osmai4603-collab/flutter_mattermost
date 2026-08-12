import 'package:flutter_mattermost/features/auth/domain/entities/ldap_groups_paged_entity.dart';

final class LDAPGroupsPagedModel extends LDAPGroupsPagedEntity {
  const LDAPGroupsPagedModel({
    required super.count,
    required super.groups,
  });

  factory LDAPGroupsPagedModel.fromMap(Map<String, dynamic> map) {
    return LDAPGroupsPagedModel(
      count: (map["count"] as num?)?.toDouble(),
      groups: (map["groups"] as List<dynamic>? ?? []).map((e) => Map<String, dynamic>.from(e as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "count": count,
      "groups": groups,
    };
  }

  factory LDAPGroupsPagedModel.fromEntity(LDAPGroupsPagedEntity entity) {
    return LDAPGroupsPagedModel(
      count: entity.count,
      groups: entity.groups,
    );
  }

  @override
  LDAPGroupsPagedModel copyWith({
    double? count,
    List<Map<String, dynamic>>? groups,
  }) {
    return LDAPGroupsPagedModel(
      count: count ?? this.count,
      groups: groups ?? this.groups,
    );
  }

  LDAPGroupsPagedEntity toEntity() => LDAPGroupsPagedEntity(
        count: count,
        groups: groups,
      );
}
