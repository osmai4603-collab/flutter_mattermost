import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/design_tokens.dart';
import 'package:flutter_mattermost/core/utils/time_format.dart';
import 'package:flutter_mattermost/core/widgets/hover_widget.dart';
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                if (participants.isNotEmpty) ...[
                  const SizedBox(width: 8),
                  _ParticipantAvatars(participants: participants),
                  const SizedBox(width: 8),
                ],
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: .circular(4.0),
                    onTap: onOpenThread,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        spacing: 4,
                        children: [
                          Icon(
                            Icons.reply_outlined,
                            size: 16,
                            color: theme.centerChannelColor.withValues(
                              alpha: 0.65,
                            ),
                          ),
                          Text(
                            '$replyCount replies',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: unread
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: theme.centerChannelColor.withValues(
                                alpha: 0.65,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 0.50,
                  height: 15,
                  color: theme.centerChannelColor.withValues(
                    alpha: isFollowing ? 0.0 : 0.35,
                  ),
                  margin: .symmetric(horizontal: 8),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: .circular(4.0),
                    onTap: onToggleFollow,

                    child: Container(
                      decoration: ShapeDecoration(
                        color: isFollowing
                            ? theme.linkColor.withValues(alpha: 0.1)
                            : Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: .circular(4.0),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4,
                      ),
                      child: Text(
                        isFollowing
                            ? l10n.threadingFollowing
                            : l10n.threadingNotFollowing,
                        style: TextStyle(
                          fontSize: 12,
                          color: isFollowing
                              ? theme.linkColor
                              : theme.centerChannelColor.withValues(
                                  alpha: 0.65,
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 0.50,
                  height: 15,
                  color: theme.centerChannelColor.withValues(
                    alpha: isFollowing ? 0.0 : 0.35,
                  ),
                  margin: .symmetric(horizontal: 8),
                ),
                if (lastReplyAt > 0) ...[
                  const SizedBox(width: 8),

                  const SizedBox(width: 8),
                  Text(
                    l10n.threadingFooterLastReplyAt(
                      formatPostTime(lastReplyAt),
                    ),
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.centerChannelColor.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ],
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
    final stackWidth = hasMore
        ? (4 * 20.0) + 20.0
        : (toShow.length * 20.0);

    return SizedBox(
      width: stackWidth,
      height: 30,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          for (var i = 0; i < toShow.length; i++)
            Positioned(
              left: i * 20.0,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: theme.centerChannelBg, width: 1.5),
                  borderRadius: BorderRadius.circular(DesignTokens.radiusPill),
                ),
                child: HoverWidget(
                  builder: (context, isHovered) {
                    return AnimatedScale(
                      scale: isHovered ? 1.20 : 1.0,
                      duration: const Duration(milliseconds: 200),
                      child: ProfilePicture.sm(
                        userId: toShow[i].id,
                        username: toShow[i].username,
                        avatarUrl: serverUserAvatarUrl(toShow[i].id),
                      ),
                    );
                  },
                ),
              ),
            ),
          if (hasMore)
            Positioned(
              left: 4 * 20.0,
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
