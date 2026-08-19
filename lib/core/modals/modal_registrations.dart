import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/modals/modal_identifiers.dart';
import 'package:flutter_mattermost/core/modals/modal_registry.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/widgets/generic_modal.dart';
import 'package:flutter_mattermost/core/enums/channel_type.dart';
import 'package:flutter_mattermost/features/app/presentation/pages/app_settings_page.dart';
import 'package:flutter_mattermost/features/channels/presentation/bloc/channel_bloc.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/features/channels/domain/repositories/channel_repository.dart';
import 'package:flutter_mattermost/features/channels/presentation/modals/channel_invite_modal.dart';
import 'package:flutter_mattermost/features/channels/presentation/modals/channel_notifications_modal.dart';
import 'package:flutter_mattermost/features/channels/presentation/modals/channel_settings_modal.dart';
import 'package:flutter_mattermost/features/channels/presentation/modals/direct_channels_modal.dart';
import 'package:flutter_mattermost/features/channels/presentation/modals/keyboard_shortcuts_modal.dart';
import 'package:flutter_mattermost/features/channels/presentation/pages/create_new_channel.dart';
import 'package:flutter_mattermost/features/chat/presentation/bloc/threads_bloc.dart';
import 'package:flutter_mattermost/features/teams/presentation/bloc/team_bloc.dart';
import 'package:flutter_mattermost/features/teams/presentation/modals/team_settings_modal.dart';
import 'package:flutter_mattermost/features/teams/presentation/widgets/invitation_modal.dart';
import 'package:flutter_mattermost/features/users/presentation/pages/user_profile_page.dart';
import 'package:flutter_mattermost/features/users/presentation/pages/user_settings_modal.dart';

/// تسجيل نوافذ webapp المنبثقة (مكافئ ModalController.registerModal)
/// ليتم فتحها عبر [ModalRegistry.open] بأي مكان.
void registerMattermostModals() {
  ModalRegistry.register(
    ModalIdentifiers.moreChannels,
    (context, args) => const _BrowseChannelsModal(),
  );
  ModalRegistry.register(
    ModalIdentifiers.renameChannel,
    (context, args) => const _RenameChannelModal(),
  );
  ModalRegistry.register(
    ModalIdentifiers.appSettings,
    (context, args) => const AppSettingsPage(),
  );
  ModalRegistry.register(
    ModalIdentifiers.editChannelHeader,
    (context, args) => const _EditChannelHeaderModal(),
  );
  ModalRegistry.register(
    ModalIdentifiers.editChannelPurpose,
    (context, args) => const _EditChannelPurposeModal(),
  );
  ModalRegistry.register(
    ModalIdentifiers.markAllThreadsAsRead,
    (context, args) => const _MarkAllThreadsAsReadModal(),
  );
  ModalRegistry.register(
    ModalIdentifiers.userSettings,
    (context, args) => UserSettingsModal(
      initialTab: _userSettingsTab(args?['initialTab'] as String?),
    ),
  );
  ModalRegistry.register(
    ModalIdentifiers.userProfile,
    (context, args) => const UserProfilePage(),
  );
  ModalRegistry.register(
    ModalIdentifiers.invitePeopleInTeam,
    (context, args) => const InvitePeopleToTeam(),
  );
  ModalRegistry.register(
    ModalIdentifiers.channelInvite,
    (context, args) => const ChannelInviteModal(),
  );
  ModalRegistry.register(
    ModalIdentifiers.channelSettings,
    (context, args) => const ChannelSettingsModal(),
  );
  ModalRegistry.register(
    ModalIdentifiers.channelNotifications,
    (context, args) => const ChannelNotificationsModal(),
  );
  ModalRegistry.register(
    ModalIdentifiers.newChannel,
    (context, args) => const CreateNewChannel(),
  );
  ModalRegistry.register(
    ModalIdentifiers.moreDirectChannels,
    (context, args) => const DirectChannelsModal(),
  );
  ModalRegistry.register(
    ModalIdentifiers.keyboardShortcuts,
    (context, args) => const KeyboardShortcutsModal(),
  );
  ModalRegistry.register(
    ModalIdentifiers.teamSettings,
    (context, args) => const TeamSettingsModal(),
  );
}

