import 'package:flutter_mattermost/features/groups/domain/entities/ldap_group_entity.dart';

final class LDAPGroupModel extends LDAPGroupEntity {
  const LDAPGroupModel({
    required super.has_syncables,
    required super.mattermost_group_id,
    required super.primary_key,
    required super.name,
  });

  factory LDAPGroupModel.fromMap(Map<String, dynamic> map) {
    return LDAPGroupModel(
      has_syncables: map["has_syncables"] as bool?,
      mattermost_group_id: map["mattermost_group_id"] as String?,
      primary_key: map["primary_key"] as String?,
      name: map["name"] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "has_syncables": has_syncables,
      "mattermost_group_id": mattermost_group_id,
      "primary_key": primary_key,
      "name": name,
    };
  }

  factory LDAPGroupModel.fromEntity(LDAPGroupEntity entity) {
    return LDAPGroupModel(
      has_syncables: entity.has_syncables,
      mattermost_group_id: entity.mattermost_group_id,
      primary_key: entity.primary_key,
      name: entity.name,
    );
  }

  @override
  LDAPGroupModel copyWith({
    bool? has_syncables,
    String? mattermost_group_id,
    String? primary_key,
    String? name,
  }) {
    return LDAPGroupModel(
      has_syncables: has_syncables ?? this.has_syncables,
      mattermost_group_id: mattermost_group_id ?? this.mattermost_group_id,
      primary_key: primary_key ?? this.primary_key,
      name: name ?? this.name,
    );
  }

  LDAPGroupEntity toEntity() => LDAPGroupEntity(
        has_syncables: has_syncables,
        mattermost_group_id: mattermost_group_id,
        primary_key: primary_key,
        name: name,
      );
}
