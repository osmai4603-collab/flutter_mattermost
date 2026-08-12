import 'package:flutter_mattermost/features/chat/domain/entities/posts_usage_entity.dart';

final class PostsUsageModel extends PostsUsageEntity {
  const PostsUsageModel({
    required super.count,
  });

  factory PostsUsageModel.fromMap(Map<String, dynamic> map) {
    return PostsUsageModel(
      count: (map["count"] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "count": count,
    };
  }

  factory PostsUsageModel.fromEntity(PostsUsageEntity entity) {
    return PostsUsageModel(
      count: entity.count,
    );
  }

  @override
  PostsUsageModel copyWith({
    double? count,
  }) {
    return PostsUsageModel(
      count: count ?? this.count,
    );
  }

  PostsUsageEntity toEntity() => PostsUsageEntity(
        count: count,
      );
}
