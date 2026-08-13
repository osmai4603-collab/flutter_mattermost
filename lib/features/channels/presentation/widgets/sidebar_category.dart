import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/core/enums/channel_category_type.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/design_tokens.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:flutter_mattermost/core/widgets/matter_menu.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_category_entity.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_entity.dart';
import 'package:flutter_mattermost/features/channels/domain/repositories/channel_repository.dart';
import 'package:flutter_mattermost/features/channels/presentation/bloc/channel_bloc.dart';
import 'package:flutter_mattermost/features/channels/presentation/widgets/sidebar_channel_row.dart';
import 'package:flutter_mattermost/features/chat/presentation/bloc/lhs_bloc.dart';

/// كائن يُرافَق أثناء السحب (LongPressDraggable) لنقل قناة بين الفئات.
class SidebarCategoryDragData {
  final String channelId;
  final String fromCategoryId;

  const SidebarCategoryDragData({
    required this.channelId,
    required this.fromCategoryId,
  });
}

/// فئة قابلة للطي — مطابق sidebar_category.tsx في webapp:
/// رأس 32px UPPERCASE 12px + طي بأنيميشن 180ms (height transition 0.18s).
/// تدعم سحب القنوات (long-press) نحو فئات أخرى عبر [onMoveChannel]،
/// وقائمة فئة (إعادة تسمية/كتم/حذف/إنشاء) عبر [category].
class SidebarCategory extends StatelessWidget {
  final String categoryId;
  final String title;
  final List<ChannelEntity> channels;
  final Map<String, ChannelUnreadCounts> unreadCounts;
  final String? selectedChannelId;
  final bool showNewDirectButton;
  final void Function(ChannelEntity) onChannelTap;

  /// كيان الفئة الحقيقية — null للقسم الافتراضي (غير مفهرسة في فئة).
  final ChannelCategoryEntity? category;
  final String userId;
  final String teamId;

  /// استدعاء عند إفلات قناة على هذه الفئة — يُمكّن السحب والإفلات.
  final void Function(String channelId, String fromCategoryId)? onMoveChannel;

  const SidebarCategory({
    super.key,
    required this.categoryId,
    required this.title,
    required this.channels,
    required this.unreadCounts,
    required this.selectedChannelId,
    required this.onChannelTap,
    this.showNewDirectButton = false,
    this.category,
    this.userId = '',
    this.teamId = '',
    this.onMoveChannel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);

    return BlocBuilder<LhsBloc, LhsState>(
      builder: (context, lhsState) {
        final collapsed = lhsState is LhsSearchState &&
            lhsState.collapsedCategories.contains(categoryId);
        final sorted = [...channels]
          ..sort((a, b) => b.lastPostAt.compareTo(a.lastPostAt));

        return DragTarget<SidebarCategoryDragData>(
          onWillAcceptWithDetails: (details) {
            return details.data.fromCategoryId != categoryId;
          },
          onAcceptWithDetails: (details) {
            onMoveChannel?.call(details.data.channelId, details.data.fromCategoryId);
          },
          builder: (context, candidateData, rejectedData) {
            final isDropTarget = onMoveChannel != null && candidateData.isNotEmpty;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () => context
                      .read<LhsBloc>()
                      .add(ToggleCategoryCollapsedEvent(categoryId)),
                  child: Container(
                    height: DesignTokens.sidebarCategoryHeaderHeight,
                    padding: const EdgeInsets.only(left: 16, right: 12),
                    child: Row(
                      children: [
                        AnimatedRotation(
                          turns: collapsed ? -0.25 : 0,
                          duration: DesignTokens.sidebarCollapseDuration,
                          child: Icon(
                            Icons.chevron_right,
                            size: 16,
                            color: theme.sidebarText.withValues(alpha: 0.64),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            title.toUpperCase(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: theme.sidebarText.withValues(alpha: 0.64),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.05 * 16,
                            ),
                          ),
                        ),
                        if (showNewDirectButton)
                          _CategoryIconButton(
                            icon: Icons.edit_outlined,
                            tooltip: l10n.newDirectMessage,
                            onTap: () {},
                          ),
                        if (category != null)
                          _CategoryMenu(
                            l10n: l10n,
                            theme: theme,
                            category: category!,
                            userId: userId,
                            teamId: teamId,
                          ),
                      ],
                    ),
                  ),
                ),
                AnimatedSize(
                  duration: DesignTokens.sidebarCollapseDuration,
                  curve: Curves.easeInOut,
                  alignment: Alignment.topCenter,
                  child: collapsed
                      ? const SizedBox(width: double.infinity)
                      : Container(
                          decoration: isDropTarget
                              ? BoxDecoration(
                                  color: theme.sidebarText.withValues(
                                    alpha: 0.06,
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                )
                              : null,
                          child: Column(
                            children: [
                              for (final channel in sorted)
                                _buildRow(channel, theme),
                            ],
                          ),
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildRow(ChannelEntity channel, MattermostColors theme) {
    final row = SidebarChannelRow(
      channel: channel,
      unread: unreadCounts[channel.id],
      isSelected: channel.id == selectedChannelId,
      onTap: () => onChannelTap(channel),
    );

    if (onMoveChannel == null) return row;

    return LongPressDraggable<SidebarCategoryDragData>(
      data: SidebarCategoryDragData(
        channelId: channel.id,
        fromCategoryId: categoryId,
      ),
      feedback: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: theme.sidebarBg,
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 8,
              ),
            ],
          ),
          child: Text(
            channel.displayName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: theme.sidebarText, fontSize: 14),
          ),
        ),
      ),
      childWhenDragging: Opacity(opacity: 0.3, child: row),
      child: row,
    );
  }
}

class _CategoryIconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  const _CategoryIconButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Tooltip(
        message: tooltip,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Icon(
            icon,
            size: 14,
            color: theme.sidebarText.withValues(alpha: 0.64),
          ),
        ),
      ),
    );
  }
}

