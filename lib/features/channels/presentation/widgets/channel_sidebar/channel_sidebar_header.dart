import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/features/channels/presentation/widgets/channel_sidebar/channel_sidebar_header_main_menu_widget.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/modals/modal_identifiers.dart';
import 'package:flutter_mattermost/core/modals/modal_registry.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/design_tokens.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:flutter_mattermost/core/widgets/matter_menu.dart';
import 'package:flutter_mattermost/core/widgets/profile_picture.dart';
import 'package:flutter_mattermost/features/auth/domain/entities/user_status_entity.dart';
import 'package:flutter_mattermost/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_mattermost/features/channels/presentation/bloc/channel_bloc.dart';
import 'package:flutter_mattermost/features/teams/presentation/bloc/team_bloc.dart';
import 'package:flutter_mattermost/features/users/presentation/bloc/user_status_bloc.dart';

/// رأس الشريط الجانبي — مطابق sidebar_header.tsx في webapp:
/// ارتفاع 55px، اسم الفريق Metropolis 16 + قائمة رئيسية (إعدادات/دعوة/كونسول)
/// + اسم المستخدم وأفاتاره + زر (+) بقائمة إنشاء قناة/تصفح/رسالة مباشرة.
class ChannelSidebarHeader extends StatelessWidget {
  const ChannelSidebarHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);
    final authState = context.watch<AuthBloc>().state;
    final user = authState is AuthenticatedState ? authState.user : null;
    final statusState = context.watch<UserStatusBloc>().state;
    final myStatus = statusState is UserStatusesLoadedState
        ? statusState.statusOf('me')
        : UserStatus.offline;

    return Container(
      height: DesignTokens.sidebarHeaderHeight,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      color: theme.sidebarBg,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ChannelSidebarHeaderMainMenuWidget(theme: theme, l10n: l10n),
          ),
          if (user != null) ...[
            const SizedBox(width: 8),
            _UserChip(
              theme: theme,
              l10n: l10n,
              userId: user.id,
              username: user.username,
              displayName: '${user.firstName} ${user.lastName}'.trim().isEmpty
                  ? user.username
                  : '${user.firstName} ${user.lastName}'.trim(),
              status: myStatus,
            ),
          ],
          const SizedBox(width: 6),
          _AddChannelMenu(theme: theme, l10n: l10n),
        ],
      ),
    );
  }
}

/// اسم المستخدم + أفاتار مع الحالة (يُفتح قائمة الحساب عند النقر).
class _UserChip extends StatelessWidget {
  final MattermostColors theme;
  final AppLocalizations l10n;
  final String? userId;
  final String username;
  final String displayName;
  final UserStatus? status;

  const _UserChip({
    required this.theme,
    required this.l10n,
    this.userId,
    required this.username,
    required this.displayName,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ProfilePicture.sm(
          userId: userId,
          username: username,
          avatarUrl: null,
          status: status,
          showStatus: true,
        ),
        if (displayName.isNotEmpty) ...[
          const SizedBox(width: 5),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 72),
            child: Text(
              displayName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: theme.sidebarHeaderTextColor.withValues(alpha: 0.85),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// زر (+) — قائمة إنشاء قناة/تصفح قنوات/رسالة مباشرة
/// (مطابق SidebarAddChannelMenu في webapp).
class _AddChannelMenu extends StatelessWidget {
  final MattermostColors theme;
  final AppLocalizations l10n;

  const _AddChannelMenu({required this.theme, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return MatterMenuScope(
      items: [
        MatterMenuItem(
          id: 'create_channel',
          label: l10n.sidebar_leftAdd_channel_dropdownCreateNewChannel,
          icon: const Icon(Icons.add_comment_outlined, size: 18),
          onTap: () {
            ModalRegistry.open(context, id: ModalIdentifiers.newChannel);
          },
        ),
        MatterMenuItem(
          id: 'browse_channels',
          label: l10n.sidebar_leftAdd_channel_dropdownBrowseChannels,
          icon: const Icon(Icons.explore_outlined, size: 18),
          onTap: () {
            ModalRegistry.open(context, id: ModalIdentifiers.moreChannels);
          },
        ),
        MatterMenuItem(
          id: 'direct_message',
          label: l10n.sidebarCreateDirectMessage,
          icon: const Icon(Icons.person_outlined, size: 18),
          onTap: () {
            ModalRegistry.open(
              context,
              id: ModalIdentifiers.moreDirectChannels,
            );
          },
        ),
        MatterMenuItem.divider(),
        MatterMenuItem(
          id: 'create_category',
          label: 'Create new category',
          icon: const Icon(Icons.add_box_outlined, size: 18),
          onTap: () => _showCreateCategoryDialog(context),
        ),
        MatterMenuItem.divider(),
        MatterMenuItem(
          id: 'invite_people',
          label: 'Invite people',
          subtitle: 'Add people to the team',
          icon: const Icon(Icons.person_add_outlined, size: 18),
          onTap: () {
            ModalRegistry.open(context, id: ModalIdentifiers.invitation);
          },
        ),
      ],
      child: InkWell(
        borderRadius: BorderRadius.circular(DesignTokens.radiusCircle),
        child: Material(
          borderRadius: BorderRadius.circular(DesignTokens.radiusCircle),
          color: theme.sidebarHeaderTextColor.withValues(alpha: 0.12),
          child: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(shape: BoxShape.circle),
            child: Icon(
              Icons.add,
              size: 16,
              color: theme.sidebarHeaderTextColor,
            ),
          ),
        ),
      ),
    );
  }

  /// نافذة «فئة جديدة» — مطابقة _showCreateDialog في category_menu.dart:
  /// تنشئ فئة مخصصة فارغة تُلحق نهاية قائمة الفئات.
  Future<void> _showCreateCategoryDialog(BuildContext context) async {
    final channelBloc = context.read<ChannelBloc>();
    final teamState = context.read<TeamBloc>().state;
    final teamId = teamState is TeamsLoadedState
        ? teamState.selectedTeam?.id ?? ''
        : '';
    final channelState = channelBloc.state;
    final userId = channelState is ChannelsLoadedState
        ? channelState.userId
        : '';
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
    if (value.isEmpty || userId.isEmpty || teamId.isEmpty) return;
    channelBloc.add(
      CreateCategoryEvent(displayName: value, userId: userId, teamId: teamId),
    );
  }
}
