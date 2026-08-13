import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/enums/channel_bookmark_type.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_bookmark_entity.dart';
import 'package:flutter_mattermost/features/channels/domain/repositories/channel_repository.dart';
import 'package:flutter_mattermost/features/channels/presentation/bloc/channel_bloc.dart';

/// شريط الإشارات المرجعية للقناة — مطابق ChannelBookmarks.tsx في webapp:
/// شريط أفقي من الشرائح فوق قائمة الرسائل، كل شريحة رابط أو ملف للقناة،
/// يُخفى تلقائياً عندما لا توجد إشارات مرجعية.
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final channelState = context.watch<ChannelBloc>().state;
      final channel = channelState is ChannelsLoadedState
          ? channelState.selectedChannel
          : null;
      final channelId = channel?.id ?? '';

      if (channelId.isNotEmpty && channelId != _loadedChannelId) {
        _loadedChannelId = channelId;
        _loadBookmarks(channelId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
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
                  onTap: () => _openBookmark(bookmark),
                ),
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
        _bookmarks = bookmarks;
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

class _BookmarkChip extends StatelessWidget {
  final ChannelBookmarkEntity bookmark;
  final VoidCallback onTap;

  const _BookmarkChip({required this.bookmark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final isFile = bookmark.type == ChannelBookmarkType.file;
    return Tooltip(
      message: bookmark.displayName,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
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
              Text(
                bookmark.displayName.isEmpty
                    ? bookmark.linkUrl
                    : bookmark.displayName,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  color: theme.centerChannelColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
