import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_mattermost/core/calls/calls_manager.dart';
import 'package:flutter_mattermost/features/chat/presentation/bloc/calls_bloc.dart';
import 'package:flutter_mattermost/features/chat/presentation/pages/full_call_screen.dart';

class ActiveCallBanner extends StatefulWidget {
  const ActiveCallBanner({super.key});

  @override
  State<ActiveCallBanner> createState() => _ActiveCallBannerState();
}

class _ActiveCallBannerState extends State<ActiveCallBanner> {
  Timer? _timer;
  Duration _duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final startAt = GetIt.I<CallsManager>().callStartAt;
      if (startAt != null && mounted) {
        setState(() {
          _duration = DateTime.now().difference(startAt);
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return hours > 0 ? '$hours:$minutes:$seconds' : '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CallsBloc, CallsState>(
      builder: (context, state) {
        if (state is! CallConnectedState && state is! CallReconnectingState) {
          return const SizedBox.shrink();
        }

        final isConnected = state is CallConnectedState;
        final isMuted = isConnected ? (state as CallConnectedState).isMuted : false;
        final participantCount = isConnected
            ? (state as CallConnectedState).participants.length + 1
            : 1;

        return Material(
          elevation: 4,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: isConnected ? const Color(0xFF15803D) : const Color(0xFFB45309),
            child: Row(
              children: [
                // Call status pulsing indicator
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),

                // Call title and duration
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isConnected ? 'Mattermost Call Active' : 'Reconnecting call...',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '${_formatDuration(_duration)} • $participantCount participant${participantCount > 1 ? 's' : ''}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                // Controls
                if (isConnected) ...[
                  IconButton(
                    icon: Icon(
                      isMuted ? Icons.mic_off : Icons.mic,
                      color: isMuted ? Colors.redAccent : Colors.white,
                      size: 20,
                    ),
                    tooltip: isMuted ? 'Unmute' : 'Mute',
                    onPressed: () {
                      context.read<CallsBloc>().add(ToggleMuteEvent());
                    },
                  ),
                  const SizedBox(width: 8),
                ],

                // Open full call screen button
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const FullCallScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.fullscreen, size: 18),
                  label: const Text('Expand'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
                const SizedBox(width: 8),

                // Leave button
                IconButton(
                  icon: const Icon(Icons.call_end, color: Colors.white, size: 20),
                  tooltip: 'Leave Call',
                  onPressed: () {
                    context.read<CallsBloc>().add(EndCallEvent());
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
