import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/widgets/profile_picture.dart';
import 'package:flutter_mattermost/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_mattermost/features/chat/domain/entities/post_entity.dart';
import 'package:flutter_mattermost/features/chat/presentation/bloc/calls_bloc.dart';
import 'package:flutter_mattermost/features/users/presentation/bloc/user_profile_bloc.dart';

/// لبنات تعبير "حالة المكالمة" داخل محادثة القناة:
///  * [ChannelCallStateBanner] — لافتة حية أسفل المحادثة (فوق محرر الرسائل)
///    عند وجود مكالمة جارية/واردة في القناة الحالية مع زر انضمام.
///  * [CallPostTile] — بطاقة تظهر بدل نص الرسالة لرسائل `custom_calls`
///    (Call started / Call ended) — مطابقة
///    custom_post_types/post_type/component.tsx في webapp.
abstract final class CallStateTiles {
  static bool isCallPost(PostEntity post) =>
      post.type.isCustom && post.propsData['start_at'] is num;

  static String durationLabel(DateTime start, DateTime end) {
    final d = end.difference(start);
    final h = d.inHours;
    final m = d.inMinutes % 60;
    final s = d.inSeconds % 60;
    if (h > 0) {
      return '${h.toString().padLeft(2, '0')}:'
          '${m.toString().padLeft(2, '0')}:'
          '${s.toString().padLeft(2, '0')}';
    }
    return '${m.toString().padLeft(2, '0')}:'
        '${s.toString().padLeft(2, '0')}';
  }
}

/// لافتة حالة المكالمة الحية في القناة — تظهر فوق محرر الرسائل (أسفل
/// القائمة) عند وجود مكالمة قائمة أو واردة في هذه القناة. إن لم يكن
/// المستخدم في المكالمة يعرض زر «انضم»؛ إن كان فيها يعرض إشارة
/// «أنت في المكالمة» (اللون الأخضر مثل indicator في webapp).
class ChannelCallStateBanner extends StatelessWidget {
  final String channelId;

