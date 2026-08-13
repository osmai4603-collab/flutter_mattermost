import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:flutter_mattermost/core/widgets/profile_picture.dart';
import 'package:flutter_mattermost/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_mattermost/features/auth/domain/entities/user_status_entity.dart';
import 'package:flutter_mattermost/features/auth/presentation/bloc/auth_bloc.dart';
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

/// لوحة Recent Mentions — مطابقة flagged_messages في webapp:
/// منشورات تُذكر المستخدم (@username) مرتبة بالأيام مع أفاتار/اسم/وقت/قناة.
class MentionsPanel extends StatefulWidget {
  const MentionsPanel({super.key});

  @override
  State<MentionsPanel> createState() => _MentionsPanelState();
}

class _MentionsPanelState extends State<MentionsPanel> {
  Future<List<PostEntity>>? _postsFuture;
  final Set<String> _requestedUserIds = {};
  final Set<String> _requestedChannelIds = {};
  Map<String, String> _channelNames = {};
  List<String> _mentionKeys = const [];

  /// مفاتيح الإشارة — مطابقة getCurrentUserMentionKeys في webapp:
  /// مفاتيح مخصصة (notify_props.mention_keys) + الاسم الأول إن كان مفعّلاً
  /// (notify_props.first_name == 'true') + @username دائماً، وأخيراً تستبعد
  /// التنبيهات العامة @channel/@all/@here كما تفعل showMentions.
  static List<String> mentionKeysFrom(UserEntity user) {
    final keys = <String>[];
    final notifyProps = user.notifyProps;
    final rawKeys = notifyProps['mention_keys'] as String? ?? '';
    for (final key in rawKeys.split(',')) {
      final trimmed = key.trim();
      if (trimmed.isNotEmpty) keys.add(trimmed);
    }
    if (notifyProps['first_name'] == 'true' && user.firstName.isNotEmpty) {
      keys.add(user.firstName);
    }
    if (notifyProps['channel'] == 'true') {
      keys.addAll(const ['@channel', '@all', '@here']);
    }
    final usernameKey = '@${user.username}';
    if (!keys.contains(usernameKey)) keys.add(usernameKey);
    return keys
        .where((k) => k != '@channel' && k != '@all' && k != '@here')
        .toList();
  }

  /// استعلام البحث — مطابق showMentions في webapp:
  /// يجمع المفاتيح ويفصلها بمسافات ويرسل is_or_search=true.
  static String queryFromKeys(List<String> keys) =>
      '${keys.join(' ').trim()} ';

  Future<List<PostEntity>> _fetch() {
    final teamState = context.read<TeamBloc>().state;
    final teamId = teamState is TeamsLoadedState
        ? teamState.selectedTeam?.id ?? teamState.teams.firstOrNull?.id
        : null;
    final authState = context.read<AuthBloc>().state;
    if (authState is! AuthenticatedState) return Future.value(const []);
    final user = authState.user;
    _mentionKeys = mentionKeysFrom(user);
    final query = queryFromKeys(_mentionKeys);
    if (teamId == null || query.trim().isEmpty) {
      return Future.value(const []);
    }
    return getIt<PostRepository>()
        .searchPostsInTeam(teamId, query, isOrSearch: true);
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
    final loaded = channelState is ChannelsLoadedState ? channelState : null;

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
        getIt<ChannelRepository>()
            .getChannelById(id)
            .then((channel) {
              if (!mounted) return;
              setState(
                () => _channelNames = {
                  ..._channelNames,
                  id: channel.displayName,
                },
              );
            })
            .catchError((_) {});
      }
    }
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
          return _MentionsEmptyState(l10n: l10n);
        }
        final sorted = [...posts]
          ..sort((a, b) => b.createAt.compareTo(a.createAt));
        return BlocBuilder<UserProfileBloc, UserProfileState>(
          builder: (context, profileState) {
            return BlocBuilder<UserStatusBloc, UserStatusState>(
              builder: (context, statusState) {
                final statuses = statusState is UserStatusesLoadedState
                    ? statusState
                    : null;
                return _buildList(context, sorted, l10n, statuses);
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
        items.add(_MentionDaySeparator(label: _dayLabel(post.createAt, l10n)));
      }
      items.add(
        _MentionRow(
          post: post,
          profile: profiles[post.userId],
          status: statuses?.statusOf(post.userId),
          channelName: _channelNames[post.channelId],
          mentionKeys: _mentionKeys,
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

class _MentionDaySeparator extends StatelessWidget {
  final String label;
  const _MentionDaySeparator({required this.label});

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

class _MentionRow extends StatelessWidget {
  final PostEntity post;
  final UserEntity? profile;
  final UserStatus? status;
  final String? channelName;
  final List<String> mentionKeys;
  final VoidCallback onTap;

  const _MentionRow({
    required this.post,
    required this.profile,
    required this.status,
    required this.channelName,
    required this.mentionKeys,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final time = DateFormat('h:mm a').format(
      DateTime.fromMillisecondsSinceEpoch(post.createAt),
    );
    final displayName = profile != null && profile!.firstName.isNotEmpty
        ? '${profile!.firstName} ${profile!.lastName}'.trim()
        : profile?.username ?? '@unknown';

    return InkWell(
      onTap: onTap,
      hoverColor: theme.centerChannelColor.withValues(alpha: 0.04),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
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
                      children: mentionHighlightSpans(
                        post.message,
                        TextStyle(
                          color: theme.centerChannelColor,
                          fontSize: 13,
                          height: 1.4,
                        ),
                        mentionKeys,
                        theme: theme,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MentionsEmptyState extends StatelessWidget {
  final AppLocalizations l10n;
  const _MentionsEmptyState({required this.l10n});

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
              l10n.no_resultsMentionsTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.centerChannelColor,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.no_resultsMentionsSubtitle,
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

/// بناء spans مع وعي بالإيموجي وتظليل مخصص للإشارات (Mention Highlighting) —
/// مطابق لتظليل الكلمات المشَار إليها في webapp (خلفية mentionHighlightBg).
List<InlineSpan> mentionHighlightSpans(
  String text,
  TextStyle style,
  List<String> keys,
  {required MattermostColors theme,
  }) {
  if (keys.isEmpty) return emojiAwareSpans(text, style);
  final pattern = RegExp(
    keys.map((k) => '(?:@?${RegExp.escape(k)})').join('|'),
    caseSensitive: false,
  );
  final highlightStyle = style.copyWith(
    backgroundColor: theme.mentionHighlightBg,
    color: theme.mentionHighlightLink,
    fontWeight: FontWeight.w700,
  );
  final spans = <InlineSpan>[];
  var last = 0;
  for (final match in pattern.allMatches(text)) {
    if (match.start > last) {
      spans.addAll(emojiAwareSpans(text.substring(last, match.start), style));
    }
    spans.add(TextSpan(text: match.group(0), style: highlightStyle));
    last = match.end;
  }
  if (last < text.length) {
    spans.addAll(emojiAwareSpans(text.substring(last), style));
  }
  return spans;
}
