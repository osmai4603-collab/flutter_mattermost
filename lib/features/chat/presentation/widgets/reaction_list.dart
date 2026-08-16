import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_mattermost/features/chat/domain/entities/reaction_entity.dart';
import 'package:flutter_mattermost/features/chat/presentation/bloc/post_bloc.dart';
import 'package:flutter_mattermost/features/chat/presentation/widgets/custom_emoji.dart';
import 'package:flutter_mattermost/features/chat/presentation/widgets/reaction_picker.dart';
import 'package:flutter_mattermost/features/users/presentation/bloc/user_profile_bloc.dart';

/// قائمة تفاعلات منشور — نظير ReactionList في webapp: تجمع التفاعلات حسب
/// الإيموجي وتعرض كبسولة (Chip) لكل منها + زر إضافة تفاعل جديد (+).
/// تُعرض أسفل نص الرسالة داخل كل منشور.
class ReactionList extends StatelessWidget {
  final String postId;
  final List<ReactionEntity> reactions;
  final String myUserId;

  const ReactionList({
    super.key,
    required this.postId,
    required this.reactions,
    required this.myUserId,
  });

  @override
  Widget build(BuildContext context) {
    if (reactions.isEmpty) return const SizedBox.shrink();

    // تجميع التفاعلات حسب emojiName.
    final byEmoji = <String, List<ReactionEntity>>{};
    for (final reaction in reactions) {
      byEmoji.putIfAbsent(reaction.emojiName, () => []).add(reaction);
    }

    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Wrap(
        spacing: 4,
        runSpacing: 4,
        children: [
          for (final entry in byEmoji.entries)
            ReactionChip(
              postId: postId,
              emojiName: entry.key,
              reactions: entry.value,
              myUserId: myUserId,
            ),
          _AddReactionChip(postId: postId),
        ],
      ),
    );
  }
}

/// كبسولة تفاعل واحدة (Chip) — نظير Reaction في webapp.
class ReactionChip extends StatelessWidget {
  final String postId;
  final String emojiName;
  final List<ReactionEntity> reactions;
  final String myUserId;

  const ReactionChip({
    super.key,
    required this.postId,
    required this.emojiName,
    required this.reactions,
    required this.myUserId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final mine = reactions.any((r) => r.userId == myUserId);

    return Tooltip(
      message: _reactorNames(context),
      waitDuration: const Duration(milliseconds: 400),
      child: InkWell(
        onTap: () {
          context.read<PostBloc>().add(ToggleReactionEvent(postId, emojiName));
        },
        borderRadius: BorderRadius.circular(4),
        child: Container(
          height: 24,
          padding: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color: mine
                ? theme.buttonBg.withValues(alpha: 0.08)
                : theme.centerChannelColor.withValues(alpha: 0.06),
            border: Border.all(
              color: mine
                  ? theme.buttonBg.withValues(alpha: 0.5)
                  : theme.centerChannelColor.withValues(alpha: 0.15),
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              emojiWidget(emojiName, size: 16),
              const SizedBox(width: 4),
              Text(
                '${reactions.length}',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: mine
                      ? theme.buttonBg
                      : theme.centerChannelColor.withValues(alpha: 0.75),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// أسماء المتفاعلين للتلميح — «أنت» للمستخدم الحالي + أسماء الآخرين إن توفرت.
  String _reactorNames(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final profileState = context.read<UserProfileBloc>().state;
    List<UserEntity> profiles = const [];
    if (profileState is UserProfileLoadedState) {
      profiles = profileState.profiles;
    }
    final byId = {for (final p in profiles) p.id: p};

    final names = <String>[];
    for (final reaction in reactions) {
      if (reaction.userId == myUserId) {
        names.add(l10n.reactionYou);
        continue;
      }
      final username = byId[reaction.userId]?.username;
      names.add(username?.isNotEmpty == true ? username! : reaction.userId);
    }
    return names.join(', ');
  }
}

/// زر إضافة تفاعل جديد (+) — يفتح منتقي الإيموجي ثم يضيف التفاعل.
class _AddReactionChip extends StatelessWidget {
  final String postId;

  const _AddReactionChip({required this.postId});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);

    return Tooltip(
      message: l10n.post_infoTooltipAdd_reactions,
      waitDuration: const Duration(milliseconds: 400),
      child: InkWell(
        onTap: () async {
          final emoji = await showReactionPicker(context);
          if (emoji == null || !context.mounted) return;
          context.read<PostBloc>().add(ToggleReactionEvent(postId, emoji));
        },
        borderRadius: BorderRadius.circular(4),
        child: Container(
          height: 24,
          width: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              color: theme.centerChannelColor.withValues(alpha: 0.2),
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(
            Icons.add,
            size: 16,
            color: theme.centerChannelColor.withValues(alpha: 0.6),
          ),
        ),
      ),
    );
  }
}
