import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/network/server_manager.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/widgets/matter_button.dart';
import 'package:flutter_mattermost/core/widgets/matter_menu.dart';
import 'package:flutter_mattermost/core/widgets/profile_picture.dart';
import 'package:flutter_mattermost/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_entity.dart';
import 'package:flutter_mattermost/features/channels/presentation/bloc/channel_bloc.dart';
import 'package:flutter_mattermost/features/chat/domain/entities/file_info_entity.dart';
import 'package:flutter_mattermost/features/chat/domain/entities/post_entity.dart';
import 'package:flutter_mattermost/features/chat/domain/entities/reaction_entity.dart';
import 'package:flutter_mattermost/features/chat/presentation/bloc/post_bloc.dart';
import 'package:flutter_mattermost/features/chat/presentation/bloc/rhs_bloc.dart';
import 'package:flutter_mattermost/features/chat/presentation/editor/message_editor.dart';
import 'package:flutter_mattermost/features/users/presentation/pages/user_profile_modal.dart';
import 'package:flutter_mattermost/features/chat/presentation/widgets/reaction_picker.dart';
import 'package:flutter_mattermost/features/users/presentation/bloc/user_profile_bloc.dart';
import 'package:flutter_mattermost/features/users/presentation/bloc/user_status_bloc.dart';
import 'package:flutter_mattermost/features/chat/presentation/widgets/markdown_message.dart';
import 'package:flutter_mattermost/features/chat/presentation/widgets/post_attachment_preview.dart';
import 'package:intl/intl.dart';

/// قائمة الرسائل الافتراضية (أحدث الرسائل في الأسفل).
class PostList extends StatefulWidget {
  final ScrollController? scrollController;

  const PostList({super.key, this.scrollController});

  @override
  State<PostList> createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  late final ScrollController _scrollController =
      widget.scrollController ?? ScrollController();

  @override
  void dispose() {
    if (widget.scrollController == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostsState>(
      builder: (context, state) {
        if (state is PostLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is PostErrorState) {
          return _ErrorView(message: state.message);
        }
        if (state is PostsLoadedState) {
          return _PostListBody(
            state: state,
            scrollController: _scrollController,
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.cloud_off, size: 40),
          const SizedBox(height: 12),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          MatterButton(
            onPressed: () {
              final channelState = context.read<ChannelBloc>().state;
              if (channelState is ChannelsLoadedState &&
                  channelState.selectedChannel != null) {
                context.read<PostBloc>().add(
                  LoadPostsForChannelEvent(channelState.selectedChannel!.id),
                );
              }
            },
            child: Text(l10n.postListRetry),
          ),
        ],
      ),
    );
  }
}

class _PostListBody extends StatefulWidget {
  final PostsLoadedState state;
  final ScrollController scrollController;

  const _PostListBody({required this.state, required this.scrollController});

  @override
  State<_PostListBody> createState() => _PostListBodyState();
}

class _PostListBodyState extends State<_PostListBody> {
  Set<String> _loadedUserIds = const {};
  final GlobalKey _focusKey = GlobalKey();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ids = widget.state.posts
        .map((p) => p.userId)
        .where((id) => id != 'current_user')
        .toSet();
    if (!setEquals(ids, _loadedUserIds)) {
      _loadedUserIds = ids;
      if (ids.isNotEmpty) {
        context.read<UserProfileBloc>().add(
          LoadProfilesByIdsEvent(ids.toList()),
        );
        context.read<UserStatusBloc>().add(LoadUserStatusesEvent(ids.toList()));
      }
    }
  }

