import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_mattermost/core/calls/calls_manager.dart';
import 'package:flutter_mattermost/features/chat/presentation/bloc/calls_bloc.dart';

class HostControlsPanel extends StatelessWidget {
  const HostControlsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final manager = GetIt.I<CallsManager>();

    return BlocBuilder<CallsBloc, CallsState>(
      builder: (context, state) {
        final participants = (state is CallConnectedState)
            ? state.participants.values.toList()
            : <CallParticipantState>[];

        return Container(
          width: 300,
          decoration: const BoxDecoration(
            color: Color(0xFF1E293B),
            border: Border(left: BorderSide(color: Colors.white10)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Host Controls',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    _buildTile(
                      icon: Icons.mic_off,
                      title: 'Mute All',
                      onTap: () => manager.hostMuteAll(),
                    ),
                    _buildTile(
                      icon: Icons.back_hand_outlined,
                      title: 'Lower All Hands',
                      onTap: () => manager.hostLowerAllHands(),
                    ),
                    const Divider(color: Colors.white10),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text('Participants', style: TextStyle(color: Colors.white60, fontSize: 12)),
                    ),
                    ...participants.map((p) => _ParticipantControlTile(participant: p, manager: manager)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton.icon(
                  onPressed: () => manager.hostEndCall(),
                  icon: const Icon(Icons.call_end),
                  label: const Text('End Call for All'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(40),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTile({required IconData icon, required String title, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70, size: 20),
      title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 14)),
      onTap: onTap,
    );
  }
}

class _ParticipantControlTile extends StatelessWidget {
  final CallParticipantState participant;
  final CallsManager manager;

  const _ParticipantControlTile({required this.participant, required this.manager});

  @override
  Widget build(BuildContext context) {
    if (participant.isHost) return const SizedBox.shrink();

    return ListTile(
      dense: true,
      title: Text(
        'User: ${participant.userId.substring(0, 5)}...',
        style: const TextStyle(color: Colors.white, fontSize: 13),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(participant.isMuted ? Icons.mic_off : Icons.mic, size: 16),
            color: participant.isMuted ? Colors.redAccent : Colors.white54,
            onPressed: () => manager.hostMute(participant.sessionId),
          ),
          IconButton(
            icon: const Icon(Icons.person_remove, size: 16, color: Colors.redAccent),
            onPressed: () => manager.hostRemove(participant.sessionId),
          ),
        ],
      ),
    );
  }
}
