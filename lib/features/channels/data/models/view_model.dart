import 'package:flutter_mattermost/features/channels/domain/entities/view_entity.dart';

final class ViewModel extends ViewEntity {
  const ViewModel({
    required super.id,
    required super.channel_id,
    required super.type,
    required super.creator_id,
    required super.title,
    required super.description,
    required super.sort_order,
    required super.props,
    required super.create_at,
    required super.update_at,
    required super.delete_at,
  });

  factory ViewModel.fromMap(Map<String, dynamic> map) {
    return ViewModel(
      id: map["id"] as String?,
      channel_id: map["channel_id"] as String?,
      type: map["type"] as String?,
      creator_id: map["creator_id"] as String?,
      title: map["title"] as String?,
      description: map["description"] as String?,
      sort_order: (map["sort_order"] as num?)?.toInt(),
      props: map["props"] as Map<String, dynamic>?,
      create_at: (map["create_at"] as num?)?.toInt(),
      update_at: (map["update_at"] as num?)?.toInt(),
      delete_at: (map["delete_at"] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "channel_id": channel_id,
      "type": type,
      "creator_id": creator_id,
      "title": title,
      "description": description,
      "sort_order": sort_order,
      "props": props,
      "create_at": create_at,
      "update_at": update_at,
      "delete_at": delete_at,
    };
  }

  factory ViewModel.fromEntity(ViewEntity entity) {
    return ViewModel(
      id: entity.id,
      channel_id: entity.channel_id,
      type: entity.type,
      creator_id: entity.creator_id,
      title: entity.title,
      description: entity.description,
      sort_order: entity.sort_order,
      props: entity.props,
      create_at: entity.create_at,
      update_at: entity.update_at,
      delete_at: entity.delete_at,
    );
  }

  @override
  ViewModel copyWith({
    String? id,
    String? channel_id,
    String? type,
    String? creator_id,
    String? title,
    String? description,
    int? sort_order,
    Map<String, dynamic>? props,
    int? create_at,
    int? update_at,
    int? delete_at,
  }) {
    return ViewModel(
      id: id ?? this.id,
      channel_id: channel_id ?? this.channel_id,
      type: type ?? this.type,
      creator_id: creator_id ?? this.creator_id,
      title: title ?? this.title,
      description: description ?? this.description,
      sort_order: sort_order ?? this.sort_order,
      props: props ?? this.props,
      create_at: create_at ?? this.create_at,
      update_at: update_at ?? this.update_at,
      delete_at: delete_at ?? this.delete_at,
    );
  }

  ViewEntity toEntity() => ViewEntity(
        id: id,
        channel_id: channel_id,
        type: type,
        creator_id: creator_id,
        title: title,
        description: description,
        sort_order: sort_order,
        props: props,
        create_at: create_at,
        update_at: update_at,
        delete_at: delete_at,
      );
}
