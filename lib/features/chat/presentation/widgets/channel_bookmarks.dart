import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/enums/channel_bookmark_type.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/network/websocket_client.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_bookmark_entity.dart';
import 'package:flutter_mattermost/features/channels/domain/repositories/channel_repository.dart';
import 'package:flutter_mattermost/features/channels/presentation/bloc/channel_bloc.dart';
import 'package:flutter_mattermost/features/channels/presentation/widgets/add_channel_bookmark_dialog.dart';

/// شريط الإشارات المرجعية للقناة — مطابق ChannelBookmarks.tsx في webapp:
/// شريط أفقي من الشرائح فوق قائمة الرسائل، كل شريحة رابط أو ملف للقناة،
/// يُخفى تلقائياً عندما لا توجد إشارات مرجعية.
///
/// يقدّم أيضاً:
/// - زر `+` لإضافة إشارة مرجعية جديدة (عبر نافذة add_bookmark).
/// - قائمة سياقية على كل شريحة (فتح/نسخ الرابط/تعديل/حذف).
/// - تحديث لحظي عبر WebSocket (bookmark_added/edited/deleted/sorted).
class ChannelBookmarks extends StatefulWidget {
  const ChannelBookmarks({super.key});

  @override
  State<ChannelBookmarks> createState() => _ChannelBookmarksState();
}

class _ChannelBookmarksState extends State<ChannelBookmarks> {
  final _repository = getIt<ChannelRepository>();
  List<ChannelBookmarkEntity> _bookmarks = const [];
  String _loadedChannelId = '';
  bool _loading = false;
  String? errorMessage;
  StreamSubscription<TypedWebSocketEvent>? _wsSub;

  @override
  void initState() {
    super.initState();
    _listenToSocketEvents();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncWithChannel();
    });
  }

  @override
  void dispose() {
    _wsSub?.cancel();
    super.dispose();
  }

  /// ربط أحداث WebSocket الخاصة بالإشارات المرجعية — يحدّث القائمة محلياً
  /// دون إعادة جلب، مطابق للاستماع في webapp (bookmarkAdded/Edited/Deleted/Sorted).
  void _listenToSocketEvents() {
    final ws = getIt<WebSocketClientManager>();
    _wsSub = ws.eventStream.listen((event) {
      if (!mounted) return;
      final channelId = _loadedChannelId;
      if (channelId.isEmpty) return;
      if (event is BookmarkAddedEvent) {
        if (event.channelId != channelId) return;
        final exists = _bookmarks.any((b) => b.id == event.bookmark.id);
        if (!exists) {
          setState(() {
            _bookmarks = _sorted([..._bookmarks, event.bookmark]);
          });
        }
      } else if (event is BookmarkEditedEvent) {
        if (event.channelId != channelId) return;
        setState(() {
          _bookmarks = _sorted([
            for (final b in _bookmarks)
              if (b.id == event.bookmark.id) event.bookmark else b,
          ]);
        });
      } else if (event is BookmarkDeletedEvent) {
        if (event.channelId != channelId) return;
        setState(() {
          _bookmarks = _bookmarks
              .where((b) => b.id != event.bookmarkId)
              .toList();
        });
      } else if (event is BookmarkSortedEvent) {
        if (event.channelId != channelId) return;
        setState(() => _bookmarks = _sorted(event.bookmarks));
      }
    });
  }

  /// يجيب على تغيّر القناة المحددة (عند إعادة البناء).
  void _syncWithChannel() {
    final channelState = context.read<ChannelBloc>().state;
    final channel = channelState is ChannelsLoadedState
        ? channelState.selectedChannel
        : null;
    final channelId = channel?.id ?? '';
    if (channelId.isNotEmpty && channelId != _loadedChannelId) {
      _loadedChannelId = channelId;
      _loadBookmarks(channelId);
    }
  }

  List<ChannelBookmarkEntity> _sorted(List<ChannelBookmarkEntity> bookmarks) {
    final list = [...bookmarks]
      ..sort((a, b) {
        final byOrder = a.sortOrder.compareTo(b.sortOrder);
        if (byOrder != 0) return byOrder;
        return a.createAt.compareTo(b.createAt);
      });
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    _syncWithChannel();
    if (errorMessage != null) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Text(errorMessage!, style: TextStyle(fontSize: 17)),
      );
    }
    if (_bookmarks.isEmpty && !_loading) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 4),
      color: theme.centerChannelColor.withValues(alpha: 0.03),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            for (final bookmark in _bookmarks)
              Padding(
                padding: const EdgeInsets.only(left: 6),
                child: _BookmarkChip(
                  bookmark: bookmark,
                  onOpen: () => _openBookmark(bookmark),
                  onEdit: () => _editBookmark(bookmark),
                  onDelete: () => _deleteBookmark(bookmark),
                  onCopyLink: () => _copyBookmarkLink(bookmark),
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(left: 6),
              child: _AddBookmarkButton(onTap: _addBookmark),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loadBookmarks(String channelId) async {
    if (_loading) return;
    setState(() => _loading = true);
    try {
      final bookmarks = await _repository.getChannelBookmarks(channelId);
      if (!mounted) return;
      setState(() {
        _bookmarks = _sorted(bookmarks);
        _loading = false;
      });
    } catch (e) {
      errorMessage = e.toString();
      if (!mounted) return;
      setState(() {
        _bookmarks = const [];
        _loading = false;
      });
    }
  }

  Future<void> _addBookmark() async {
    final channelId = _loadedChannelId;
    if (channelId.isEmpty) return;
    final saved = await showAddChannelBookmarkDialog(
      context,
      channelId: channelId,
    );
    if (saved == null || !mounted) return;
    setState(() {
      _bookmarks = _sorted([..._bookmarks, saved]);
    });
  }

  Future<void> _editBookmark(ChannelBookmarkEntity bookmark) async {
    final saved = await showAddChannelBookmarkDialog(
      context,
      channelId: bookmark.channelId,
      existing: bookmark,
    );
    if (saved == null || !mounted) return;
    setState(() {
      _bookmarks = _sorted([
        for (final b in _bookmarks)
          if (b.id == saved.id) saved else b,
      ]);
    });
  }

  Future<void> _deleteBookmark(ChannelBookmarkEntity bookmark) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.channel_bookmarksConfirmDeleteTitle),
        content: Text(
          l10n.channel_bookmarksConfirmDeleteText(bookmark.displayName),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.postEditCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              l10n.channel_bookmarksConfirmDeleteButton,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    try {
      await _repository.deleteChannelBookmark(bookmark.channelId, bookmark.id);
      if (!mounted) return;
      setState(() {
        _bookmarks = _bookmarks.where((b) => b.id != bookmark.id).toList();
      });
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete bookmark')),
      );
    }
  }

  void _copyBookmarkLink(ChannelBookmarkEntity bookmark) {
    if (bookmark.type == ChannelBookmarkType.file || bookmark.linkUrl.isEmpty) {
      return;
    }
    Clipboard.setData(ClipboardData(text: bookmark.linkUrl));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).channel_bookmarksCopy),
        ),
      );
    }
  }

  void _openBookmark(ChannelBookmarkEntity bookmark) {
    if (bookmark.type == ChannelBookmarkType.file) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('الإشارة مرتبطة بملف (${bookmark.displayName})'),
        ),
      );
      return;
    }
    final uri = Uri.tryParse(bookmark.linkUrl);
    if (uri == null) return;
    unawaited(launchUrl(uri, mode: LaunchMode.externalApplication));
  }
}

