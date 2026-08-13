import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/storage/recent_searches_store.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/design_tokens.dart';
import 'package:flutter_mattermost/core/widgets/profile_picture.dart';
import 'package:flutter_mattermost/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_mattermost/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_entity.dart';
import 'package:flutter_mattermost/features/channels/domain/repositories/channel_repository.dart';
import 'package:flutter_mattermost/features/channels/presentation/bloc/channel_bloc.dart';
import 'package:flutter_mattermost/features/chat/domain/entities/file_info_entity.dart';
import 'package:flutter_mattermost/features/chat/domain/entities/post_entity.dart';
import 'package:flutter_mattermost/features/chat/domain/repositories/post_repository.dart';
import 'package:flutter_mattermost/features/chat/presentation/bloc/post_bloc.dart';
import 'package:flutter_mattermost/features/chat/presentation/bloc/rhs_bloc.dart';
import 'package:flutter_mattermost/features/chat/presentation/bloc/search_bloc.dart';
import 'package:flutter_mattermost/features/teams/presentation/bloc/team_bloc.dart';
import 'package:flutter_mattermost/features/users/presentation/bloc/user_profile_bloc.dart';
import 'package:intl/intl.dart';

/// لوحة نتائج البحث داخل RHS — مطابقة search_results.tsx في webapp:
/// محدد (رسائل/ملفات) مع عدّادات + قائمة نتائج مع تحميل تلقائي عند التمرير
/// + حالات فارغة مطابقة لـ NoResultsIndicator.
class SearchResultsPanel extends StatefulWidget {
  final String searchTerms;

  const SearchResultsPanel({super.key, required this.searchTerms});

  @override
  State<SearchResultsPanel> createState() => _SearchResultsPanelState();
}

class _SearchResultsPanelState extends State<SearchResultsPanel> {
  final ScrollController _scrollController = ScrollController();
  final Map<String, ChannelEntity> _fetchedChannels = {};
  final Set<String> _pendingChannelIds = {};
  final RecentSearchesStore _recentStore = RecentSearchesStore();
  late final TextEditingController _searchController = TextEditingController(
    text: widget.searchTerms,
  );
  final FocusNode _searchFocusNode = FocusNode();
  String? _requestedTeamId;
  List<String> _recentSearches = const [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadRecents();
  }

  @override
  void didUpdateWidget(covariant SearchResultsPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchTerms != widget.searchTerms &&
        widget.searchTerms != _searchController.text) {
      _searchController.text = widget.searchTerms;
      _searchController.selection = TextSelection.fromPosition(
        TextPosition(offset: _searchController.text.length),
      );
      _performSearch();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _performSearch();
  }

  bool _started = false;

  Future<void> _loadRecents() async {
    final recents = await _recentStore.load();
    if (!mounted) return;
    setState(() => _recentSearches = recents);
  }

  void _recordSearch(String terms) {
    _recentStore.record(terms).then((next) {
      if (mounted) setState(() => _recentSearches = next);
    });
  }

  Future<void> _clearRecents() async {
    await _recentStore.clear();
    if (mounted) setState(() => _recentSearches = const []);
  }

  void _performSearch() {
    final terms = widget.searchTerms.trim();
    final bloc = context.read<SearchBloc>();
    if (terms.isEmpty) {
      bloc.add(ClearSearchEvent());
      return;
    }
    final current = bloc.state;
    if (_started && current is SearchLoadedState && current.terms == terms) {
      return;
    }
    final teamState = context.read<TeamBloc>().state;
    final teamId = teamState is TeamsLoadedState
        ? teamState.selectedTeam?.id ?? ''
        : '';
    bloc.add(PerformSearchEvent(terms: terms, teamId: teamId));
    _started = true;
  }

  /// تنفيذ بحث يدوي من شريط البحث أو شريحة سجل — يحدّث RHS فيُعاد التنفيذ.
  void _runSearch(String terms) {
    final trimmed = terms.trim();
    final bloc = context.read<SearchBloc>();
    if (trimmed.isEmpty) {
      bloc.add(ClearSearchEvent());
    } else {
      _recordSearch(trimmed);
    }
    context.read<RhsBloc>().add(UpdateRhsSearchTermsEvent(trimmed));
    context.read<RhsBloc>().add(ShowSearchResultsEvent(trimmed));
    _searchFocusNode.unfocus();
  }