  @override
  void didUpdateWidget(_PostListBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state.focusPostId != null &&
        widget.state.focusPostId != oldWidget.state.focusPostId) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_focusKey.currentContext != null) {
          Scrollable.ensureVisible(
            _focusKey.currentContext!,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = widget.state;
    final theme = AppTheme.of(context);

    final profiles =
        context.watch<UserProfileBloc>().state is UserProfileLoadedState
        ? (context.read<UserProfileBloc>().state as UserProfileLoadedState)
              .profiles
        : const <UserEntity>[];
    final byId = {for (final p in profiles) p.id: p};

    final myUserId =
        context.read<UserProfileBloc>().state is UserProfileLoadedState
        ? (context.read<UserProfileBloc>().state as UserProfileLoadedState)
                  .myProfile
                  ?.id ??
              'me'
        : 'me';

    final channelState = context.watch<ChannelBloc>().state;
    int lastViewedAt = 0;
    ChannelEntity? selectedChannel;
    if (channelState is ChannelsLoadedState) {
      selectedChannel = channelState.selectedChannel;
      lastViewedAt = channelState.members[state.channelId]?.lastViewedAt ?? 0;
    }

    final items = <Widget>[];
    if (state.hasMore && state.posts.isNotEmpty) {
      items.add(
        Center(
          child: TextButton(
            onPressed: () {
              context.read<PostBloc>().add(
                LoadMorePostsEvent(state.channelId, state.posts.last.id),
              );
            },
            child: Text(l10n.postListLoadMore),
          ),
        ),
      );
    }
    if (state.posts.isEmpty && selectedChannel != null) {
      items.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
          child: Column(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: theme.centerChannelColor.withValues(alpha: 0.05),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  selectedChannel.type.value == 'D' ? Icons.person : Icons.tag,
                  size: 40,
                  color: theme.centerChannelColor.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Beginning of ${selectedChannel.displayName}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: theme.centerChannelColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'This is the start of the ${selectedChannel.displayName} channel.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: theme.centerChannelColor.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      );
    }

    DateTime? previousDay;
    bool newMessagesLineShown = false;

    // posts are sorted latest to oldest (reverse: true)
    for (int i = 0; i < state.posts.length; i++) {
      final post = state.posts[i];
      final isNew = lastViewedAt > 0 && post.createAt > lastViewedAt && post.userId != myUserId;

      final day = DateTime.fromMillisecondsSinceEpoch(post.createAt);
      final dayKey = DateTime(day.year, day.month, day.day);

      // Check if we need to insert "New Messages" line.
      // Since it's reversed, we check if the NEXT post (which is older) was the last viewed one.
      if (!newMessagesLineShown && isNew) {
        // If this is the last post or the next one is older than lastViewedAt
        final isLastNew = (i == state.posts.length - 1) ||
            (state.posts[i + 1].createAt <= lastViewedAt);
        if (isLastNew) {
          items.add(const _NewMessagesSeparator());
          newMessagesLineShown = true;
        }
      }

      final isFocused = post.id == state.focusPostId;
      final item = PostItem(
        key: isFocused ? _focusKey : null,
        post: post,
        profile: post.userId == 'current_user' ? null : byId[post.userId],
        myUserId: myUserId,
        isFlagged: state.isFlagged(post.id),
        isPinned: state.isPinned(post.id),
        reactions: state.reactionsFor(post.id),
        filesList: state.filesFor(post.id),
        replyCount: post.rootId.isEmpty ? state.replyCountFor(post.id) : 0,
        isReply: post.rootId.isNotEmpty,
        isNew: isNew,
      );
      items.add(
        isFocused
            ? _FocusFlash(key: ValueKey('flash_${post.id}'), child: item)
            : item,
      );

      if (previousDay == null || dayKey != previousDay) {
        items.add(_DateSeparator(date: day));
        previousDay = dayKey;
      }
    }

    if (state.typingUserIds.isNotEmpty) {
      items.add(_TypingRow(userIds: state.typingUserIds.toList()));
    }


    return ListView(
      controller: widget.scrollController,
      reverse: true,
      padding: const EdgeInsets.only(bottom: 8),
      children: items,
    );
  }
}

class _NewMessagesSeparator extends StatelessWidget {
  const _NewMessagesSeparator();

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(child: Divider(color: theme.errorTextColor, thickness: 1)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              'New Messages',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: theme.errorTextColor,
              ),
            ),
          ),
          Expanded(child: Divider(color: theme.errorTextColor, thickness: 1)),
        ],
      ),
    );
  }
}

class _DateSeparator extends StatelessWidget {
  final DateTime date;
  const _DateSeparator({required this.date});

  String _label(AppLocalizations l10n) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(date.year, date.month, date.day);
    if (day == today) return l10n.postDateToday;
    final yesterday = today.subtract(const Duration(days: 1));
    if (day == yesterday) return l10n.postDateYesterday;
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: theme.centerChannelColor.withValues(alpha: 0.1),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              _label(l10n),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: theme.centerChannelColor.withValues(alpha: 0.5),
              ),
            ),
          ),
          Expanded(
            child: Divider(
              color: theme.centerChannelColor.withValues(alpha: 0.1),
            ),
          ),
        ],
      ),
    );
  }
}

