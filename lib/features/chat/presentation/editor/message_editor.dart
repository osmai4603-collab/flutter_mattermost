import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/features/channels/presentation/bloc/channel_bloc.dart';
import 'package:flutter_mattermost/features/chat/presentation/bloc/post_bloc.dart';

/// محرر الرسالة: مربع نص + إجراءات + زر إرسال (رسالة عادية أو رد في Thread).
class MessageEditor extends StatefulWidget {
  final String? rootId;

  const MessageEditor({super.key, this.rootId});

  @override
  State<MessageEditor> createState() => _MessageEditorState();
}

class _MessageEditorState extends State<MessageEditor> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Timer? _typingTimer;

  @override
  void dispose() {
    _typingTimer?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  String? get _channelId {
    final state = context.read<ChannelBloc>().state;
    return state is ChannelsLoadedState ? state.selectedChannel?.id : null;
  }

  String? get _channelDisplayName {
    final state = context.read<ChannelBloc>().state;
    return state is ChannelsLoadedState
        ? state.selectedChannel?.displayName
        : null;
  }

  void _onTextChanged(String _) {
    final channelId = _channelId;
    if (channelId == null) return;
    _typingTimer?.cancel();
    _typingTimer = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      context.read<PostBloc>().add(
        SendTypingEvent(channelId, parentId: widget.rootId),
      );
    });
  }

  void _send() {
    final channelId = _channelId;
    final text = _controller.text.trim();
    if (channelId == null || text.isEmpty) return;
    context.read<PostBloc>().add(
      SendPostEvent(channelId: channelId, message: text, rootId: widget.rootId),
    );
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      color: theme.centerChannelBg,
      child: Container(
        decoration: BoxDecoration(
          color: theme.centerChannelBg,
          border: Border.all(
            color: theme.centerChannelColor.withValues(alpha: 0.18),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IconButton(
              icon: Icon(
                Icons.add,
                size: 22,
                color: theme.centerChannelColor.withValues(alpha: 0.6),
              ),
              tooltip: l10n.editorAddAttachment,
              onPressed: () {},
            ),
            Expanded(
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                onChanged: _onTextChanged,
                minLines: 1,
                maxLines: 8,
                keyboardType: TextInputType.multiline,
                style: TextStyle(color: theme.centerChannelColor, fontSize: 14),
                decoration: InputDecoration(
                  hintText: _channelDisplayName != null
                      ? l10n.create_postWrite(_channelDisplayName!)
                      : l10n.editorPlaceholder,
                  hintStyle: TextStyle(
                    color: theme.centerChannelColor.withValues(alpha: 0.45),
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.emoji_emotions_outlined,
                size: 22,
                color: theme.centerChannelColor.withValues(alpha: 0.6),
              ),
              tooltip: l10n.editorAddEmoji,
              onPressed: () {},
            ),
            const SizedBox(width: 4),
            IconButton(
              icon: Icon(Icons.send, size: 22, color: theme.buttonBg),
              tooltip: l10n.editorSend,
              onPressed: _send,
            ),
          ],
        ),
      ),
    );
  }
}
