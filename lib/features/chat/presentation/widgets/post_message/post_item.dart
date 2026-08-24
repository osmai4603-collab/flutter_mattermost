import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/network/server_manager.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:flutter_mattermost/core/utils/mention_utils.dart';
import 'package:flutter_mattermost/core/widgets/profile_picture.dart';
import 'package:flutter_mattermost/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_mattermost/features/chat/domain/entities/file_info_entity.dart';
import 'package:flutter_mattermost/features/chat/domain/entities/post_entity.dart';
import 'package:flutter_mattermost/features/chat/domain/entities/reaction_entity.dart';
import 'package:flutter_mattermost/features/chat/presentation/bloc/post_bloc.dart';
import 'package:flutter_mattermost/features/chat/presentation/bloc/rhs_bloc.dart';
import 'package:flutter_mattermost/features/chat/presentation/widgets/call_state_tiles.dart';
import 'package:flutter_mattermost/features/chat/presentation/widgets/post_message/markdown_message.dart';
import 'package:flutter_mattermost/features/chat/presentation/widgets/post_attachment_preview.dart';
import 'package:flutter_mattermost/features/chat/presentation/widgets/post_message/post_actions.dart';
import 'package:flutter_mattermost/features/chat/presentation/widgets/post_message/post_thread_footer.dart';
import 'package:flutter_mattermost/features/chat/presentation/widgets/post_message/reaction_list.dart';
import 'package:flutter_mattermost/features/chat/presentation/widgets/post_message/youtube_embed_preview.dart';
import 'package:flutter_mattermost/features/users/presentation/bloc/user_status_bloc.dart';
import 'package:flutter_mattermost/features/users/presentation/pages/user_profile_modal.dart';
import 'package:intl/intl.dart';

/// عنصر رسالة واحدة — يستخدم في القائمة الرئيسية وفي Thread RHS.
class PostItem extends StatefulWidget {
  final PostEntity post;
  final UserEntity? profile;
  final String myUserId;
  final bool isFlagged;
  final bool isPinned;
  final List<ReactionEntity> reactions;
  final List<FileInfoEntity> filesList;
  final int replyCount;
  final bool isReply;
  final bool showFullHeader;
  final bool isNew;

  /// هل تذكر الرسالة المستخدم الحالي؟ (تظليل خلفية الرسالة).
  final bool isMentioned;

  /// المشاركون في المحادثة (لرسائل الجذر) لعرض تذييل ThreadFooter.
  final List<UserEntity> threadParticipants;

  /// وقت آخر رد في المحادثة (ملي ثانية).
  final int threadLastReplyAt;

  /// هل يتابع المستخدم المحادثة؟
  final bool threadIsFollowing;

  /// عدد الردود غير المقروءة في المحادثة.
  final int threadUnreadReplies;

