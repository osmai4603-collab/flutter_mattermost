import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/enums/channel_category_type.dart';
import 'package:flutter_mattermost/core/enums/channel_type.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/network/server_manager.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:flutter_mattermost/core/widgets/matter_menu.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_entity.dart';
import 'package:flutter_mattermost/features/channels/presentation/bloc/channel_bloc.dart';
import 'package:flutter_mattermost/features/channels/presentation/modals/channel_notifications_modal.dart';
import 'package:flutter_mattermost/features/channels/presentation/modals/channel_settings_modal.dart';
import 'package:flutter_mattermost/features/teams/presentation/bloc/team_bloc.dart';

/// يبني بنود قائمة قناة الشريط الجانبي — مطابق sidebar_channel_menu.tsx:
///
/// ترتيب منطقي بفواصل: التنظيم (مفضلة/نقل إلى) في الأعلى، التنبيهات
/// (كتم/تفضيلات) في المنتصف، المشاركة/المعلومات (نسخ/معلومات/إعدادات)،
/// ثم البنود الحسّاسة باللون الأحمر في الأسفل (مغادرة/أرشفة).
List<MatterMenuItem> buildChannelMenuItems(
  BuildContext context,
  ChannelEntity channel,
) {
  final l10n = AppLocalizations.of(context);
  final state = context.read<ChannelBloc>().state;
  final loaded = state is ChannelsLoadedState ? state : null;
  final member = loaded?.members[channel.id];
  final muted = member?.notifyProps['mark_unread'] == 'mention';
  final currentUserId = loaded?.userId ?? '';
  final isFavorited =
      loaded?.categories
          .where((c) => c.type == ChannelCategoryType.favorites)
          .any((c) => c.channelIds.contains(channel.id)) ??
      false;
  final isDirect = channel.type == ChannelType.direct;
  final isGroup = channel.type == ChannelType.group;
  final isArchived = channel.deleteAt > 0;

  // التعديل/الأرشفة لمنشئ القناة (creatorId)، وإن لم يوجد تُعتمد صلاحية
  // مدير القناة (channel_admin) من أدوار العضو.
  final isCreator =
      channel.creatorId.isNotEmpty && channel.creatorId == currentUserId;
  final isChannelAdmin = (member?.roles ?? '')
      .split(' ')
      .contains('channel_admin');
  final canManage = isCreator || isChannelAdmin;

  final items = <MatterMenuItem>[
    MatterMenuItem(
      id: 'new_window',
      label: 'Open in a new window',
      icon: Icon(Icons.content_copy, size: 18),
    ),
    MatterMenuItem.divider(),

    MatterMenuItem(
      id: 'mark_as_unread',
      label: 'Mark as Unread',
      icon: Icon(Icons.content_copy, size: 18),
    ),
    // ==== التنظيم ====
    MatterMenuItem(
      id: 'favorite',
      label: isFavorited
          ? l10n.sidebar_leftSidebar_channel_menuUnfavoriteChannel
          : l10n.sidebar_leftSidebar_channel_menuFavoriteChannel,
      icon: Icon(isFavorited ? Icons.star : Icons.star_outline, size: 18),
      onTap: () {
        final teamState = context.read<TeamBloc>().state;
        final teamId = teamState is TeamsLoadedState
            ? teamState.selectedTeam?.id ?? ''
            : '';
        context.read<ChannelBloc>().add(
          ToggleFavoriteEvent(
            channelId: channel.id,
            userId: currentUserId,
            teamId: teamId,
          ),
        );
      },
    ),
    // ==== التنبيهات ====
    MatterMenuItem(
      id: 'mute',
      label: muted
          ? l10n.sidebar_leftSidebar_channel_menuUnmuteChannel
          : l10n.sidebar_leftSidebar_channel_menuMuteChannel,
      icon: Icon(
        muted ? Icons.notifications_off : Icons.notifications_off_outlined,
        size: 18,
      ),
      onTap: () {
        context.read<ChannelBloc>().add(
          ToggleMuteEvent(channelId: channel.id, userId: currentUserId),
        );
      },
    ),
    MatterMenuItem.divider(),
    MatterMenuItem(
      id: 'move_to',
      label: l10n.sidebar_leftSidebar_channel_menuMoveTo,
      icon: const Icon(Icons.drive_file_move_outlined, size: 18),
      submenu: _moveToItems(context, channel, loaded),
    ),
    MatterMenuItem.divider(),
    MatterMenuItem(
      id: 'copy_link',
      label: l10n.sidebar_leftSidebar_channel_menuCopyLink,
      icon: const Icon(Icons.link, size: 18),
      onTap: () => _copyLink(context, channel),
    ),
    MatterMenuItem(
      id: 'add_members',
      label: l10n.sidebar_leftSidebar_channel_menuAddMembers,
      icon: const Icon(Icons.group, size: 18),
      onTap: () {
        showDialog<void>(
          context: context,
          builder: (_) => ChannelNotificationsModal(channel: channel),
        );
      },
    ),
    MatterMenuItem.divider(),
    // ==== المشاركة والمعلومات ====
    // رسائل DM/GM لا تملك رابط قناة ضمن فريق — لا يُعرض بند نسخ الرابط لها.
    // ==== خروج (حمراء) ====
    MatterMenuItem(
      id: 'leave',
      label: isDirect || isGroup
          ? l10n.sidebar_leftSidebar_channel_menuLeaveConversation
          : l10n.sidebar_leftSidebar_channel_menuLeaveChannel,
      icon: const Icon(Icons.logout, size: 18),
      danger: true,
      onTap: () => _confirmLeave(context, channel),
    ),
  ];

  return items;
}

