import 'dart:core';

import 'package:flutter_mattermost/features/chat/data/models/post_model.dart';
import 'package:flutter_mattermost/features/chat/domain/entities/post_entity.dart';
import 'package:flutter_mattermost/features/chat/domain/entities/post_list_entity.dart';

final class PostListModel extends PostListEntity {
  const PostListModel({
    required super.order,
    required super.posts,
    required super.next_post_id,
    required super.prev_post_id,
    required super.has_next,
  });

  factory PostListModel.fromMap(Map<String, dynamic> map) {
    return PostListModel(
      order: List<String>.from(map["order"] as List<dynamic>? ?? []),
      posts: _parsePosts(map["posts"]),
      next_post_id: map["next_post_id"] as String?,
      prev_post_id: map["prev_post_id"] as String?,
      has_next: map["has_next"] as bool?,
    );
  }

  static Map<String, PostEntity> _parsePosts(Map<String, dynamic>? data) {
    if (data == null) return {};
    return data.map(
      (key, value) => MapEntry(
        key,
        PostModel.fromMap(value as Map<String, dynamic>).toEntity(),
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "order": order,
      "posts": posts,
      "next_post_id": next_post_id,
      "prev_post_id": prev_post_id,
      "has_next": has_next,
    };
  }

  factory PostListModel.fromEntity(PostListEntity entity) {
    return PostListModel(
      order: entity.order,
      posts: entity.posts,
      next_post_id: entity.next_post_id,
      prev_post_id: entity.prev_post_id,
      has_next: entity.has_next,
    );
  }

  @override
  PostListModel copyWith({
    List<String>? order,
    Map<String, PostEntity>? posts,
    String? next_post_id,
    String? prev_post_id,
    bool? has_next,
  }) {
    return PostListModel(
      order: order ?? this.order,
      posts: posts ?? this.posts,
      next_post_id: next_post_id ?? this.next_post_id,
      prev_post_id: prev_post_id ?? this.prev_post_id,
      has_next: has_next ?? this.has_next,
    );
  }

  PostListEntity toEntity() => PostListEntity(
    order: order,
    posts: posts,
    next_post_id: next_post_id,
    prev_post_id: prev_post_id,
    has_next: has_next,
  );
}
