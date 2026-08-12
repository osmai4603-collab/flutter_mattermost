import 'package:flutter_mattermost/features/channels/domain/entities/sidebar_category_with_channels_entity.dart';

final class SidebarCategoryWithChannelsModel extends SidebarCategoryWithChannelsEntity {
  const SidebarCategoryWithChannelsModel({
    required super.id,
    required super.user_id,
    required super.team_id,
    required super.display_name,
    required super.type,
    required super.channel_ids,
  });

  factory SidebarCategoryWithChannelsModel.fromMap(Map<String, dynamic> map) {
    return SidebarCategoryWithChannelsModel(
      id: map["id"] as String?,
      user_id: map["user_id"] as String?,
      team_id: map["team_id"] as String?,
      display_name: map["display_name"] as String?,
      type: map["type"] as String?,
      channel_ids: List<String>.from(map["channel_ids"] as List<dynamic>? ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "user_id": user_id,
      "team_id": team_id,
      "display_name": display_name,
      "type": type,
      "channel_ids": channel_ids,
    };
  }

  factory SidebarCategoryWithChannelsModel.fromEntity(SidebarCategoryWithChannelsEntity entity) {
    return SidebarCategoryWithChannelsModel(
      id: entity.id,
      user_id: entity.user_id,
      team_id: entity.team_id,
      display_name: entity.display_name,
      type: entity.type,
      channel_ids: entity.channel_ids,
    );
  }

  @override
  SidebarCategoryWithChannelsModel copyWith({
    String? id,
    String? user_id,
    String? team_id,
    String? display_name,
    String? type,
    List<String>? channel_ids,
  }) {
    return SidebarCategoryWithChannelsModel(
      id: id ?? this.id,
      user_id: user_id ?? this.user_id,
      team_id: team_id ?? this.team_id,
      display_name: display_name ?? this.display_name,
      type: type ?? this.type,
      channel_ids: channel_ids ?? this.channel_ids,
    );
  }

  SidebarCategoryWithChannelsEntity toEntity() => SidebarCategoryWithChannelsEntity(
        id: id,
        user_id: user_id,
        team_id: team_id,
        display_name: display_name,
        type: type,
        channel_ids: channel_ids,
      );
}
