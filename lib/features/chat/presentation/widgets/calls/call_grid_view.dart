import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter_mattermost/core/calls/calls_manager.dart';
import 'package:flutter_mattermost/features/users/domain/repositories/user_repository.dart';
import 'package:get_it/get_it.dart';

class CallGridView extends StatelessWidget {
  final List<CallParticipantState> participants;
  final bool isFullscreen;

  const CallGridView({
    super.key,
    required this.participants,
    this.isFullscreen = false,
  });

  @override
  Widget build(BuildContext context) {
    if (participants.isEmpty) {
      return const Center(
        child: Text(
          'No participants connected',
          style: TextStyle(color: Colors.white60),
        ),
      );
    }

    // Grid layout logic for Desktop
    int crossAxisCount = 1;
    if (participants.length > 1) crossAxisCount = 2;
    if (participants.length > 4) crossAxisCount = 3;
    if (participants.length > 9) crossAxisCount = 4;

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 16 / 9,
      ),
      itemCount: participants.length,
      itemBuilder: (context, index) {
        return _ParticipantTile(participant: participants[index]);
      },
    );
  }
}

class _ParticipantTile extends StatefulWidget {
  final CallParticipantState participant;
  const _ParticipantTile({required this.participant});

  @override
  State<_ParticipantTile> createState() => _ParticipantTileState();
}

class _ParticipantTileState extends State<_ParticipantTile> {
  String? _displayName;

  @override
  void initState() {
    super.initState();
    _resolveName();
  }

  Future<void> _resolveName() async {
    try {
      final users = await GetIt.I<UserRepository>()
          .getProfilesByIds([widget.participant.userId]);
      if (!mounted || users.isEmpty) return;
      final user = users.first;
      final full = '${user.firstName} ${user.lastName}'.trim();
      setState(() => _displayName = full.isNotEmpty ? full : user.username);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final participant = widget.participant;
    final hasVideo = participant.renderer != null && participant.isVideoOn;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: participant.isVoiceActive ? Colors.greenAccent : Colors.transparent,
          width: 2,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: hasVideo
                ? RTCVideoView(participant.renderer!, objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover)
                : Center(
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.blueGrey,
                      child: Text(
                        (_displayName ?? participant.userId).substring(0, 1).toUpperCase(),
                        style: const TextStyle(fontSize: 32, color: Colors.white),
                      ),
                    ),
                  ),
          ),
          // Participant info overlay
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withValues(alpha: 0.8), Colors.transparent],
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _displayName ?? '...',
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (participant.isMuted)
                    const Icon(Icons.mic_off, size: 14, color: Colors.redAccent),
                  if (participant.isHandRaised)
                    const Icon(Icons.back_hand, size: 14, color: Colors.amber),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
