import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_mattermost/core/calls/calls_manager.dart';
import 'package:flutter_mattermost/core/calls/audio_session_manager.dart';
import 'package:flutter_mattermost/features/chat/presentation/bloc/calls_bloc.dart';
import 'package:flutter_mattermost/features/chat/presentation/widgets/host_controls_bottom_sheet.dart';

/// الشاشة الكاملة للمكالمات الصوتية والمرئية ومشاركة الشاشة
class FullCallScreen extends StatefulWidget {
  const FullCallScreen({super.key});

  @override
  State<FullCallScreen> createState() => _FullCallScreenState();
}

class _FullCallScreenState extends State<FullCallScreen> {
  final _callsManager = GetIt.I<CallsManager>();

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
          IconButton(
            icon: const Icon(Icons.admin_panel_settings, color: Colors.white),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (_) => const HostControlsBottomSheet(),
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

          final remoteRenderers = _callsManager.remoteRenderers;

          return SafeArea(
            child: Column(
              children: [
                // شبكة المشاركين بالصوت والفيديو
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: remoteRenderers.isEmpty
                        ? _buildSingleLocalParticipantView(state)
                        : _buildMultiParticipantsGrid(state, remoteRenderers),
                  ),
                ),

                // شريط التفاعلات بالإيموجي
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

  Widget _buildMultiParticipantsGrid(
    CallConnectedState state,
    Map<String, RTCVideoRenderer> remoteRenderers,
  ) {
    final renderersList = remoteRenderers.values.toList();
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: renderersList.length > 2 ? 2 : 1,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: renderersList.length,
      itemBuilder: (context, index) {
        final renderer = renderersList[index];
        return Container(
          decoration: BoxDecoration(
            color: Colors.black45,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white24),
          ),
          clipBehavior: Clip.antiAlias,
          child: RTCVideoView(renderer),
        );
      },
    );
  }

  Widget _buildEmojiReactionsBar(BuildContext context) {
    final emojis = ['👍', '👏', '❤️', '🎉', '✋'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: emojis.map((emoji) {
        return GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('تم التفاعل: $emoji'),
                duration: const Duration(seconds: 1),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 6),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Text(
              emoji,
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
