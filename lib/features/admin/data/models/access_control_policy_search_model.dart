import 'package:flutter_mattermost/features/admin/domain/entities/access_control_policy_search_entity.dart';

final class AccessControlPolicySearchModel extends AccessControlPolicySearchEntity {
  const AccessControlPolicySearchModel({
    required super.term,
    required super.type,
    required super.parent_id,
    required super.ids,
    required super.active,
    required super.include_children,
    required super.cursor,
    required super.limit,
  });

  factory AccessControlPolicySearchModel.fromMap(Map<String, dynamic> map) {
    return AccessControlPolicySearchModel(
      term: map["term"] as String?,
      type: map["type"] as String?,
      parent_id: map["parent_id"] as String?,
      ids: List<String>.from(map["ids"] as List<dynamic>? ?? []),
      active: map["active"] as bool?,
      include_children: map["include_children"] as bool?,
      cursor: map["cursor"] as Map<String, dynamic>?,
      limit: (map["limit"] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "term": term,
      "type": type,
      "parent_id": parent_id,
      "ids": ids,
      "active": active,
      "include_children": include_children,
      "cursor": cursor,
      "limit": limit,
    };
  }

  factory AccessControlPolicySearchModel.fromEntity(AccessControlPolicySearchEntity entity) {
    return AccessControlPolicySearchModel(
      term: entity.term,
      type: entity.type,
      parent_id: entity.parent_id,
      ids: entity.ids,
      active: entity.active,
      include_children: entity.include_children,
      cursor: entity.cursor,
      limit: entity.limit,
    );
  }

  AccessControlPolicySearchModel copyWith({
    String? term,
    String? type,
    String? parent_id,
    List<String>? ids,
    bool? active,
    bool? include_children,
    Map<String, dynamic>? cursor,
    int? limit,
  }) {
    return AccessControlPolicySearchModel(
      term: term ?? this.term,
      type: type ?? this.type,
      parent_id: parent_id ?? this.parent_id,
      ids: ids ?? this.ids,
      active: active ?? this.active,
      include_children: include_children ?? this.include_children,
      cursor: cursor ?? this.cursor,
      limit: limit ?? this.limit,
    );
  }

  AccessControlPolicySearchEntity toEntity() => AccessControlPolicySearchEntity(
        term: term,
        type: type,
        parent_id: parent_id,
        ids: ids,
        active: active,
        include_children: include_children,
        cursor: cursor,
        limit: limit,
      );
}