/// زر `+` لإضافة إشارة مرجعية — مطابق زر الإضافة في نهاية شريط webapp.
class _AddBookmarkButton extends StatelessWidget {
  final VoidCallback onTap;

  const _AddBookmarkButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);
    return Tooltip(
      message: l10n.channel_bookmarksAddBookmark,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: theme.centerChannelColor.withValues(alpha: 0.18),
            ),
          ),
          child: Icon(
            Icons.add,
            size: 15,
            color: theme.centerChannelColor.withValues(alpha: 0.7),
          ),
        ),
      ),
    );
  }
}

class _BookmarkChip extends StatelessWidget {
  final ChannelBookmarkEntity bookmark;
  final VoidCallback onOpen;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onCopyLink;

  const _BookmarkChip({
    required this.bookmark,
    required this.onOpen,
    required this.onEdit,
    required this.onDelete,
    required this.onCopyLink,
  });

  Future<void> _showMenu(BuildContext context, Offset position) async {
    final l10n = AppLocalizations.of(context);
    final theme = AppTheme.of(context);
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final isFile = bookmark.type == ChannelBookmarkType.file;

    final selected = await showMenu<String>(
      context: context,
      position: RelativeRect.fromRect(
        position & const Size(1, 1),
        Offset.zero & overlay.size,
      ),
      items: [
        PopupMenuItem(
          value: 'open',
          child: Row(
            children: [
              const Icon(Icons.open_in_new, size: 18),
              const SizedBox(width: 8),
              Text(l10n.channel_bookmarksOpen),
            ],
          ),
        ),
        if (!isFile && bookmark.linkUrl.isNotEmpty)
          PopupMenuItem(
            value: 'copy',
            child: Row(
              children: [
                const Icon(Icons.copy, size: 18),
                const SizedBox(width: 8),
                Text(l10n.channel_bookmarksCopy),
              ],
            ),
          ),
        PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              const Icon(Icons.edit_outlined, size: 18),
              const SizedBox(width: 8),
              Text(l10n.channel_bookmarksEdit),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete_outline, size: 18, color: theme.errorTextColor),
              const SizedBox(width: 8),
              Text(
                l10n.channel_bookmarksDelete,
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      ],
    );

    if (!context.mounted) return;
    switch (selected) {
      case 'open':
        onOpen();
      case 'copy':
        onCopyLink();
      case 'edit':
        onEdit();
      case 'delete':
        onDelete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final isFile = bookmark.type == ChannelBookmarkType.file;

    return Tooltip(
      message: bookmark.displayName,
      child: Builder(
        builder: (chipContext) => GestureDetector(
          onTap: onOpen,
          onLongPress: () {
            final box = chipContext.findRenderObject() as RenderBox;
            final position = box.localToGlobal(Offset.zero);
            _showMenu(chipContext, position + Offset(0, box.size.height));
          },
          onSecondaryTapDown: (details) =>
              _showMenu(chipContext, details.globalPosition),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: theme.centerChannelColor.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: theme.centerChannelColor.withValues(alpha: 0.12),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isFile ? Icons.attach_file : Icons.link,
                  size: 13,
                  color: theme.centerChannelColor.withValues(alpha: 0.6),
                ),
                const SizedBox(width: 6),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 220),
                  child: Text(
                    bookmark.displayName.isEmpty
                        ? bookmark.linkUrl
                        : bookmark.displayName,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                      color: theme.centerChannelColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
