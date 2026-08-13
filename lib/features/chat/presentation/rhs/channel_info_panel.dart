import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/enums/channel_category_type.dart';
import 'package:flutter_mattermost/core/enums/channel_type.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/modals/modal_identifiers.dart';
import 'package:flutter_mattermost/core/modals/modal_registry.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/design_tokens.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_category_entity.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_entity.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_member_entity.dart';
import 'package:flutter_mattermost/features/channels/domain/repositories/channel_repository.dart';
import 'package:flutter_mattermost/features/channels/presentation/bloc/channel_bloc.dart';
import 'package:flutter_mattermost/features/chat/presentation/bloc/rhs_bloc.dart';
import 'package:flutter_mattermost/features/teams/presentation/bloc/team_bloc.dart';
import 'package:go_router/go_router.dart';

class ChannelInfoPanel extends StatefulWidget {
  const ChannelInfoPanel({super.key});

  @override
  State<ChannelInfoPanel> createState() => _ChannelInfoPanelState();
}

class _ChannelInfoPanelState extends State<ChannelInfoPanel> {
  bool _copiedRecently = false;
  Timer? _copyTimer;

  @override
  void dispose() {
    _copyTimer?.cancel();
    super.dispose();
  }

  void _onCopy(String link) {
    Clipboard.setData(ClipboardData(text: link));
    setState(() => _copiedRecently = true);
    _copyTimer?.cancel();
    _copyTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copiedRecently = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);

    final channelState = context.watch<ChannelBloc>().state;
    ChannelEntity? channel;
    String? userId;
    List<ChannelCategoryEntity> categories = [];
    Map<String, ChannelMemberEntity> members = {};

    if (channelState is ChannelsLoadedState) {
      channel = channelState.selectedChannel;
      userId = channelState.userId;
      categories = channelState.categories;
      members = channelState.members;
    }
    if (channel == null) return const SizedBox.shrink();
    final ch = channel;

    final isFavorited = categories
        .where((c) => c.type == ChannelCategoryType.favorites)
        .any((c) => c.channelIds.contains(channel!.id));

