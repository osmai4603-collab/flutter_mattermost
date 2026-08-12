import 'package:equatable/equatable.dart';

class PostListEntity extends Equatable {
  final List<String>? order;
  final Map<String, dynamic>? posts;
  final String? next_post_id;
  final String? prev_post_id;
  final bool? has_next;

  const PostListEntity({
    this.order,
    this.posts,
    this.next_post_id,
    this.prev_post_id,
    this.has_next,
  });

  @override
  List<Object?> get props => [
        order,
        posts,
        next_post_id,
        prev_post_id,
        has_next,
      ];

  PostListEntity copyWith({
    List<String>? order,
    Map<String, dynamic>? posts,
    String? next_post_id,
    String? prev_post_id,
    bool? has_next,
  }) {
    return PostListEntity(
      order: order ?? this.order,
      posts: posts ?? this.posts,
      next_post_id: next_post_id ?? this.next_post_id,
      prev_post_id: prev_post_id ?? this.prev_post_id,
      has_next: has_next ?? this.has_next,
    );
  }
}
