import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/features/channels/presentation/bloc/channel_bloc.dart';
import 'package:flutter_mattermost/features/chat/presentation/bloc/rhs_bloc.dart';
import 'package:flutter_mattermost/features/chat/presentation/editor/message_editor.dart';
import 'package:flutter_mattermost/features/chat/presentation/widgets/message_list.dart';

/// جسم لوحة Thread داخل RHS — يُركّب داخل [RhsBody].
/// (يستخرج من ThreadPanel السابق الذي كان يحمل العرض نفسه.)
class ThreadPanelBody extends StatelessWidget {
  const ThreadPanelBody({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return BlocBuilder<RhsBloc, RhsState>(
      builder: (context, state) {
        if (state is! RhsThreadState) return const SizedBox.shrink();
        final threadState = state;

        final channelState = context.read<ChannelBloc>().state;
        bool isArchived = false;
        if (channelState is ChannelsLoadedState) {
          final ch = channelState.channels
              .where((c) => c.id == threadState.channelId)
              .firstOrNull;
          if (ch != null && ch.deleteAt > 0) {
            isArchived = true;
          }
        }

        return Column(
          children: [
            if (isArchived) _ArchivedWarning(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(bottom: 8),
                children: [
                  if (threadState.rootPost != null)
                    PostItem(post: threadState.rootPost!, showFullHeader: true),
                  const Divider(height: 24),
                  if (threadState.loading)
                    const Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  for (final reply in threadState.replies)
                    PostItem(post: reply, isReply: true),
                  if (threadState.rootPost == null &&
                      threadState.replies.isEmpty &&
                      !threadState.loading)
                    Padding(
                      padding: const EdgeInsets.all(32),
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context).rhsThreadEmpty,
                          style: TextStyle(
                            color: theme.centerChannelColor.withValues(
                              alpha: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (!isArchived) MessageEditor(rootId: threadState.rootPostId),
          ],
        );
      },
    );
  }
}

class _ArchivedWarning extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: theme.centerChannelColor.withValues(alpha: 0.05),
      child: Row(
        children: [
          Icon(Icons.archive_outlined, size: 20, color: theme.centerChannelColor.withValues(alpha: 0.6)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              l10n.createCommentThreadFromArchivedChannelMessage.replaceAll(RegExp(r'<[^>]*>'), ''),
              style: TextStyle(
                color: theme.centerChannelColor.withValues(alpha: 0.7),
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
