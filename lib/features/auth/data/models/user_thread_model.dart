import 'package:flutter_mattermost/features/auth/domain/entities/user_thread_entity.dart';

final class UserThreadModel extends UserThreadEntity {
  const UserThreadModel({
    required super.id,
    required super.reply_count,
    required super.last_reply_at,
    required super.last_viewed_at,
    required super.participants,
    required super.post,
  });

  factory UserThreadModel.fromMap(Map<String, dynamic> map) {
    return UserThreadModel(
      id: map["id"] as String?,
      reply_count: (map["reply_count"] as num?)?.toInt(),
      last_reply_at: (map["last_reply_at"] as num?)?.toInt(),
      last_viewed_at: (map["last_viewed_at"] as num?)?.toInt(),
      participants: (map["participants"] as List<dynamic>? ?? []).map((e) => Map<String, dynamic>.from(e as Map<String, dynamic>)).toList(),
      post: map["post"] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "reply_count": reply_count,
      "last_reply_at": last_reply_at,
      "last_viewed_at": last_viewed_at,
      "participants": participants,
      "post": post,
    };
  }

  factory UserThreadModel.fromEntity(UserThreadEntity entity) {
    return UserThreadModel(
      id: entity.id,
      reply_count: entity.reply_count,
      last_reply_at: entity.last_reply_at,
      last_viewed_at: entity.last_viewed_at,
      participants: entity.participants,
      post: entity.post,
    );
  }

  @override
  UserThreadModel copyWith({
    String? id,
    int? reply_count,
    int? last_reply_at,
    int? last_viewed_at,
    List<Map<String, dynamic>>? participants,
    Map<String, dynamic>? post,
  }) {
    return UserThreadModel(
      id: id ?? this.id,
      reply_count: reply_count ?? this.reply_count,
      last_reply_at: last_reply_at ?? this.last_reply_at,
      last_viewed_at: last_viewed_at ?? this.last_viewed_at,
      participants: participants ?? this.participants,
      post: post ?? this.post,
    );
  }

  UserThreadEntity toEntity() => UserThreadEntity(
        id: id,
        reply_count: reply_count,
        last_reply_at: last_reply_at,
        last_viewed_at: last_viewed_at,
        participants: participants,
        post: post,
      );
}