UserSettingsTab _userSettingsTab(String? value) {
  return UserSettingsTab.values.firstWhere(
    (tab) => tab.name == value,
    orElse: () => UserSettingsTab.notifications,
  );
}

/// Browse Channels (more_channels.tsx): بحث + قائمة قنوات + زر انضمام.
class _BrowseChannelsModal extends StatefulWidget {
  const _BrowseChannelsModal();

  @override
  State<_BrowseChannelsModal> createState() => _BrowseChannelsModalState();
}

class _BrowseChannelsModalState extends State<_BrowseChannelsModal> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);

    return GenericModal(
      title: l10n.more_channelsTitle,
      body: BlocBuilder<ChannelBloc, ChannelState>(
        builder: (context, state) {
          final loaded = state is ChannelsLoadedState ? state : null;
          final channels = (loaded?.channels ?? const [])
              .where(
                (c) =>
                    c.type != ChannelType.direct &&
                    (_query.isEmpty ||
                        c.displayName.toLowerCase().contains(_query)),
              )
              .toList();
          final selectedId = loaded?.selectedChannel?.id;

          return Column(
            children: [
              TextField(
                onChanged: (value) => setState(() => _query = value),
                style: TextStyle(color: theme.centerChannelColor, fontSize: 14),
                decoration: InputDecoration(
                  hintText: l10n.search_barSearch_messages,
                  hintStyle: TextStyle(
                    color: theme.centerChannelColor.withValues(alpha: 0.5),
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    size: 18,
                    color: theme.centerChannelColor.withValues(alpha: 0.6),
                  ),
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.more_channelsCount(channels.length),
                style: TextStyle(
                  color: theme.centerChannelColor.withValues(alpha: 0.6),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 8),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 320),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (final channel in channels)
                      ListTile(
                        dense: true,
                        leading: Icon(
                          channel.type == ChannelType.private
                              ? Icons.lock_outline
                              : Icons.tag,
                          size: 18,
                          color: theme.centerChannelColor.withValues(
                            alpha: 0.6,
                          ),
                        ),
                        title: Text(
                          channel.displayName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: theme.centerChannelColor,
                            fontSize: 14,
                          ),
                        ),
                        trailing: channel.id == selectedId
                            ? Text(
                                l10n.more_channelsJoined,
                                style: TextStyle(
                                  color: theme.centerChannelColor.withValues(
                                    alpha: 0.6,
                                  ),
                                  fontSize: 12,
                                ),
                              )
                            : FilledButton(
                                style: FilledButton.styleFrom(
                                  backgroundColor: theme.buttonBg,
                                  foregroundColor: theme.buttonColor,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  minimumSize: const Size(0, 28),
                                ),
                                onPressed: () {
                                  context.read<ChannelBloc>().add(
                                    SelectChannelEvent(channel),
                                  );
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  l10n.more_channelsJoined,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                        onTap: () {
                          context.read<ChannelBloc>().add(
                            SelectChannelEvent(channel),
                          );
                          Navigator.of(context).pop();
                        },
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      confirmLabel: l10n.more_channelsCreate,
      onConfirm: () => _openCreateChannel(context),
    );
  }

  void _openCreateChannel(BuildContext context) {
    ModalRegistry.open(context, id: ModalIdentifiers.newChannel);
  }
}

/// إعادة تسمية القناة (webapp rename_channel_modal).
class _RenameChannelModal extends StatelessWidget {
  const _RenameChannelModal();

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);

    final state = context.read<ChannelBloc>().state;
    final channel = state is ChannelsLoadedState ? state.selectedChannel : null;
    final controller = TextEditingController(text: channel?.displayName ?? '');

    return GenericModal(
      title: l10n.modalRenameChannelTitle,
      body: TextField(
        controller: controller,
        autofocus: true,
        style: TextStyle(color: theme.centerChannelColor, fontSize: 14),
        decoration: const InputDecoration(
          isDense: true,
          border: OutlineInputBorder(),
        ),
      ),
      confirmLabel: l10n.generic_modalConfirm,
      onConfirm: () async {
        if (channel == null) {
          Navigator.of(context).pop();
          return;
        }
        final newName = controller.text.trim();
        if (newName.isNotEmpty) {
          try {
            await getIt<ChannelRepository>().updateChannel(
              channel.id,
              name: channel.name,
              displayName: newName,
              purpose: channel.purpose,
              header: channel.header,
            );
            final updated = channel.copyWith(displayName: newName);
            if (context.mounted) {
              context.read<ChannelBloc>().add(UpdateChannelEvent(updated));
            }
          } catch (_) {}
        }
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      },
    );
  }
}

class _EditChannelHeaderModal extends StatelessWidget {
  const _EditChannelHeaderModal();

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);
    final state = context.watch<ChannelBloc>().state;
    final channel = state is ChannelsLoadedState ? state.selectedChannel : null;
    final controller = TextEditingController(text: channel?.header ?? '');

    return GenericModal(
      title: l10n.channel_info_rhsAbout_areaEdit_channel_header,
      body: TextField(
        controller: controller,
        autofocus: true,
        maxLines: 6,
        minLines: 2,
        style: TextStyle(color: theme.centerChannelColor, fontSize: 14),
        decoration: const InputDecoration(border: OutlineInputBorder()),
      ),
      confirmLabel: l10n.generic_modalConfirm,
      onConfirm: () async {
        if (channel == null) {
          Navigator.of(context).pop();
          return;
        }
        final newHeader = controller.text.trim();
        try {
          await getIt<ChannelRepository>().updateChannel(
            channel.id,
            name: channel.name,
            displayName: channel.displayName,
            purpose: channel.purpose,
            header: newHeader,
          );
          final updated = channel.copyWith(header: newHeader);
          if (context.mounted) {
            context.read<ChannelBloc>().add(UpdateChannelEvent(updated));
          }
        } catch (_) {}
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      },
    );
  }
}

class _EditChannelPurposeModal extends StatelessWidget {
  const _EditChannelPurposeModal();

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);
    final state = context.watch<ChannelBloc>().state;
    final channel = state is ChannelsLoadedState ? state.selectedChannel : null;
    final controller = TextEditingController(text: channel?.purpose ?? '');

    return GenericModal(
      title: l10n.channel_info_rhsAbout_areaEdit_channel_purpose,
      body: TextField(
        controller: controller,
        autofocus: true,
        maxLines: 6,
        minLines: 2,
        style: TextStyle(color: theme.centerChannelColor, fontSize: 14),
        decoration: const InputDecoration(border: OutlineInputBorder()),
      ),
      confirmLabel: l10n.generic_modalConfirm,
      onConfirm: () async {
        if (channel == null) {
          Navigator.of(context).pop();
          return;
        }
        final newPurpose = controller.text.trim();
        try {
          await getIt<ChannelRepository>().updateChannel(
            channel.id,
            name: channel.name,
            displayName: channel.displayName,
            purpose: newPurpose,
            header: channel.header,
          );
          final updated = channel.copyWith(purpose: newPurpose);
          if (context.mounted) {
            context.read<ChannelBloc>().add(UpdateChannelEvent(updated));
          }
        } catch (_) {}
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      },
    );
  }
}

