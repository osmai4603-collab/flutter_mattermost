import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/widgets/profile_picture.dart';
import 'package:flutter_mattermost/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_mattermost/features/auth/domain/entities/user_status_entity.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_entity.dart';
import 'package:flutter_mattermost/features/channels/domain/repositories/channel_repository.dart';
import 'package:flutter_mattermost/features/channels/presentation/bloc/channel_bloc.dart';
import 'package:flutter_mattermost/features/chat/domain/entities/post_entity.dart';
import 'package:flutter_mattermost/features/chat/domain/repositories/post_repository.dart';
import 'package:flutter_mattermost/features/chat/presentation/bloc/post_bloc.dart';
import 'package:flutter_mattermost/features/chat/presentation/bloc/rhs_bloc.dart';
import 'package:flutter_mattermost/features/chat/presentation/widgets/markdown_message.dart';
import 'package:flutter_mattermost/features/chat/presentation/widgets/reaction_picker.dart';
import 'package:flutter_mattermost/features/teams/presentation/bloc/team_bloc.dart';
import 'package:flutter_mattermost/features/users/presentation/bloc/user_profile_bloc.dart';
import 'package:flutter_mattermost/features/users/presentation/bloc/user_status_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// نوع المحتوى المعروض في اللوحة — مطابق التبديل بين
/// "الرسائل" و "الملفات" في webapp (messages_or_files_selector).
enum SavedContentFilter { messages, files }

/// لوحة الرسائل المحفوظة/المثبتة — مطابقة flagged/pinned_messages في webapp:
/// قائمة منشورات مع فواصل تواريخ وأفاتار/اسم/وقت/نص وقناة (للمحفوظة)
/// وزر إزالة (إلغاء الحفظ/إزالة التثبيت).
class SavedPinnedPanel extends StatefulWidget {
  final bool isPinned;
  final String? channelId;
  final void Function(int count)? onLoad;
  final SavedContentFilter contentFilter;
  final String searchQuery;

  const SavedPinnedPanel({
    super.key,
    this.isPinned = false,
    this.channelId,
    this.onLoad,
    this.contentFilter = SavedContentFilter.messages,
    this.searchQuery = '',
  });

  @override
  State<SavedPinnedPanel> createState() => _SavedPinnedPanelState();
}

class _SavedPinnedPanelState extends State<SavedPinnedPanel> {
  Future<List<PostEntity>>? _postsFuture;
  String? _channelId;
  final Set<String> _requestedUserIds = {};
  final Set<String> _requestedChannelIds = {};
  Map<String, ChannelEntity> _channels = {};

  @override
  void initState() {
    super.initState();
    _channelId = widget.channelId ?? _currentChannelId();
  }

  Future<List<PostEntity>> _fetch() async {
    final repo = getIt<PostRepository>();
    if (widget.isPinned) {
      return repo.getPinnedPosts(_channelId ?? '');
    }
    return repo.getFlaggedPosts('me');
  }

  String _currentChannelId() {
    final channelState = context.read<ChannelBloc>().state;
    if (channelState is ChannelsLoadedState &&
        channelState.selectedChannel != null) {
      return channelState.selectedChannel!.id;
    }
    return '';
  }

  void _reload() {
    setState(() => _postsFuture = _fetch());
  }

  /// فلترة محلية حسب نوع المحتوى (رسائل/ملفات) واستعلام البحث.
  List<PostEntity> _applyFilters(List<PostEntity> posts) {
    final query = widget.searchQuery.trim().toLowerCase();
    return posts.where((post) {
      final hasFiles =
          post.fileIds.isNotEmpty ||
          (post.metadata?.files?.isNotEmpty ?? false);
      if (widget.contentFilter == SavedContentFilter.files && !hasFiles) {
        return false;
      }
      if (query.isEmpty) return true;
      final fileNames = (post.metadata?.files ?? const [])
          .map((f) => f.name)
          .join(' ');
      return post.message.toLowerCase().contains(query) ||
          fileNames.toLowerCase().contains(query);
    }).toList();
  }

  void _loadProfiles(List<PostEntity> posts) {
    final ids = posts
        .map((p) => p.userId)
        .where((id) => !_requestedUserIds.contains(id))
        .toList();
    if (ids.isEmpty) return;
    _requestedUserIds.addAll(ids);
    context.read<UserProfileBloc>().add(LoadProfilesByIdsEvent(ids));
    context.read<UserStatusBloc>().add(LoadUserStatusesEvent(ids));
  }

  void _resolveChannels(List<PostEntity> posts) {
    final channelState = context.read<ChannelBloc>().state;
    final loaded = channelState is ChannelsLoadedState ? channelState : null;

    for (final post in posts) {
      final id = post.channelId;
      if (id.isEmpty) continue;
      ChannelEntity? channel;
      if (loaded != null) {
        for (final c in loaded.channels) {
          if (c.id == id) {
            channel = c;
            break;
          }
        }
      }
      if (channel != null) {
        if (_channels[id] != channel) {
          setState(() => _channels = {..._channels, id: channel!});
        }
      } else if (_requestedChannelIds.add(id)) {
        getIt<ChannelRepository>()
            .getChannelById(id)
            .then((c) {
              if (!mounted) return;
              setState(() => _channels = {..._channels, id: c});
            })
            .catchError((_) {});
      }
    }
  }

