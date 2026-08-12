import 'package:equatable/equatable.dart';

class PostsUsageEntity extends Equatable {
  final double? count;

  const PostsUsageEntity({
    this.count,
  });

  @override
  List<Object?> get props => [
        count,
      ];

  PostsUsageEntity copyWith({
    double? count,
  }) {
    return PostsUsageEntity(
      count: count ?? this.count,
    );
  }
}
