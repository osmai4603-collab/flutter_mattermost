import 'package:flutter_mattermost/features/chat/domain/entities/post_acknowledgement_entity.dart';

final class PostAcknowledgementModel extends PostAcknowledgementEntity {
  const PostAcknowledgementModel({
    required super.user_id,
    required super.post_id,
    required super.acknowledged_at,
  });

  factory PostAcknowledgementModel.fromMap(Map<String, dynamic> map) {
    return PostAcknowledgementModel(
      user_id: map["user_id"] as String?,
      post_id: map["post_id"] as String?,
      acknowledged_at: (map["acknowledged_at"] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "user_id": user_id,
      "post_id": post_id,
      "acknowledged_at": acknowledged_at,
    };
  }

  factory PostAcknowledgementModel.fromEntity(PostAcknowledgementEntity entity) {
    return PostAcknowledgementModel(
      user_id: entity.user_id,
      post_id: entity.post_id,
      acknowledged_at: entity.acknowledged_at,
    );
  }

  @override
  PostAcknowledgementModel copyWith({
    String? user_id,
    String? post_id,
    int? acknowledged_at,
  }) {
    return PostAcknowledgementModel(
      user_id: user_id ?? this.user_id,
      post_id: post_id ?? this.post_id,
      acknowledged_at: acknowledged_at ?? this.acknowledged_at,
    );
  }

  PostAcknowledgementEntity toEntity() => PostAcknowledgementEntity(
        user_id: user_id,
        post_id: post_id,
        acknowledged_at: acknowledged_at,
      );
}
