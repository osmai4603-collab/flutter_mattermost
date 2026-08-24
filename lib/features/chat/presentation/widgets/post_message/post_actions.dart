import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/network/server_manager.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/widgets/hover_widget.dart';
import 'package:flutter_mattermost/core/widgets/matter_menu.dart';
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
          spacing: 2,
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final emoji in const ['👍', '✅', '😀'])
              InkWell(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: emojiWidget(emoji, size: 17),
                ),
                onTap: () {
                  context.read<PostBloc>().add(
                    ToggleReactionEvent(post.id, emoji),
                  );
                },
              ),
            _ActionIcon(
              icon: Icons.add_reaction_outlined,
              iconSize: 17,
              tooltip: l10n.reactionAdd,
              onTap: (ctx) {
                EmojiPickerOverlay.show(
                  context,
                  anchorContext: ctx,
                  multiSelected: false,
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
              iconSize: 17,
              tooltip: isSavedMessage ? l10n.postMenuUnflag : l10n.postMenuFlag,
              color: isSavedMessage ? theme.linkColor : null,
              onTap: (_) {
                context.read<PostBloc>().add(ToggleFlagPostEvent(post.id));
              },
            ),
            _ActionIcon(
              icon: Icons.grid_view_outlined,
              iconSize: 17,
              tooltip: 'More actions',
              color: null,
              onTap: (_) {
                // context.read<PostBloc>().add(ToggleFlagPostEvent(post.id));
              },
            ),
            if (!isReply)
              _ActionIcon(
                icon: Icons.reply_outlined,
                tooltip: l10n.postMenuReply,
                iconSize: 17,
                onTap: (_) {
                  context.read<RhsBloc>().add(
                    OpenThreadEvent(post.id, post.channelId),
                  );
                },
              ),
            MatterMenu(
              controller: controller,
              // offest: Offset.fromDirection(-20),
              items: [
                MatterMenuItem(
                  id: 'reply',
                  label: '',
                  icon: SizedBox(
                    width: 220,
                    child: Row(
                      spacing: 10,
                      children: [
                        const Icon(Icons.reply_outlined, size: 20),
                        Text(l10n.postMenuReply),
                        Expanded(
                          child: Align(
                            alignment: .centerEnd,
                            child: Padding(
                              padding: .symmetric(horizontal: 0),
                              child: Text('R', style: TextStyle(fontSize: 12)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    context.read<RhsBloc>().add(
                      OpenThreadEvent(post.id, post.channelId),
                    );
                  },
                ),
                MatterMenuItem(
                  id: 'forward',
                  label: '',
                  icon: SizedBox(
                    width: 220,
                    child: Row(
                      spacing: 10,
                      children: [
                        Icon(
                          Icons.forward_outlined,
                          size: 20,
                          color: theme.centerChannelColor.withValues(
                            alpha: 0.65,
                          ),
                        ),
                        Text('Forward', style: TextStyle(fontSize: 14)),
                        Expanded(
                          child: Align(
                            alignment: .centerEnd,
                            child: Padding(
                              padding: .symmetric(horizontal: 0),
                              child: Text(
                                'Shift + F',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    context.read<RhsBloc>().add(
                      OpenThreadEvent(post.id, post.channelId),
                    );
                  },
                ),
                MatterMenuItem(
                  id: 'follow_thread',
                  label: '',
                  icon: SizedBox(
                    width: 220,
                    child: Row(
                      spacing: 10,
                      children: [
                        Icon(
                          Icons.message_outlined,
                          size: 20,
                          color: theme.centerChannelColor.withValues(
                            alpha: 0.65,
                          ),
                        ),
                        Text('Follow Thread', style: TextStyle(fontSize: 14)),
                        Expanded(
                          child: Align(
                            alignment: .centerEnd,
                            child: Padding(
                              padding: .symmetric(horizontal: 0),
                              child: Text('F', style: TextStyle(fontSize: 12)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    context.read<RhsBloc>().add(
                      OpenThreadEvent(post.id, post.channelId),
                    );
                  },
                ),
                MatterMenuItem(
                  id: 'mark_unread',
                  label: '',
                  icon: SizedBox(
                    width: 220,
                    child: Row(
                      spacing: 10,
                      children: [
                        Icon(
                          Icons.menu_outlined,
                          size: 20,
                          color: theme.centerChannelColor.withValues(
                            alpha: 0.65,
                          ),
                        ),
                        Text('Mark as Unread', style: TextStyle(fontSize: 14)),
                        Expanded(
                          child: Align(
                            alignment: .centerEnd,
                            child: Padding(
                              padding: .symmetric(horizontal: 0),
                              child: Text('U', style: TextStyle(fontSize: 12)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    context.read<RhsBloc>().add(
                      OpenThreadEvent(post.id, post.channelId),
                    );
                  },
                ),
                MatterMenuItem(
                  id: 'save_message',
                  label: '',
                  icon: SizedBox(
                    width: 220,
                    child: Row(
                      spacing: 10,
                      children: [
                        Icon(
                          Icons.bookmark_outline,
                          size: 20,
                          color: theme.centerChannelColor.withValues(
                            alpha: 0.65,
                          ),
                        ),
                        Text('Save Message', style: TextStyle(fontSize: 14)),
                        Expanded(
                          child: Align(
                            alignment: .centerEnd,
                            child: Padding(
                              padding: .symmetric(horizontal: 0),
                              child: Text('S', style: TextStyle(fontSize: 12)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    context.read<RhsBloc>().add(
                      OpenThreadEvent(post.id, post.channelId),
                    );
                  },
                ),
                MatterMenuItem(
                  id: 'pin_to_channel',
                  label: '',
                  icon: SizedBox(
                    width: 220,
                    child: Row(
                      spacing: 10,
                      children: [
                        Icon(
                          Icons.pin_end_outlined,
                          size: 20,
                          color: theme.centerChannelColor.withValues(
                            alpha: 0.65,
                          ),
                        ),
                        Text('Pin to Channel', style: TextStyle(fontSize: 14)),
                        Expanded(
                          child: Align(
                            alignment: .centerEnd,
                            child: Padding(
                              padding: .symmetric(horizontal: 0),
                              child: Text('P', style: TextStyle(fontSize: 12)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    context.read<RhsBloc>().add(
                      OpenThreadEvent(post.id, post.channelId),
                    );
                  },
                ),
                MatterMenuItem.divider(),
                MatterMenuItem(
                  id: 'copy',
                  label: '',
                  icon: SizedBox(
                    width: 220,
                    child: Row(
                      spacing: 10,
                      children: [
                        const Icon(Icons.copy, size: 16),
                        Text('Copy Text', style: TextStyle(fontSize: 14)),
                        Expanded(
                          child: Align(
                            alignment: .centerEnd,
                            child: Padding(
                              padding: .symmetric(horizontal: 0),
                              child: Text('C', style: TextStyle(fontSize: 12)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () =>
                      Clipboard.setData(ClipboardData(text: post.message)),
                ),
                MatterMenuItem(
                  id: 'copy_link',
                  label: '',
                  icon: SizedBox(
                    width: 220,
                    child: Row(
                      spacing: 10,
                      children: [
                        const Icon(Icons.link_outlined, size: 16),
                        Text('Copy Link', style: TextStyle(fontSize: 14)),
                        Expanded(
                          child: Align(
                            alignment: .centerEnd,
                            child: Padding(
                              padding: .symmetric(horizontal: 0),
                              child: Text('K', style: TextStyle(fontSize: 12)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    final serverUrl = getIt<ServerManager>().activeServerUrl;
                    final link = '$serverUrl/_redirect/pl/${post.id}';
                    Clipboard.setData(ClipboardData(text: link));
                  },
                ),
                MatterMenuItem.divider(),
                MatterMenuItem(
                  id: 'edit',
                  label: '',
                  icon: SizedBox(
                    width: 220,
                    child: Row(
                      spacing: 10,
                      children: [
                        const Icon(Icons.edit_outlined, size: 16),
                        Text('Edit', style: TextStyle(fontSize: 14)),
                        Expanded(
                          child: Align(
                            alignment: .centerEnd,
                            child: Padding(
                              padding: .symmetric(horizontal: 0),
                              child: Text('E', style: TextStyle(fontSize: 12)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () => _startComposerEdit(context),
                ),
                MatterMenuItem(
                  id: 'delete',
                  label: '',
                  icon: SizedBox(
                    width: 220,
                    child: Row(
                      spacing: 10,
                      children: [
                        const Icon(Icons.delete_outline, size: 16),
                        Text('Delete', style: TextStyle(fontSize: 14)),
                        Expanded(
                          child: Align(
                            alignment: .centerEnd,
                            child: Padding(
                              padding: .symmetric(horizontal: 0),
                              child: Text(
                                'delete',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  danger: true,
                  onTap: () => _confirmDelete(context),
                ),
              ],
              child: HoverWidget(
                builder: (context, isHovered) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: .circular(4),
                      color: isHovered
                          ? theme.centerChannelColor.withValues(alpha: 0.10)
                          : null,
                    ),
                    padding: const EdgeInsets.all(4.0),
                    child: Icon(
                      Icons.more_vert,
                      size: 16,
                      color: theme.centerChannelColor.withValues(alpha: 0.65),
                    ),
                  );
                },
              ),
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