/// قائمة فئة — مطابق sidebar_category_menu في webapp:
/// إنشاء فئة جديدة، إعادة تسمية، كتم/إلغاء كتم، حذف (للفئات المخصصة فقط).
class _CategoryMenu extends StatelessWidget {
  final AppLocalizations l10n;
  final MattermostColors theme;
  final ChannelCategoryEntity category;
  final String userId;
  final String teamId;

  const _CategoryMenu({
    required this.l10n,
    required this.theme,
    required this.category,
    required this.userId,
    required this.teamId,
  });

  bool get _isCustom => category.type == ChannelCategoryType.custom;

  @override
  Widget build(BuildContext context) {
    final items = <MatterMenuItem>[
      MatterMenuItem(
        id: 'create',
        label: l10n.sidebar_leftSidebar_category_menuCreateCategory,
        icon: const Icon(Icons.create_new_folder_outlined, size: 18),
        onTap: () => _showCreateDialog(context),
      ),
    ];

    if (_isCustom || category.type == ChannelCategoryType.favorites) {
      items.addAll([
        MatterMenuItem(
          id: 'rename',
          label: l10n.sidebar_leftSidebar_category_menuRenameCategory,
          icon: const Icon(Icons.edit_outlined, size: 18),
          onTap: () => _showRenameDialog(context),
        ),
      ]);
    }

    if (_isCustom) {
      items.addAll([
        MatterMenuItem(
          id: 'mute',
          label: category.muted
              ? l10n.sidebar_leftSidebar_category_menuUnmuteCategory
              : l10n.sidebar_leftSidebar_category_menuMuteCategory,
          icon: Icon(
            category.muted ? Icons.notifications_off : Icons.notifications_off_outlined,
            size: 18,
          ),
          onTap: () {
            context.read<ChannelBloc>().add(
                  ToggleMuteCategoryEvent(
                    categoryId: category.id,
                    muted: !category.muted,
                    userId: userId,
                    teamId: teamId,
                  ),
                );
          },
        ),
        MatterMenuItem.divider(),
        MatterMenuItem(
          id: 'delete',
          label: l10n.sidebar_leftSidebar_category_menuDeleteCategory,
          icon: const Icon(Icons.delete_outline, size: 18),
          danger: true,
          onTap: () => _confirmDelete(context),
        ),
      ]);
    }

    return MatterMenuScope(
      items: items,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Icon(
          Icons.more_horiz,
          size: 16,
          color: theme.sidebarText.withValues(alpha: 0.64),
        ),
      ),
    );
  }

  Future<void> _showCreateDialog(BuildContext context) async {
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
    if (!context.mounted) return;
    if (value.isNotEmpty) {
      context.read<ChannelBloc>().add(
            CreateCategoryEvent(
              displayName: value,
              userId: userId,
              teamId: teamId,
            ),
          );
    }
  }

  Future<void> _showRenameDialog(BuildContext context) async {
    final controller = TextEditingController(text: category.displayName);
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.rename_category_modalRenameCategory),
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
            child: Text(l10n.rename_category_modalRename),
          ),
        ],
      ),
    );
    controller.dispose();
    final value = name?.trim() ?? '';
    if (!context.mounted) return;
    if (value.isNotEmpty && value != category.displayName) {
      context.read<ChannelBloc>().add(
            RenameCategoryEvent(
              categoryId: category.id,
              newName: value,
              userId: userId,
              teamId: teamId,
            ),
          );
    }
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final help = l10n
        .delete_category_modalHelpText(category.displayName)
        .replaceAll(RegExp(r'<[^>]+>'), '');
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.delete_category_modalDeleteCategory),
        content: Text(help),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.postEditCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              l10n.delete_category_modalDelete,
              style: TextStyle(color: theme.errorTextColor),
            ),
          ),
        ],
      ),
    );
    if (!context.mounted) return;
    if (confirmed == true) {
      context.read<ChannelBloc>().add(
            DeleteCategoryEvent(
              categoryId: category.id,
              userId: userId,
              teamId: teamId,
            ),
          );
    }
  }
}