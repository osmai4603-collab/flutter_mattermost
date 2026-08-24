import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/enums/category_sorting.dart';
import 'package:flutter_mattermost/core/enums/channel_category_type.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/modals/modal_identifiers.dart';
import 'package:flutter_mattermost/core/modals/modal_registry.dart';
import 'package:flutter_mattermost/core/theme/design_tokens.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:flutter_mattermost/core/widgets/hover_widget.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_category_entity.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_entity.dart';
import 'package:flutter_mattermost/features/channels/domain/repositories/channel_repository.dart';
import 'package:flutter_mattermost/features/channels/presentation/widgets/channel_sidebar/category_menu.dart';

class ChannelCategoryRow extends StatelessWidget {
  const ChannelCategoryRow({
    super.key,
    required this.categoryId,
    required this.category,
    required this.userId,
    required this.teamId,
    required this.title,
    required this.channels,
    required this.unreadCounts,
    required this.context,
    required this.collapsed,
    required this.theme,
    required this.l10n,
    required this.onToggleChanged,
  });

  final String categoryId;
  final ChannelCategoryEntity? category;
  final String userId;
  final String teamId;
  final String title;
  final List<ChannelEntity> channels;
  final Map<String, ChannelUnreadCounts> unreadCounts;
  final BuildContext context;
  final bool collapsed;
  final MattermostColors theme;
  final AppLocalizations l10n;
  final void Function(bool) onToggleChanged;

  @override
  Widget build(BuildContext context) {
    return HoverWidget(
      builder: (context, isHovered) {
        return InkWell(
          onTap: () => onToggleChanged(!collapsed),
          child: Container(
            height: DesignTokens.sidebarCategoryHeaderHeight,
            padding: const EdgeInsetsDirectional.only(start: 8),
            child: Row(
              children: [
                AnimatedRotation(
                  turns: collapsed ? 0 : 0.25, // : 0,
                  duration: DesignTokens.sidebarCollapseDuration,
                  child: Icon(
                    Icons.chevron_right,
                    size: 16,
                    color: isHovered
                        ? theme.sidebarText
                        : theme.sidebarText.withValues(alpha: 0.64),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    title.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isHovered
                          ? theme.sidebarText
                          : theme.sidebarText.withValues(alpha: 0.64),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.05 * 16,
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (category?.type == ChannelCategoryType.directMessages)
                      Tooltip(
                        message:
                            category?.type == ChannelCategoryType.directMessages
                            ? (l10n.sidebarDirectMessages.isNotEmpty
                                  ? l10n.sidebarDirectMessages
                                  : 'Direct Messages')
                            : 'Add Channel',
                        child: InkWell(
                          borderRadius: BorderRadius.circular(4),
                          onTap: () {
                            final modalId =
                                category?.type ==
                                    ChannelCategoryType.directMessages
                                ? ModalIdentifiers.moreDirectChannels
                                : ModalIdentifiers.newChannel;
                            ModalRegistry.open(context, id: modalId);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Icon(
                              Icons.add,
                              size: 16,
                              color: theme.sidebarText.withValues(alpha: 0.64),
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(width: 2),
                    AnimatedOpacity(
                      opacity: isHovered ? 1 : 0,
                      duration: const Duration(milliseconds: 150),
                      child: CategoryMenu(
                        l10n: l10n,
                        theme: theme,
                        category: ChannelCategoryEntity(
                          id: categoryId,
                          teamId: teamId,
                          userId: userId,
                          displayName: title,
                          type: category?.type ?? ChannelCategoryType.channels,
                          channelIds: channels.map((e) => e.id).toList(),
                          muted: category?.muted ?? false,
                          sorting: category?.sorting ?? CategorySorting.recent,
                        ),
                        userId: userId,
                        teamId: teamId,
                        unreadCounts: unreadCounts,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