class _TypingRow extends StatelessWidget {
  final List<String> userIds;
  const _TypingRow({required this.userIds});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);
    final names = userIds.map((id) => id).join(', ');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: theme.centerChannelColor.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$names ${l10n.messageTyping}',
            style: TextStyle(
              fontSize: 12,
              color: theme.centerChannelColor.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}

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
  });

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);
    final post = widget.post;

    final username = widget.profile?.username ?? post.userId;
    final time = _formatTime(post.createAt);
    final fullTime = DateFormat('EEEE, MMMM d, yyyy h:mm a').format(
      DateTime.fromMillisecondsSinceEpoch(post.createAt).toLocal(),
    );
    final isMine =
        post.userId == 'current_user' || post.userId == widget.myUserId;
    final canDelete = isMine || post.pendingPostId.isNotEmpty;
    final avatarUrl = _avatarUrlFor(post.userId);
    final isBot = widget.profile?.roles.contains('bot') == true ||
        post.propsData['from_webhook'] == 'true';

    final status =
        context.watch<UserStatusBloc>().state is UserStatusesLoadedState
        ? (context.read<UserStatusBloc>().state as UserStatusesLoadedState)
              .statusOf(post.userId)
        : null;

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
        decoration: BoxDecoration(
          color: _hovered
              ? theme.centerChannelColor.withValues(alpha: 0.04)
              : Colors.transparent,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => showUserProfile(context, post.userId),
              child: ProfilePicture(
                username: username,
                avatarUrl: avatarUrl,
                status: widget.isReply ? null : status,
                size: widget.isReply ? 24 : 32,
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
                                color: theme.centerChannelColor.withValues(
                                  alpha: 0.08,
                                ),
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: Text(
                                'BOT',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: theme.centerChannelColor.withValues(
                                    alpha: 0.6,
                                  ),
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
                                color: theme.centerChannelColor.withValues(
                                  alpha: 0.45,
                                ),
                              ),
                            ),
                          ),
                          if (widget.isPinned) ...[
                            const SizedBox(width: 6),
                            Icon(
                              Icons.push_pin,
                              size: 12,
                              color: theme.centerChannelColor.withValues(
                                alpha: 0.45,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  if (post.deleteAt > 0)
                    Text(
                      l10n.postDeleted,
                      style: TextStyle(
                        color: theme.centerChannelColor.withValues(alpha: 0.5),
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        height: 1.35,
                      ),
                    )
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MarkdownMessage(text: post.message),
                        if (post.editAt > 0)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              l10n.postEdited,
                              style: TextStyle(
                                fontSize: 11,
                                fontStyle: FontStyle.italic,
                                color: theme.centerChannelColor.withValues(
                                  alpha: 0.45,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  if (widget.filesList.isNotEmpty)
                    PostAttachmentPreview(files: widget.filesList),
                  if ((widget.reactions.isNotEmpty || _hovered) &&
                      post.deleteAt == 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: _ReactionsBar(
                        postId: post.id,
                        reactions: widget.reactions,
                        myUserId: widget.myUserId,
                      ),
                    ),
                  if (widget.replyCount > 0)
                    InkWell(
                      onTap: () {
                        context.read<RhsBloc>().add(
                          OpenThreadEvent(post.id, post.channelId),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          '${widget.replyCount} ${widget.replyCount == 1 ? l10n.repliesCount1 : l10n.repliesCountN(widget.replyCount)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.linkColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (_hovered && post.deleteAt == 0)
              _PostActions(
                post: post,
                isFlagged: widget.isFlagged,
                isPinned: widget.isPinned,
                isReply: widget.isReply,
                canDelete: canDelete,
                canEdit: isMine,
              ),
          ],
        ),
      ),
    );
  }

  String _formatTime(int millis) {
    final dt = DateTime.fromMillisecondsSinceEpoch(millis).toLocal();
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}


class _PostActions extends StatelessWidget {
  final PostEntity post;
  final bool isFlagged;
  final bool isPinned;
  final bool isReply;
  final bool canDelete;
  final bool canEdit;

  const _PostActions({
    required this.post,
    required this.isFlagged,
    required this.isPinned,
    required this.isReply,
    required this.canDelete,
    required this.canEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!isReply)
          _ActionIcon(
            icon: Icons.mode_comment_outlined,
            tooltip: l10n.postMenuReply,
            onTap: () {
              context.read<RhsBloc>().add(
                OpenThreadEvent(post.id, post.channelId),
              );
            },
          ),
        _ActionIcon(
          icon: isFlagged ? Icons.flag : Icons.flag_outlined,
          tooltip: isFlagged ? l10n.postMenuUnflag : l10n.postMenuFlag,
          color: isFlagged ? theme.errorTextColor : null,
          onTap: () {
            context.read<PostBloc>().add(ToggleFlagPostEvent(post.id));
          },
        ),
        MatterMenuScope(
          openUp: true,
          items: [
            MatterMenuItem(
              id: 'reply',
              label: l10n.postMenuReply,
              icon: const Icon(Icons.mode_comment_outlined, size: 18),
              onTap: () {
                context.read<RhsBloc>().add(
                  OpenThreadEvent(post.id, post.channelId),
                );
              },
            ),
            MatterMenuItem(
              id: 'copy',
              label: l10n.postMenuCopy,
              icon: const Icon(Icons.copy, size: 18),
              onTap: () => Clipboard.setData(ClipboardData(text: post.message)),
            ),
            MatterMenuItem(
              id: 'copy_link',
              label: 'Copy Link',
              icon: const Icon(Icons.link, size: 18),
              onTap: () {
                final serverUrl = getIt<ServerManager>().activeServerUrl;
                final link = '$serverUrl/_redirect/pl/${post.id}';
                Clipboard.setData(ClipboardData(text: link));
              },
            ),
            MatterMenuItem(
              id: 'flag',
              label: isFlagged ? l10n.postMenuUnflag : l10n.postMenuFlag,
              icon: Icon(
                isFlagged ? Icons.flag : Icons.flag_outlined,
                size: 18,
              ),
              onTap: () {
                context.read<PostBloc>().add(ToggleFlagPostEvent(post.id));
              },
            ),
            MatterMenuItem(
              id: 'pin',
              label: isPinned ? l10n.postMenuUnpin : l10n.postMenuPin,
              icon: Icon(
                isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                size: 18,
              ),
              onTap: () {
                context.read<PostBloc>().add(TogglePinPostEvent(post.id));
              },
            ),
            if (canEdit)
              MatterMenuItem(
                id: 'edit',
                label: l10n.postMenuEdit,
                icon: const Icon(Icons.edit_outlined, size: 18),
                onTap: () => _startComposerEdit(context),
              ),
            if (canDelete)
              MatterMenuItem(
                id: 'delete',
                label: l10n.postMenuDelete,
                icon: const Icon(Icons.delete_outline, size: 18),
                danger: true,
                separatorBefore: true,
                onTap: () => _confirmDelete(context),
              ),
          ],
          child: _ActionIcon(
            icon: Icons.more_horiz,
            tooltip: l10n.channelHeaderMore,
            onTap: null,
          ),
        ),
      ],
    );
  }

  /// يدخل وضع التعديل في المحرر الرئيسي (مثل webapp)؛ وإن لم يتوفر محرر
  /// نشط يستخدم نافذة التعديل السريعة كبديل.
  void _startComposerEdit(BuildContext context) {
    final composer = MessageEditor.activeComposer;
    if (composer != null && !composer.isEditMode) {
      composer.beginEdit(post.id, post.message);
      composer.focusNode.requestFocus();
    } else {
      _showEditDialog(context);
    }
  }

  Future<void> _showEditDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final theme = AppTheme.of(context);
    final controller = TextEditingController(text: post.message);
    final newMessage = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.postEditTitle),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLines: 6,
          minLines: 2,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(color: theme.linkColor),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.postEditCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(controller.text),
            child: Text(l10n.postEditSave),
          ),
        ],
      ),
    );
    controller.dispose();
    final value = newMessage?.trim() ?? '';
    if (value.isNotEmpty && value != post.message && context.mounted) {
      context.read<PostBloc>().add(EditPostEvent(post.id, value));
    }
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.postDeleteConfirmTitle),
        content: Text(l10n.postDeleteConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.postDeleteConfirmCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.postDeleteConfirmOk),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      context.read<PostBloc>().add(DeletePostEvent(post.id));
    }
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback? onTap;
  final Color? color;

  const _ActionIcon({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Icon(
            icon,
            size: 16,
            color: color ?? theme.centerChannelColor.withValues(alpha: 0.55),
          ),
        ),
      ),
    );
  }
}

