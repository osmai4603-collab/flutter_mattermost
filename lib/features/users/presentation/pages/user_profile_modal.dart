import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/utils/mention_utils.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/modals/modal_identifiers.dart';
import 'package:flutter_mattermost/core/modals/modal_registry.dart';
import 'package:flutter_mattermost/core/network/server_manager.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/widgets/matter_button.dart';
import 'package:flutter_mattermost/core/widgets/profile_picture.dart';
import 'package:flutter_mattermost/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_mattermost/features/auth/domain/entities/user_status_entity.dart';
import 'package:flutter_mattermost/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_mattermost/features/channels/domain/repositories/channel_repository.dart';
import 'package:flutter_mattermost/features/channels/presentation/bloc/channel_bloc.dart';
import 'package:flutter_mattermost/features/chat/presentation/bloc/calls_bloc.dart';
import 'package:flutter_mattermost/features/users/presentation/bloc/user_profile_bloc.dart';
import 'package:flutter_mattermost/features/users/presentation/bloc/user_status_bloc.dart';

/// رابط صورة العضو — مطابق `$server/api/v4/users/{id}/image`.
String userAvatarUrl(String userId) {
  final serverUrl = getIt<ServerManager>().activeServerUrl;
  return '$serverUrl/api/v4/users/$userId/image';
}

/// نافذة بطاقة المستخدم — تظهر عند النقر على اسم/صورة المستخدم في الرسائل
/// أو في قائمة أعضاء القناة (نظير UserProfilePopover في webapp):
/// صورة + اسم + @username + الحالة + الوظيفة + البريد + التوقيت المحلي،
/// مع إرسال رسالة مباشرة أو بدء مكالمة.
Future<void> showUserProfile(BuildContext context, String userId) {
  return showDialog<void>(
    context: context,
    builder: (_) => _UserProfileModal(userId: userId),
  );
}

class _UserProfileModal extends StatefulWidget {
  final String userId;

  const _UserProfileModal({required this.userId});

  @override
  State<_UserProfileModal> createState() => _UserProfileModalState();
}

class _UserProfileModalState extends State<_UserProfileModal> {
  bool _sendingDm = false;

  @override
  void initState() {
    super.initState();
    context.read<UserProfileBloc>().add(
      LoadProfilesByIdsEvent([widget.userId]),
    );
    context.read<UserStatusBloc>().add(LoadUserStatusesEvent([widget.userId]));
  }

  String _displayName(UserEntity user) {
    return getMentionDisplayName(
      username: user.username,
      nickname: user.nickname,
      firstName: user.firstName,
      lastName: user.lastName,
    );
  }

  String _statusLabel(AppLocalizations l10n, UserStatus? status) {
    switch (status) {
      case UserStatus.online:
        return l10n.statusSetOnline;
      case UserStatus.away:
        return l10n.statusSetAway;
      case UserStatus.dnd:
        return l10n.statusSetDnd;
      case UserStatus.offline:
        return l10n.statusSetOffline;
      case null:
        return '';
    }
  }

  /// التوقيت المحلي للمستخدم من إعدادات المنطقة الزمنية (دعم الإزاحة اليدوية
  /// بصيغة UTC±HH[:MM])؛ وإلا يُعرض توقيت الجهاز كتقريب.
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
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(local.hour)}:${two(local.minute)}';
  }

  Future<void> _startDirectMessage() async {
    setState(() => _sendingDm = true);
    try {
      final channelState = context.read<ChannelBloc>().state;
      final myId = channelState is ChannelsLoadedState
          ? channelState.userId
          : '';
      final channel = await getIt<ChannelRepository>().createDirectChannel([
        myId,
        widget.userId,
      ]);
      if (!mounted) return;
      Navigator.of(context).pop();
      context.read<ChannelBloc>().add(SelectChannelEvent(channel));
    } catch (_) {
      if (!mounted) return;
      setState(() => _sendingDm = false);
    }
  }

  Future<void> _startCall() async {
    setState(() => _sendingDm = true);
    try {
      final channelState = context.read<ChannelBloc>().state;
      final myId = channelState is ChannelsLoadedState
          ? channelState.userId
          : '';
      final channel = await getIt<ChannelRepository>().createDirectChannel([
        myId,
        widget.userId,
      ]);
      if (!mounted) return;
      Navigator.of(context).pop();
      context.read<ChannelBloc>().add(UpsertChannelEvent(channel));
      context.read<CallsBloc>().add(StartCallEvent(channel.id));
    } catch (_) {
      if (!mounted) return;
      setState(() => _sendingDm = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);

    return Dialog(
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(20),
        child: BlocBuilder<UserProfileBloc, UserProfileState>(
          builder: (context, profState) {
            final UserEntity? user;
            if (profState is UserProfileLoadedState) {
              user = profState.profiles
                  .where((p) => p.id == widget.userId)
                  .firstOrNull;
            } else {
              user = null;
            }

            final authState = context.read<AuthBloc>().state;
            final myUserId = authState is AuthenticatedState
                ? authState.user.id
                : '';
            final isSelf = user != null && user.id == myUserId;

            final status =
                context.watch<UserStatusBloc>().state is UserStatusesLoadedState
                ? (context.read<UserStatusBloc>().state
                          as UserStatusesLoadedState)
                      .statusOf(widget.userId)
                : null;

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (user == null)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: CircularProgressIndicator(strokeWidth: 2.5),
                  )
                else ...[
                  ProfilePicture(
                    userId: user.id,
                    username: user.username,
                    avatarUrl: userAvatarUrl(user.id),
                    status: status,
                    size: 64,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _displayName(user),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: theme.centerChannelColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '@${user.username}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: theme.centerChannelColor.withValues(alpha: 0.6),
                      fontSize: 13.5,
                    ),
                  ),
                  if (status != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      _statusLabel(l10n, status),
                      style: TextStyle(
                        color: theme.centerChannelColor.withValues(alpha: 0.45),
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                  if (user.position.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      user.position,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: theme.centerChannelColor.withValues(alpha: 0.6),
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                  if (user.email.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      user.email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: theme.centerChannelColor.withValues(alpha: 0.6),
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                  const SizedBox(height: 4),
                  Text(
                    'Local time ${_localTime(user.timezone)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: theme.centerChannelColor.withValues(alpha: 0.6),
                      fontSize: 12.5,
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (isSelf)
                      TextButton(
                        onPressed: () {
                          ModalRegistry.open(
                            context,
                            id: ModalIdentifiers.userProfile,
                          );
                        },
                        child: Text(l10n.userProfileModalViewFullProfile),
                      ),
                    const Spacer(),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(l10n.userProfileModalClose),
                    ),
                    const SizedBox(width: 8),
                    MatterButton(
                      onPressed: _sendingDm ? null : _startDirectMessage,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            size: 16,
                            color: theme.buttonColor,
                          ),
                          const SizedBox(width: 8),
                          Text(l10n.userProfileModalSendMessage),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    MatterButton(
                      transparent: true,
                      onPressed: _sendingDm ? null : _startCall,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.phone_outlined,
                            size: 16,
                            color: theme.buttonBg,
                          ),
                          const SizedBox(width: 8),
                          Text(l10n.channelHeaderStartCall),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
