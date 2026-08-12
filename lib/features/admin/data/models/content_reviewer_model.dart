import 'package:flutter_mattermost/features/admin/domain/entities/content_reviewer_entity.dart';

final class ContentReviewerModel extends ContentReviewerEntity {
  const ContentReviewerModel({
    required super.user_id,
    required super.username,
    required super.nickname,
    required super.first_name,
    required super.last_name,
    required super.email,
    required super.create_at,
  });

  factory ContentReviewerModel.fromMap(Map<String, dynamic> map) {
    return ContentReviewerModel(
      user_id: map["user_id"] as String?,
      username: map["username"] as String?,
      nickname: map["nickname"] as String?,
      first_name: map["first_name"] as String?,
      last_name: map["last_name"] as String?,
      email: map["email"] as String?,
      create_at: (map["create_at"] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "user_id": user_id,
      "username": username,
      "nickname": nickname,
      "first_name": first_name,
      "last_name": last_name,
      "email": email,
      "create_at": create_at,
    };
  }

  factory ContentReviewerModel.fromEntity(ContentReviewerEntity entity) {
    return ContentReviewerModel(
      user_id: entity.user_id,
      username: entity.username,
      nickname: entity.nickname,
      first_name: entity.first_name,
      last_name: entity.last_name,
      email: entity.email,
      create_at: entity.create_at,
    );
  }

  ContentReviewerModel copyWith({
    String? user_id,
    String? username,
    String? nickname,
    String? first_name,
    String? last_name,
    String? email,
    int? create_at,
  }) {
    return ContentReviewerModel(
      user_id: user_id ?? this.user_id,
      username: username ?? this.username,
      nickname: nickname ?? this.nickname,
      first_name: first_name ?? this.first_name,
      last_name: last_name ?? this.last_name,
      email: email ?? this.email,
      create_at: create_at ?? this.create_at,
    );
  }

  ContentReviewerEntity toEntity() => ContentReviewerEntity(
        user_id: user_id,
        username: username,
        nickname: nickname,
        first_name: first_name,
        last_name: last_name,
        email: email,
        create_at: create_at,
      );
}
