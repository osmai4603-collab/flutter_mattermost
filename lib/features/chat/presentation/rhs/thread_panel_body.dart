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

        return Column(
          children: [
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
            MessageEditor(rootId: threadState.rootPostId),
          ],
        );
      },
    );
  }
}