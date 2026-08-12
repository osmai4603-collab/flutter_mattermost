import 'package:flutter_mattermost/features/chat/domain/entities/reaction_entity.dart';

final class ReactionModel extends ReactionEntity {
  const ReactionModel({
    required super.serverId,
    required super.userId,
    required super.postId,
    required super.emojiName,
    required super.createAt,
  });

  factory ReactionModel.fromMap(Map<String, dynamic> data) {
    return ReactionModel(
      serverId: data['server_id'] ?? '',
      userId: data['user_id'] ?? '',
      postId: data['post_id'] ?? '',
      emojiName: data['emoji_name'] ?? '',
      createAt: (data['create_at'] ?? 0).toInt(),
    );
  }

  factory ReactionModel.fromEntity(ReactionEntity entity) {
    return ReactionModel(
      serverId: entity.serverId,
      userId: entity.userId,
      postId: entity.postId,
      emojiName: entity.emojiName,
      createAt: entity.createAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'server_id': serverId,
      'user_id': userId,
      'post_id': postId,
      'emoji_name': emojiName,
      'create_at': createAt,
    };
  }

  @override
  ReactionModel copyWith({
    String? serverId,
    String? userId,
    String? postId,
    String? emojiName,
    int? createAt,
  }) {
    return ReactionModel(
      serverId: serverId ?? this.serverId,
      userId: userId ?? this.userId,
      postId: postId ?? this.postId,
      emojiName: emojiName ?? this.emojiName,
      createAt: createAt ?? this.createAt,
    );
  }

  ReactionEntity toEntity() {
    return ReactionEntity(
      serverId: serverId,
      userId: userId,
      postId: postId,
      emojiName: emojiName,
      createAt: createAt,
    );
  }
}
