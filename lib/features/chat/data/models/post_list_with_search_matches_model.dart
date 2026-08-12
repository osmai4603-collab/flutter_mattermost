import 'package:flutter_mattermost/features/chat/domain/entities/post_list_with_search_matches_entity.dart';

final class PostListWithSearchMatchesModel extends PostListWithSearchMatchesEntity {
  const PostListWithSearchMatchesModel({
    required super.order,
    required super.posts,
    required super.matches,
  });

  factory PostListWithSearchMatchesModel.fromMap(Map<String, dynamic> map) {
    return PostListWithSearchMatchesModel(
      order: List<String>.from(map["order"] as List<dynamic>? ?? []),
      posts: map["posts"] as Map<String, dynamic>?,
      matches: map["matches"] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "order": order,
      "posts": posts,
      "matches": matches,
    };
  }

  factory PostListWithSearchMatchesModel.fromEntity(PostListWithSearchMatchesEntity entity) {
    return PostListWithSearchMatchesModel(
      order: entity.order,
      posts: entity.posts,
      matches: entity.matches,
    );
  }

  @override
  PostListWithSearchMatchesModel copyWith({
    List<String>? order,
    Map<String, dynamic>? posts,
    Map<String, dynamic>? matches,
  }) {
    return PostListWithSearchMatchesModel(
      order: order ?? this.order,
      posts: posts ?? this.posts,
      matches: matches ?? this.matches,
    );
  }

  PostListWithSearchMatchesEntity toEntity() => PostListWithSearchMatchesEntity(
        order: order,
        posts: posts,
        matches: matches,
      );
}
