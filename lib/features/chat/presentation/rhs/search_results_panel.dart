import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
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
  String? _requestedTeamId;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(covariant SearchResultsPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchTerms != widget.searchTerms) {
      _performSearch();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _performSearch();
  }

  bool _started = false;

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return Column(
          children: [
            _SearchBar(
              initialTerms: widget.searchTerms,
              type: state is SearchLoadedState
                  ? state.type
                  : state is SearchLoadingState
                  ? state.type
                  : SearchResultType.messages,
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
      return const Center(child: CircularProgressIndicator());
    }
    if (state is! SearchLoadedState) {
      return _EmptyState(
        icon: Icons.search,
        title: l10n.search_headerSearch,
        subtitle: l10n.no_resultsSearchSubtitle,
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
      return _EmptyState(
        icon: Icons.search,
        title: l10n.search_headerSearch,
        subtitle: l10n.no_resultsSearchSubtitle,
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
          return _FileResultCard(file: state.files[index]);
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
      final day = _dayLabel(post.createAt);
      if (day != previousDay) {
        items.add(_DateSeparator(label: day));
        previousDay = day;
      }
      items.add(
        _PostResultItem(
          post: post,
          profile: profiles[post.userId],
          channelName: channels[post.channelId]?.displayName,
          onOpen: () => _openResultPost(context, post),
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

  /// فتح نتيجة منشور: تحديد القناة + تحميل المنشورات + تحديث الرابط
  /// + فتح الـ thread — مطابق click على search-item في webapp.
  void _openResultPost(BuildContext context, PostEntity post) {
    if (post.channelId.isEmpty) return;
    final channel = _resolvedChannel(post.channelId);
    if (channel == null) {
      _pendingChannelIds.add(post.channelId);
      _fetchChannel(post.channelId).then((_) {
        if (!mounted || !context.mounted) return;
        final fetched = _fetchedChannels[post.channelId];
        if (fetched != null) {
          _navigateToPost(context, post, fetched);
        }
      });
      return;
    }
    _navigateToPost(context, post, channel);
  }

  void _navigateToPost(
    BuildContext context,
    PostEntity post,
    ChannelEntity channel,
  ) {
    context.read<ChannelBloc>().add(SelectChannelEvent(channel));
    context.read<PostBloc>().add(LoadPostsForChannelEvent(channel.id));
    final teamState = context.read<TeamBloc>().state;
    final teamName = teamState is TeamsLoadedState
        ? teamState.selectedTeam?.name
        : null;
    if (teamName != null) {
      context.go('/$teamName/channels/${channel.name}');
    }
    context.read<RhsBloc>().add(OpenThreadEvent(post.id, post.channelId));
  }

  Map<String, UserEntity> _profilesById(BuildContext context) {
    final profileState = context.read<UserProfileBloc>().state;
    if (profileState is! UserProfileLoadedState) return const {};
    return {for (final p in profileState.profiles) p.id: p};
  }

  String _dayLabel(int timestampMs) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestampMs);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(date.year, date.month, date.day);
    final difference = today.difference(day).inDays;
    if (difference == 0) return 'Today';
    if (difference == 1) return 'Yesterday';
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
/// صورة + اسم/وقت + نص مع إبراز النتائج.
class _PostResultItem extends StatelessWidget {
  final PostEntity post;
  final UserEntity? profile;
  final String? channelName;
  final VoidCallback onOpen;

  const _PostResultItem({
    required this.post,
    required this.profile,
    required this.channelName,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final time = DateFormat(
      'h:mm a',
    ).format(DateTime.fromMillisecondsSinceEpoch(post.createAt));
    final displayName =
        profile?.firstName != null && profile!.firstName.isNotEmpty
        ? '${profile!.firstName} ${profile!.lastName}'.trim()
        : profile?.username ?? '@unknown';
    final statusColor = theme.centerChannelColor.withValues(alpha: 0.3);

    return InkWell(
      onTap: onOpen,
      hoverColor: theme.centerChannelColor.withValues(alpha: 0.04),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: ProfilePicture.md(
                username: profile?.username ?? '?',
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
                      if (channelName != null) ...[
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            channelName!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: statusColor, fontSize: 11),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    post.message,
                    style: TextStyle(
                      color: theme.centerChannelColor,
                      fontSize: 13,
                      height: 1.4,
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

/// بطاقة ملف في النتائج — مطابقة file_search_result_item.scss:
/// max-width 600، padding 11، border 0.16، radius 4، hover shadow.
class _FileResultCard extends StatelessWidget {
  final FileInfoEntity file;

  const _FileResultCard({required this.file});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final sizeLabel = _formatSize(file.size);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(
          border: Border.all(
            color: theme.centerChannelColor.withValues(alpha: 0.16),
          ),
          borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
        ),
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
                _fileIcon(file.extension),
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
                    file.name,
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
          ],
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
/// عند الضغط Enter أو زر البحث تُحدَّث مصطلحات البحث في RHS فيُعاد التنفيذ.
class _SearchBar extends StatefulWidget {
  final String initialTerms;
  final SearchResultType type;

  const _SearchBar({required this.initialTerms, required this.type});

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initialTerms,
  );
  final FocusNode _focusNode = FocusNode();
  bool _showHints = false;

  @override
  void didUpdateWidget(covariant _SearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialTerms != widget.initialTerms &&
        widget.initialTerms != _controller.text) {
      _controller.text = widget.initialTerms;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submit() {
    final terms = _controller.text.trim();
    final bloc = context.read<SearchBloc>();
    if (terms.isEmpty) {
      bloc.add(ClearSearchEvent());
    }
    context.read<RhsBloc>().add(UpdateRhsSearchTermsEvent(terms));
    context.read<RhsBloc>().add(ShowSearchResultsEvent(terms));
    _focusNode.unfocus();
  }

  void _insertTerm(String term) {
    final current = _controller.text;
    setState(() {
      _controller.text = current.trim().isEmpty
          ? term
          : '${current.trimRight()} $term';
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
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
                  controller: _controller,
                  focusNode: _focusNode,
                  onSubmitted: (_) => _submit(),
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
