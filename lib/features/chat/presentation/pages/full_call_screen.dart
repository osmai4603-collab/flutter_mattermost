import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_mattermost/core/calls/calls_manager.dart';
import 'package:flutter_mattermost/core/calls/audio_session_manager.dart';
import 'package:flutter_mattermost/core/calls/calls_websocket_client.dart';
import 'package:flutter_mattermost/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_mattermost/features/chat/presentation/bloc/calls_bloc.dart';
import 'package:flutter_mattermost/features/chat/presentation/widgets/host_controls_bottom_sheet.dart';
import 'package:flutter_mattermost/features/users/domain/repositories/user_repository.dart';

/// خيار إيموجي للتفاعل أثناء المكالمة (EmojiData حسب الخادم).
class CallEmojiOption {
  final String name;
  final String literal;
  final String unified;
  const CallEmojiOption({
    required this.name,
    required this.literal,
    required this.unified,
  });
}

const List<CallEmojiOption> callEmojiOptions = [
  CallEmojiOption(name: 'thumbsup', literal: '👍', unified: '1f44d'),
  CallEmojiOption(name: 'clap', literal: '👏', unified: '1f44f'),
  CallEmojiOption(name: 'heart', literal: '❤️', unified: '2764'),
  CallEmojiOption(name: 'tada', literal: '🎉', unified: '1f389'),
  CallEmojiOption(name: 'joy', literal: '😂', unified: '1f602'),
];

/// الشاشة الكاملة للمكالمات الصوتية والمرئية ومشاركة الشاشة —
/// شبكة المشاركين من state.participants (أسماء + شارات + متحدث نشط)،
/// تفاعلات حقيقية (إرسال عبر react + استقبال من reactionsStream).
class FullCallScreen extends StatefulWidget {
  const FullCallScreen({super.key});

  @override
  State<FullCallScreen> createState() => _FullCallScreenState();
}

class _FullCallScreenState extends State<FullCallScreen> {
  final _callsManager = GetIt.I<CallsManager>();

  final List<CallReactionEvent> _activeReactions = [];
  final Map<String, Timer> _reactionTimers = {};
  int _reactionKey = 0;

  @override
  void initState() {
    super.initState();
    _callsManager.reactionsStream.listen(_onReactionReceived);
  }

  @override
  void dispose() {
    for (final t in _reactionTimers.values) {
      t.cancel();
    }
    super.dispose();
  }

