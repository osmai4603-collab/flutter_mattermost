import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/features/chat/presentation/bloc/calls_bloc.dart';
import 'package:flutter_mattermost/features/chat/presentation/pages/full_call_screen.dart';

/// شريط المكالمة النشطة العلوي — يظهر أعلى القناة أثناء وجود حالة CallConnectedState
class ActiveCallGlobalBanner extends StatelessWidget {
  const ActiveCallGlobalBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CallsBloc, CallsState>(
      builder: (context, state) {
        if (state is! CallConnectedState) {
          return const SizedBox.shrink();
        }

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.green.shade700,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.call, color: Colors.white, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'مكالمة نشطة الآن',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'المشاركون: ${state.participants.length + 1}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  state.isMuted ? Icons.mic_off : Icons.mic,
                  color: Colors.white,
                ),
                onPressed: () {
                  context.read<CallsBloc>().add(ToggleMuteEvent());
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.green.shade800,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const FullCallScreen()),
                  );
                },
                child: const Text('العودة للمكالمة'),
              ),
            ],
          ),
        );
      },
    );
  }
}
