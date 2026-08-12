import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/storage/secure_storage_service.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/design_tokens.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:flutter_mattermost/features/channels/presentation/bloc/channel_bloc.dart';
import 'package:flutter_mattermost/features/chat/data/models/draft_model.dart';
import 'package:flutter_mattermost/features/chat/data/models/scheduled_post_model.dart';
import 'package:flutter_mattermost/features/chat/domain/repositories/drafts_repository.dart';
import 'package:flutter_mattermost/features/chat/domain/repositories/post_repository.dart';
import 'package:flutter_mattermost/features/chat/domain/repositories/scheduled_posts_repository.dart';
import 'package:intl/intl.dart';

/// صفحة المسودات والرسائل المجدولة — مطابقة لـ Drafts / Scheduled Posts في webapp
/// تبويبات: المسودات / المجدولة (القادمة) / سجل الإرسال (الماضية).
class DraftsPage extends StatefulWidget {
  final String? teamId;
  final int initialTab;

  const DraftsPage({super.key, this.teamId, this.initialTab = 0});

  @override
  State<DraftsPage> createState() => _DraftsPageState();
}

class _DraftsPageState extends State<DraftsPage> {
  late int _selectedTab;
  Future<List<ScheduledPostModel>>? _scheduledFuture;
  Future<List<DraftModel>>? _draftsFuture;

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.initialTab;
    _reloadScheduled();
    _reloadDrafts();
  }

  Future<String> _currentUserId() async =>
      (await getIt<SecureStorageService>().getUserId()) ?? 'me';

  void _reloadScheduled() {
    if (getIt.isRegistered<ScheduledPostsRepository>()) {
      setState(() {
        _scheduledFuture = getIt<ScheduledPostsRepository>().getScheduledPosts(
          widget.teamId ?? '',
        );
      });
    }
  }

  void _reloadDrafts() {
    if (!getIt.isRegistered<DraftsRepository>()) return;
    _currentUserId().then((userId) {
      if (!mounted) return;
      setState(() {
        _draftsFuture = getIt<DraftsRepository>().getDraftsForTeam(
          userId,
          widget.teamId ?? '',
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: theme.centerChannelBg,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Bar (56px)
          Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: theme.centerChannelBg,
              border: Border(
                bottom: BorderSide(
                  color: theme.centerChannelColor.withValues(alpha: 0.12),
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.drafts_outlined,
                  size: 20,
                  color: theme.centerChannelColor,
                ),
                const SizedBox(width: 12),
                Text(
                  l10n.draftsHeading,
                  style: TextStyle(
                    color: theme.centerChannelColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                // Tabs
                Row(
                  children: [
                    _DraftTabButton(
                      label: l10n.draftsHeading,
                      badgeCount: 0,
                      active: _selectedTab == 0,
                      onTap: () {
                        setState(() => _selectedTab = 0);
                        final teamName = widget.teamId;
                        if (teamName != null && teamName.isNotEmpty) {
                          context.go('/$teamName/drafts');
                        }
                      },
                    ),
                    const SizedBox(width: 8),
                    _DraftTabButton(
                      label: l10n.scheduledPostsTabScheduled,
                      badgeCount: 0,
                      active: _selectedTab == 1,
                      onTap: () {
                        setState(() => _selectedTab = 1);
                        final teamName = widget.teamId;
                        if (teamName != null && teamName.isNotEmpty) {
                          context.go('/$teamName/scheduled_posts');
                        }
                      },
                    ),
                    const SizedBox(width: 8),
                    _DraftTabButton(
                      label: l10n.scheduledPostsTabSendHistory,
                      badgeCount: 0,
                      active: _selectedTab == 2,
                      onTap: () => setState(() => _selectedTab = 2),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Content area
          Expanded(
            child: _selectedTab == 0
                ? _buildDraftsList(theme, l10n)
                : _buildScheduledList(theme, l10n, history: _selectedTab == 2),
          ),
        ],
      ),
    );
  }

  Widget _buildDraftsList(MattermostColors theme, AppLocalizations l10n) {
    return FutureBuilder<List<DraftModel>>(
      future: _draftsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(color: theme.buttonBg),
          );
        }
        final drafts = snapshot.data ?? [];
        if (drafts.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.drafts_outlined,
                  size: 64,
                  color: theme.centerChannelColor.withValues(alpha: 0.32),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.draftsEmptyTitle,
                  style: TextStyle(
                    color: theme.centerChannelColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.draftsEmptySubtitle,
                  style: TextStyle(
                    color: theme.centerChannelColor.withValues(alpha: 0.6),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: drafts.length,
          itemBuilder: (context, index) {
            final draft = drafts[index];
            return _DraftPanel(
              draft: draft,
              onSendNow: () async {
                final userId = await _currentUserId();
                if (getIt.isRegistered<PostRepository>()) {
                  await getIt<PostRepository>().sendPost(
                    draft.channelId,
                    draft.message,
                    rootId: draft.rootId,
                  );
                }
                await getIt<DraftsRepository>().deleteDraft(
                  userId,
                  draft.channelId,
                  rootId: draft.rootId,
                );
                _reloadDrafts();
              },
              onDelete: () async {
                final userId = await _currentUserId();
                await getIt<DraftsRepository>().deleteDraft(
                  userId,
                  draft.channelId,
                  rootId: draft.rootId,
                );
                _reloadDrafts();
              },
            );
          },
        );
      },
    );
  }

  Widget _buildScheduledList(
    MattermostColors theme,
    AppLocalizations l10n, {
    required bool history,
  }) {
    if (_scheduledFuture == null) {
      return _buildScheduledEmpty(theme, l10n, history: history);
    }

    return FutureBuilder<List<ScheduledPostModel>>(
      future: _scheduledFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(color: theme.buttonBg),
          );
        }

        final all = snapshot.data ?? [];
        final now = DateTime.now().millisecondsSinceEpoch;
        final posts = history
            ? (all
                  .where(
                    (p) =>
                        (p.scheduledAt ?? 0) > 0 && (p.scheduledAt ?? 0) <= now,
                  )
                  .toList()
                ..sort(
                  (a, b) => (b.scheduledAt ?? 0).compareTo(a.scheduledAt ?? 0),
                ))
            : (all
                  .where(
                    (p) =>
                        (p.scheduledAt ?? 0) > now || (p.scheduledAt ?? 0) == 0,
                  )
                  .toList()
                ..sort(
                  (a, b) => (a.scheduledAt ?? 0).compareTo(b.scheduledAt ?? 0),
                ));
        if (posts.isEmpty) {
          return _buildScheduledEmpty(theme, l10n, history: history);
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            return _ScheduledPostPanel(
              post: post,
              isHistory: history,
              onSendNow: () async {
                if (getIt.isRegistered<PostRepository>()) {
                  await getIt<PostRepository>().sendPost(
                    post.channelId ?? '',
                    post.message ?? '',
                    rootId: post.rootId,
                    fileIds: post.fileIds ?? const [],
                  );
                }
                if (post.id != null &&
                    getIt.isRegistered<ScheduledPostsRepository>()) {
                  await getIt<ScheduledPostsRepository>().deleteScheduledPost(
                    post.id!,
                  );
                }
                _reloadScheduled();
              },
              onEdit: () async {
                final id = post.id;
                if (id == null) return;
                final controller = TextEditingController(text: post.message);
                final newMessage = await showDialog<String>(
                  context: context,
                  builder: (dialogContext) => AlertDialog(
                    title: Text(l10n.scheduledPostsEditTitle),
                    content: TextField(
                      controller: controller,
                      maxLines: 4,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: l10n.scheduledPostsEditHint,
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        child: Text(l10n.scheduledPostsCancel),
                      ),
                      FilledButton(
                        onPressed: () =>
                            Navigator.of(dialogContext).pop(controller.text),
                        child: Text(l10n.scheduledPostsSave),
                      ),
                    ],
                  ),
                );
                if (newMessage == null || newMessage == post.message) return;
                await getIt<ScheduledPostsRepository>().editScheduledPost(
                  id,
                  message: newMessage,
                );
                _reloadScheduled();
              },
              onDelete: () async {
                if (post.id != null &&
                    getIt.isRegistered<ScheduledPostsRepository>()) {
                  await getIt<ScheduledPostsRepository>().deleteScheduledPost(
                    post.id!,
                  );
                }
                _reloadScheduled();
              },
            );
          },
        );
      },
    );
  }

  Widget _buildScheduledEmpty(
    MattermostColors theme,
    AppLocalizations l10n, {
    required bool history,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.schedule_send_outlined,
              size: 64,
              color: theme.centerChannelColor.withValues(alpha: 0.32),
            ),
            const SizedBox(height: 16),
            Text(
              history
                  ? l10n.scheduledPostsEmptyHistoryTitle
                  : l10n.scheduledPostsEmptyScheduledTitle,
              style: TextStyle(
                color: theme.centerChannelColor,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Text(
                history
                    ? l10n.scheduledPostsEmptyHistorySubtitle
                    : l10n.scheduledPostsEmptyScheduledSubtitle,
                style: TextStyle(
                  color: theme.centerChannelColor.withValues(alpha: 0.6),
                  fontSize: 14,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DraftTabButton extends StatelessWidget {
  final String label;
  final int badgeCount;
  final bool active;
  final VoidCallback onTap;

  const _DraftTabButton({
    required this.label,
    required this.badgeCount,
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: active
              ? theme.buttonBg.withValues(alpha: 0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: active ? theme.buttonBg : theme.centerChannelColor,
                fontWeight: active ? FontWeight.w600 : FontWeight.normal,
                fontSize: 13,
              ),
            ),
            if (badgeCount > 0) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: active
                      ? theme.buttonBg
                      : theme.centerChannelColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$badgeCount',
                  style: TextStyle(
                    color: active
                        ? theme.buttonColor
                        : theme.centerChannelColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
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

class _ScheduledPostPanel extends StatefulWidget {
  final ScheduledPostModel post;
  final bool isHistory;
  final VoidCallback onSendNow;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ScheduledPostPanel({
    required this.post,
    required this.isHistory,
    required this.onSendNow,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<_ScheduledPostPanel> createState() => _ScheduledPostPanelState();
}

class _ScheduledPostPanelState extends State<_ScheduledPostPanel> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);

    final scheduledAt = widget.post.scheduledAt != null
        ? DateTime.fromMillisecondsSinceEpoch(widget.post.scheduledAt!)
        : DateTime.now();
    final timeFormatted = DateFormat.yMMMd().add_jm().format(scheduledAt);

    String channelName = widget.post.channelId ?? '';
    final channelState = context.read<ChannelBloc>().state;
    if (channelState is ChannelsLoadedState) {
      for (final ch in channelState.channels) {
        if (ch.id == widget.post.channelId) {
          channelName = ch.displayName;
          break;
        }
      }
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: theme.centerChannelBg,
          borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
          border: Border.all(
            color: theme.centerChannelColor.withValues(alpha: 0.16),
          ),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: theme.centerChannelColor.withValues(alpha: 0.08),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.tag,
                  size: 16,
                  color: theme.centerChannelColor.withValues(alpha: 0.6),
                ),
                const SizedBox(width: 4),
                Text(
                  channelName,
                  style: TextStyle(
                    color: theme.centerChannelColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                Text(
                  timeFormatted,
                  style: TextStyle(
                    color: theme.centerChannelColor.withValues(alpha: 0.6),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 12),
                // Action buttons 28x28px
                if (widget.isHistory)
                  _ActionButton(
                    icon: Icons.delete_outline,
                    tooltip: l10n.scheduledPostsDelete,
                    onTap: widget.onDelete,
                  )
                else ...[
                  _ActionButton(
                    icon: Icons.edit_outlined,
                    tooltip: l10n.scheduledPostsEdit,
                    onTap: widget.onEdit,
                  ),
                  const SizedBox(width: 4),
                  _ActionButton(
                    icon: Icons.send_outlined,
                    tooltip: l10n.draftsConfirmSendButton,
                    onTap: widget.onSendNow,
                  ),
                  const SizedBox(width: 4),
                  _ActionButton(
                    icon: Icons.delete_outline,
                    tooltip: l10n.draftsActionsDelete,
                    onTap: widget.onDelete,
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),
            Text(
              widget.post.message ?? '',
              style: TextStyle(color: theme.centerChannelColor, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

class _DraftPanel extends StatefulWidget {
  final DraftModel draft;
  final VoidCallback onSendNow;
  final VoidCallback onDelete;

  const _DraftPanel({
    required this.draft,
    required this.onSendNow,
    required this.onDelete,
  });

  @override
  State<_DraftPanel> createState() => _DraftPanelState();
}

class _DraftPanelState extends State<_DraftPanel> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);

    final updatedAt = widget.draft.updateAt > 0
        ? DateTime.fromMillisecondsSinceEpoch(widget.draft.updateAt)
        : DateTime.fromMillisecondsSinceEpoch(widget.draft.createAt);
    final timeFormatted = DateFormat.yMMMd().add_jm().format(updatedAt);

    String channelName = widget.draft.channelId;
    final channelState = context.read<ChannelBloc>().state;
    if (channelState is ChannelsLoadedState) {
      for (final ch in channelState.channels) {
        if (ch.id == widget.draft.channelId) {
          channelName = ch.displayName;
          break;
        }
      }
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: theme.centerChannelBg,
          borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
          border: Border.all(
            color: theme.centerChannelColor.withValues(alpha: 0.16),
          ),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: theme.centerChannelColor.withValues(alpha: 0.08),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.tag,
                  size: 16,
                  color: theme.centerChannelColor.withValues(alpha: 0.6),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    channelName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: theme.centerChannelColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
                Text(
                  timeFormatted,
                  style: TextStyle(
                    color: theme.centerChannelColor.withValues(alpha: 0.6),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 12),
                // Action buttons 28x28px
                _ActionButton(
                  icon: Icons.send_outlined,
                  tooltip: l10n.draftsConfirmSendButton,
                  onTap: widget.onSendNow,
                ),
                const SizedBox(width: 4),
                _ActionButton(
                  icon: Icons.delete_outline,
                  tooltip: l10n.draftsActionsDelete,
                  onTap: widget.onDelete,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              widget.draft.message,
              style: TextStyle(color: theme.centerChannelColor, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  const _ActionButton({
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
        borderRadius: BorderRadius.circular(4),
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: theme.centerChannelColor.withValues(alpha: 0.12),
            ),
          ),
          child: Icon(
            icon,
            size: 16,
            color: theme.centerChannelColor.withValues(alpha: 0.72),
          ),
        ),
      ),
    );
  }
}
