import 'package:flutter_mattermost/features/channels/domain/entities/recap_channel_entity.dart';

final class RecapChannelModel extends RecapChannelEntity {
  const RecapChannelModel({
    required super.id,
    required super.recap_id,
    required super.channel_id,
    required super.channel_name,
    required super.highlights,
    required super.action_items,
    required super.source_post_ids,
    required super.create_at,
  });

  factory RecapChannelModel.fromMap(Map<String, dynamic> map) {
    return RecapChannelModel(
      id: map["id"] as String?,
      recap_id: map["recap_id"] as String?,
      channel_id: map["channel_id"] as String?,
      channel_name: map["channel_name"] as String?,
      highlights: List<String>.from(map["highlights"] as List<dynamic>? ?? []),
      action_items: List<String>.from(map["action_items"] as List<dynamic>? ?? []),
      source_post_ids: List<String>.from(map["source_post_ids"] as List<dynamic>? ?? []),
      create_at: (map["create_at"] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "recap_id": recap_id,
      "channel_id": channel_id,
      "channel_name": channel_name,
      "highlights": highlights,
      "action_items": action_items,
      "source_post_ids": source_post_ids,
      "create_at": create_at,
    };
  }

  factory RecapChannelModel.fromEntity(RecapChannelEntity entity) {
    return RecapChannelModel(
      id: entity.id,
      recap_id: entity.recap_id,
      channel_id: entity.channel_id,
      channel_name: entity.channel_name,
      highlights: entity.highlights,
      action_items: entity.action_items,
      source_post_ids: entity.source_post_ids,
      create_at: entity.create_at,
    );
  }

  @override
  RecapChannelModel copyWith({
    String? id,
    String? recap_id,
    String? channel_id,
    String? channel_name,
    List<String>? highlights,
    List<String>? action_items,
    List<String>? source_post_ids,
    int? create_at,
  }) {
    return RecapChannelModel(
      id: id ?? this.id,
      recap_id: recap_id ?? this.recap_id,
      channel_id: channel_id ?? this.channel_id,
      channel_name: channel_name ?? this.channel_name,
      highlights: highlights ?? this.highlights,
      action_items: action_items ?? this.action_items,
      source_post_ids: source_post_ids ?? this.source_post_ids,
      create_at: create_at ?? this.create_at,
    );
  }

  RecapChannelEntity toEntity() => RecapChannelEntity(
        id: id,
        recap_id: recap_id,
        channel_id: channel_id,
        channel_name: channel_name,
        highlights: highlights,
        action_items: action_items,
        source_post_ids: source_post_ids,
        create_at: create_at,
      );
}