  const PostItem({
    super.key,
    required this.post,
    this.profile,
    this.myUserId = 'me',
    this.isFlagged = false,
    this.isPinned = false,
    this.reactions = const [],
    this.filesList = const [],
    this.replyCount = 0,
    this.isReply = false,
    this.showFullHeader = true,
    this.isNew = false,
    this.isMentioned = false,
    this.threadParticipants = const [],
    this.threadLastReplyAt = 0,
    this.threadIsFollowing = false,
    this.threadUnreadReplies = 0,
  });

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  bool _hovered = false;
  final _menuActionController = MenuController();

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);
    final post = widget.post;

    final username = widget.profile != null
        ? widget.profile!.username
        // ? getMentionDisplayName(
        //     username: widget.profile!.username,
        //     nickname: widget.profile!.nickname,
        //     firstName: widget.profile!.firstName,
        //     lastName: widget.profile!.lastName,
        //   )
        : formatMemberName(post.userId);
    final time = _formatTime(post.createAt);
    final fullTime = DateFormat(
      'EEEE, MMMM d, yyyy h:mm a',
    ).format(DateTime.fromMillisecondsSinceEpoch(post.createAt).toLocal());
    final isMine =
        post.userId == 'current_user' || post.userId == widget.myUserId;
    final canDelete = isMine || post.pendingPostId.isNotEmpty;
    final avatarUrl = _avatarUrlFor(post.userId);
    final isBot =
        widget.profile?.roles.contains('bot') == true ||
        post.propsData['from_webhook'] == 'true';

    final status =
        context.watch<UserStatusBloc>().state is UserStatusesLoadedState
        ? (context.read<UserStatusBloc>().state as UserStatusesLoadedState)
              .statusOf(post.userId)
        : null;

    final effectiveFiles = widget.filesList.isNotEmpty
        ? widget.filesList
        : (post.metadata?.files != null && post.metadata!.files!.isNotEmpty
              ? post.metadata!.files!
                    .whereType<FileInfoEntity>()
                    .where((f) => f.id.isNotEmpty)
                    .toList()
              : const <FileInfoEntity>[]);

    final youtubeUrls = YouTubeEmbedPreview.extractAllUrls(post.message);
    if (youtubeUrls.isEmpty && post.metadata?.embeds != null) {
      for (final embed in post.metadata!.embeds!) {
        final type = embed['type'];
        final url = embed['url'] as String?;
        if (url != null && (type == 'opengraph' || type == 'youtube')) {
          if (YouTubeEmbedPreview.extractVideoId(url) != null) {
            youtubeUrls.add(url);
          }
        }
      }
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Container(
        padding: EdgeInsets.fromLTRB(
          16,
          widget.isReply ? 2 : 8,
          16,
          widget.isReply ? 2 : 4,
        ),
        decoration: BoxDecoration(color: _postBackgroundColor(theme)),
        child: Column(
          children: [
            Stack(
              alignment: AlignmentDirectional.topEnd,
              fit: .passthrough,
              clipBehavior: .none,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => showUserProfile(context, post.userId),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          ProfilePicture.md(
                            userId: post.userId,
                            username: username,
                            avatarUrl: avatarUrl,
                            status: widget.isReply ? null : status,
                          ),
                          if (widget.isFlagged)
                            Positioned(
                              top: -4,
                              right: -4,
                              child: Container(
                                padding: const EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                  color: theme.centerChannelBg,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.bookmark_rounded,
                                  size: 14,
                                  color: theme.linkColor,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.showFullHeader || widget.isReply)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 2),
                              child: Row(
                                children: [
                                  Flexible(
                                    child: GestureDetector(
                                      onTap: () =>
                                          showUserProfile(context, post.userId),
                                      child: Text(
                                        username,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: theme.centerChannelColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: widget.isReply ? 13 : 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (isBot) ...[
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 4,
                                        vertical: 1,
                                      ),
                                      decoration: BoxDecoration(
                                        color: theme.centerChannelColor
                                            .withValues(alpha: 0.08),
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                      child: Text(
                                        'BOT',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          color: theme.centerChannelColor
                                              .withValues(alpha: 0.6),
                                        ),
                                      ),
                                    ),
                                  ],
                                  const SizedBox(width: 6),
                                  Tooltip(
                                    message: fullTime,
                                    child: Text(
                                      time,
                                      style: TextStyle(
                                        fontSize: 11.5,
                                        color: theme.centerChannelColor
                                            .withValues(alpha: 0.45),
                                      ),
                                    ),
                                  ),
                                  if (widget.isPinned) ...[
                                    const SizedBox(width: 6),
                                    Icon(
                                      Icons.push_pin,
                                      size: 12,
                                      color: theme.centerChannelColor
                                          .withValues(alpha: 0.45),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          if (post.deleteAt > 0)
                            Text(
                              l10n.postDeleted,
                              style: TextStyle(
                                color: theme.centerChannelColor.withValues(
                                  alpha: 0.5,
                                ),
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                                height: 1.35,
                              ),
                            )
                          else
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (CallStateTiles.isCallPost(post))
                                  CallPostTile(post: post)
                                else ...[
                                  MarkdownMessage(
                                    text: post.message,
                                    mentionTime: post.createAt,
                                  ),
                                  for (final ytUrl in youtubeUrls)
                                    YouTubeEmbedPreview(url: ytUrl),
                                  if (post.editAt > 0)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 2),
                                      child: InkWell(
                                        onTap: () => context
                                            .read<RhsBloc>()
                                            .add(OpenEditHistoryEvent(post.id)),
                                        borderRadius: BorderRadius.circular(4),
                                        child: Text(
                                          l10n.postEdited,
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontStyle: FontStyle.italic,
                                            color: theme.centerChannelColor
                                                .withValues(alpha: 0.45),
                                            decoration:
                                                TextDecoration.underline,
                                            decorationColor: theme
                                                .centerChannelColor
                                                .withValues(alpha: 0.3),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ],
                            ),
                          ReactionList(
                            postId: post.id,
                            reactions: widget.reactions,
                            myUserId: widget.myUserId,
                            isHovered: _hovered,
                          ),
                          if (effectiveFiles.isNotEmpty)
                            PostAttachmentPreview(files: effectiveFiles),
                          if (!widget.isReply && widget.replyCount > 0)
                            PostThreadFooter(
                              replyCount: widget.replyCount,
                              participants: widget.threadParticipants,
                              lastReplyAt: widget.threadLastReplyAt,
                              isFollowing: widget.threadIsFollowing,
                              unreadReplies: widget.threadUnreadReplies,
                              onOpenThread: () {
                                context.read<RhsBloc>().add(
                                  OpenThreadEvent(post.id, post.channelId),
                                );
                              },
                              onToggleFollow: () {
                                context.read<PostBloc>().add(
                                  ToggleThreadFollowEvent(
                                    channelId: post.channelId,
                                    threadId: post.id,
                                    follow: !widget.threadIsFollowing,
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (post.deleteAt == 0)
                  PositionedDirectional(
                    top: -10,
                    // end: 20,
                    child: AnimatedOpacity(
                      opacity: _hovered || _menuActionController.isOpen ? 1 : 0,
                      duration: const Duration(milliseconds: 100),
                      child: PostActions(
                        controller: _menuActionController,
                        post: post,
                        isSavedMessage: widget.isFlagged,
                        isPinned: widget.isPinned,
                        isReply: widget.isReply,
                        canDelete: canDelete,
                        canEdit: isMine,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(int millis) {
    final dt = DateTime.fromMillisecondsSinceEpoch(millis).toLocal();
    final h12 = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final m = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '$h12:$m $period';
  }

  /// خلفية الرسالة: تظليل mention للمستخدم الحالي + لون التمرير.
  Color _postBackgroundColor(MattermostColors theme) {
    final base = widget.isMentioned
        ? theme.mentionHighlightBgMixed
        : Colors.transparent;
    if (!_hovered) return base;
    final hover = theme.centerChannelColor.withValues(alpha: 0.04);
    return Color.alphaBlend(hover, base);
  }
}

/// رابط صورة المستخدم (يتطلب ترخيص — يقع الاحتياط على الأحرف الأولى عند الفشل).
String _avatarUrlFor(String userId) {
  final serverUrl = getIt<ServerManager>().activeServerUrl;
  return '$serverUrl/api/v4/users/$userId/image';
}