  Future<void> _removeFromList(PostEntity post) async {
    final repo = getIt<PostRepository>();
    if (widget.isPinned) {
      await repo.unpinPost(post.id);
    } else {
      await repo.unflagPost(post.id);
    }
    _reload();
  }

  /// تأكيد قبل إلغاء الحفظ — مطابق لسلوك webapp في تجنّب الإزالة بالخطأ.
  Future<void> _confirmAndRemove(PostEntity post) async {
    if (widget.isPinned) {
      await _removeFromList(post);
      return;
    }
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.flaggedMessagesUnflagConfirmTitle),
        content: Text(l10n.flaggedMessagesUnflagConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.generic_modalCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.generic_modalConfirm),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      await _removeFromList(post);
    }
  }

  void _navigateToPost(PostEntity post) {
    final channel = _channels[post.channelId];
    if (channel == null) return;

    context.read<ChannelBloc>().add(SelectChannelEvent(channel));
    // استخدام LoadPostsAroundEvent للانتقال للسياق الأصلي وتظليل الرسالة.
    context.read<PostBloc>().add(LoadPostsAroundEvent(channel.id, post.id));

    final teamState = context.read<TeamBloc>().state;
    final teamName = teamState is TeamsLoadedState
        ? teamState.selectedTeam?.name
        : null;
    if (teamName != null) {
      context.go('/$teamName/channels/${channel.name}');
    }
  }

  Map<String, UserEntity> _profilesById() {
    final profileState = context.read<UserProfileBloc>().state;
    if (profileState is! UserProfileLoadedState) return const {};
    return {for (final p in profileState.profiles) p.id: p};
  }

  String _dayLabel(int timestampMs, AppLocalizations l10n) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestampMs);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(date.year, date.month, date.day);
    final difference = today.difference(day).inDays;
    if (difference == 0) return l10n.datetimeToday;
    if (difference == 1) return l10n.datetimeYesterday;
    return DateFormat('MMMM d, yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    _postsFuture ??= _fetch();

    return FutureBuilder<List<PostEntity>>(
      future: _postsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        final all = snapshot.data ?? const <PostEntity>[];
        final posts = _applyFilters(all);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          widget.onLoad?.call(all.length);
          _loadProfiles(posts);
          _resolveChannels(posts);
        });
        if (posts.isEmpty) {
          if (widget.contentFilter == SavedContentFilter.files &&
              all.isNotEmpty) {
            return _FilesEmptyState(l10n: l10n);
          }
          return widget.isPinned
              ? _PinnedEmptyState(l10n: l10n)
              : _SavedEmptyState(l10n: l10n);
        }
        return BlocBuilder<UserProfileBloc, UserProfileState>(
          builder: (context, profileState) {
            return BlocBuilder<UserStatusBloc, UserStatusState>(
              builder: (context, statusState) {
                final statuses = statusState is UserStatusesLoadedState
                    ? statusState
                    : null;
                return _buildList(context, posts, l10n, statuses);
              },
            );
          },
        );
      },
    );
  }

  Widget _buildList(
    BuildContext context,
    List<PostEntity> posts,
    AppLocalizations l10n,
    UserStatusesLoadedState? statuses,
  ) {
    final profiles = _profilesById();
    final items = <Widget>[];
    String? lastDayKey;

    for (final post in posts) {
      final date = DateTime.fromMillisecondsSinceEpoch(post.createAt);
      final dayKey = '${date.year}-${date.month}-${date.day}';
      if (dayKey != lastDayKey) {
        lastDayKey = dayKey;
        items.add(_DaySeparator(label: _dayLabel(post.createAt, l10n)));
      }
      items.add(
        _PostRow(
          post: post,
          profile: profiles[post.userId],
          status: statuses?.statusOf(post.userId),
          channel: widget.isPinned ? null : _channels[post.channelId],
          removeIcon: widget.isPinned
              ? Icons.push_pin_outlined
              : Icons.bookmark_border,
          removeTooltip: widget.isPinned
              ? l10n.postMenuUnpin
              : l10n.postMenuUnflag,
          onRemove: () => _confirmAndRemove(post),
          onTap: () => _navigateToPost(post),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.only(bottom: 16),
      children: items,
    );
  }
}

class _DaySeparator extends StatelessWidget {
  final String label;
  const _DaySeparator({required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
      child: Text(
        label,
        style: TextStyle(
          color: theme.centerChannelColor.withValues(alpha: 0.5),
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

/// عنصر منشور — بطاقة تفاعلية تحتوي على أفاتار/اسم/وقت + القناة + نص + أفعال سريعة.
class _PostRow extends StatelessWidget {
  final PostEntity post;
  final UserEntity? profile;
  final UserStatus? status;
  final ChannelEntity? channel;
  final IconData removeIcon;
  final String removeTooltip;
  final VoidCallback onRemove;
  final VoidCallback onTap;

  const _PostRow({
    required this.post,
    required this.profile,
    required this.status,
    required this.channel,
    required this.removeIcon,
    required this.removeTooltip,
    required this.onRemove,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);
    final time = DateFormat(
      'h:mm a',
    ).format(DateTime.fromMillisecondsSinceEpoch(post.createAt));
    final displayName = profile != null && profile!.firstName.isNotEmpty
        ? '${profile!.firstName} ${profile!.lastName}'.trim()
        : profile?.username ?? '@unknown';

    final isArchived = channel?.deleteAt != null && channel!.deleteAt > 0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: theme.centerChannelBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.centerChannelColor.withValues(alpha: 0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // شريط المصدر (Channel Badge)
              if (channel != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Icon(Icons.tag, size: 14, color: theme.linkColor),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          channel!.displayName,
                          style: TextStyle(
                            color: theme.linkColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (isArchived)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: theme.centerChannelColor.withValues(
                              alpha: 0.05,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            l10n.search_itemChannelArchived,
                            style: TextStyle(
                              color: theme.centerChannelColor.withValues(
                                alpha: 0.5,
                              ),
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfilePicture.sm(
                    userId: profile?.id ?? post.userId,
                    username: profile?.username ?? '',
                    avatarUrl: null,
                    status: status,
                    showStatus: true,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                displayName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: theme.centerChannelColor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              time,
                              style: TextStyle(
                                color: theme.centerChannelColor.withValues(
                                  alpha: 0.3,
                                ),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        if (post.deleteAt > 0)
                          Text(
                            l10n.postDeleted,
                            style: TextStyle(
                              color: theme.centerChannelColor.withValues(
                                alpha: 0.5,
                              ),
                              fontSize: 13,
                              fontStyle: FontStyle.italic,
                              height: 1.4,
                            ),
                          )
                        else
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MarkdownMessage(
                                text: post.message,
                                style: TextStyle(
                                  color: theme.centerChannelColor,
                                  fontSize: 13,
                                  height: 1.4,
                                ),
                              ),
                              if (post.editAt > 0)
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Text(
                                    l10n.postEdited,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontStyle: FontStyle.italic,
                                      color: theme.centerChannelColor
                                          .withValues(alpha: 0.4),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.bookmark, // أيقونة مظللة كما في المواصفات
                      size: 20,
                      color: theme.linkColor,
                    ),
                    tooltip: removeTooltip,
                    onPressed: onRemove,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 8),
              // شريط الإجراءات السريعة
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      _QuickAction(
                        icon: Icons.add_reaction_outlined,
                        onTap: () async {
                          final emoji = await showReactionPicker(context);
                          if (emoji != null && context.mounted) {
                            context.read<PostBloc>().add(
                              ToggleReactionEvent(post.id, emoji),
                            );
                          }
                        },
                      ),
                      _QuickAction(
                        icon: Icons.reply_outlined,
                        onTap: () {
                          context.read<RhsBloc>().add(
                            OpenThreadEvent(post.id, post.channelId),
                          );
                        },
                      ),
                      _QuickAction(
                        icon: Icons.share_outlined,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Share - coming soon'),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  TextButton.icon(
                    onPressed: onTap,
                    icon: const Icon(Icons.open_in_new, size: 14),
                    label: Text(
                      l10n.search_itemJump, // زر الانتقال للسياق الأصلي
                      style: const TextStyle(fontSize: 12),
                    ),
                    style: TextButton.styleFrom(
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
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QuickAction({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(
          icon,
          size: 18,
          color: theme.centerChannelColor.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}

class _SavedEmptyState extends StatelessWidget {
  final AppLocalizations l10n;
  const _SavedEmptyState({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return _EmptyBody(
      title: l10n.no_resultsFlagged_postsTitle,
      subtitle: l10n.no_resultsFlagged_postsSubtitle(l10n.postMenuFlag),
    );
  }
}

class _PinnedEmptyState extends StatelessWidget {
  final AppLocalizations l10n;
  const _PinnedEmptyState({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return _EmptyBody(
      title: l10n.no_resultsPinned_messagesTitle,
      subtitle: l10n.no_resultsPinned_messagesSubtitle(l10n.postMenuPin),
    );
  }
}

class _FilesEmptyState extends StatelessWidget {
  final AppLocalizations l10n;
  const _FilesEmptyState({required this.l10n});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.attach_file,
              size: 64,
              color: theme.centerChannelColor.withValues(alpha: 0.1),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.no_resultsFlagged_postsTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.centerChannelColor,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.no_resultsFilesSubtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.centerChannelColor.withValues(alpha: 0.6),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyBody extends StatelessWidget {
  final String title;
  final String subtitle;
  const _EmptyBody({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.bookmark_border,
              size: 64,
              color: theme.centerChannelColor.withValues(alpha: 0.1),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.centerChannelColor,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.centerChannelColor.withValues(alpha: 0.6),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
