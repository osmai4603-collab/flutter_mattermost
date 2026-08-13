import 'package:flutter_mattermost/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_mattermost/features/chat/domain/entities/post_entity.dart';

/// ثريد من قائمة ثريدات المستخدم (webapp UserThread):
/// الجذر + عدادات الردود/غير المقروء.
class ThreadEntity {
  final String rootPostId;
  final String channelId;
  final String channelName;
  final PostEntity rootPost;
  final int replyCount;
  final int lastReplyAt;
  final int lastViewedAt;
  final bool isFollowing;
  final int unreadReplies;
  final int unreadMentions;
  final List<UserEntity> participants;

  const ThreadEntity({
    required this.rootPostId,
    required this.channelId,
    this.channelName = '',
    required this.rootPost,
    this.replyCount = 0,
    this.lastReplyAt = 0,
    this.lastViewedAt = 0,
    this.isFollowing = true,
    this.unreadReplies = 0,
    this.unreadMentions = 0,
    this.participants = const [],
  });

  bool get hasUnread => unreadReplies > 0 || unreadMentions > 0;

  ThreadEntity copyWith({
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
  }) => ThreadEntity(
    rootPostId: rootPostId,
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