/// بنود «نقل إلى...»: الفئات المخصصة + إنشاء فئة جديدة فوراً.
List<MatterMenuItem> _moveToItems(
  BuildContext context,
  ChannelEntity channel,
  ChannelsLoadedState? loaded,
) {
  final l10n = AppLocalizations.of(context);
  return [
    MatterMenuItem(
      id: 'favorites',
      label: 'Favorites',
      icon: const Icon(Icons.star_outline, size: 18),
      onTap: () => _promptCreateCategory(context, channel, loaded),
    ),
    MatterMenuItem(
      id: 'channels',
      label: 'Channels',
      icon: const Icon(Icons.folder_outlined, size: 18),
      onTap: () => _promptCreateCategory(context, channel, loaded),
    ),
    MatterMenuItem.divider(),
    MatterMenuItem(
      id: 'move_new_category',
      label: l10n.sidebar_leftSidebar_channel_menuMoveToNewCategory,
      icon: const Icon(Icons.create_new_folder_outlined, size: 18),
      onTap: () => _promptCreateCategory(context, channel, loaded),
    ),
  ];
}

/// فتح قائمة سياقية عند مؤشر الفأرة (نقر يميني على صف القناة).
void showChannelContextMenu(
  BuildContext context,
  ChannelEntity channel,
  Offset position,
) {
  showContextMenuAt(
    context,
    position: position,
    items: buildChannelMenuItems(context, channel),
  );
}

/// زر ⋯ الذي يظهر عند التمرير على صف القناة (نفس البنود).
class ChannelRowMenu extends StatelessWidget {
  final ChannelEntity channel;
  final double iconSize;
  final Color? iconColor;

  const ChannelRowMenu({
    super.key,
    required this.channel,
    this.iconSize = 18,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return MatterMenuScope(
      items: buildChannelMenuItems(context, channel),
      child: SizedBox(
        width: 24,
        height: 24,
        child: Icon(
          Icons.more_vert,
          size: iconSize,
          color: iconColor ?? theme.sidebarText.withValues(alpha: 0.7),
        ),
      ),
    );
  }
}

void _moveTo(
  BuildContext context,
  ChannelEntity channel,
  String targetCategoryId,
  ChannelsLoadedState? loaded,
) {
  if (loaded == null) return;
  final teamState = context.read<TeamBloc>().state;
  final teamId = teamState is TeamsLoadedState
      ? teamState.selectedTeam?.id ?? ''
      : '';
  context.read<ChannelBloc>().add(
    MoveChannelToCategoryEvent(
      channelId: channel.id,
      targetCategoryId: targetCategoryId,
      userId: loaded.userId,
      teamId: teamId,
    ),
  );
}

/// نافذة «فئة جديدة» — تنشئ الفئة والقناة داخلها فوراً.
Future<void> _promptCreateCategory(
  BuildContext context,
  ChannelEntity channel,
  ChannelsLoadedState? loaded,
) async {
  if (loaded == null) return;
  final l10n = AppLocalizations.of(context);
  final theme = AppTheme.of(context);
  final controller = TextEditingController();
  final name = await showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.create_category_modalCreateCategory),
      content: TextField(
        controller: controller,
        autofocus: true,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: theme.linkColor),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.postEditCancel),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(controller.text),
          child: Text(l10n.create_category_modalCreate),
        ),
      ],
    ),
  );
  controller.dispose();
  final value = name?.trim() ?? '';
  if (!context.mounted || value.isEmpty) return;
  final teamState = context.read<TeamBloc>().state;
  final teamId = teamState is TeamsLoadedState
      ? teamState.selectedTeam?.id ?? ''
      : '';
  context.read<ChannelBloc>().add(
    CreateCategoryEvent(
      displayName: value,
      userId: loaded.userId,
      teamId: teamId,
      channelIds: [channel.id],
    ),
  );
}

