import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/network/server_manager.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/features/channels/presentation/widgets/add_channel_bookmark_dialog.dart';
import 'package:flutter_mattermost/features/chat/domain/entities/post_entity.dart';
import 'package:flutter_mattermost/features/chat/presentation/bloc/post_bloc.dart';
import 'package:flutter_mattermost/features/chat/presentation/bloc/rhs_bloc.dart';
import 'package:flutter_mattermost/features/chat/presentation/editor/message_editor.dart';
import 'package:flutter_mattermost/features/chat/presentation/widgets/custom_emoji.dart';
import 'package:flutter_mattermost/features/chat/presentation/widgets/emoji_picker_overlay.dart';

class PostActions extends StatelessWidget {
  final PostEntity post;
  final bool isSavedMessage;
  final bool isPinned;
  final bool isReply;
  final bool canDelete;
  final bool canEdit;
  final MenuController controller;

  const PostActions({
    super.key,
    required this.post,
    required this.isSavedMessage,
    required this.isPinned,
    required this.isReply,
    required this.canDelete,
    required this.canEdit,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);

    return Card(
      color: ColorScheme.of(context).surface,
      margin: .zero,
      shape: RoundedRectangleBorder(
        borderRadius: .circular(6),
        side: BorderSide(color: theme.buttonColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final emoji in const ['👍', '😀'])
              InkWell(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: emojiWidget(emoji, size: 20),
                ),
                onTap: () {
                  context.read<PostBloc>().add(
                    ToggleReactionEvent(post.id, emoji),
                  );
                },
              ),
            _ActionIcon(
              icon: Icons.check_box_rounded,
              tooltip: l10n.reactionAdd,
              color: Colors.green[700],
              iconSize: 20,
              onTap: (ctx) {
                EmojiPickerOverlay.show(
                  context,
                  anchorContext: ctx,
                  onEmojiSelected: (emoji) {
                    context.read<PostBloc>().add(
                      ToggleReactionEvent(post.id, emoji),
                    );
                  },
                );
              },
            ),
            _ActionIcon(
              icon: Icons.add_reaction_outlined,
              iconSize: 20,
              tooltip: l10n.reactionAdd,
              onTap: (ctx) {
                EmojiPickerOverlay.show(
                  context,
                  anchorContext: ctx,
                  onEmojiSelected: (emoji) {
                    context.read<PostBloc>().add(
                      ToggleReactionEvent(post.id, emoji),
                    );
                  },
                );
              },
            ),
            _ActionIcon(
              icon: isSavedMessage ? Icons.bookmark : Icons.bookmark_outline,
              iconSize: 20,
              tooltip: isSavedMessage ? l10n.postMenuUnflag : l10n.postMenuFlag,
              color: isSavedMessage ? theme.linkColor : null,
              onTap: (_) {
                context.read<PostBloc>().add(ToggleFlagPostEvent(post.id));
              },
            ),
            if (!isReply)
              _ActionIcon(
                icon: Icons.reply_outlined,
                tooltip: l10n.postMenuReply,
                iconSize: 20,
                onTap: (_) {
                  context.read<RhsBloc>().add(
                    OpenThreadEvent(post.id, post.channelId),
                  );
                },
              ),
            PopupMenuButton<String>(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Icon(
                  Icons.more_vert,
                  size: 18,
                ),
              ),
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: 'reply',

                  onTap: () {
                    context.read<RhsBloc>().add(
                      OpenThreadEvent(post.id, post.channelId),
                    );
                  },
                  child: Row(
                    spacing: 10,
                    children: [
                      const Icon(Icons.mode_comment_outlined, size: 18),
                      Text(l10n.postMenuReply),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'copy',
                  onTap: () =>
                      Clipboard.setData(ClipboardData(text: post.message)),

                  child: Row(
                    spacing: 10,
                    children: [
                      const Icon(Icons.copy, size: 18),
                      Text(l10n.postMenuCopy),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'copy link',
                  onTap: () {
                    final serverUrl = getIt<ServerManager>().activeServerUrl;
                    final link = '$serverUrl/_redirect/pl/${post.id}';
                    Clipboard.setData(ClipboardData(text: link));
                  },
                  child: Row(
                    spacing: 10,
                    children: [
                      const Icon(Icons.link, size: 18),
                      Text('Copy Link'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'bookmark',
                  child: Row(
                    children: [
                      const Icon(Icons.bookmark_add_outlined, size: 18),
                      Text(l10n.channel_bookmarksAddBookmark),
                    ],
                  ),
                  onTap: () => _addBookmark(context),
                ),
                PopupMenuItem(
                  child: Row(
                    children: [
                      Icon(
                        isSavedMessage ? Icons.flag : Icons.flag_outlined,
                        size: 18,
                      ),
                      Text(
                        isSavedMessage
                            ? l10n.postMenuUnflag
                            : l10n.postMenuFlag,
                      ),
                    ],
                  ),
                  onTap: () {
                    context.read<PostBloc>().add(ToggleFlagPostEvent(post.id));
                  },
                ),
                PopupMenuItem(
                  child: Row(
                    children: [
                      Icon(
                        isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                        size: 18,
                      ),
                      Text(isPinned ? l10n.postMenuUnpin : l10n.postMenuPin),
                    ],
                  ),
                  onTap: () {
                    context.read<PostBloc>().add(TogglePinPostEvent(post.id));
                  },
                ),
                if (canEdit)
                  PopupMenuItem(
                    child: Row(
                      children: [
                        const Icon(Icons.edit_outlined, size: 18),
                        Text(l10n.postMenuEdit),
                      ],
                    ),
                    onTap: () => _startComposerEdit(context),
                  ),
                if (canDelete)
                  PopupMenuItem(
                    child: Row(
                      children: [
                        const Icon(Icons.delete_outline, size: 18),
                        Text(
                          l10n.postMenuDelete,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                    onTap: () => _confirmDelete(context),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// إضافة المنشور الحالي كإشارة مرجعية في قناته — يفتح نافذة
  /// إضافة الإشارة معبّأة برابط المنشور (مطابق إضافة bookmark من
  /// قائمة خيارات المنشور في webapp).
  void _addBookmark(BuildContext context) {
    final serverUrl = getIt<ServerManager>().activeServerUrl;
    final link = '$serverUrl/_redirect/pl/${post.id}';
    showAddChannelBookmarkDialog(
      context,
      channelId: post.channelId,
      prefillLink: link,
    );
  }

  /// يدخل وضع التعديل في المحرر الرئيسي (مثل webapp)؛ وإن لم يتوفر محرر
  /// نشط يستخدم نافذة التعديل السريعة كبديل.
  void _startComposerEdit(BuildContext context) {
    final composer = MessageEditor.activeComposer;
    if (composer != null && !composer.isEditMode) {
      composer.beginEdit(post.id, post.message);
      composer.focusNode.requestFocus();
    } else {
      _showEditDialog(context);
    }
  }

  Future<void> _showEditDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final theme = AppTheme.of(context);
    final controller = TextEditingController(text: post.message);
    final newMessage = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.postEditTitle),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLines: 6,
          minLines: 2,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(color: theme.linkColor),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.postEditCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(controller.text),
            child: Text(l10n.postEditSave),
          ),
        ],
      ),
    );
    controller.dispose();
    final value = newMessage?.trim() ?? '';
    if (value.isNotEmpty && value != post.message && context.mounted) {
      context.read<PostBloc>().add(EditPostEvent(post.id, value));
    }
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.postDeleteConfirmTitle),
        content: Text(l10n.postDeleteConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.postDeleteConfirmCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.postDeleteConfirmOk),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      context.read<PostBloc>().add(DeletePostEvent(post.id));
    }
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final void Function(BuildContext context)? onTap;
  final Color? color;
  final double iconSize;

  const _ActionIcon({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.color,
    this.iconSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: () => onTap?.call(context),
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Icon(
            icon,
            size: iconSize,
            color: color ?? theme.centerChannelColor.withValues(alpha: 0.55),
          ),
        ),
      ),
    );
  }
}
