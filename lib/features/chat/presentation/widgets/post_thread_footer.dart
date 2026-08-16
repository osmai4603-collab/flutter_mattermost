import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/design_tokens.dart';
import 'package:flutter_mattermost/core/utils/time_format.dart';
import 'package:flutter_mattermost/core/widgets/profile_picture.dart';
import 'package:flutter_mattermost/features/auth/domain/entities/user_entity.dart';

/// تذييل الرسالة الجذرية في القناة — مطابق ThreadFooter.tsx في webapp:
/// صور المشاركين المتداخلة + عداد الردود القابل للنقر + نقطة الردود
/// غير المقروءة + وقت آخر رد + زر متابعة/إلغاء المتابعة.
class PostThreadFooter extends StatelessWidget {
  final int replyCount;
  final List<UserEntity> participants;
  final int lastReplyAt;
  final bool isFollowing;
  final int unreadReplies;
  final VoidCallback onOpenThread;
  final VoidCallback onToggleFollow;

  const PostThreadFooter({
    super.key,
    required this.replyCount,
    required this.participants,
    this.lastReplyAt = 0,
    this.isFollowing = false,
    this.unreadReplies = 0,
    required this.onOpenThread,
    required this.onToggleFollow,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);
    final unread = unreadReplies > 0;

    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: onOpenThread,
              borderRadius: BorderRadius.circular(4),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (unread) ...[
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: theme.linkColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      l10n.threadingNumReplies(replyCount),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: unread ? FontWeight.w700 : FontWeight.w500,
                        color: unread ? theme.linkColor : theme.linkColor,
                      ),
                    ),
                    if (participants.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      _ParticipantAvatars(participants: participants),
                    ],
                    if (lastReplyAt > 0) ...[
                      const SizedBox(width: 8),
                      Text(
                        '•',
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.centerChannelColor.withValues(
                            alpha: 0.3,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        l10n.threadingFooterLastReplyAt(
                          formatPostTime(lastReplyAt),
                        ),
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.centerChannelColor.withValues(
                            alpha: 0.6,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          TextButton.icon(
            onPressed: onToggleFollow,
            icon: Icon(
              isFollowing
                  ? Icons.notifications_active_outlined
                  : Icons.notifications_none,
              size: 15,
            ),
            label: Text(
              isFollowing
                  ? l10n.threadingFollowing
                  : l10n.threadingNotFollowing,
              style: const TextStyle(fontSize: 12),
            ),
            style: TextButton.styleFrom(
              foregroundColor: isFollowing
                  ? theme.linkColor
                  : theme.centerChannelColor.withValues(alpha: 0.6),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }
}

/// صور المشاركين المتداخلة (مطابقة ThreadFooter-participants في webapp).
class _ParticipantAvatars extends StatelessWidget {
  final List<UserEntity> participants;

  const _ParticipantAvatars({required this.participants});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final toShow = participants.take(4).toList();
    final hasMore = participants.length > 4;

    return SizedBox(
      height: 20,
      child: Stack(
        children: [
          for (var i = 0; i < toShow.length; i++)
            Positioned(
              left: i * 14.0,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: theme.centerChannelBg, width: 1.5),
                  borderRadius: BorderRadius.circular(DesignTokens.radiusPill),
                ),
                child: ProfilePicture(
                  username: toShow[i].username,
                  avatarUrl: serverUserAvatarUrl(toShow[i].id),
                  size: 20,
                ),
              ),
            ),
          if (hasMore)
            Positioned(
              left: 4 * 14.0,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: theme.centerChannelColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(DesignTokens.radiusPill),
                ),
                child: Center(
                  child: Text(
                    '+${participants.length - 4}',
                    style: TextStyle(
                      fontSize: 9,
                      color: theme.centerChannelColor,
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
}
