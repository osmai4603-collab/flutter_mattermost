import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/features/chat/domain/entities/post_entity.dart';
import 'package:flutter_mattermost/features/chat/presentation/bloc/calls_bloc.dart';

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

/// بطاقة رسالة `custom_calls` في المحادثة — تُرسم بدل النص العادي:
/// أيقونة مكالمة خضراء + «بدأت/انتهت المكالمة» + المدة + زر «انضم»
/// إن كانت المكالمة ما زالت قائمة.
class CallPostTile extends StatelessWidget {
  final PostEntity post;

  const CallPostTile({super.key, required this.post});

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
    final endAt = ongoing
        ? DateTime.now()
        : DateTime.fromMillisecondsSinceEpoch(endAtMs);
    final title = ongoing ? l10n.callsCallStarted : l10n.callsCallEnded;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 2, bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: theme.centerChannelColor.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.buttonBg.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: ongoing
                  ? theme.onlineIndicator
                  : theme.centerChannelColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              ongoing ? Icons.call : Icons.call_end,
              size: 16,
              color: ongoing ? Colors.white : theme.centerChannelColor,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: theme.centerChannelColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  CallStateTiles.durationLabel(startAt, endAt),
                  style: TextStyle(
                    fontSize: 11,
                    color: theme.centerChannelColor.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          if (ongoing)
            TextButton(
              onPressed: () => context
                  .read<CallsBloc>()
                  .add(StartCallEvent(post.channelId)),
              style: TextButton.styleFrom(
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                minimumSize: const Size(0, 28),
                backgroundColor: theme.onlineIndicator,
                foregroundColor: Colors.white,
                textStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: Text(l10n.callsJoinCall),
            ),
        ],
      ),
    );
  }
}
