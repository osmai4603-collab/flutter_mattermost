import 'package:flutter_mattermost/core/entities/entity.dart';

class ReactionEntity extends Entity {
  final String serverId;
  final String userId;
  final String postId;
  final String emojiName;
  final int createAt;

  const ReactionEntity({
    required this.serverId,
    required this.userId,
    required this.postId,
    required this.emojiName,
    required this.createAt,
  });

  @override
  List<Object?> get props => [
        serverId,
        userId,
        postId,
        emojiName,
        createAt,
      ];

  @override
  ReactionEntity copyWith({
    String? serverId,
    String? userId,
    String? postId,
    String? emojiName,
    int? createAt,
  }) {
    return ReactionEntity(
      serverId: serverId ?? this.serverId,
      userId: userId ?? this.userId,
      postId: postId ?? this.postId,
      emojiName: emojiName ?? this.emojiName,
      createAt: createAt ?? this.createAt,
    );
  }
}
