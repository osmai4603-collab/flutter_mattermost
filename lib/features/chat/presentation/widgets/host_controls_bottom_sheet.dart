import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_mattermost/core/calls/calls_manager.dart';
import 'package:flutter_mattermost/features/chat/presentation/bloc/calls_bloc.dart';

/// قائمة أدوات المشرف السفلية — أوامر مضيف حقيقية عبر CallsManager:
/// كتم الكل / إنزال الأيدي / طرد مشارك / إنهاء المكالمة للجميع.
class HostControlsBottomSheet extends StatelessWidget {
  const HostControlsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final manager = GetIt.I<CallsManager>();

    return BlocBuilder<CallsBloc, CallsState>(
      builder: (context, state) {
        final participants = (state is CallConnectedState)
            ? state.participants.values.toList()
            : <CallParticipantState>[];

        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.6,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          decoration: const BoxDecoration(
            color: Color(0xFF1E2638),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white30,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'أدوات وخيارات المشرف',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.mic_off, color: Colors.amber),
                title: const Text('كتم جميع المشاركين', style: TextStyle(color: Colors.white)),
                onTap: () async {
                  await manager.hostMuteAll();
                  if (context.mounted) Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.back_hand_outlined, color: Colors.lightBlueAccent),
                title: const Text('إخفاض الأيدي المرفوعة', style: TextStyle(color: Colors.white)),
                onTap: () async {
                  await manager.hostLowerAllHands();
                  if (context.mounted) Navigator.pop(context);
                },
              ),
              if (participants.isNotEmpty) ...[
                const Divider(color: Colors.white24),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Text(
                    'المشاركون (طرد)',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 180),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: participants.length,
                    itemBuilder: (context, index) {
                      final participant = participants[index];
                      if (participant.isHost) {
                        return const SizedBox.shrink();
                      }
                      return ListTile(
                        leading: Icon(
                          participant.isMuted ? Icons.mic_off : Icons.mic,
                          color: participant.isMuted ? Colors.redAccent : Colors.white54,
                        ),
                        title: Text(
                          'جلسة ${participant.sessionId.substring(0, 8)}',
                          style: const TextStyle(color: Colors.white),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.person_remove, color: Colors.redAccent),
                          tooltip: 'طرد',
                          onPressed: () async {
                            await manager.hostRemove(participant.sessionId);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
              const Divider(color: Colors.white24),
              ListTile(
                leading: const Icon(Icons.call_end, color: Colors.redAccent),
                title: const Text('إنهاء المكالمة للجميع', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                onTap: () async {
                  await manager.hostEndCall();
                  if (context.mounted) {
                    Navigator.pop(context);
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
