import 'package:flutter_mattermost/features/channels/domain/entities/sidebar_category_entity.dart';

final class SidebarCategoryModel extends SidebarCategoryEntity {
  const SidebarCategoryModel({
    required super.id,
    required super.user_id,
    required super.team_id,
    required super.display_name,
    required super.type,
  });

  factory SidebarCategoryModel.fromMap(Map<String, dynamic> map) {
    return SidebarCategoryModel(
      id: map["id"] as String?,
      user_id: map["user_id"] as String?,
      team_id: map["team_id"] as String?,
      display_name: map["display_name"] as String?,
      type: map["type"] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "user_id": user_id,
      "team_id": team_id,
      "display_name": display_name,
      "type": type,
    };
  }

  factory SidebarCategoryModel.fromEntity(SidebarCategoryEntity entity) {
    return SidebarCategoryModel(
      id: entity.id,
      user_id: entity.user_id,
      team_id: entity.team_id,
      display_name: entity.display_name,
      type: entity.type,
    );
  }

  @override
  SidebarCategoryModel copyWith({
    String? id,
    String? user_id,
    String? team_id,
    String? display_name,
    String? type,
  }) {
    return SidebarCategoryModel(
      id: id ?? this.id,
      user_id: user_id ?? this.user_id,
      team_id: team_id ?? this.team_id,
      display_name: display_name ?? this.display_name,
      type: type ?? this.type,
    );
  }

  SidebarCategoryEntity toEntity() => SidebarCategoryEntity(
        id: id,
        user_id: user_id,
        team_id: team_id,
        display_name: display_name,
        type: type,
      );
}
