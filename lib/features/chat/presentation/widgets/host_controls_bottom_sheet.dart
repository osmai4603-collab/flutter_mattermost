import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/features/chat/presentation/bloc/calls_bloc.dart';

/// قائمة أدوات المشرف السفلية — للتحكم بالمكالمة والمشاركين
class HostControlsBottomSheet extends StatelessWidget {
  const HostControlsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.back_hand_outlined, color: Colors.lightBlueAccent),
            title: const Text('إخفاض الأيدي المرفوعة', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.record_voice_over, color: Colors.greenAccent),
            title: const Text('طلب التحدث من الجميع', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const Divider(color: Colors.white24),
          ListTile(
            leading: const Icon(Icons.call_end, color: Colors.redAccent),
            title: const Text('إنهاء المكالمة للجميع', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
            onTap: () {
              context.read<CallsBloc>().add(EndCallEvent());
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
