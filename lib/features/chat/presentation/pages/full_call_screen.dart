import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_mattermost/core/calls/calls_manager.dart';
import 'package:flutter_mattermost/features/chat/presentation/bloc/calls_bloc.dart';
import 'package:flutter_mattermost/features/chat/presentation/widgets/calls/call_grid_view.dart';
import 'package:flutter_mattermost/features/chat/presentation/widgets/calls/host_controls_panel.dart';

class FullCallScreen extends StatefulWidget {
  const FullCallScreen({super.key});

  @override
  State<FullCallScreen> createState() => _FullCallScreenState();
}

class _FullCallScreenState extends State<FullCallScreen> {
  final _callsManager = GetIt.I<CallsManager>();
  bool _showHostControls = false;

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
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white70),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: BlocBuilder<CallsBloc, CallsState>(
          builder: (context, state) {
            final count = (state is CallConnectedState) ? state.participants.length + 1 : 0;
            return Text(
              'Mattermost Call ($count participants)',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.admin_panel_settings,
              color: _showHostControls ? Colors.blueAccent : Colors.white70,
            ),
            onPressed: () => setState(() => _showHostControls = !_showHostControls),
          ),
        ],
      ),
      body: BlocBuilder<CallsBloc, CallsState>(
        builder: (context, state) {
          if (state is! CallConnectedState) {
            return const Center(
              child: Text('Call ended', style: TextStyle(color: Colors.white70)),
            );
          }

          final participants = state.participants.values.toList();

          return Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    // Reaction Overlay (Simplified for Desktop)
                    if (_activeReactions.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Wrap(
                          spacing: 8,
                          children: _activeReactions.map((r) => Text(r.emojiLiteral, style: const TextStyle(fontSize: 24))).toList(),
                        ),
                      ),
                    
                    // Main Grid
                    Expanded(
                      child: CallGridView(participants: participants),
                    ),

                    // Controls
                    _buildControls(context, state),
                  ],
                ),
              ),
              if (_showHostControls && _callsManager.isCurrentUserHost)
                const HostControlsPanel(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildControls(BuildContext context, CallConnectedState state) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      color: const Color(0xFF1E293B),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _controlButton(
            icon: state.isMuted ? Icons.mic_off : Icons.mic,
            color: state.isMuted ? Colors.redAccent : Colors.white70,
            onPressed: () => context.read<CallsBloc>().add(ToggleMuteEvent()),
          ),
          const SizedBox(width: 16),
          _controlButton(
            icon: state.isVideoOn ? Icons.videocam : Icons.videocam_off,
            color: state.isVideoOn ? Colors.greenAccent : Colors.white70,
            onPressed: () => context.read<CallsBloc>().add(ToggleVideoEvent()),
          ),
          const SizedBox(width: 16),
          _controlButton(
            icon: Icons.screen_share,
            color: Colors.white70,
            onPressed: () => context.read<CallsBloc>().add(ToggleShareScreenEvent()),
          ),
          const SizedBox(width: 32),
          _controlButton(
            icon: Icons.call_end,
            color: Colors.red,
            size: 32,
            onPressed: () {
              context.read<CallsBloc>().add(EndCallEvent());
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Widget _controlButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    double size = 24,
  }) {
    return IconButton(
      icon: Icon(icon, color: color, size: size),
      onPressed: onPressed,
      padding: const EdgeInsets.all(12),
      style: IconButton.styleFrom(
        backgroundColor: Colors.white.withValues(alpha: 0.05),
      ),
    );
  }
}
