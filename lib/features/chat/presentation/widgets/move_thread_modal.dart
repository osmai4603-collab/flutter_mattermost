import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/design_tokens.dart';
import 'package:flutter_mattermost/core/enums/channel_type.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_entity.dart';
import 'package:flutter_mattermost/features/channels/presentation/bloc/channel_bloc.dart';

/// عرض نافذة نقل المحادثة (Move Thread Modal) — مطابقة
/// components/move_thread_modal في webapp: اختيار قناة هدف داخل الفريق
/// ثم تأكيد النقل عبر POST /posts/{post_id}/move.
Future<void> showMoveThreadModal(
  BuildContext context, {
  required String threadId,
  required String currentChannelId,
  required void Function(String channelId, String channelName) onMove,
}) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) => _MoveThreadModal(
      threadId: threadId,
      currentChannelId: currentChannelId,
      onMove: onMove,
    ),
  );
}

class _MoveThreadModal extends StatefulWidget {
  final String threadId;
  final String currentChannelId;
  final void Function(String channelId, String channelName) onMove;

  const _MoveThreadModal({
    required this.threadId,
    required this.currentChannelId,
    required this.onMove,
  });

  @override
  State<_MoveThreadModal> createState() => _MoveThreadModalState();
}

class _MoveThreadModalState extends State<_MoveThreadModal> {
  String _query = '';
  ChannelEntity? _selected;

  List<ChannelEntity> _availableChannels(List<ChannelEntity> all) {
    return all
        .where(
          (c) =>
              c.id != widget.currentChannelId &&
              c.type != ChannelType.direct &&
              c.type != ChannelType.group,
        )
        .where(
          (c) =>
              _query.isEmpty ||
              c.displayName.toLowerCase().contains(_query.toLowerCase()),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Dialog(
      backgroundColor: theme.centerChannelBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.dialogRadius),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: theme.centerChannelColor.withValues(alpha: 0.1),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Move thread',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: theme.centerChannelColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Icon(
                        Icons.close,
                        size: 20,
                        color: theme.centerChannelColor.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: BlocBuilder<ChannelBloc, ChannelState>(
                builder: (context, state) {
                  final loaded = state is ChannelsLoadedState ? state : null;
                  final channels = _availableChannels(
                    loaded?.channels ?? const [],
                  );

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        onChanged: (value) => setState(() => _query = value),
                        autofocus: true,
                        style: TextStyle(
                          color: theme.centerChannelColor,
                          fontSize: 14,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search channels',
                          hintStyle: TextStyle(
                            color: theme.centerChannelColor.withValues(
                              alpha: 0.5,
                            ),
                            fontSize: 14,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            size: 18,
                            color: theme.centerChannelColor.withValues(
                              alpha: 0.6,
                            ),
                          ),
                          isDense: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 300),
                        child: channels.isEmpty
                            ? Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  'No channels found',
                                  style: TextStyle(
                                    color: theme.centerChannelColor.withValues(
                                      alpha: 0.6,
                                    ),
                                    fontSize: 13,
                                  ),
                                ),
                              )
                            : ListView(
                                shrinkWrap: true,
                                children: [
                                  for (final channel in channels)
                                    InkWell(
                                      onTap: () =>
                                          setState(() => _selected = channel),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              channel.type ==
                                                      ChannelType.private
                                                  ? Icons.lock_outline
                                                  : Icons.tag,
                                              size: 18,
                                              color: theme.centerChannelColor
                                                  .withValues(alpha: 0.6),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Text(
                                                channel.displayName,
                                                maxLines: 1,
                                                overflow:
                                                    TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: theme
                                                      .centerChannelColor,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                            if (_selected?.id == channel.id)
                                              Icon(
                                                Icons.check_circle,
                                                size: 18,
                                                color: theme.linkColor,
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: theme.buttonBg,
                      foregroundColor: theme.buttonColor,
                    ),
                    onPressed: _selected == null
                        ? null
                        : () {
                            Navigator.of(context).pop();
                            widget.onMove(
                              _selected!.id,
                              _selected!.displayName,
                            );
                          },
                    child: const Text('Move thread'),
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