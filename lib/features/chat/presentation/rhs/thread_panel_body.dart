import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_mattermost/features/channels/presentation/bloc/channel_bloc.dart';
import 'package:flutter_mattermost/features/chat/presentation/bloc/rhs_bloc.dart';
import 'package:flutter_mattermost/features/chat/presentation/editor/message_editor.dart';
import 'package:flutter_mattermost/features/chat/presentation/widgets/message_list.dart';
import 'package:flutter_mattermost/features/chat/presentation/widgets/post_message/post_item.dart';
import 'package:flutter_mattermost/features/users/presentation/bloc/user_profile_bloc.dart';

/// جسم لوحة Thread داخل RHS — يُركّب داخل [RhsBody].
/// يحمّل ملفات تعريف المستخدمين تلقائياً لعرض الأسماء بدلاً من المعرفات.
class ThreadPanelBody extends StatefulWidget {
  const ThreadPanelBody({super.key});

  @override
  State<ThreadPanelBody> createState() => _ThreadPanelBodyState();
}

class _ThreadPanelBodyState extends State<ThreadPanelBody> {
  /// معرفات المستخدمين الذين تم طلب ملفاتهم بالفعل لتجنب الطلبات المكررة.
  final Set<String> _loadedUserIds = {};

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return BlocBuilder<RhsBloc, RhsState>(
      builder: (context, state) {
        if (state is! RhsThreadState) return const SizedBox.shrink();
        final threadState = state;

        _loadMissingProfiles(threadState);

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

        final profileState = context.read<UserProfileBloc>().state;
        final profiles = profileState is UserProfileLoadedState
            ? profileState.profiles
            : const <UserEntity>[];
        final byId = {for (final p in profiles) p.id: p};

        final myUserId = profileState is UserProfileLoadedState
            ? (profileState.myProfile?.id ?? 'me')
            : 'me';

        return Column(
          children: [
            if (isArchived) _ArchivedWarning(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(bottom: 8),
                children: [
                  if (threadState.rootPost != null)
                    PostItem(
                      post: threadState.rootPost!,
                      profile: byId[threadState.rootPost!.userId],
                      showFullHeader: true,
                      myUserId: myUserId,
                    ),
                  const Divider(height: 24),
                  for (final reply in threadState.replies)
                    PostItem(
                      post: reply,
                      profile: byId[reply.userId],
                      isReply: true,
                      myUserId: myUserId,
                    ),
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

  /// يطلب ملفات تعريف المستخدمين الذين لم تُحمَّل بعد.
  void _loadMissingProfiles(RhsThreadState threadState) {
    final allIds = <String>{
      if (threadState.rootPost != null) threadState.rootPost!.userId,
      for (final reply in threadState.replies) reply.userId,
    }..remove('current_user');

    final newIds = allIds.difference(_loadedUserIds);
    if (newIds.isNotEmpty) {
      _loadedUserIds.addAll(newIds);
      context.read<UserProfileBloc>().add(
        LoadProfilesByIdsEvent(newIds.toList()),
      );
    }
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