    final member = members[channel.id];
    final isMuted = member?.notifyProps['mark_unread'] == 'mention';
    final isArchived = channel.deleteAt > 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isArchived) _buildArchivedNotice(context),

          // Header with Channel Name and Purpose
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  channel.displayName,
                  style: TextStyle(
                    color: theme.centerChannelColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildAboutSection(
                  context,
                  title: l10n.channel_info_rhsAbout_areaPurpose,
                  content: channel.purpose,
                  hint: l10n.channel_info_rhsAbout_areaPurpose_hint,
                  onEdit: () => ModalRegistry.open(
                    context,
                    id: ModalIdentifiers.editChannelPurpose,
                  ),
                ),
                const SizedBox(height: 16),
                _buildAboutSection(
                  context,
                  title: l10n.channel_info_rhsAbout_areaHeader,
                  content: channel.header,
                  hint: l10n.channel_info_rhsAbout_areaHeader_hint,
                  onEdit: () => ModalRegistry.open(
                    context,
                    id: ModalIdentifiers.editChannelHeader,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Quick Action Cards
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final cardWidth = (constraints.maxWidth - 24) / 4;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _ActionCard(
                      icon: isFavorited ? Icons.star : Icons.star_border,
                      iconColor: isFavorited ? Colors.amber : null,
                      label: isFavorited
                          ? l10n.channel_info_rhsTop_buttonsFavorited
                          : l10n.channel_info_rhsTop_buttonsFavorite,
                      width: cardWidth,
                      onTap: () {
                        if (userId != null) {
                          context.read<ChannelBloc>().add(ToggleFavoriteEvent(
                                channelId: channel!.id,
                                userId: userId,
                                teamId: channel.teamId,
                              ));
                        }
                      },
                    ),
                    _ActionCard(
                      icon: isMuted ? Icons.notifications_off : Icons.notifications_none,
                      iconColor: isMuted ? theme.errorTextColor : null,
                      label: isMuted
                          ? l10n.channel_info_rhsTop_buttonsMuted
                          : l10n.channel_info_rhsTop_buttonsMute,
                      width: cardWidth,
                      onTap: () {
                        if (userId != null) {
                          context.read<ChannelBloc>().add(ToggleMuteEvent(
                                channelId: channel!.id,
                                userId: userId,
                              ));
                        }
                      },
                    ),
                    _ActionCard(
                      icon: Icons.person_add_outlined,
                      label: l10n.channel_info_rhsTop_buttonsAdd_people,
                      width: cardWidth,
                      onTap: () => ModalRegistry.open(
                        context,
                        id: ModalIdentifiers.channelInvite,
                      ),
                    ),
                    _ActionCard(
                      icon: _copiedRecently ? Icons.check : Icons.link,
                      label: _copiedRecently
                          ? l10n.channel_info_rhsTop_buttonsCopied
                          : l10n.channel_info_rhsTop_buttonsCopy,
                      width: cardWidth,
                      isSuccess: _copiedRecently,
                      onTap: () => _copyChannelLink(context, channel!),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 24),

          // Options List
          _buildOptionTile(
            context,
            icon: Icons.settings_outlined,
            title: l10n.channelSettingsTitle,
            onTap: () => ModalRegistry.open(
              context,
              id: ModalIdentifiers.channelSettings,
            ),
          ),
          _buildOptionTile(
            context,
            icon: Icons.notifications_outlined,
            title: l10n.channelNotificationsTitle,
            onTap: () => ModalRegistry.open(
              context,
              id: ModalIdentifiers.channelNotifications,
            ),
          ),
          _buildOptionTile(
            context,
            icon: Icons.group_outlined,
            title: l10n.channelHeaderMembers,
            onTap: () => context.read<RhsBloc>().add(ShowChannelMembersEvent()),
          ),
          _buildOptionTile(
            context,
            icon: Icons.push_pin_outlined,
            title: l10n.search_headerPinnedMessages,
            onTap: () => context.read<RhsBloc>().add(ShowPinnedPostsEvent()),
          ),
          _buildOptionTile(
            context,
            icon: Icons.folder_outlined,
            title: l10n.channel_info_rhsMenuFiles,
            onTap: () => context.read<RhsBloc>().add(ShowChannelFilesEvent()),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(height: 1),
          ),

          // الإجراءات الحمراء: مغادرة القناة / أرشفة (للمدراء).
          if (!isArchived && !_isDirectChannel(ch)) ...[
            _buildDangerTile(
              context,
              icon: Icons.logout,
              title: l10n.sidebar_leftSidebar_channel_menuLeaveChannel,
              onTap: () => _leaveChannel(context, ch),
            ),
            if (_isAdmin(member))
              _buildDangerTile(
                context,
                icon: Icons.archive_outlined,
                title: l10n.channel_settingsModalArchiveTitle,
                onTap: () => _archiveChannel(context, ch),
              ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Divider(height: 1),
            ),
          ],

          // Technical Details (Handle / ID)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${l10n.channel_info_rhsAbout_area_handle} ${channel.name}',
                  style: TextStyle(
                    color: theme.centerChannelColor.withValues(alpha: 0.56),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${l10n.channel_info_rhsAbout_area_id} ${channel.id}',
                  style: TextStyle(
                    color: theme.centerChannelColor.withValues(alpha: 0.56),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArchivedNotice(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(DesignTokens.radiusM),
        border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.archive_outlined, color: Colors.amber, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              l10n.channel_info_rhsArchivedTitle,
              style: TextStyle(
                color: theme.centerChannelColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(
    BuildContext context, {
    required String title,
    required String content,
    required String hint,
    required VoidCallback onEdit,
  }) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: TextStyle(
                color: theme.centerChannelColor,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: onEdit,
              style: TextButton.styleFrom(
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
              child: Text(
                l10n.channel_info_rhsAbout_areaEdit,
                style: TextStyle(color: theme.buttonBg, fontSize: 12),
              ),
            ),
          ],
        ),
        Text(
          content.isNotEmpty ? content : hint,
          style: TextStyle(
            color: content.isNotEmpty
                ? theme.centerChannelColor
                : theme.centerChannelColor.withValues(alpha: 0.48),
            fontSize: 14,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildOptionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final theme = AppTheme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: theme.centerChannelColor.withValues(alpha: 0.64),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: theme.centerChannelColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 16,
              color: theme.centerChannelColor.withValues(alpha: 0.32),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDangerTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final theme = AppTheme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 20, color: theme.errorTextColor),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: theme.errorTextColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isDirectChannel(ChannelEntity channel) =>
      channel.type == ChannelType.direct || channel.type == ChannelType.group;

  bool _isAdmin(ChannelMemberEntity? member) =>
      member != null &&
      member.roles.split(',').any((r) => r.trim() == 'channel_admin');

  Future<void> _goToTownSquare() async {
    final teamState = context.read<TeamBloc>().state;
    final teamName = teamState is TeamsLoadedState
        ? teamState.selectedTeam?.name
        : null;
    context.read<RhsBloc>().add(CloseRhsEvent());
    if (teamName != null) context.go('/$teamName/channels/town-square');
  }

  Future<void> _leaveChannel(BuildContext context, ChannelEntity channel) async {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.centerChannelBg,
        title: Text(
          channel.type == ChannelType.private
              ? l10n.leave_private_channel_modalTitle(channel.displayName)
              : l10n.leave_policy_channel_modalTitle(channel.displayName),
          style: TextStyle(color: theme.centerChannelColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              l10n.generic_modalCancel,
              style: TextStyle(color: theme.centerChannelColor),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              channel.type == ChannelType.private
                  ? l10n.leave_private_channel_modalLeave
                  : l10n.leave_policy_channel_modalLeave,
              style: const TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    final channelState = context.read<ChannelBloc>().state;
    final userId = channelState is ChannelsLoadedState
        ? channelState.userId
        : null;
    if (userId != null) {
      context.read<ChannelBloc>().add(
        LeaveChannelEvent(channelId: channel.id, userId: userId),
      );
    }
    await _goToTownSquare();
  }

  Future<void> _archiveChannel(
    BuildContext context,
    ChannelEntity channel,
  ) async {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.centerChannelBg,
        title: Text(
          l10n.channel_settingsModalArchiveTitle,
          style: TextStyle(color: theme.centerChannelColor),
        ),
        content: Text(
          l10n.channelSettingsArchiveDescription,
          style: TextStyle(
            color: theme.centerChannelColor.withValues(alpha: 0.7),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              l10n.generic_modalCancel,
              style: TextStyle(color: theme.centerChannelColor),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              l10n.channel_settingsModalConfirmArchive,
              style: const TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    try {
      await getIt<ChannelRepository>().deleteChannel(channel.id);
      if (!context.mounted) return;
      context.read<ChannelBloc>().add(ArchiveChannelEvent(channel));
      await _goToTownSquare();
    } catch (_) {
      // لا تغيير عند فشل الأرشفة.
    }
  }

  void _copyChannelLink(BuildContext context, ChannelEntity channel) {
    final teamState = context.read<TeamBloc>().state;
    if (teamState is TeamsLoadedState) {
      final teamName = teamState.selectedTeam?.name;
      if (teamName != null) {
        final link = 'https://mattermost.com/$teamName/channels/${channel.name}';
        _onCopy(link);
      }
    }
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final String label;
  final double width;
  final VoidCallback onTap;
  final bool isSuccess;

  const _ActionCard({
    required this.icon,
    this.iconColor,
    required this.label,
    required this.width,
    required this.onTap,
    this.isSuccess = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final bgColor = isSuccess
        ? Colors.green.withValues(alpha: 0.8)
        : theme.centerChannelColor.withValues(alpha: 0.04);
    final contentColor = isSuccess
        ? Colors.white
        : theme.centerChannelColor.withValues(alpha: 0.8);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(DesignTokens.radiusM),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: width,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(DesignTokens.radiusM),
          border: Border.all(
            color: isSuccess
                ? Colors.green
                : theme.centerChannelColor.withValues(alpha: 0.08),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSuccess ? Colors.white : (iconColor ?? contentColor),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: contentColor,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