/// تأكيد قراءة كل المحادثات (mark_all_threads_as_read_modal).
class _MarkAllThreadsAsReadModal extends StatelessWidget {
  const _MarkAllThreadsAsReadModal();

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);

    return GenericModal(
      title: l10n.mark_all_threads_as_read_modalTitle,
      body: Text(
        l10n.mark_all_threads_as_read_modalDescription,
        style: TextStyle(
          color: theme.centerChannelColor.withValues(alpha: 0.7),
          fontSize: 14,
        ),
      ),
      dismissLabel: l10n.generic_modalCancel,
      confirmLabel: l10n.mark_all_threads_as_read_modalConfirm,
      onConfirm: () {
        final state = context.read<ThreadsBloc>().state;
        final teamState = context.read<TeamBloc>().state;
        final teamId = teamState is TeamsLoadedState
            ? teamState.selectedTeam?.id ?? ''
            : '';
        if (state is ThreadsLoadedState) {
          for (final thread in state.threads) {
            if (thread.hasUnread) {
              context.read<ThreadsBloc>().add(
                MarkThreadReadEvent(
                  userId: 'me',
                  teamId: teamId,
                  threadId: thread.rootPostId,
                ),
              );
            }
          }
        }
        Navigator.of(context).pop();
      },
    );
  }
}
