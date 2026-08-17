import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/network/server_manager.dart';
import 'package:flutter_mattermost/core/network/websocket_client.dart';
import 'package:flutter_mattermost/core/storage/secure_storage_service.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/design_tokens.dart';
import 'package:flutter_mattermost/core/utils/mention_utils.dart';
import 'package:flutter_mattermost/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_mattermost/features/chat/domain/entities/thread_entity.dart';
import 'package:flutter_mattermost/features/chat/presentation/bloc/rhs_bloc.dart';
import 'package:flutter_mattermost/features/chat/presentation/bloc/threads_bloc.dart';
import 'package:flutter_mattermost/features/chat/presentation/widgets/move_thread_modal.dart';
import 'package:flutter_mattermost/features/chat/presentation/widgets/thread_card.dart';
import 'package:flutter_mattermost/features/teams/presentation/bloc/team_bloc.dart';
import 'package:flutter_mattermost/features/users/presentation/bloc/user_profile_bloc.dart';

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
  StreamSubscription<TypedWebSocketEvent>? _socketSub;

  @override
  void initState() {
    super.initState();
    _listenToSocketEvents();
  }

  /// ربط أحداث WebSocket الخاصة بالمحادثات (thread_follow_changed /
  /// thread_read_changed) بشجرة البلوك لتحديث القائمة دون إعادة تحميل.
  void _listenToSocketEvents() {
    final ws = getIt<WebSocketClientManager>();
    _socketSub = ws.eventStream.listen((event) {
      if (!mounted) return;
      final teamId = _teamId;
      if (teamId == null) return;
      if (event is ThreadFollowChangedEvent) {
        if (event.teamId == teamId) {
          context.read<ThreadsBloc>().add(
            ThreadFollowChangedSocketEvent(
              teamId: event.teamId,
              threadId: event.threadId,
              following: event.following,
            ),
          );
        }
      } else if (event is ThreadReadChangedEvent) {
        if (event.teamId == teamId) {
          context.read<ThreadsBloc>().add(
            ThreadReadChangedSocketEvent(
              teamId: event.teamId,
              threadId: event.threadId,
              lastViewedAt: event.timestamp,
              unreadMentions: event.unreadMentions,
              unreadReplies: event.unreadReplies,
            ),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _socketSub?.cancel();
    super.dispose();
  }

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
    if (!mounted) return;
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

  /// جلب بروفايلات مؤلفي الرسائل الجذرية لعرض الأسماء بدلاً من المعرّفات.
  void _loadRootPostProfiles(ThreadsLoadedState state) {
    final ids = state.threads
        .map((t) => t.rootPost.userId)
        .where((id) => id.isNotEmpty)
        .toSet()
        .toList();
    if (ids.isNotEmpty) {
      context.read<UserProfileBloc>().add(LoadProfilesByIdsEvent(ids));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);

    return BlocListener<ThreadsBloc, ThreadsState>(
      listener: (context, state) {
        _autoOpenThread();
        if (state is ThreadsLoadedState) _loadRootPostProfiles(state);
      },
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
    final profiles = _profilesById();
    return ListView.builder(
      itemCount: threads.length,
      itemBuilder: (context, index) {
        final thread = threads[index];
        return ThreadCard(
          thread: thread,
          myUserId: _userId ?? 'me',
          rootPostUsername: _displayNameFor(profiles, thread.rootPost.userId),
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
          onMarkUnread: () {
            context.read<ThreadsBloc>().add(
                  SetThreadUnreadEvent(
                    userId: _userId ?? 'me',
                    teamId: _teamId ?? '',
                    threadId: thread.rootPostId,
                  ),
                );
          },
          onCopyLink: () => _copyThreadLink(thread.rootPostId),
          onToggleSave: () {
            context.read<ThreadsBloc>().add(
                  ToggleSaveEvent(
                    teamId: _teamId ?? '',
                    threadId: thread.rootPostId,
                    isCurrentlySaved: thread.rootPost.isSaved,
                  ),
                );
          },
          onMoveThread: _canMoveThread
              ? () => _openMoveThreadModal(thread)
              : null,
        );
      },
    );
  }

  bool get _canMoveThread {
    // webapp يقيّد نقل المحادثات بالمشرفين/مدراء القنوات (move_threads permission).
    final profileState = context.read<UserProfileBloc>().state;
    if (profileState is UserProfileLoadedState) {
      for (final p in profileState.profiles) {
        if (p.id == _userId) return p.roles.contains('admin');
      }
    }
    return false;
  }

  void _openMoveThreadModal(ThreadEntity thread) {
    showMoveThreadModal(
      context,
      threadId: thread.rootPostId,
      currentChannelId: thread.channelId,
      onMove: (channelId, channelName) {
        context.read<ThreadsBloc>().add(
              MoveThreadEvent(
                userId: _userId ?? 'me',
                teamId: _teamId ?? '',
                threadId: thread.rootPostId,
                channelId: channelId,
                channelName: channelName,
              ),
            );
      },
    );
  }

  void _copyThreadLink(String postId) {
    final teamName = _teamName();
    final serverUrl = getIt<ServerManager>().activeServerUrl;
    final link = '$serverUrl/$teamName/pl/$postId';
    Clipboard.setData(ClipboardData(text: link));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).threadingThreadMenuLinkCopied),
        ),
      );
    }
  }

  Map<String, UserEntity> _profilesById() {
    final profileState = context.read<UserProfileBloc>().state;
    if (profileState is! UserProfileLoadedState) return const {};
    return {for (final p in profileState.profiles) p.id: p};
  }

  String? _displayNameFor(Map<String, UserEntity> profiles, String userId) {
    final profile = profiles[userId];
    if (profile == null) return null;
    return getMentionDisplayName(
      username: profile.username,
      nickname: profile.nickname,
      firstName: profile.firstName,
      lastName: profile.lastName,
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
