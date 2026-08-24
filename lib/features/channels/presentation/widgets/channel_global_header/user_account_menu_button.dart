import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/modals/modal_identifiers.dart';
import 'package:flutter_mattermost/core/modals/modal_registry.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/widgets/matter_menu.dart';
import 'package:flutter_mattermost/core/widgets/profile_picture.dart';
import 'package:flutter_mattermost/features/auth/domain/entities/user_status_entity.dart';
import 'package:flutter_mattermost/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_mattermost/features/users/presentation/bloc/user_status_bloc.dart';

/// زر حساب المستخدم (أفاتار 24 + حالة) — يطابق user_account_menuButton.
class UserAccountMenuButton extends StatelessWidget {
  const UserAccountMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);
    final authState = context.watch<AuthBloc>().state;
    final user = authState is AuthenticatedState ? authState.user : null;

    final statusBloc = context.read<UserStatusBloc>();
    final statusState = context.watch<UserStatusBloc>().state;
    final myStatus = statusState is UserStatusesLoadedState
        ? (statusState.statusOf(user?.id ?? 'me') ??
              statusState.statusOf('me') ??
              UserStatus.online)
        : UserStatus.online;

    return MatterMenuScope(
      openUp: false,
      items: [
        MatterMenuItem(
          id: 'name',
          label: '',
          icon: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 200,
              child: Row(
                spacing: 16,
                children: [
                  ProfilePicture(
                    size: 38,
                    userId: user?.id,
                    username: user?.username ?? '?',
                    avatarUrl: null,
                    status: myStatus,
                    showStatus: true,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${user?.firstName ?? ""} ${user?.lastName ?? ''}"
                                .trim()
                                .isEmpty
                            ? (user?.username ?? '')
                            : "${user?.firstName ?? ""} ${user?.lastName ?? ''}",
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.sidebarBg,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        '@${user?.username ?? ''}',
                        style: TextStyle(fontSize: 14, color: theme.sidebarBg),
                      ),
                    ],
                  ),
                  const SizedBox(width: 1),
                ],
              ),
            ),
          ),
          onTap: () {
            ModalRegistry.open(context, id: ModalIdentifiers.userProfile);
          },
        ),
        MatterMenuItem.divider(),
        MatterMenuItem(
          id: 'custom_status',
          label: l10n.userAccountMenuSetCustomStatus,
          icon: const Icon(Icons.emoji_emotions_outlined, size: 18),
          onTap: () {
            ModalRegistry.open(context, id: ModalIdentifiers.customStatus);
          },
        ),
        MatterMenuItem.divider(),
        MatterMenuItem(
          id: 'status_online',
          label: l10n.statusSetOnline,
          icon: const Icon(Icons.check_circle, size: 18, color: Colors.green),
          trailingIcon: myStatus == UserStatus.online
              ? Icon(Icons.check, size: 18, color: theme.sidebarBg)
              : null,
          onTap: () =>
              statusBloc.add(const SetMyUserStatusEvent(UserStatus.online)),
        ),
        MatterMenuItem(
          id: 'status_away',
          label: l10n.statusSetAway,
          icon: const Icon(Icons.punch_clock, size: 18, color: Colors.orange),
          trailingIcon: myStatus == UserStatus.away
              ? Icon(Icons.check, size: 18, color: theme.sidebarBg)
              : null,
          onTap: () =>
              statusBloc.add(const SetMyUserStatusEvent(UserStatus.away)),
        ),
        MatterMenuItem(
          id: 'status_dnd',
          label: l10n.statusSetDnd,
          subtitle: 'Disable all notifications',
          icon: const Icon(Icons.remove_circle, size: 18, color: Colors.red),
          trailingIcon: myStatus == UserStatus.dnd
              ? Icon(Icons.check, size: 18, color: theme.sidebarBg)
              : null,
          onTap: () =>
              statusBloc.add(const SetMyUserStatusEvent(UserStatus.dnd)),
        ),
        MatterMenuItem(
          id: 'status_offline',
          label: l10n.statusSetOffline,
          icon: const Icon(
            Icons.offline_pin_rounded,
            size: 18,
            color: Colors.grey,
          ),
          trailingIcon: myStatus == UserStatus.offline
              ? Icon(Icons.check, size: 18, color: theme.sidebarBg)
              : null,
          onTap: () =>
              statusBloc.add(const SetMyUserStatusEvent(UserStatus.offline)),
        ),

        MatterMenuItem(
          id: 'profile',
          label: l10n.userAccountMenuProfile,
          icon: const Icon(Icons.account_circle_outlined, size: 18),
          separatorBefore: true,
          onTap: () {
            ModalRegistry.open(
              context,
              id: ModalIdentifiers.userSettings,
              args: const {'initialTab': 'profile'},
            );
          },
        ),

        MatterMenuItem(
          id: 'logout',
          label: l10n.statusLogout,
          icon: const Icon(Icons.logout, size: 18),
          separatorBefore: true,
          onTap: () => context.read<AuthBloc>().add(LogoutRequestedEvent()),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Row(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                ProfilePicture(
                  size: 26,
                  userId: user?.id,
                  username: user?.username ?? '?',
                  avatarUrl: null,
                  status: myStatus,
                  showStatus: true,
                ),
                Icon(
                  Icons.expand_more,
                  size: 16,
                  color: theme.sidebarText.withValues(alpha: 0.64),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
