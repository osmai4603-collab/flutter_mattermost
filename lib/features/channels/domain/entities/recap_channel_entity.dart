import 'package:equatable/equatable.dart';

class RecapChannelEntity extends Equatable {
  final String? id;
  final String? recap_id;
  final String? channel_id;
  final String? channel_name;
  final List<String>? highlights;
  final List<String>? action_items;
  final List<String>? source_post_ids;
  final int? create_at;

  const RecapChannelEntity({
    this.id,
    this.recap_id,
    this.channel_id,
    this.channel_name,
    this.highlights,
    this.action_items,
    this.source_post_ids,
    this.create_at,
  });

  @override
  List<Object?> get props => [
        id,
        recap_id,
        channel_id,
        channel_name,
        highlights,
        action_items,
        source_post_ids,
        create_at,
      ];

  RecapChannelEntity copyWith({
    String? id,
    String? recap_id,
    String? channel_id,
    String? channel_name,
    List<String>? highlights,
    List<String>? action_items,
    List<String>? source_post_ids,
    int? create_at,
  }) {
    return RecapChannelEntity(
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
}
