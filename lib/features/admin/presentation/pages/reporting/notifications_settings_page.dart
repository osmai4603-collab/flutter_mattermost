import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/features/admin/presentation/bloc/admin_config_bloc.dart';

/// صفحة إعدادات الإشعارات + أزرار الاختبار.
class AdminConsoleNotificationsSettingsPage extends StatelessWidget {
  const AdminConsoleNotificationsSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AdminConfigBloc>(),
      child: BlocConsumer<AdminConfigBloc, AdminConfigState>(
        listener: (context, state) {
          if (state is AdminConfigError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.redAccent,
              ),
            );
          } else if (state is AdminConfigActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green.shade700,
              ),
            );
          }
        },
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [_buildTestingCard(context, state)],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white12)),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.notifications_outlined,
            color: Colors.blueAccent,
            size: 20,
          ),
          SizedBox(width: 10),
          Text(
            'Notifications Settings',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestingCard(BuildContext context, AdminConfigState state) {
    final isWorking = state is AdminConfigLoading;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF181825),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Notification Testing',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Test the current email and push notification setup of the server.',
            style: TextStyle(color: Colors.white54, fontSize: 12),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: isWorking
                    ? null
                    : () => context.read<AdminConfigBloc>().add(
                        TestAdminEmailEvent(),
                      ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white70,
                  side: const BorderSide(color: Colors.white24),
                ),
                icon: const Icon(Icons.email_outlined, size: 16),
                label: const Text('Test Connection to Email Server'),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: isWorking
                    ? null
                    : () => context.read<AdminConfigBloc>().add(
                        TestAdminSiteUrlEvent(),
                      ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white70,
                  side: const BorderSide(color: Colors.white24),
                ),
                icon: const Icon(Icons.public, size: 16),
                label: const Text('Test Site URL'),
              ),
              const SizedBox(width: 12),
              FilledButton.icon(
                onPressed: isWorking
                    ? null
                    : () => context.read<AdminConfigBloc>().add(
                        SendTestNotificationEvent(),
                      ),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                ),
                icon: const Icon(Icons.notification_add_outlined, size: 16),
                label: const Text('Send Test Notification'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
