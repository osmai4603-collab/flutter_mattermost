import 'package:equatable/equatable.dart';

class PostListWithSearchMatchesEntity extends Equatable {
  final List<String>? order;
  final Map<String, dynamic>? posts;
  final Map<String, dynamic>? matches;

  const PostListWithSearchMatchesEntity({
    this.order,
    this.posts,
    this.matches,
  });

  @override
  List<Object?> get props => [
        order,
        posts,
        matches,
      ];

  PostListWithSearchMatchesEntity copyWith({
    List<String>? order,
    Map<String, dynamic>? posts,
    Map<String, dynamic>? matches,
  }) {
    return PostListWithSearchMatchesEntity(
      order: order ?? this.order,
      posts: posts ?? this.posts,
      matches: matches ?? this.matches,
    );
  }
}
