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
import 'package:flutter_mattermost/features/chat/presentation/widgets/custom_emoji.dart';
import 'package:flutter_mattermost/features/teams/presentation/bloc/team_bloc.dart';
import 'package:flutter_mattermost/features/users/presentation/bloc/user_profile_bloc.dart';
import 'package:flutter_mattermost/features/users/presentation/bloc/user_status_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// لوحة الرسائل المحفوظة/المثبتة — مطابقة flagged/pinned_messages في webapp:
/// قائمة منشورات مع فواصل تواريخ وأفاتار/اسم/وقت/نص وقناة (للمحفوظة)
/// وزر إزالة (إلغاء الحفظ/إزالة التثبيت).
class SavedPinnedPanel extends StatefulWidget {
  final bool isPinned;
  final String? channelId;

  const SavedPinnedPanel({super.key, this.isPinned = false, this.channelId});

  @override
  State<SavedPinnedPanel> createState() => _SavedPinnedPanelState();
}

class _SavedPinnedPanelState extends State<SavedPinnedPanel> {
  Future<List<PostEntity>>? _postsFuture;
  String? _channelId;
  final Set<String> _requestedUserIds = {};
  final Set<String> _requestedChannelIds = {};
  Map<String, String> _channelNames = {};

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

  void _resolveChannelNames(List<PostEntity> posts) {
    final channelState = context.read<ChannelBloc>().state;
    final loaded =
        channelState is ChannelsLoadedState ? channelState : null;

    for (final post in posts) {
      final id = post.channelId;
      if (id.isEmpty) continue;
      String? name;
      if (loaded != null) {
        for (final c in loaded.channels) {
          if (c.id == id) {
            name = c.displayName;
            break;
          }
        }
      }
      if (name == null && _requestedChannelIds.add(id)) {
        getIt<ChannelRepository>().getChannelById(id).then((channel) {
          if (!mounted) return;
          setState(() => _channelNames = {..._channelNames, id: channel.displayName});
        }).catchError((_) {});
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

  void _navigateToPost(PostEntity post) {
    final channelState = context.read<ChannelBloc>().state;
    ChannelEntity? channel;
    if (channelState is ChannelsLoadedState) {
      for (final c in channelState.channels) {
        if (c.id == post.channelId) {
          channel = c;
          break;
        }
      }
    }
    if (channel == null) return;
    context.read<ChannelBloc>().add(SelectChannelEvent(channel));
    context.read<PostBloc>().add(LoadPostsForChannelEvent(channel.id));
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
        final posts = snapshot.data ?? const <PostEntity>[];
        _loadProfiles(posts);
        _resolveChannelNames(posts);
        if (posts.isEmpty) {
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
          channelName: widget.isPinned ? null : _channelNames[post.channelId],
          removeIcon: widget.isPinned ? Icons.push_pin_outlined : Icons.bookmark_border,
          removeTooltip: widget.isPinned
              ? l10n.postMenuUnpin
              : l10n.postMenuUnflag,
          onRemove: () => _removeFromList(post),
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

/// عنصر منشور — أفاتار + اسم/وقت/قناة + نص + زر إزالة.
class _PostRow extends StatelessWidget {
  final PostEntity post;
  final UserEntity? profile;
  final UserStatus? status;
  final String? channelName;
  final IconData removeIcon;
  final String removeTooltip;
  final VoidCallback onRemove;
  final VoidCallback onTap;

  const _PostRow({
    required this.post,
    required this.profile,
    required this.status,
    required this.channelName,
    required this.removeIcon,
    required this.removeTooltip,
    required this.onRemove,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final time = DateFormat('h:mm a').format(
      DateTime.fromMillisecondsSinceEpoch(post.createAt),
    );
    final displayName = profile != null &&
            profile!.firstName.isNotEmpty
        ? '${profile!.firstName} ${profile!.lastName}'.trim()
        : profile?.username ?? '@unknown';

    return InkWell(
      onTap: onTap,
      hoverColor: theme.centerChannelColor.withValues(alpha: 0.04),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: ProfilePicture.md(
                username: profile?.username ?? '',
                avatarUrl: null,
                status: status,
                showStatus: true,
              ),
            ),
            const SizedBox(width: 12),
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
                          color: theme.centerChannelColor.withValues(alpha: 0.3),
                          fontSize: 11,
                        ),
                      ),
                      if (channelName != null) ...[
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            channelName!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: theme.centerChannelColor.withValues(alpha: 0.3),
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  RichText(
                    text: TextSpan(
                      children: emojiAwareSpans(
                        post.message,
                        TextStyle(
                          color: theme.centerChannelColor,
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 4),
            IconButton(
              icon: Icon(
                removeIcon,
                size: 18,
                color: theme.centerChannelColor.withValues(alpha: 0.5),
              ),
              tooltip: removeTooltip,
              onPressed: onRemove,
            ),
          ],
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

class _EmptyBody extends StatelessWidget {
  final String title;
  final String subtitle;
  const _EmptyBody({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