void _copyLink(BuildContext context, ChannelEntity channel) {
  final teamState = context.read<TeamBloc>().state;
  final teamName = teamState is TeamsLoadedState
      ? teamState.selectedTeam?.name ?? ''
      : '';
  // dio.baseUrl يتضمن /api/v4 — نأخذ جذر الخادم فقط لبناء رابط الويب
  // بالصيغة: {server}/{team}/channels/{channel}.
  final serverRoot = getIt<ServerManager>().activeServerUrl.replaceAll(
    RegExp(r'/api/v4/*$'),
    '',
  );
  final url = '$serverRoot/$teamName/channels/${channel.name}';
  Clipboard.setData(ClipboardData(text: url));
}

void _showChannelInfo(BuildContext context, ChannelEntity channel) {
  final theme = AppTheme.of(context);
  final l10n = AppLocalizations.of(context);
  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.channelHeaderChannelInfo),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InfoRow(
            label: l10n.channel_info_rhsAbout_areaChannel_nameHeading,
            value: channel.displayName,
            theme: theme,
          ),
          if (channel.purpose.isNotEmpty)
            _InfoRow(
              label: l10n.channel_info_rhsAbout_areaChannel_purposeHeading,
              value: channel.purpose,
              theme: theme,
            ),
          if (channel.header.isNotEmpty)
            _InfoRow(
              label: l10n.channel_info_rhsAbout_areaChannel_headerHeading,
              value: channel.header,
              theme: theme,
            ),
          _InfoRow(
            label: l10n.channel_info_rhsAbout_area_id,
            value: '${channel.id} (${channel.type.value})',
            theme: theme,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.generic_modalCancel),
        ),
      ],
    ),
  );
}

Future<void> _confirmLeave(BuildContext context, ChannelEntity channel) async {
  final l10n = AppLocalizations.of(context);
  final theme = AppTheme.of(context);
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        channel.type == ChannelType.private
            ? l10n.leave_private_channel_modalTitle(channel.displayName)
            : l10n.leave_policy_channel_modalTitle(channel.displayName),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.generic_modalCancel),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(
            channel.type == ChannelType.private
                ? l10n.leave_private_channel_modalLeave
                : l10n.leave_policy_channel_modalLeave,
            style: TextStyle(color: theme.errorTextColor),
          ),
        ),
      ],
    ),
  );
  if (!context.mounted) return;
  if (confirmed == true) {
    final state = context.read<ChannelBloc>().state;
    final userId = state is ChannelsLoadedState ? state.userId : '';
    context.read<ChannelBloc>().add(
      LeaveChannelEvent(channelId: channel.id, userId: userId),
    );
  }
}

Future<void> _confirmArchive(
  BuildContext context,
  ChannelEntity channel,
) async {
  final l10n = AppLocalizations.of(context);
  final theme = AppTheme.of(context);
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        l10n.channel_settingsModalArchiveTitle.replaceFirst(
          '?',
          ' ~${channel.displayName}?',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.generic_modalCancel),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(
            l10n.channel_settingsModalConfirmArchive,
            style: TextStyle(color: theme.errorTextColor),
          ),
        ),
      ],
    ),
  );
  if (!context.mounted) return;
  if (confirmed == true) {
    context.read<ChannelBloc>().add(ArchiveChannelEvent(channel));
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final MattermostColors theme;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: RichText(
        text: TextSpan(
          style: TextStyle(color: theme.centerChannelColor, fontSize: 13),
          children: [
            TextSpan(
              text: '$label ',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: theme.centerChannelColor.withValues(alpha: 0.7),
              ),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}
