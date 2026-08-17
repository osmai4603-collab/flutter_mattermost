import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/widgets/profile_picture.dart';
import 'package:flutter_mattermost/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_mattermost/features/channels/presentation/bloc/channel_bloc.dart';
import 'package:flutter_mattermost/features/chat/presentation/bloc/calls_bloc.dart';
import 'package:flutter_mattermost/features/users/presentation/bloc/user_profile_bloc.dart';

/// بطاقة المكالمة الواردة المدمجة — مطابقة call_incoming_condensed في webapp:
/// كارت صغير أسفل يسار الشاشة بعرض الشريط الجانبي، أخضر، يعرض **اسم
/// المتصل وصورته** (avatar) وزرا قبول (Join) ورفض (X). يظهر أثناء
/// CallRingingState ويختفي تلقائياً عند انتهاء مهلة الرنين (آلة الحالات
/// في CallsManager → idle).
class IncomingCallBanner extends StatelessWidget {
  const IncomingCallBanner({super.key});

  static String _displayNameFor(UserEntity user) {
    final full = '${user.firstName} ${user.lastName}'.trim();
    return full.isNotEmpty
        ? full
        : (user.nickname.isNotEmpty ? user.nickname : user.username);
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);

    return BlocBuilder<CallsBloc, CallsState>(
      builder: (context, state) {
        if (state is! CallRingingState) {
          return const SizedBox.shrink();
        }

        final channelState = context.read<ChannelBloc>().state;
        final channelName = channelState is ChannelsLoadedState
            ? channelState.channels
                  .where((c) => c.id == state.channelId)
                  .firstOrNull
                  ?.displayName
            : null;

        // تحميل بيانات المتصل (اسم + avatar) عبر UserProfileBloc مع كاش.
        final ownerId = state.ownerId;
        final profileBloc = context.read<UserProfileBloc>();
        final profiles = profileBloc.state is UserProfileLoadedState
            ? (profileBloc.state as UserProfileLoadedState).profiles
            : const <UserEntity>[];
        final caller = profiles.where((p) => p.id == ownerId).firstOrNull;
        if (ownerId.isNotEmpty && caller == null) {
          // طلب واحد عند الحاجة — غير مكرر (إذن التكرار مسموح لكن البث
          // يستهلك الاحتفاظ بالقديم ولا يكسر أي شيء).
          profileBloc.add(LoadProfilesByIdsEvent([ownerId]));
        }

        final callerName = caller != null ? _displayNameFor(caller) : '';
        final text = callerName.isNotEmpty
            ? l10n.incomingCallFrom(callerName)
            : l10n.incomingCallDescription(channelName ?? '');
        final callerLabel = ownerId.isNotEmpty ? caller?.username ?? '' : '';

        return Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: theme.onlineIndicator,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                ProfilePicture(
                  userId: ownerId,
                  username: callerLabel,
                  avatarUrl: ownerId.isNotEmpty
                      ? serverUserAvatarUrl(ownerId)
                      : null,
                  size: 28,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    text,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                _CircleActionButton(
                  tooltip: l10n.incomingCallAccept,
                  icon: Icons.call,
                  onPressed: () {
                    context.read<CallsBloc>().add(JoinCallEvent(state.callId));
                  },
                ),
                const SizedBox(width: 4),
                _CircleActionButton(
                  tooltip: l10n.incomingCallDecline,
                  icon: Icons.close,
                  onPressed: () {
                    context.read<CallsBloc>().add(
                      RejectCallEvent(state.callId),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// زر دائري شفاف بحدود ناعمة — مثل SmallJoinButton/XButton في webapp.
class _CircleActionButton extends StatelessWidget {
  const _CircleActionButton({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(6),
      ),
      child: IconButton(
        tooltip: tooltip,
        icon: Icon(icon, color: Colors.white, size: 18),
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints.tightFor(width: 28, height: 28),
        onPressed: onPressed,
      ),
    );
  }
}
