import 'package:flutter_mattermost/features/chat/domain/entities/thread_entity.dart';
import 'package:flutter_mattermost/features/chat/domain/entities/post_entity.dart';
import 'package:flutter_mattermost/features/chat/data/models/post_model.dart';
import 'package:flutter_mattermost/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_mattermost/features/auth/data/models/user_model.dart';

final class ThreadModel extends ThreadEntity {
  const ThreadModel({
    required super.rootPostId,
    required super.channelId,
    required super.channelName,
    required super.rootPost,
    required super.replyCount,
    required super.lastReplyAt,
    required super.lastViewedAt,
    required super.isFollowing,
    required super.unreadReplies,
    required super.unreadMentions,
    super.participants = const [],
  });

  factory ThreadModel.fromMap(Map<String, dynamic> map) {
    return ThreadModel(
      rootPostId: map["id"] as String? ?? '',
      channelId: map["channel_id"] as String? ?? '',
      channelName: map["channel_name"] as String? ?? '',
      rootPost: PostModel.fromMap(
        map["post"] as Map<String, dynamic>? ?? const {},
      ),
      replyCount: (map["reply_count"] as num?)?.toInt() ?? 0,
      lastReplyAt: (map["last_reply_at"] as num?)?.toInt() ?? 0,
      lastViewedAt: (map["last_viewed_at"] as num?)?.toInt() ?? 0,
      isFollowing: map["is_following"] as bool? ?? true,
      unreadReplies: (map["unread_replies"] as num?)?.toInt() ?? 0,
      unreadMentions: (map["unread_mentions"] as num?)?.toInt() ?? 0,
      participants: (map["participants"] as List<dynamic>? ?? [])
          .map((u) => UserModel.fromMap(u as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": rootPostId,
      "channel_id": channelId,
      "channel_name": channelName,
      "post": rootPost is PostModel ? (rootPost as PostModel).toMap() : null,
      "reply_count": replyCount,
      "last_reply_at": lastReplyAt,
      "last_viewed_at": lastViewedAt,
      "is_following": isFollowing,
      "unread_replies": unreadReplies,
      "unread_mentions": unreadMentions,
      "participants": participants
          .map((u) => u is UserModel ? u.toMap() : UserModel.fromEntity(u).toMap())
          .toList(),
    };
  }

  factory ThreadModel.fromEntity(ThreadEntity entity) {
    return ThreadModel(
      rootPostId: entity.rootPostId,
      channelId: entity.channelId,
      channelName: entity.channelName,
      rootPost: entity.rootPost,
      replyCount: entity.replyCount,
      lastReplyAt: entity.lastReplyAt,
      lastViewedAt: entity.lastViewedAt,
      isFollowing: entity.isFollowing,
      unreadReplies: entity.unreadReplies,
      unreadMentions: entity.unreadMentions,
      participants: entity.participants,
    );
  }

  ThreadModel copyWith({
    String? rootPostId,
    String? channelId,
    String? channelName,
    PostEntity? rootPost,
    int? replyCount,
    int? lastReplyAt,
    int? lastViewedAt,
    bool? isFollowing,
    int? unreadReplies,
    int? unreadMentions,
    List<UserEntity>? participants,
  }) {
    return ThreadModel(
      rootPostId: rootPostId ?? this.rootPostId,
      channelId: channelId ?? this.channelId,
      channelName: channelName ?? this.channelName,
      rootPost: rootPost ?? this.rootPost,
      replyCount: replyCount ?? this.replyCount,
      lastReplyAt: lastReplyAt ?? this.lastReplyAt,
      lastViewedAt: lastViewedAt ?? this.lastViewedAt,
      isFollowing: isFollowing ?? this.isFollowing,
      unreadReplies: unreadReplies ?? this.unreadReplies,
      unreadMentions: unreadMentions ?? this.unreadMentions,
      participants: participants ?? this.participants,
    );
  }

  ThreadEntity toEntity() => ThreadEntity(
        rootPostId: rootPostId,
        channelId: channelId,
        channelName: channelName,
        rootPost: rootPost,
        replyCount: replyCount,
        lastReplyAt: lastReplyAt,
        lastViewedAt: lastViewedAt,
        isFollowing: isFollowing,
        unreadReplies: unreadReplies,
        unreadMentions: unreadMentions,
        participants: participants,
      );
}
