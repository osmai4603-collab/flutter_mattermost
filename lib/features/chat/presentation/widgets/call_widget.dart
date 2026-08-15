import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/core/calls/calls_manager.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/widgets/profile_picture.dart';
import 'package:flutter_mattermost/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_mattermost/features/channels/presentation/bloc/channel_bloc.dart'
    hide ToggleMuteEvent;
import 'package:flutter_mattermost/features/chat/presentation/bloc/calls_bloc.dart';
import 'package:flutter_mattermost/features/chat/presentation/widgets/call_duration.dart';
import 'package:flutter_mattermost/features/users/presentation/bloc/user_profile_bloc.dart';

/// بطاقة المكالمة النشطة المدمجة — تعرض أسفل يسار الشاشة (عبر
/// CallWidgetOverlay) بعرض الشريط الجانبي. محتواها:
///  * شريط علوي بمقبض السحب (drag handle): اسم القناة • عدّاد المدة.
///  * صف المتحدث: صورة المتحدث واسمه «X يتحدث…» (نفس renderSpeaking في webapp).
///  * معاينة الفيديو المحلية عند تفعيل الكاميرا.
///  * أزرار: كتم / فيديو / مشاركة شاشة / إنهاء.
/// يختفي تلقائياً عند انتهاء المكالمة (CallConnectedState → حالات أخرى).
class CallWidget extends StatelessWidget {
  const CallWidget({super.key});

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
        if (state is! CallConnectedState) {
          return const SizedBox.shrink();
        }

        final channelState = context.read<ChannelBloc>().state;
        final channelName = channelState is ChannelsLoadedState
            ? channelState.channels
                  .where((c) => c.id == state.channelId)
                  .firstOrNull
                  ?.displayName
            : null;

        // المتحدث: أول مشارك مفعّل صوته (نفس renderSpeaking في webapp).
        final speaker = state.participants.values
            .where((p) => p.isVoiceActive)
            .firstOrNull;
        final speakerUserId = speaker?.userId ?? '';

        // بيانات المتحدث (اسم + avatar) عبر UserProfileBloc مع كاش.
        final profileBloc = context.read<UserProfileBloc>();
        final profiles = profileBloc.state is UserProfileLoadedState
            ? (profileBloc.state as UserProfileLoadedState).profiles
            : const <UserEntity>[];
        final speakerProfile =
            profiles.where((p) => p.id == speakerUserId).firstOrNull;
        if (speakerUserId.isNotEmpty && speakerProfile == null) {
          profileBloc.add(LoadProfilesByIdsEvent([speakerUserId]));
        }