  void _onReactionReceived(CallReactionEvent event) {
    if (!mounted) return;
    setState(() {
      _activeReactions.add(event);
      final key = _reactionKey++;
      final timer = Timer(const Duration(seconds: 3), () {
        if (!mounted) return;
        setState(() {
          _activeReactions.remove(event);
        });
        _reactionTimers.remove('$key');
      });
      _reactionTimers['$key'] = timer;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 28),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'مكالمة جارية',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          BlocBuilder<CallsBloc, CallsState>(
            builder: (context, state) {
              if (state is! CallConnectedState ||
                  !_callsManager.isCurrentUserHost) {
                return const SizedBox.shrink();
              }
              return IconButton(
                icon: const Icon(Icons.admin_panel_settings, color: Colors.white),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (_) => const HostControlsBottomSheet(),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<CallsBloc, CallsState>(
        builder: (context, state) {
          if (state is! CallConnectedState) {
            return const Center(
              child: Text(
                'تم إنهاء المكالمة',
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          final participants = state.participants.values.toList();

          return SafeArea(
            child: Column(
              children: [
                // تفاعلات المشاركين الواردة (مؤقتة)
                if (_activeReactions.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _activeReactions
                          .map(
                            (r) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                              child: Text(
                                r.emojiLiteral.isNotEmpty
                                    ? r.emojiLiteral
                                    : '👍',
                                style: const TextStyle(fontSize: 36),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),

                // شبكة المشاركين
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: participants.isEmpty
                        ? _buildSingleLocalParticipantView(state)
                        : _buildParticipantsGrid(state, participants),
                  ),
                ),

                // شريط التفاعلات بالإيموجي (إرسال حقيقي)
                _buildEmojiReactionsBar(context),

                const SizedBox(height: 12),

                // شريط أزرار التحكم الفعلي بالمكالمة
                _buildControlButtonsBar(context, state),

                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSingleLocalParticipantView(CallConnectedState state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              state.isVideoOn ? Icons.videocam : Icons.account_circle,
              size: 80,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'أنت متصل الآن بالمكالمة',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'في انتظار انضمام أطراف أخرى...',
            style: TextStyle(color: Colors.white60, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildParticipantsGrid(
    CallConnectedState state,
    List<CallParticipantState> participants,
  ) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: participants.length > 2 ? 2 : 1,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: participants.length,
      itemBuilder: (context, index) {
        return _ParticipantTile(participant: participants[index]);
      },
    );
  }

  Widget _buildEmojiReactionsBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: callEmojiOptions.map((option) {
        return GestureDetector(
          onTap: () {
            context.read<CallsBloc>().add(ToggleReactionEvent(
              CallsEmoji(
                name: option.name,
                literal: option.literal,
                unified: option.unified,
              ),
            ));
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 6),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Text(
              option.literal,
              style: const TextStyle(fontSize: 20),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildControlButtonsBar(BuildContext context, CallConnectedState state) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: Icon(state.isMuted ? Icons.mic_off : Icons.mic),
            color: state.isMuted ? Colors.redAccent : Colors.white,
            onPressed: () => context.read<CallsBloc>().add(ToggleMuteEvent()),
          ),
          IconButton(
            icon: Icon(state.isVideoOn ? Icons.videocam : Icons.videocam_off),
            color: state.isVideoOn ? Colors.greenAccent : Colors.white70,
            onPressed: () => context.read<CallsBloc>().add(ToggleVideoEvent()),
          ),
          IconButton(
            icon: Icon(state.isHandRaised ? Icons.back_hand : Icons.back_hand_outlined),
            color: state.isHandRaised ? Colors.amber : Colors.white70,
            onPressed: () => context.read<CallsBloc>().add(ToggleRaiseHandEvent()),
          ),
          IconButton(
            icon: Icon(
              state.audioDevice == AudioOutputDevice.speaker
                  ? Icons.volume_up
                  : Icons.hearing,
            ),
            color: Colors.white,
            onPressed: () {
              final newDevice = state.audioDevice == AudioOutputDevice.speaker
                  ? AudioOutputDevice.earpiece
                  : AudioOutputDevice.speaker;
              context.read<CallsBloc>().add(SwitchAudioOutputEvent(newDevice));
            },
          ),
          IconButton(
            icon: const Icon(Icons.call_end),
            color: Colors.red,
            iconSize: 32,
            onPressed: () {
              context.read<CallsBloc>().add(EndCallEvent());
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}

/// بلاطة مشارك: فيديو (إن وُجد) أو أيقونة، مع الاسم (يُجلب عبر
/// UserRepository.getProfilesByIds مع تخزين مؤقت) وشارات الحالة
/// وإطار المتحدث النشط.
class _ParticipantTile extends StatefulWidget {
  final CallParticipantState participant;
  const _ParticipantTile({required this.participant});

  @override
  State<_ParticipantTile> createState() => _ParticipantTileState();
}

class _ParticipantTileState extends State<_ParticipantTile> {
  static final Map<String, String> _namesCache = {};
  String? _displayName;

  static String _displayNameFor(UserEntity user) {
    final full = '${user.firstName} ${user.lastName}'.trim();
    return full.isNotEmpty ? full : (user.nickname.isNotEmpty ? user.nickname : user.username);
  }

  @override
  void initState() {
    super.initState();
    _resolveName();
  }

  Future<void> _resolveName() async {
    final cached = _namesCache[widget.participant.userId];
    if (cached != null) {
      setState(() => _displayName = cached);
      return;
    }
    try {
      final users = await GetIt.I<UserRepository>()
          .getProfilesByIds([widget.participant.userId]);
      if (!mounted || users.isEmpty) return;
      final name = _displayNameFor(users.first);
      _namesCache[widget.participant.userId] = name;
      setState(() => _displayName = name);
    } catch (_) {
      // تبقى خلية بلا اسم عند فشل الجلب.
    }
  }

  @override
  Widget build(BuildContext context) {
    final participant = widget.participant;
    final hasVideo = participant.renderer != null && participant.isVideoOn;

    return Container(
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: participant.isVoiceActive
              ? Colors.greenAccent
              : Colors.white24,
          width: participant.isVoiceActive ? 3 : 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: hasVideo
                ? RTCVideoView(participant.renderer!)
                : Center(
                    child: Icon(
                      participant.isSharingScreen
                          ? Icons.screen_share
                          : Icons.account_circle,
                      size: 72,
                      color: Colors.white38,
                    ),
                  ),
          ),
          // الشارات: كتم/يد/شاشة/مضيف
          Positioned(
            top: 8,
            right: 8,
            child: Row(
              children: [
                if (participant.isHost) _badge(Icons.admin_panel_settings, Colors.amber),
                if (participant.isSharingScreen) _badge(Icons.screen_share, Colors.purpleAccent),
                if (participant.isHandRaised) _badge(Icons.back_hand, Colors.orangeAccent),
                if (participant.isMuted) _badge(Icons.mic_off, Colors.redAccent),
              ],
            ),
          ),
          // الاسم
          Positioned(
            bottom: 8,
            left: 8,
            right: 8,
            child: Text(
              _displayName ?? '...',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                shadows: [
                  Shadow(color: Colors.black, blurRadius: 4),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _badge(IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(left: 4),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.55),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 16, color: color),
    );
  }
}