  void _onScroll() {
    final position = _scrollController.position;
    if (position.pixels +
            position.viewportDimension +
            SearchBloc.loadMoreBuffer >=
        position.maxScrollExtent) {
      context.read<SearchBloc>().add(LoadMoreSearchEvent());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return Column(
          children: [
            _SearchBar(
              controller: _searchController,
              focusNode: _searchFocusNode,
              initialTerms: widget.searchTerms,
              type: state is SearchLoadedState
                  ? state.type
                  : state is SearchLoadingState
                  ? state.type
                  : SearchResultType.messages,
              onSubmit: _runSearch,
            ),
            _MessageFileSelector(
              state: state,
              onChanged: (type) =>
                  context.read<SearchBloc>().add(ChangeSearchTypeEvent(type)),
            ),
            Expanded(child: _buildBody(context, state)),
          ],
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, SearchState state) {
    final l10n = AppLocalizations.of(context);

    if (state is SearchLoadingState) {
      return const _SkeletonResults();
    }
    if (state is! SearchLoadedState) {
      return _SearchInitialBody(
        recentSearches: _recentSearches,
        onSelect: (term) {
          _searchController.text = term;
          _searchController.selection = TextSelection.fromPosition(
            TextPosition(offset: _searchController.text.length),
          );
          _runSearch(term);
        },
        onClearRecents: _clearRecents,
      );
    }
    if (state.error != null && state.posts.isEmpty && state.files.isEmpty) {
      debugPrint('Search error: ${state.error}');
      return _EmptyState(
        icon: Icons.error_outline,
        title: l10n.more_channelsSearchError,
      );
    }
    if (state.terms.trim().isEmpty) {
      return _SearchInitialBody(
        recentSearches: _recentSearches,
        onSelect: (term) {
          _searchController.text = term;
          _searchController.selection = TextSelection.fromPosition(
            TextPosition(offset: _searchController.text.length),
          );
          _runSearch(term);
        },
        onClearRecents: _clearRecents,
      );
    }

    if (state.type == SearchResultType.files) {
      if (state.files.isEmpty) {
        return _EmptyState(
          icon: Icons.folder_open,
          title: l10n.searchTypeFiles,
          subtitle: l10n.no_resultsSearchSubtitle,
        );
      }
      return ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
        itemCount: state.files.length + (state.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= state.files.length) {
            return const Padding(
              padding: EdgeInsets.all(12),
              child: Center(
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            );
          }
          return _FileResultCard(
            file: state.files[index],
            onOpen: () => _openFileInChannel(context, state.files[index]),
          );
        },
      );
    }

    if (state.posts.isEmpty) {
      return _EmptyState(
        icon: Icons.search_off,
        title: l10n.search_headerResults,
        subtitle: l10n.no_resultsSearchSubtitle,
      );
    }

    return BlocBuilder<ChannelBloc, ChannelState>(
      builder: (context, _) => _buildPostsList(context, state),
    );
  }

  Widget _buildPostsList(BuildContext context, SearchLoadedState state) {
    final profiles = _profilesById(context);
    _ensureChannelNames(state.teamId, {
      for (final p in state.posts) p.channelId,
    });
    final channels = _channelsById(context);
    final posts = state.posts;

    final items = <Widget>[];
    String? previousDay;
    for (var i = 0; i < posts.length; i++) {
      final post = posts[i];
      final day = _dayLabel(context, post.createAt);
      if (day != previousDay) {
        items.add(_DateSeparator(label: day));
        previousDay = day;
      }
      items.add(
        _PostResultItem(
          post: post,
          terms: state.terms,
          profile: profiles[post.userId],
          channelName: channels[post.channelId]?.displayName,
          onJump: () => _openResultPost(context, post),
          onThread: () => _openResultThread(context, post),
        ),
      );
      if (i == posts.length - 1 && state.hasMore) {
        items.add(
          const Padding(
            padding: EdgeInsets.all(12),
            child: Center(
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          ),
        );
      }
    }

    return ListView(
      controller: _scrollController,
      padding: const EdgeInsets.only(bottom: 24),
      children: items,
    );
  }

  Map<String, ChannelEntity> _channelsById(BuildContext context) {
    final channelState = context.read<ChannelBloc>().state;
    final map = <String, ChannelEntity>{};
    if (channelState is ChannelsLoadedState) {
      for (final c in channelState.channels) {
        map[c.id] = c;
      }
    }
    map.addAll(_fetchedChannels);
    return map;
  }

  ChannelEntity? _resolvedChannel(String channelId) {
    final channelState = context.read<ChannelBloc>().state;
    if (channelState is ChannelsLoadedState) {
      final channel = channelState.channelById(channelId);
      if (channel != null) return channel;
    }
    return _fetchedChannels[channelId];
  }

  /// طلب قنوات الفريق إن لم تكن محملة + جلب أسماء القنوات الناقصة
  /// (نتائج من قنوات غير محملة/خاصة) عند الطلب.
  void _ensureChannelNames(String teamId, Set<String> channelIds) {
    final channelState = context.read<ChannelBloc>().state;
    if (channelState is! ChannelsLoadedState) {
      if (_requestedTeamId != teamId && teamId.isNotEmpty) {
        _requestedTeamId = teamId;
        final authState = context.read<AuthBloc>().state;
        final userId = authState is AuthenticatedState
            ? authState.user.id
            : null;
        context.read<ChannelBloc>().add(
          LoadChannelsForTeamEvent(teamId, userId: userId),
        );
      }
    }
    final loaded = channelState is ChannelsLoadedState
        ? {for (final c in channelState.channels) c.id}
        : <String>{};
    for (final id in channelIds) {
      if (id.isEmpty ||
          loaded.contains(id) ||
          _fetchedChannels.containsKey(id) ||
          _pendingChannelIds.contains(id)) {
        continue;
      }
      _pendingChannelIds.add(id);
      _fetchChannel(id);
    }
  }

  Future<void> _fetchChannel(String channelId) async {
    try {
      final channel = await getIt<ChannelRepository>().getChannelById(
        channelId,
      );
      if (!mounted) return;
      setState(() => _fetchedChannels[channelId] = channel);
    } catch (_) {
      // القناة غير متاحة (غير عضو/محذوفة) — تُعرض النتائج بدون اسم.
    } finally {
      _pendingChannelIds.remove(channelId);
    }
  }

  /// فتح نتيجة منشور: تحديد القناة + تحميل المنشورات حول الرسالة + تحديث
  /// الرابط — مطابق jump إلى الرسالة في webapp (يبقى RHS معروضًا).
  void _openResultPost(BuildContext context, PostEntity post) {
    if (post.channelId.isEmpty) return;
    final channel = _resolvedChannel(post.channelId);
    if (channel == null) {
      _pendingChannelIds.add(post.channelId);
      _fetchChannel(post.channelId).then((_) {
        if (!mounted || !context.mounted) return;
        final fetched = _fetchedChannels[post.channelId];
        if (fetched != null) {
          _jumpToPost(context, post, fetched);
        }
      });
      return;
    }
    _jumpToPost(context, post, channel);
  }

  /// فتح الخيط الخاص بالنتيجة بعد الانتقال للقناة (webapp: open thread from search).
  void _openResultThread(BuildContext context, PostEntity post) {
    if (post.channelId.isEmpty) return;
    final channel = _resolvedChannel(post.channelId);
    if (channel == null) return;
    _jumpToPost(context, post, channel);
    context.read<RhsBloc>().add(OpenThreadEvent(post.id, post.channelId));
  }

  void _jumpToPost(
    BuildContext context,
    PostEntity post,
    ChannelEntity channel,
  ) {
    context.read<ChannelBloc>().add(SelectChannelEvent(channel));
    context.read<PostBloc>().add(LoadPostsAroundEvent(channel.id, post.id));
    final teamState = context.read<TeamBloc>().state;
    final teamName = teamState is TeamsLoadedState
        ? teamState.selectedTeam?.name
        : null;
    if (teamName != null) {
      context.go('/$teamName/channels/${channel.name}');
    }
  }

  /// فتح موقع منشور الملف في القناة — مطابق open in channel لنتائج الملفات.
  Future<void> _openFileInChannel(
    BuildContext context,
    FileInfoEntity file,
  ) async {
    if (file.postId.isEmpty) return;
    try {
      final post = await getIt<PostRepository>().getPostById(file.postId);
      if (!mounted || !context.mounted) return;
      _openResultPost(context, post);
    } catch (_) {
      // الملف غير مرتبط بمنشور متاح — لا شيء.
    }
  }

  Map<String, UserEntity> _profilesById(BuildContext context) {
    final profileState = context.read<UserProfileBloc>().state;
    if (profileState is! UserProfileLoadedState) return const {};
    return {for (final p in profileState.profiles) p.id: p};
  }

  String _dayLabel(BuildContext context, int timestampMs) {
    final l10n = AppLocalizations.of(context);
    final date = DateTime.fromMillisecondsSinceEpoch(timestampMs);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(date.year, date.month, date.day);
    final difference = today.difference(day).inDays;
    if (difference == 0) return l10n.datetimeToday;
    if (difference == 1) return l10n.datetimeYesterday;
    return DateFormat('MMMM d, yyyy').format(date);
  }
}

/// محدد الرسائل/الملفات مع العدّادات (webapp messages_or_files_selector).
class _MessageFileSelector extends StatelessWidget {
  final SearchState state;
  final ValueChanged<SearchResultType> onChanged;

  const _MessageFileSelector({required this.state, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);

    final loaded = state is SearchLoadedState
        ? state as SearchLoadedState
        : null;
    final messagesCount = loaded?.posts.length ?? 0;
    final filesCount = loaded?.files.length ?? 0;
    final hasMore = loaded?.hasMore ?? false;

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 7, 14, 7),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.centerChannelColor.withValues(alpha: 0.08),
          ),
        ),
      ),
      child: Row(
        children: [
          _SelectorTab(
            label: l10n.searchTypeMessages,
            count: messagesCount,
            hasMore: hasMore,
            active: loaded?.type == SearchResultType.messages,
            onTap: () => onChanged(SearchResultType.messages),
          ),
          const SizedBox(width: 4),
          _SelectorTab(
            label: l10n.searchTypeFiles,
            count: filesCount,
            hasMore: hasMore,
            active: loaded?.type == SearchResultType.files,
            onTap: () => onChanged(SearchResultType.files),
          ),
        ],
      ),
    );
  }
}

