import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/storage/secure_storage_service.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/design_tokens.dart';
import 'package:flutter_mattermost/features/chat/presentation/bloc/rhs_bloc.dart';
import 'package:flutter_mattermost/features/chat/presentation/bloc/threads_bloc.dart';
import 'package:flutter_mattermost/features/chat/presentation/widgets/thread_card.dart';
import 'package:flutter_mattermost/features/teams/presentation/bloc/team_bloc.dart';

/// صفحة المحادثات (Global Threads) — مطابقة global_threading.tsx:
/// رأس + تبويب الكل/غير المقروء + قائمة المحادثات،
/// والنقر على محادثة يفتحها في RHS ويحدد المسار /threads/:threadId.
class ThreadsPage extends StatefulWidget {
  final String? teamName;
  final String? threadId;

  const ThreadsPage({super.key, this.teamName, this.threadId});

  @override
  State<ThreadsPage> createState() => _ThreadsPageState();
}

class _ThreadsPageState extends State<ThreadsPage> {
  String? _userId;
  String? _teamId;
  String? _loadedTeamId;
  bool _unreadOnly = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _resolveContext();
  }

  Future<void> _resolveContext() async {
    final teamState = context.read<TeamBloc>().state;
    if (teamState is TeamsLoadedState && teamState.teams.isNotEmpty) {
      var team = widget.teamName != null
          ? teamState.teams.where((t) => t.name == widget.teamName).firstOrNull
          : null;
      team ??= teamState.selectedTeam;
      if (team != null) {
        _teamId = team.id;
      }
    }
    _userId ??= (await getIt<SecureStorageService>().getUserId()) ?? 'me';
    if (!context.mounted) return;
    if (_teamId != null && _loadedTeamId != _teamId) {
      _loadedTeamId = _teamId;
      context.read<ThreadsBloc>().add(
        LoadThreadsEvent(
          userId: _userId!,
          teamId: _teamId!,
          unreadOnly: _unreadOnly,
        ),
      );
    }
  }

  void _autoOpenThread() {
    final threadId = widget.threadId;
    if (threadId == null) return;
    final state = context.read<ThreadsBloc>().state;
    if (state is ThreadsLoadedState) {
      final match =
          state.threads.where((t) => t.rootPostId == threadId).firstOrNull;
      if (match != null) {
        context
            .read<RhsBloc>()
            .add(OpenThreadEvent(match.rootPostId, match.channelId));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);

    return BlocListener<ThreadsBloc, ThreadsState>(
      listener: (context, state) => _autoOpenThread(),
      child: BlocBuilder<ThreadsBloc, ThreadsState>(
        builder: (context, state) {
          return Column(
            children: [
              Container(
                height: 56,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: theme.centerChannelBg,
                  border: Border(
                    bottom: BorderSide(
                      color: theme.centerChannelColor.withValues(alpha: 0.1),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.forum_outlined,
                      size: 20,
                      color: theme.centerChannelColor.withValues(alpha: 0.7),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.globalThreadsSidebarLink,
                        style: TextStyle(
                          color: theme.centerChannelColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    _TabChip(
                      label: l10n.threadingFiltersAll,
                      selected: !_unreadOnly,
                      onTap: () => _setFilter(false),
                    ),
                    const SizedBox(width: 8),
                    _TabChip(
                      label: l10n.threadingFiltersUnreads,
                      selected: _unreadOnly,
                      onTap: () => _setFilter(true),
                    ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: _markAllRead,
                      icon: const Icon(Icons.done_all, size: 18),
                      label: Text(
                        l10n.mark_all_threads_as_read_modalConfirm,
                        style: const TextStyle(fontSize: 13),
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: theme.linkColor,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(child: _buildBody(context, state)),
            ],
          );
        },
      ),
    );
  }

  void _setFilter(bool unread) {
    setState(() => _unreadOnly = unread);
    final teamId = _teamId;
    if (teamId != null && _userId != null) {
      context.read<ThreadsBloc>().add(
        LoadThreadsEvent(
          userId: _userId!,
          teamId: teamId,
          unreadOnly: unread,
        ),
      );
    }
  }

  void _markAllRead() {
    final teamId = _teamId;
    final userId = _userId;
    if (teamId != null && userId != null) {
      context.read<ThreadsBloc>().add(
            MarkAllThreadsReadEvent(userId: userId, teamId: teamId),
          );
    }
  }

  Widget _buildBody(BuildContext context, ThreadsState state) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);

    if (state is ThreadsLoadingState) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state is ThreadsErrorState) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            state.message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: theme.centerChannelColor.withValues(alpha: 0.6),
              fontSize: 13,
            ),
          ),
        ),
      );
    }
    final threads = state is ThreadsLoadedState ? state.threads : const [];
    if (threads.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _unreadOnly
                    ? l10n.globalThreadsThreadListNoUnreadThreads
                    : l10n.globalThreadsNoThreadsTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: theme.centerChannelColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _unreadOnly
                    ? l10n.globalThreadsThreadListNoUnreadThreadsSubtitle
                    : l10n.globalThreadsNoThreadsSubtitle,
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
    return ListView(
      children: [
        for (final thread in threads)
          ThreadCard(
            thread: thread,
            myUserId: _userId ?? 'me',
            onTap: () {
              context.read<ThreadsBloc>().add(
                    MarkThreadReadEvent(
                      userId: _userId ?? 'me',
                      teamId: _teamId ?? '',
                      threadId: thread.rootPostId,
                    ),
                  );
              context
                  .read<RhsBloc>()
                  .add(OpenThreadEvent(thread.rootPostId, thread.channelId));
              final teamName = _teamName();
              context.go(
                teamName != null
                    ? '/$teamName/threads/${thread.rootPostId}'
                    : '/threads/${thread.rootPostId}',
              );
            },
            onChannelTap: () {
              final teamName = _teamName();
              // We need channel name to navigate properly
              // For now navigate to the thread and then to channel if we had channel name
              // Actually, ThreadEntity has channelName, but navigation usually needs channel ID or name.
              // In this app, it seems to use channel name in URL.
              // We'll navigate to channel screen if we had the name correctly.
              if (teamName != null) {
                context.go('/$teamName/channels/${thread.channelName}');
              }
            },
            onToggleFollow: () {
              if (thread.isFollowing) {
                context.read<ThreadsBloc>().add(
                      UnfollowThreadEvent(
                        userId: _userId ?? 'me',
                        teamId: _teamId ?? '',
                        threadId: thread.rootPostId,
                      ),
                    );
              } else {
                context.read<ThreadsBloc>().add(
                      FollowThreadEvent(
                        userId: _userId ?? 'me',
                        teamId: _teamId ?? '',
                        threadId: thread.rootPostId,
                      ),
                    );
              }
            },
          ),
      ],
    );
  }

  String? _teamName() {
    final teamState = context.read<TeamBloc>().state;
    if (teamState is TeamsLoadedState && teamState.teams.isNotEmpty) {
      for (final t in teamState.teams) {
        if (t.id == _teamId) return t.name;
      }
      return teamState.teams.first.name;
    }
    return null;
  }
}

class _TabChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TabChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(DesignTokens.radiusPill),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
        decoration: BoxDecoration(
          color: selected
              ? theme.centerChannelColor.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(DesignTokens.radiusPill),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected
                ? theme.centerChannelColor
                : theme.centerChannelColor.withValues(alpha: 0.6),
            fontSize: 13,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