        final speakerName =
            speakerProfile != null ? _displayNameFor(speakerProfile) : '';
        final textureId = getIt<CallsManager>().localRenderer.textureId;

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: theme.centerChannelBg,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: theme.buttonBg.withValues(alpha: 0.3)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // شريط علوي — مقبض السحب + اسم القناة + المدة.
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: theme.centerChannelColor.withValues(alpha: 0.04),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(8),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.drag_handle, size: 14),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        channelName ?? l10n.callWidgetTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: theme.centerChannelColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    CallDuration(
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: theme.centerChannelColor.withValues(
                          alpha: 0.75,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // صف المتحدث: «{name} يتحدث…» (أو «لا أحد»).
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 6, 8, 4),
                child: Row(
                  children: [
                    ProfilePicture(
                      username: speakerProfile?.username ?? '',
                      avatarUrl: speakerUserId.isNotEmpty
                          ? serverUserAvatarUrl(speakerUserId)
                          : null,
                      size: 20,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        speakerName.isNotEmpty
                            ? '$speakerName ${l10n.callsSpeakerTalking}'
                            : l10n.callsNoOneTalking,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.centerChannelColor.withValues(
                            alpha: 0.75,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // معاينة الفيديو المحلية عند تفعيل الكاميرا.
              if (state.isVideoOn && textureId != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 2, 8, 4),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      height: 72,
                      color: Colors.black,
                      child: Texture(textureId: textureId),
                    ),
                  ),
                ),
              // أزرار التحكم.
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 2, 8, 8),
                child: Row(
                  children: [
                    IconButton(
                      tooltip: state.isMuted
                          ? l10n.callWidgetUnmute
                          : l10n.callWidgetMute,
                      icon: Icon(
                        state.isMuted ? Icons.mic_off : Icons.mic,
                        size: 18,
                      ),
                      color: state.isMuted
                          ? theme.errorTextColor
                          : theme.centerChannelColor,
                      onPressed: () =>
                          context.read<CallsBloc>().add(ToggleMuteEvent()),
                    ),
                    IconButton(
                      tooltip: state.isVideoOn
                          ? l10n.callWidgetVideoOff
                          : l10n.callWidgetVideoOn,
                      icon: Icon(
                        state.isVideoOn ? Icons.videocam : Icons.videocam_off,
                        size: 18,
                      ),
                      color: theme.centerChannelColor,
                      onPressed: () =>
                          context.read<CallsBloc>().add(ToggleVideoEvent()),
                    ),
                    IconButton(
                      tooltip: state.isSharingScreen
                          ? l10n.callWidgetStopSharing
                          : l10n.callWidgetShareScreen,
                      icon: Icon(
                        state.isSharingScreen
                            ? Icons.stop_screen_share
                            : Icons.screen_share,
                        size: 18,
                      ),
                      color: state.isSharingScreen
                          ? theme.mentionBg
                          : theme.centerChannelColor,
                      onPressed: () =>
                          context.read<CallsBloc>().add(ToggleShareScreenEvent()),
                    ),
                    const Spacer(),
                    IconButton(
                      tooltip: l10n.callWidgetEndCall,
                      icon: const Icon(Icons.call_end, size: 18),
                      color: theme.errorTextColor,
                      onPressed: () =>
                          context.read<CallsBloc>().add(EndCallEvent()),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// غلاف بطاقة المكالمة النشطة القابل للتحريك — يملأ جسم التطبيق بالكامل
/// (Positioned.fill في ChannelShell) ويضع البطاقة افتراضياً أسفل-يسار
/// فوق منطقة الـ sidebar بعرضه (lhsWidth). أثناء الاتصال يمكن سحب البطاقة
/// إلى أي موضع داخل نافذة التطبيق، مع تحوّل مؤشر الفأرة إلى move/grab/
/// grabbing (مثل بطاقة call widget في webapp). لا يعترض نقرات الواجهة
/// خارجه (إزالة الحجم الفارغ لا تلتقط الأحداث).
class CallWidgetOverlay extends StatefulWidget {
  final ValueListenable<double> lhsWidth;

  const CallWidgetOverlay({super.key, required this.lhsWidth});

  @override
  State<CallWidgetOverlay> createState() => _CallWidgetOverlayState();
}

class _CallWidgetOverlayState extends State<CallWidgetOverlay> {
  final GlobalKey _areaKey = GlobalKey();
  final GlobalKey _cardKey = GlobalKey();

  /// موضع زاوية البطاقة العلوية-اليسرى بالنسبة لمنطقة التراكب؛
  /// null = الافتراضي (أسفل-يسار مربوط بالـ sidebar).
  Offset? _pos;
  Offset? _grabDxDy;
  bool _dragging = false;

  static const double _defaultLeft = 72; // TeamSwitcher(64) + هامش 8.
  static const double _defaultBottom = 8;

  void _onPanStart(DragStartDetails details) {
    final areaBox = _areaKey.currentContext?.findRenderObject() as RenderBox?;
    final cardBox = _cardKey.currentContext?.findRenderObject() as RenderBox?;
    if (areaBox == null || cardBox == null) return;
    final areaTopLeft = areaBox.localToGlobal(Offset.zero);
    final cardTopLeft = cardBox.localToGlobal(Offset.zero);
    setState(() {
      _pos = cardTopLeft - areaTopLeft;
      _grabDxDy = cardTopLeft - details.globalPosition;
      _dragging = true;
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final areaBox = _areaKey.currentContext?.findRenderObject() as RenderBox?;
    if (areaBox == null || _grabDxDy == null) return;
    final areaTopLeft = areaBox.localToGlobal(Offset.zero);
    setState(() {
      _pos = details.globalPosition + _grabDxDy! - areaTopLeft;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() => _dragging = false);
    _grabDxDy = null;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: widget.lhsWidth,
      builder: (context, width, _) {
        return BlocBuilder<CallsBloc, CallsState>(
          builder: (context, state) {
            if (state is! CallConnectedState) {
              return const SizedBox.shrink();
            }
            return Stack(
              key: _areaKey,
              children: [
                Positioned(
                  left: _pos?.dx ?? _defaultLeft,
                  top: _pos?.dy,
                  bottom: _pos == null ? _defaultBottom : null,
                  width: width,
                  child: MouseRegion(
                    cursor: _dragging
                        ? SystemMouseCursors.grabbing
                        : SystemMouseCursors.move,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onPanStart: _onPanStart,
                      onPanUpdate: _onPanUpdate,
                      onPanEnd: _onPanEnd,
                      child: CallWidget(key: _cardKey),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
