import 'package:equatable/equatable.dart';

class PostAcknowledgementEntity extends Equatable {
  final String? user_id;
  final String? post_id;
  final int? acknowledged_at;

  const PostAcknowledgementEntity({
    this.user_id,
    this.post_id,
    this.acknowledged_at,
  });

  @override
  List<Object?> get props => [
        user_id,
        post_id,
        acknowledged_at,
      ];

  PostAcknowledgementEntity copyWith({
    String? user_id,
    String? post_id,
    int? acknowledged_at,
  }) {
    return PostAcknowledgementEntity(
      user_id: user_id ?? this.user_id,
      post_id: post_id ?? this.post_id,
      acknowledged_at: acknowledged_at ?? this.acknowledged_at,
    );
  }
}
