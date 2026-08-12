import 'package:flutter_mattermost/features/auth/domain/entities/new_team_members_list_entity.dart';

final class NewTeamMembersListModel extends NewTeamMembersListEntity {
  const NewTeamMembersListModel({
    required super.has_next,
    required super.items,
    required super.total_count,
  });

  factory NewTeamMembersListModel.fromMap(Map<String, dynamic> map) {
    return NewTeamMembersListModel(
      has_next: map["has_next"] as bool?,
      items: (map["items"] as List<dynamic>? ?? []).map((e) => Map<String, dynamic>.from(e as Map<String, dynamic>)).toList(),
      total_count: (map["total_count"] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "has_next": has_next,
      "items": items,
      "total_count": total_count,
    };
  }

  factory NewTeamMembersListModel.fromEntity(NewTeamMembersListEntity entity) {
    return NewTeamMembersListModel(
      has_next: entity.has_next,
      items: entity.items,
      total_count: entity.total_count,
    );
  }

  @override
  NewTeamMembersListModel copyWith({
    bool? has_next,
    List<Map<String, dynamic>>? items,
    int? total_count,
  }) {
    return NewTeamMembersListModel(
      has_next: has_next ?? this.has_next,
      items: items ?? this.items,
      total_count: total_count ?? this.total_count,
    );
  }

  NewTeamMembersListEntity toEntity() => NewTeamMembersListEntity(
        has_next: has_next,
        items: items,
        total_count: total_count,
      );
}