class _SelectorTab extends StatelessWidget {
  final String label;
  final int count;
  final bool hasMore;
  final bool active;
  final VoidCallback onTap;

  const _SelectorTab({
    required this.label,
    required this.count,
    required this.hasMore,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: active
              ? theme.buttonBg.withValues(alpha: 0.08)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: active
                    ? theme.buttonBg
                    : theme.centerChannelColor.withValues(alpha: 0.75),
              ),
            ),
            if (count > 0) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: theme.centerChannelColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  hasMore ? '$count+' : '$count',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: theme.centerChannelColor.withValues(alpha: 0.75),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// عنصر منشور في نتائج البحث — مطابق search-item__container:
/// صورة + اسم/وقت/قناة + نص مع إبراز النتائج + أزرار (فتح خيط/انتقال) عند التحويم.
class _PostResultItem extends StatefulWidget {
  final PostEntity post;
  final String terms;
  final UserEntity? profile;
  final String? channelName;
  final VoidCallback onJump;
  final VoidCallback onThread;

  const _PostResultItem({
    required this.post,
    required this.terms,
    required this.profile,
    required this.channelName,
    required this.onJump,
    required this.onThread,
  });

  @override
  State<_PostResultItem> createState() => _PostResultItemState();
}

class _PostResultItemState extends State<_PostResultItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final time = DateFormat(
      'h:mm a',
    ).format(DateTime.fromMillisecondsSinceEpoch(widget.post.createAt));
    final displayName =
        widget.profile?.firstName != null && widget.profile!.firstName.isNotEmpty
        ? '${widget.profile!.firstName} ${widget.profile!.lastName}'.trim()
        : widget.profile?.username ?? '@unknown';
    final statusColor = theme.centerChannelColor.withValues(alpha: 0.3);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: InkWell(
        onTap: widget.onJump,
        hoverColor: theme.centerChannelColor.withValues(alpha: 0.04),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: ProfilePicture.md(
                  username: widget.profile?.username ?? '?',
                  avatarUrl: null,
                  status: null,
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
                          style: TextStyle(color: statusColor, fontSize: 11),
                        ),
                        if (widget.channelName != null) ...[
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              widget.channelName!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: statusColor,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    _HighlightedText(
                      text: widget.post.message,
                      terms: widget.terms,
                      style: TextStyle(
                        color: theme.centerChannelColor,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              if (_hovered)
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _ResultAction(
                        icon: Icons.mode_comment_outlined,
                        tooltip: AppLocalizations.of(context).postMenuReply,
                        onTap: widget.onThread,
                      ),
                      const SizedBox(height: 4),
                      _ResultAction(
                        icon: Icons.arrow_forward,
                        tooltip: AppLocalizations.of(context).search_itemJump,
                        onTap: widget.onJump,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// زر إجراء صغير على نتيجة البحث (يظهر عند التحويم).
class _ResultAction extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  const _ResultAction({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            border: Border.all(
              color: theme.centerChannelColor.withValues(alpha: 0.2),
            ),
            borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
          ),
          child: Icon(
            icon,
            size: 13,
            color: theme.buttonBg,
          ),
        ),
      ),
    );
  }
}

/// نص مع إبراز كلمات البحث (بدون محددات) بخلفية ملونة — مطابق mark في webapp.
class _HighlightedText extends StatelessWidget {
  final String text;
  final String terms;
  final TextStyle style;

  const _HighlightedText({
    required this.text,
    required this.terms,
    required this.style,
  });

  /// كلمات بحث صافية: يزيل المحددات (from:/in:/on:/before:/after:/ext:/-)
  /// وعلامات التنصيص ويحتفظ ببقية المصطلحات.
  static List<String> wordsFrom(String terms) {
    final result = <String>[];
    for (final token in terms.split(RegExp(r'\s+'))) {
      final lower = token.toLowerCase();
      if (lower.startsWith('from:') ||
          lower.startsWith('in:') ||
          lower.startsWith('on:') ||
          lower.startsWith('before:') ||
          lower.startsWith('after:') ||
          lower.startsWith('ext:') ||
          lower.startsWith('phrase:')) {
        continue;
      }
      final clean = token.replaceAll('"', '').trim();
      if (clean.isNotEmpty && clean != '-') result.add(clean);
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final words = wordsFrom(terms);
    if (words.isEmpty || text.isEmpty) {
      return Text(text, style: style);
    }
    final pattern = RegExp(
      words.map(RegExp.escape).join('|'),
      caseSensitive: false,
    );
    final highlightStyle = style.copyWith(
      backgroundColor: theme.mentionHighlightBg,
      color: theme.mentionHighlightLink,
      fontWeight: FontWeight.w700,
    );
    final spans = <TextSpan>[];
    var last = 0;
    for (final match in pattern.allMatches(text)) {
      if (match.start > last) {
        spans.add(TextSpan(text: text.substring(last, match.start)));
      }
      spans.add(
        TextSpan(text: match.group(0), style: highlightStyle),
      );
      last = match.end;
    }
    if (last < text.length) {
      spans.add(TextSpan(text: text.substring(last)));
    }
    return Text.rich(TextSpan(children: spans, style: style));
  }
}

/// بطاقة ملف في النتائج — مطابقة file_search_result_item.scss:
/// max-width 600، padding 11، border 0.16، radius 4، hover shadow
/// + زر فتح في القناة عند التحويم.
class _FileResultCard extends StatefulWidget {
  final FileInfoEntity file;
  final VoidCallback onOpen;

  const _FileResultCard({required this.file, required this.onOpen});

  @override
  State<_FileResultCard> createState() => _FileResultCardState();
}

class _FileResultCardState extends State<_FileResultCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);
    final sizeLabel = _formatSize(widget.file.size);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          padding: const EdgeInsets.all(11),
          decoration: BoxDecoration(
            border: Border.all(
              color: theme.centerChannelColor.withValues(alpha: 0.16),
            ),
            borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: theme.centerChannelColor.withValues(alpha: 0.12),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : null,
          ),
          child: InkWell(
            onTap: widget.onOpen,
            borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: theme.centerChannelColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
                  ),
                  child: Icon(
                    _fileIcon(widget.file.extension),
                    size: 22,
                    color: theme.centerChannelColor.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.file.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: theme.centerChannelColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        sizeLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: theme.centerChannelColor.withValues(alpha: 0.6),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedOpacity(
                  opacity: _hovered ? 1 : 0,
                  duration: DesignTokens.hoverFadeDuration,
                  child: IconButton(
                    icon: Icon(
                      Icons.open_in_new,
                      size: 16,
                      color: theme.buttonBg,
                    ),
                    tooltip: l10n.file_search_result_itemOpen_in_channel,
                    onPressed: widget.onOpen,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _fileIcon(String extension) {
    if (extension == 'png' ||
        extension == 'jpg' ||
        extension == 'jpeg' ||
        extension == 'gif' ||
        extension == 'svg') {
      return Icons.image_outlined;
    }
    if (extension == 'pdf') return Icons.picture_as_pdf_outlined;
    if (extension == 'mp4' || extension == 'mov' || extension == 'webm') {
      return Icons.movie_outlined;
    }
    return Icons.insert_drive_file_outlined;
  }

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}

/// فاصل تواريخ — مطابق DateSeparator في webapp.
class _DateSeparator extends StatelessWidget {
  final String label;

  const _DateSeparator({required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      alignment: Alignment.center,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        decoration: BoxDecoration(
          color: theme.centerChannelColor.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(DesignTokens.radiusPill),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: theme.centerChannelColor.withValues(alpha: 0.6),
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

/// حالة فارغة — مطابقة NoResultsIndicator.
class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _EmptyState({
    required this.icon,
    required this.title,
    this.subtitle = '',
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: theme.centerChannelColor.withValues(alpha: 0.06),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 26,
                color: theme.centerChannelColor.withValues(alpha: 0.5),
              ),
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
            const SizedBox(height: 6),
            if (subtitle.isNotEmpty) ...[
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: theme.centerChannelColor.withValues(alpha: 0.6),
                  fontSize: 13,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// شريط البحث أعلى اللوحة — مطابق search_bar.tsx في webapp:
/// حقل نصي + زر تلميحات (SearchHint) + زر تنفيذ.
/// عند الضغط Enter أو زر البحث تُستدعى [onSubmit] فيُحدَّث RHS ويُعاد التنفيذ.
/// كما يتحقق من صحة محددات التاريخ (before:/after:/on:) ويعرض شريط تنبيه.
class _SearchBar extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String initialTerms;
  final SearchResultType type;
  final ValueChanged<String> onSubmit;

  const _SearchBar({
    required this.controller,
    required this.focusNode,
    required this.initialTerms,
    required this.type,
    required this.onSubmit,
  });

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  bool _showHints = false;
  String? _invalidDateError;

  @override
  void dispose() {
    super.dispose();
  }

  void _submit() {
    final terms = widget.controller.text.trim();
    final invalid = validateSearchTerms(terms);
    if (invalid != null) {
      setState(() => _invalidDateError = invalid);
      return;
    }
    setState(() => _invalidDateError = null);
    widget.onSubmit(terms);
    widget.focusNode.unfocus();
  }

  void _insertTerm(String term) {
    final current = widget.controller.text;
    setState(() {
      _invalidDateError = null;
      widget.controller.text = current.trim().isEmpty
          ? term
          : '${current.trimRight()} $term';
      widget.controller.selection = TextSelection.fromPosition(
        TextPosition(offset: widget.controller.text.length),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);

    final hints = _hintOptions(context, widget.type, l10n);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: theme.centerChannelColor.withValues(alpha: 0.08),
              ),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.search,
                size: 18,
                color: theme.centerChannelColor.withValues(alpha: 0.6),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  focusNode: widget.focusNode,
                  onSubmitted: (_) => _submit(),
                  onChanged: (_) {
                    if (_invalidDateError != null) {
                      setState(() => _invalidDateError = null);
                    }
                  },
                  style: TextStyle(
                    color: theme.centerChannelColor,
                    fontSize: 13,
                  ),
                  decoration: InputDecoration(
                    hintText: l10n.search_barSearch,
                    hintStyle: TextStyle(
                      color: theme.centerChannelColor.withValues(alpha: 0.5),
                      fontSize: 13,
                    ),
                    isDense: true,
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  _showHints ? Icons.help : Icons.help_outline,
                  size: 18,
                  color: _showHints
                      ? theme.buttonBg
                      : theme.centerChannelColor.withValues(alpha: 0.6),
                ),
                tooltip: l10n.search_barUsageTitle,
                onPressed: () => setState(() => _showHints = !_showHints),
              ),
              IconButton(
                icon: Icon(
                  Icons.arrow_forward,
                  size: 18,
                  color: theme.centerChannelColor.withValues(alpha: 0.6),
                ),
                tooltip: l10n.search_barSearch,
                onPressed: _submit,
              ),
            ],
          ),
        ),
        if (_invalidDateError != null)
          _InvalidQueryBanner(
            invalidValue: _invalidDateError!,
            onDismiss: () => setState(() => _invalidDateError = null),
          ),
        if (_showHints) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            decoration: BoxDecoration(
              color: theme.centerChannelColor.withValues(alpha: 0.03),
              border: Border(
                bottom: BorderSide(
                  color: theme.centerChannelColor.withValues(alpha: 0.08),
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.type == SearchResultType.files
                      ? l10n.search_barUsageTitle_files
                      : l10n.search_barUsageTitle_messages,
                  style: TextStyle(
                    color: theme.centerChannelColor.withValues(alpha: 0.6),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 6),
                for (final option in hints)
                  InkWell(
                    onTap: () => _insertTerm(option.term),
                    borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: theme.centerChannelColor.withValues(
                                alpha: 0.08,
                              ),
                              borderRadius: BorderRadius.circular(
                                DesignTokens.radiusSm,
                              ),
                            ),
                            child: Text(
                              option.term,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: theme.buttonBg,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              option.label,
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.centerChannelColor.withValues(
                                  alpha: 0.75,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  /// خيارات التلميحات — مطابقة searchHintOptions/searchFilesHintOptions
  /// في webapp utils/constants.tsx.
  List<_HintOption> _hintOptions(
    BuildContext context,
    SearchResultType type,
    AppLocalizations l10n,
  ) {
    if (type == SearchResultType.files) {
      return [
        _HintOption('from:', l10n.search_files_list_optionFrom),
        _HintOption('in:', l10n.search_files_list_optionIn),
        _HintOption('on:', l10n.search_files_list_optionOn),
        _HintOption('before:', l10n.search_files_list_optionBefore),
        _HintOption('after:', l10n.search_files_list_optionAfter),
        _HintOption('ext:', l10n.search_files_list_optionExt),
        _HintOption('-', l10n.search_files_list_optionExclude),
      ];
    }
    return [
      _HintOption('from:', l10n.search_list_optionFrom),
      _HintOption('in:', l10n.search_list_optionIn),
      _HintOption('on:', l10n.search_list_optionOn),
      _HintOption('before:', l10n.search_list_optionBefore),
      _HintOption('after:', l10n.search_list_optionAfter),
      _HintOption('-', l10n.search_list_optionExclude),
      _HintOption('""', l10n.search_list_optionPhrases),
    ];
  }
}

/// خيار تلميح — المصطلح المُدخل (from:/in:/...) + وصفه.
class _HintOption {
  final String term;
  final String label;

  const _HintOption(this.term, this.label);
}

/// يتحقق من صحة محددات التاريخ (before:/after:/on:) — يجب أن تكون بصيغة
/// YYYY-MM-DD وتاريخًا حقيقيًا. يعيد القيمة الخاطئة أو null.
String? validateSearchTerms(String terms) {
  final dateModifier = RegExp(r'(before|after|on):(\S+)', caseSensitive: false);
  for (final match in dateModifier.allMatches(terms)) {
    final value = match.group(2)!;
    final valid = RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value) &&
        _isRealDate(value);
    if (!valid) return value;
  }
  return null;
}

bool _isRealDate(String value) {
  final parts = value.split('-');
  final year = int.tryParse(parts[0]);
  final month = int.tryParse(parts[1]);
  final day = int.tryParse(parts[2]);
  if (year == null || month == null || day == null) return false;
  if (month < 1 || month > 12 || day < 1 || day > 31) return false;
  final date = DateTime(year, month, day);
  return date.year == year && date.month == month && date.day == day;
}

/// شريط تنبيه لصيغة بحث غير صالحة (webapp: warning بشأن محددات البحث).
class _InvalidQueryBanner extends StatelessWidget {
  final String invalidValue;
  final VoidCallback onDismiss;

  const _InvalidQueryBanner({
    required this.invalidValue,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      padding: const EdgeInsets.fromLTRB(10, 8, 4, 8),
      decoration: BoxDecoration(
        color: theme.awayIndicator.withValues(alpha: 0.14),
        border: Border.all(
          color: theme.awayIndicator.withValues(alpha: 0.5),
        ),
        borderRadius: BorderRadius.circular(DesignTokens.radiusM),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            size: 16,
            color: theme.awayIndicator,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.interactive_dialogErrorBad_format,
                  style: TextStyle(
                    color: theme.centerChannelColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$invalidValue — ${l10n.search_invalidDateModifierHint}',
                  style: TextStyle(
                    color: theme.centerChannelColor.withValues(alpha: 0.7),
                    fontSize: 11.5,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.close,
              size: 16,
              color: theme.centerChannelColor.withValues(alpha: 0.5),
            ),
            tooltip: l10n.search_barClose,
            onPressed: onDismiss,
          ),
        ],
      ),
    );
  }
}

/// حالة البداية الفارغة للبحث (webapp NewSearch -> recent searches + hints):
/// سجل البحث الأخير والمحددات الممكنة (from:/in:/on:/before:/after:).
class _SearchInitialBody extends StatelessWidget {
  final List<String> recentSearches;
  final ValueChanged<String> onSelect;
  final VoidCallback onClearRecents;

  const _SearchInitialBody({
    required this.recentSearches,
    required this.onSelect,
    required this.onClearRecents,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);

    final hints = <(String, String)>[
      ('from:user', l10n.searchHintFrom),
      ('in:channel', l10n.searchHintIn),
      ('on:YYYY-MM-DD', l10n.searchHintOn),
      ('before:YYYY-MM-DD', l10n.searchHintBefore),
      ('after:YYYY-MM-DD', l10n.searchHintAfter),
      ('"exact phrase"', l10n.search_list_optionPhrases),
    ];

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        if (recentSearches.isNotEmpty) ...[
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.search_recentTitle,
                  style: TextStyle(
                    color: theme.centerChannelColor.withValues(alpha: 0.6),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
              InkWell(
                onTap: onClearRecents,
                borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text(
                    l10n.search_barClear,
                    style: TextStyle(
                      fontSize: 11,
                      color: theme.linkColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final term in recentSearches)
                _RecentSearchChip(label: term, onTap: () => onSelect(term)),
            ],
          ),
          const SizedBox(height: 24),
        ],
        Text(
          l10n.searchHintsTitle,
          style: TextStyle(
            color: theme.centerChannelColor.withValues(alpha: 0.6),
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 10),
        for (final (term, label) in hints)
          InkWell(
            onTap: () => onSelect(term),
            borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: theme.centerChannelColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(
                        DesignTokens.radiusSm,
                      ),
                    ),
                    child: Text(
                      term,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: theme.buttonBg,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.centerChannelColor.withValues(alpha: 0.75),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// شريحة سجل بحث قابلة للنقر.
class _RecentSearchChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _RecentSearchChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Tooltip(
      message: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(DesignTokens.radiusPill),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: theme.centerChannelColor.withValues(alpha: 0.06),
            border: Border.all(
              color: theme.centerChannelColor.withValues(alpha: 0.14),
            ),
            borderRadius: BorderRadius.circular(DesignTokens.radiusPill),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.history,
                size: 12,
                color: theme.centerChannelColor.withValues(alpha: 0.5),
              ),
              const SizedBox(width: 6),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 200),
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: theme.centerChannelColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// هيكل عظمي نابض أثناء جلب النتائج — مطابق skeleton loader في webapp.
class _SkeletonResults extends StatefulWidget {
  const _SkeletonResults();

  @override
  State<_SkeletonResults> createState() => _SkeletonResultsState();
}

class _SkeletonResultsState extends State<_SkeletonResults>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final alpha = 0.05 + (0.05 * _controller.value);
        final blockColor = theme.centerChannelColor.withValues(alpha: alpha);
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          physics: const NeverScrollableScrollPhysics(),
          children: [
            for (var i = 0; i < 6; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 18),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: blockColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 120 + (i % 3) * 40,
                            height: 12,
                            decoration: BoxDecoration(
                              color: blockColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            height: 11,
                            decoration: BoxDecoration(
                              color: blockColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            width: 180 + (i % 2) * 60,
                            height: 11,
                            decoration: BoxDecoration(
                              color: blockColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}