/// شريط ردود الفعل أسفل الرسالة: رموز مضافة + زر إضافة.
class _ReactionsBar extends StatelessWidget {
  final String postId;
  final List<ReactionEntity> reactions;
  final String myUserId;

  const _ReactionsBar({
    required this.postId,
    required this.reactions,
    required this.myUserId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    final byEmoji = <String, List<ReactionEntity>>{};
    for (final r in reactions) {
      byEmoji.putIfAbsent(r.emojiName, () => []).add(r);
    }
    final entries = byEmoji.entries.toList()
      ..sort((a, b) => b.value.length.compareTo(a.value.length));

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (final entry in entries)
          _ReactionChip(postId: postId, entry: entry, myUserId: myUserId),
        Tooltip(
          message: AppLocalizations.of(context).reactionAdd,
          child: InkWell(
            onTap: () async {
              final emoji = await showReactionPicker(context);
              if (emoji != null && context.mounted) {
                context.read<PostBloc>().add(
                  ToggleReactionEvent(postId, emoji),
                );
              }
            },
            borderRadius: BorderRadius.circular(4),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                border: Border.all(
                  color: theme.centerChannelColor.withValues(alpha: 0.2),
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Icon(
                Icons.add_reaction_outlined,
                size: 14,
                color: theme.centerChannelColor.withValues(alpha: 0.55),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ReactionChip extends StatelessWidget {
  final String postId;
  final MapEntry<String, List<ReactionEntity>> entry;
  final String myUserId;

  const _ReactionChip({
    required this.postId,
    required this.entry,
    required this.myUserId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final mine = entry.value.any((r) => r.userId == myUserId);

    return Tooltip(
      message: entry.value.map((r) => r.userId).join(', '),
      child: InkWell(
        onTap: () {
          context.read<PostBloc>().add(ToggleReactionEvent(postId, entry.key));
        },
        borderRadius: BorderRadius.circular(4),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          decoration: BoxDecoration(
            color: mine
                ? theme.linkColor.withValues(alpha: 0.1)
                : Colors.transparent,
            border: Border.all(
              color: mine
                  ? theme.linkColor.withValues(alpha: 0.5)
                  : theme.centerChannelColor.withValues(alpha: 0.2),
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            '${entry.key} ${entry.value.length}',
            style: TextStyle(
              fontSize: 12.5,
              color: mine
                  ? theme.linkColor
                  : theme.centerChannelColor.withValues(alpha: 0.8),
            ),
          ),
        ),
      ),
    );
  }
}

/// رابط صورة المستخدم (يتطلب ترخيص — يقع الاحتياط على الأحرف الأولى عند الفشل).
String _avatarUrlFor(String userId) {
  final serverUrl = getIt<ServerManager>().activeServerUrl;
  return '$serverUrl/api/v4/users/$userId/image';
}

/// وميض خلفية للرسالة المستهدفة عند الانتقال إليها من نتائج البحث
/// (webapp: focusPost + flash background يتلاشى خلال ثانيتين).
class _FocusFlash extends StatefulWidget {
  final Widget child;
  const _FocusFlash({super.key, required this.child});

  @override
  State<_FocusFlash> createState() => _FocusFlashState();
}

class _FocusFlashState extends State<_FocusFlash>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2400),
  )..forward();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final highlight = AppTheme.of(context).mentionHighlightBgMixed;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;
        final content = child!;
        if (t >= 1) return content;
        // احتفاظ قصير بقوة الإبراز ثم انحسار (webapp highlight-post).
        final phase = (t / 0.12).clamp(0.0, 1.0);
        final fade = (1 - Curves.easeOut.transform((t - 0.12) / 0.88)).clamp(
          0.0,
          1.0,
        );
        return Container(
          color: highlight.withValues(alpha: 0.55 * phase * fade),
          child: content,
        );
      },
      child: widget.child,
    );
  }
}
