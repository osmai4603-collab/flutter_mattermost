import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/design_tokens.dart';
import 'package:flutter_mattermost/core/widgets/matter_menu.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_entity.dart';
import 'package:flutter_mattermost/features/channels/domain/repositories/channel_repository.dart';
import 'package:flutter_mattermost/features/channels/presentation/widgets/sidebar_channel_row.dart';
import 'package:flutter_mattermost/features/chat/presentation/bloc/lhs_bloc.dart';

/// فئة قابلة للطي — مطابق sidebar_category.tsx في webapp:
/// رأس 32px UPPERCASE 12px + طي بأنيميشن 180ms (height transition 0.18s).
class SidebarCategory extends StatelessWidget {
  final String categoryId;
  final String title;
  final List<ChannelEntity> channels;
  final Map<String, ChannelUnreadCounts> unreadCounts;
  final String? selectedChannelId;
  final bool showNewDirectButton;
  final void Function(ChannelEntity) onChannelTap;

  const SidebarCategory({
    super.key,
    required this.categoryId,
    required this.title,
    required this.channels,
    required this.unreadCounts,
    required this.selectedChannelId,
    required this.onChannelTap,
    this.showNewDirectButton = false,
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
                    _CategoryMenu(l10n: l10n),
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
                  : Column(
                      children: [
                        for (final channel in sorted)
                          SidebarChannelRow(
                            channel: channel,
                            unread: unreadCounts[channel.id],
                            isSelected: channel.id == selectedChannelId,
                            onTap: () => onChannelTap(channel),
                          ),
                      ],
                    ),
            ),
          ],
        );
      },
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

/// قائمة فئة: إعادة تسمية/حذف (webapp sidebar_category_menu).
class _CategoryMenu extends StatelessWidget {
  final AppLocalizations l10n;
  const _CategoryMenu({required this.l10n});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return MatterMenuScope(
      items: [
        MatterMenuItem(
          id: 'rename',
          label: l10n.modalRenameChannelTitle,
          icon: const Icon(Icons.edit_outlined, size: 18),
          onTap: () {},
        ),
        MatterMenuItem(
          id: 'delete',
          label: l10n.postMenuDelete,
          icon: const Icon(Icons.delete_outline, size: 18),
          danger: true,
          onTap: () {},
        ),
      ],
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
}