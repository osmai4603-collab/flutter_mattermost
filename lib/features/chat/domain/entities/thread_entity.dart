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
  });

  bool get hasUnread => unreadReplies > 0 || unreadMentions > 0;
}