  const ChannelCallStateBanner({super.key, required this.channelId});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);

    return BlocBuilder<CallsBloc, CallsState>(
      builder: (context, state) {
        final String? activeCallId = switch (state) {
          CallRingingState(:final channelId) when channelId == this.channelId =>
            state.callId,
          CallConnectedState(:final channelId)
              when channelId == this.channelId => state.callId,
          _ => null,
        };
        if (activeCallId == null) {
          return const SizedBox.shrink();
        }
        final inCall = state is CallConnectedState;

        return Container(
          margin: const EdgeInsets.fromLTRB(12, 2, 12, 6),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: theme.centerChannelColor.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: theme.onlineIndicator.withValues(alpha: 0.4),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: theme.onlineIndicator,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.callsOngoingCall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: theme.centerChannelColor,
                  ),
                ),
              ),
              if (!inCall)
                TextButton(
                  onPressed: () => context
                      .read<CallsBloc>()
                      .add(StartCallEvent(channelId)),
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    minimumSize: const Size(0, 28),
                    backgroundColor: theme.onlineIndicator,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child: Text(l10n.callsJoinCall),
                )
              else
                Text(
                  l10n.callsYouAreInTheCall,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: theme.onlineIndicator,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

/// بطاقة رسالة `custom_calls` في المحادثة — مطابقة
/// custom_post_types/post_type/component.tsx في webapp:
/// مؤشر دائري 40px (أخضر + هاتف للمكالمة النشطة، رمادي + إنهاء للمنتهية)،
/// عنوان «Call started / Call ended» (Metropolis 16px w600)، رسالة فرعية
/// («by {user}» للنشطة / «Ended at … • Lasted …» للمنتهية)، وأفاتار
/// المشاركين + زر انضمام/مغادرة للفعالة.
class CallPostTile extends StatelessWidget {
  final PostEntity post;

  const CallPostTile({super.key, required this.post});

  static String _displayNameFor(UserEntity user) {
    final full = '${user.firstName} ${user.lastName}'.trim();
    return full.isNotEmpty
        ? full
        : (user.nickname.isNotEmpty ? user.nickname : user.username);
  }

  static String _toHumanDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes % 60;
    final s = d.inSeconds % 60;
    if (h > 0) return '${h}h ${m}m';
    if (m > 0) return '${m}m ${s}s';
    return '${s}s';
  }

  static String _clockTime(DateTime t) {
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);

    final props = post.propsData;
    final startAtMs = (props['start_at'] as num).toInt();
    final endAtMs = props['end_at'] is num
        ? (props['end_at'] as num).toInt()
        : 0;
    final ongoing = endAtMs <= 0;
    final startAt = DateTime.fromMillisecondsSinceEpoch(startAtMs);
    final endAt = DateTime.fromMillisecondsSinceEpoch(endAtMs);

    final participants = props['participants'];
    final participantIds = participants is List
        ? participants.whereType<String>().toList()
        : <String>[];

    // اسم من بدأ المكالمة (مؤلف الرسالة) عبر UserProfileBloc.
    final profileBloc = context.read<UserProfileBloc>();
    final profiles = profileBloc.state is UserProfileLoadedState
        ? (profileBloc.state as UserProfileLoadedState).profiles
        : const <UserEntity>[];
    final author =
        profiles.where((p) => p.id == post.userId).firstOrNull;
    if (post.userId.isNotEmpty && author == null) {
      profileBloc.add(LoadProfilesByIdsEvent([post.userId]));
    }

    // هل المستخدم داخل هذه المكالمة حالياً؟ (زر مغادرة بدل انضمام).
    final callsState = context.read<CallsBloc>().state;
    final inCall =
        callsState is CallConnectedState &&
        callsState.channelId == post.channelId;

    // نهاية الرسالة الفرعية: «Ended at HH:mm • Lasted Xm Ys».
    final subMessage = ongoing
        ? (author != null ? l10n.callsCallBy(_displayNameFor(author)) : '')
        : '${l10n.callsCallEndedAt(_clockTime(endAt))} • '
              '${l10n.callsCallLasted(_toHumanDuration(endAt.difference(startAt)))}';

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 600),
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.centerChannelBg,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: theme.centerChannelColor.withValues(alpha: 0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // مؤشر المكالمة الدائري 40px.
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: ongoing
                  ? theme.onlineIndicator
                  : theme.centerChannelColor.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              ongoing ? Icons.call : Icons.call_end,
              size: 20,
              color: ongoing
                  ? theme.centerChannelBg
                  : theme.centerChannelColor.withValues(alpha: 0.72),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ongoing ? l10n.callsCallStarted : l10n.callsCallEnded,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Metropolis',
                    color: theme.centerChannelColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subMessage,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.33,
                    color: theme.centerChannelColor.withValues(alpha: 0.72),
                  ),
                ),
              ],
            ),
          ),
          if (ongoing) ...[
            const SizedBox(width: 12),
            // أفاتار المشاركين (ConnectedProfiles).
            ...participantIds.take(3).map(
              (id) => Padding(
                padding: const EdgeInsets.only(left: 2),
                child: ProfilePicture(
                  username: profiles
                          .where((p) => p.id == id)
                          .firstOrNull
                          ?.username ??
                      '',
                  avatarUrl: id.isNotEmpty ? serverUserAvatarUrl(id) : null,
                  size: 28,
                ),
              ),
            ),
            const SizedBox(width: 12),
            if (inCall)
              _CallPostButton(
                onPressed: () =>
                    context.read<CallsBloc>().add(EndCallEvent()),
                backgroundColor: theme.errorTextColor,
                foregroundColor: theme.buttonColor,
                label: l10n.callsLeaveCall,
                icon: Icons.call_end,
              )
            else
              _CallPostButton(
                onPressed: () => context
                    .read<CallsBloc>()
                    .add(StartCallEvent(post.channelId)),
                backgroundColor: theme.onlineIndicator,
                foregroundColor: theme.centerChannelBg,
                label: l10n.callsJoinCall,
                icon: Icons.call,
              ),
          ],
        ],
      ),
    );
  }
}

/// زر انضمام/مغادرة من تصميم post_type: خلفية مملوءة، محتوى كثيف، w600.
class _CallPostButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final String label;
  final IconData icon;

  const _CallPostButton({
    required this.onPressed,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        visualDensity: VisualDensity.compact,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        minimumSize: const Size(0, 40),
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      icon: Icon(icon, size: 16),
      label: Text(label),
    );
  }
}
