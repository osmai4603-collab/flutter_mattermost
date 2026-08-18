import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/network/server_manager.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:flutter_mattermost/core/widgets/matter_button.dart';
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
import 'package:flutter_mattermost/features/chat/presentation/widgets/call_state_tiles.dart';
import 'package:flutter_mattermost/features/chat/presentation/widgets/post_message/post_item.dart';
import 'package:flutter_mattermost/features/users/presentation/pages/user_profile_modal.dart';
import 'package:flutter_mattermost/features/users/presentation/bloc/user_profile_bloc.dart';
import 'package:flutter_mattermost/features/users/presentation/bloc/user_status_bloc.dart';
import 'package:flutter_mattermost/features/chat/presentation/widgets/post_message/markdown_message.dart';
import 'package:flutter_mattermost/features/chat/presentation/rhs/mentions_panel.dart';
import 'package:flutter_mattermost/core/utils/mention_utils.dart';
import 'package:flutter_mattermost/features/chat/presentation/widgets/custom_emoji.dart';
import 'package:flutter_mattermost/features/chat/presentation/widgets/post_message/reaction_list.dart';
import 'package:flutter_mattermost/features/chat/presentation/widgets/emoji_picker_overlay.dart';

import 'package:flutter_mattermost/features/chat/presentation/widgets/post_attachment_preview.dart';
import 'package:flutter_mattermost/features/chat/presentation/widgets/post_message/post_thread_footer.dart';
import 'package:flutter_mattermost/features/chat/presentation/widgets/post_message/youtube_embed_preview.dart';
import 'package:flutter_mattermost/features/channels/presentation/widgets/add_channel_bookmark_dialog.dart';
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

  bool _atBottom = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    if (widget.scrollController == null) {
      _scrollController.dispose();
    } else {
      _scrollController.removeListener(_onScroll);
    }
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    // القائمة معكوسة: offset 0 = الأسفل (أحدث الرسائل).
    final atBottom = _scrollController.offset <= 24;
    if (atBottom != _atBottom) {
      setState(() => _atBottom = atBottom);
    }
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostsState>(
      builder: (context, state) {
        final body = switch (state) {
          PostLoadingState() => const Center(
            child: CircularProgressIndicator(),
          ),
          PostErrorState() => _ErrorView(message: state.message),
          PostsLoadedState() => _PostListBody(
            state: state,
            scrollController: _scrollController,
          ),
          _ => const SizedBox.shrink(),
        };

        return Stack(
          alignment: AlignmentDirectional.topCenter,
          children: [
            body,
            Positioned(
              child: AnimatedOpacity(
                opacity: _atBottom ? 0 : 1,
                duration: const Duration(milliseconds: 200),
                child: IgnorePointer(
                  ignoring: _atBottom,
                  child: _ScrollToBottomButton(
                    label: 'أحدث الرسائل',
                    onTap: _scrollToBottom,
                  ),
                ),
              ),
            ),
          ],
        );
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

/// زر "أحدث الرسائل" العائم — يظهر عند التمرير للأعلى ويعيد التمرير للأسفل؛
/// مطابق New Messages button في webapp.
class _ScrollToBottomButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _ScrollToBottomButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(4),
      color: theme.buttonBg,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.keyboard_arrow_down,
                size: 20,
                color: theme.buttonColor,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: theme.buttonColor,
                ),
              ),
            ],
          ),
        ),
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
  void initState() {
    super.initState();
    _loadMissingProfiles();
  }

  @override
  void didUpdateWidget(_PostListBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state.channelId != widget.state.channelId) {
      _loadedUserIds = const {};
    }
    _loadMissingProfiles();
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

  void _loadMissingProfiles() {
    final allIds = widget.state.posts
        .map((p) => p.userId)
        .where((id) => id != 'current_user')
        .toSet();

    final newIds = allIds.difference(_loadedUserIds);

    if (newIds.isNotEmpty) {
      // ندمج المعرفات الجديدة مع السجل لضمان عدم طلبها مرة أخرى
      _loadedUserIds = {..._loadedUserIds, ...newIds};
      context.read<UserProfileBloc>().add(
        LoadProfilesByIdsEvent(newIds.toList()),
      );
      context.read<UserStatusBloc>().add(
        LoadUserStatusesEvent(newIds.toList()),
      );
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

    final profState = context.read<UserProfileBloc>().state;
    final myProfile = profState is UserProfileLoadedState
        ? profState.myProfile
        : null;
    final myUserId = myProfile?.id ?? 'me';
    // مفاتيح الإشارة للمستخدم الحالي — مطابقة showMentions/getCurrentUserMentionKeys
    // في webapp؛ تُستخدم لتظليل خلفية الرسائل التي تذكره.
    final myMentionKeys = myProfile == null
        ? const <String>[]
        : allMentionKeysFrom(myProfile);

    final channelState = context.watch<ChannelBloc>().state;
    int lastViewedAt = 0;
    ChannelEntity? selectedChannel;
    if (channelState is ChannelsLoadedState) {
      selectedChannel = channelState.selectedChannel;
      lastViewedAt = channelState.members[state.channelId]?.lastViewedAt ?? 0;
    }

    final items = <Widget>[];
    // لافتة حالة المكالمة الحية — أسفل القائمة (فوق محرر الرسائل) في القناة
    // الحالية؛ تعرض «مكالمة جارية» + زر انضمام أو «أنت في المكالمة».
    items.insert(0, ChannelCallStateBanner(channelId: state.channelId));
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

    // بيانات تذييل المحادثة (ThreadFooter): المشاركون + وقت آخر رد
    // مستنتجان من نطاق الرسائل المحمّل في تمريرة واحدة.
    final rootLastReplyAt = <String, int>{};
    final rootParticipantIds = <String, Set<String>>{};
    for (final p in state.posts) {
      if (p.rootId.isEmpty) continue;
      final ids = rootParticipantIds.putIfAbsent(p.rootId, () => {});
      ids.add(p.userId);
      final last = rootLastReplyAt[p.rootId];
      if (last == null || p.createAt > last) {
        rootLastReplyAt[p.rootId] = p.createAt;
      }
    }

    // تضمين مؤلّف الرسالة الجذرية نفسه في قائمة المشاركين (ترتيب النطاق قد
    // يضع الجذر قبل أو بعد ردوده، لذا نمرّ مرة ثانية).
    for (final p in state.posts) {
      if (p.rootId.isEmpty) {
        rootParticipantIds[p.id]?.add(p.userId);
      }
    }

    final visiblePosts = state.posts.where((p) => p.rootId.isEmpty).toList();

    // posts are sorted latest to oldest (reverse: true)
    for (int i = 0; i < visiblePosts.length; i++) {
      final post = visiblePosts[i];
      final isNew =
          lastViewedAt > 0 &&
          post.createAt > lastViewedAt &&
          post.userId != myUserId;

      final day = DateTime.fromMillisecondsSinceEpoch(post.createAt);
      final dayKey = DateTime(day.year, day.month, day.day);

      // Check if we need to insert "New Messages" line.
      // Since it's reversed, we check if the NEXT post (which is older) was the last viewed one.
      if (!newMessagesLineShown && isNew) {
        // If this is the last post or the next one is older than lastViewedAt
        final isLastNew =
            (i == visiblePosts.length - 1) ||
            (visiblePosts[i + 1].createAt <= lastViewedAt);
        if (isLastNew) {
          items.add(const _NewMessagesSeparator());
          newMessagesLineShown = true;
        }
      }

      final isFocused = post.id == state.focusPostId;
      final isRoot = post.rootId.isEmpty;

      // هل الرسالة تذكر المستخدم الحالي؟ (تظليل خلفية الرسالة — Post Mention
      // Highlight في webapp عبر مطابقة النص مع مفاتيح الإشارة).
      final isMentioned = textMentionsKeys(post.message, myMentionKeys);

      final ids = isRoot ? rootParticipantIds[post.id] : null;
      final threadParticipants = <UserEntity>[
        if (ids != null)
          for (final id in ids)
            if (id != 'current_user' && byId[id] != null) byId[id]!,
      ];

      final item = PostItem(
        key: isFocused ? _focusKey : null,
        post: post,
        profile: post.userId == 'current_user' ? null : byId[post.userId],
        myUserId: myUserId,
        isFlagged: state.isFlagged(post.id),
        isPinned: state.isPinned(post.id),
        reactions: state.reactionsFor(post.id),
        filesList: state.filesFor(post.id),
        replyCount: isRoot ? state.replyCountFor(post.id) : 0,
        isReply: !isRoot,
        isNew: isNew,
        isMentioned: isMentioned,
        threadParticipants: threadParticipants,
        threadLastReplyAt: isRoot ? (rootLastReplyAt[post.id] ?? 0) : 0,
        threadIsFollowing: state.threadFollowing[post.id] ?? false,
        threadUnreadReplies: state.threadUnreadReplies[post.id] ?? 0,
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
      final typingNames = state.typingUserIds.map((id) {
        final profile = byId[id];
        return profile != null
            ? getMentionDisplayName(
                username: profile.username,
                nickname: profile.nickname,
                firstName: profile.firstName,
                lastName: profile.lastName,
              )
            : formatMemberName(id);
      }).toList();
      items.add(_TypingRow(names: typingNames));
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
  final List<String> names;
  const _TypingRow({required this.names});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);
    final joinedNames = names.join(', ');
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
            '$joinedNames ${l10n.messageTyping}',
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
