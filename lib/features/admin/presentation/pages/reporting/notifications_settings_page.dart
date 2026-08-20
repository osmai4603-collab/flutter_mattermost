import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/features/admin/presentation/bloc/admin_config_bloc.dart';

/// صفحة إعدادات الإشعارات + أزرار الاختبار.
class AdminConsoleNotificationsSettingsPage extends StatelessWidget {
  const AdminConsoleNotificationsSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.of(context);
    return Scaffold(
      backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(65),
        child: Container(
          color: colors.centerChannelBg,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Notifications Settings',
              style: TextStyle(
                color: colors.centerChannelColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      body: BlocProvider(
        create: (_) => getIt<AdminConfigBloc>(),
        child: BlocConsumer<AdminConfigBloc, AdminConfigState>(
          listener: (context, state) {
            if (state is AdminConfigError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: colors.errorTextColor,
                ),
              );
            } else if (state is AdminConfigActionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: colors.onlineIndicator,
                ),
              );
            }
          },
          builder: (context, state) {
            return Column(
              spacing: 24,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
      ),
    );
  }

  Widget _buildTestingCard(BuildContext context, AdminConfigState state) {
    final colors = AppTheme.of(context);
    final isWorking = state is AdminConfigLoading;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.mentionHighlightBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: colors.centerChannelColor.withValues(alpha: 0.12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Notification Testing',
            style: TextStyle(
              color: colors.centerChannelColor,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Test the current email and push notification setup of the server.',
            style: TextStyle(
              color: colors.centerChannelColor.withValues(alpha: 0.54),
              fontSize: 12,
            ),
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
                  foregroundColor: colors.buttonColor.withValues(alpha: 0.70),
                  side: BorderSide(
                    color: colors.centerChannelColor.withValues(alpha: 0.24),
                  ),
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
                  foregroundColor: colors.buttonColor.withValues(alpha: 0.70),
                  side: BorderSide(
                    color: colors.centerChannelColor.withValues(alpha: 0.24),
                  ),
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
                style: FilledButton.styleFrom(backgroundColor: colors.buttonBg),
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
