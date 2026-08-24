import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/widgets/profile_picture.dart';
import 'package:flutter_mattermost/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_mattermost/features/users/presentation/bloc/user_status_bloc.dart';
import 'package:flutter_mattermost/core/network/server_manager.dart';
import 'package:intl/intl.dart';

String userAvatarUrl(String userId) {
  final serverUrl = getIt<ServerManager>().activeServerUrl;
  return '$serverUrl/api/v4/users/$userId/image';
}

class UserMentionPopover extends StatelessWidget {
  final UserEntity user;
  final int mentionTime;
  final VoidCallback? onMessage;
  final VoidCallback? onAddPerson;
  final VoidCallback? onCall;
  final VoidCallback? onClose;

  const UserMentionPopover({
    super.key,
    required this.user,
    required this.mentionTime,
    this.onMessage,
    this.onAddPerson,
    this.onCall,
    this.onClose,
  });

  String _localTime(UserTimezone timezone) {
    final now = DateTime.now().toUtc();
    var offsetMinutes = 0;
    final manual = timezone.manualTimezone;
    final match = RegExp(
      r'UTC([+-])(\d{1,2})(?::?(\d{2}))?',
    ).firstMatch(manual);
    if (match != null) {
      final sign = match.group(1) == '-' ? -1 : 1;
      final hours = int.parse(match.group(2)!);
      final minutes = int.tryParse(match.group(3) ?? '') ?? 0;
      offsetMinutes = sign * (hours * 60 + minutes);
    }
    final local = now.add(Duration(minutes: offsetMinutes));
    return DateFormat('hh:mm a').format(local);
  }

  String _formatMentionTime(int timestamp) {
    final dt = DateTime.fromMillisecondsSinceEpoch(timestamp).toLocal();
    return DateFormat('MMM d, yyyy hh:mm a').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);
    final status =
        context.watch<UserStatusBloc>().state is UserStatusesLoadedState
        ? (context.read<UserStatusBloc>().state as UserStatusesLoadedState)
              .statusOf(user.id)
        : null;

    return Container(
      width: 320,
      decoration: BoxDecoration(
        color: theme.centerChannelBg,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 24, bottom: 16),
                child: Center(
                  child: ProfilePicture(
                    userId: user.id,
                    username: user.username,
                    avatarUrl: userAvatarUrl(user.id),
                    status: status,
                    size: 80,
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: onClose ?? () => Navigator.of(context).pop(),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  splashRadius: 20,
                ),
              ),
            ],
          ),
          Text(
            user.nickname.isNotEmpty
                ? user.nickname
                : '${user.firstName} ${user.lastName}'.trim(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: theme.centerChannelColor,
            ),
          ),
          Text(
            '@${user.username}',
            style: TextStyle(
              fontSize: 14,
              color: theme.centerChannelColor.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.email_outlined, size: 20),
            title: Text(
              user.email.isNotEmpty ? user.email : 'No email provided',
              style: TextStyle(fontSize: 14, color: theme.centerChannelColor),
            ),
            dense: true,
          ),
          ListTile(
            leading: const Icon(Icons.access_time, size: 20),
            title: Text(
              'Local time: ${_localTime(user.timezone)}',
              style: TextStyle(fontSize: 14, color: theme.centerChannelColor),
            ),
            dense: true,
          ),
          ListTile(
            leading: const Icon(Icons.history, size: 20),
            title: Text(
              'Mentioned at: ${_formatMentionTime(mentionTime)}',
              style: TextStyle(fontSize: 14, color: theme.centerChannelColor),
            ),
            dense: true,
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: onMessage,
                    icon: const Icon(Icons.send, size: 18),
                    label: const Text('Message'),
                    style: FilledButton.styleFrom(
                      backgroundColor: theme.buttonBg,
                      foregroundColor: theme.buttonColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Tooltip(
                  message: 'Add to channel',
                  child: IconButton(
                    onPressed: onAddPerson,
                    icon: const Icon(Icons.person_add_outlined),
                    color: theme.centerChannelColor.withValues(alpha: 0.7),
                  ),
                ),
                Tooltip(
                  message: 'Start call',
                  child: IconButton(
                    onPressed: onCall,
                    icon: const Icon(Icons.phone_outlined),
                    color: theme.centerChannelColor.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
