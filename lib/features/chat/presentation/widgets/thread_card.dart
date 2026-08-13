import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/network/server_manager.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/design_tokens.dart';
import 'package:flutter_mattermost/core/utils/time_format.dart';
import 'package:flutter_mattermost/core/widgets/profile_picture.dart';
import 'package:flutter_mattermost/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_mattermost/features/chat/domain/entities/thread_entity.dart';
import 'package:flutter_mattermost/features/chat/presentation/widgets/markdown_message.dart';

class ThreadCard extends StatelessWidget {
  final ThreadEntity thread;
  final String myUserId;
  final VoidCallback onTap;
  final VoidCallback onChannelTap;
  final VoidCallback onToggleFollow;

  const ThreadCard({
    super.key,
    required this.thread,
    required this.myUserId,
    required this.onTap,
    required this.onChannelTap,
    required this.onToggleFollow,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);
    final unread = thread.hasUnread;
    final post = thread.rootPost;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.centerChannelBg,
          border: Border(
            bottom: BorderSide(
              color: theme.centerChannelColor.withValues(alpha: 0.08),
            ),
            left: unread
                ? BorderSide(color: theme.linkColor, width: 4)
                : BorderSide.none,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ProfilePicture(
                  username: post.userId,
                  avatarUrl: _avatarUrlFor(post.userId),
                  size: 24,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        post.userId, // Should ideally be username, but ThreadEntity.rootPost has userId
                        style: TextStyle(
                          color: theme.centerChannelColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        formatPostTime(post.createAt),
                        style: TextStyle(
                          color: theme.centerChannelColor.withValues(alpha: 0.5),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: onChannelTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: theme.centerChannelColor.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      thread.channelName,
                      style: TextStyle(
                        color: theme.centerChannelColor.withValues(alpha: 0.7),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            MarkdownMessage(
              text: post.message,
              maxLines: 3,
              style: TextStyle(
                color: theme.centerChannelColor,
                fontSize: 14,
                fontWeight: unread ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _ParticipantsList(participants: thread.participants),
                const SizedBox(width: 12),
                Text(
                  l10n.threadingNumReplies(thread.replyCount),
                  style: TextStyle(
                    color: theme.centerChannelColor.withValues(alpha: 0.6),
                    fontSize: 12,
                    fontWeight: unread ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '•',
                  style: TextStyle(
                    color: theme.centerChannelColor.withValues(alpha: 0.3),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.threadingFooterLastReplyAt(
                    formatPostTime(thread.lastReplyAt),
                  ),
                  style: TextStyle(
                    color: theme.centerChannelColor.withValues(alpha: 0.6),
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: onToggleFollow,
                  icon: Icon(
                    thread.isFollowing
                        ? Icons.notifications_active_outlined
                        : Icons.notifications_none,
                    size: 16,
                  ),
                  label: Text(
                    thread.isFollowing
                        ? l10n.threadingFollowing
                        : l10n.threadingNotFollowing,
                    style: const TextStyle(fontSize: 12),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: thread.isFollowing
                        ? theme.linkColor
                        : theme.centerChannelColor.withValues(alpha: 0.6),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _avatarUrlFor(String userId) {
    final serverUrl = getIt<ServerManager>().activeServerUrl;
    return '$serverUrl/api/v4/users/$userId/image';
  }
}

class _ParticipantsList extends StatelessWidget {
  final List<UserEntity> participants;

  const _ParticipantsList({required this.participants});

  @override
  Widget build(BuildContext context) {
    if (participants.isEmpty) return const SizedBox.shrink();

    final toShow = participants.take(5).toList();
    final hasMore = participants.length > 5;

    return SizedBox(
      height: 24,
      child: Stack(
        children: [
          for (var i = 0; i < toShow.length; i++)
            Positioned(
              left: i * 16.0,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppTheme.of(context).centerChannelBg,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(DesignTokens.radiusPill),
                ),
                child: ProfilePicture(
                  username: toShow[i].username,
                  avatarUrl: _avatarUrlFor(toShow[i].id),
                  size: 20,
                ),
              ),
            ),
          if (hasMore)
            Positioned(
              left: 5 * 16.0,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: AppTheme.of(context).centerChannelColor.withValues(
                        alpha: 0.1,
                      ),
                  borderRadius: BorderRadius.circular(DesignTokens.radiusPill),
                ),
                child: Center(
                  child: Text(
                    '+${participants.length - 5}',
                    style: TextStyle(
                      fontSize: 9,
                      color: AppTheme.of(context).centerChannelColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _avatarUrlFor(String userId) {
    final serverUrl = getIt<ServerManager>().activeServerUrl;
    return '$serverUrl/api/v4/users/$userId/image';
  }
}
