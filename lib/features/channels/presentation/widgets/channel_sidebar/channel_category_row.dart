import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/theme/design_tokens.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:flutter_mattermost/core/widgets/hover_widget.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_category_entity.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_entity.dart';
import 'package:flutter_mattermost/features/channels/domain/repositories/channel_repository.dart';
import 'package:flutter_mattermost/features/channels/presentation/bloc/channel_bloc.dart';
import 'package:flutter_mattermost/features/channels/presentation/widgets/channel_sidebar/category_menu.dart';
import 'package:flutter_mattermost/features/chat/presentation/bloc/lhs_bloc.dart';

class ChannelCategoryRow extends StatefulWidget {
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

  @override
  State<ChannelCategoryRow> createState() => _ChannelCategoryRowState();
}

class _ChannelCategoryRowState extends State<ChannelCategoryRow> {
  @override
  Widget build(BuildContext context) {
    return HoverWidget(
      builder: (context, isHovered) {
        return InkWell(
          onTap: () {
            context.read<LhsBloc>().add(
              ToggleCategoryCollapsedEvent(widget.categoryId),
            );
            // حفظ حالة الطي على الخادم للفئات الحقيقية.
            if (widget.category != null &&
                widget.userId.isNotEmpty &&
                widget.teamId.isNotEmpty) {
              context.read<ChannelBloc>().add(
                SetCategoryCollapsedEvent(
                  categoryId: widget.categoryId,
                  collapsed: !widget.collapsed,
                  userId: widget.userId,
                  teamId: widget.teamId,
                ),
              );
            }
          },
          child: Container(
            height: DesignTokens.sidebarCategoryHeaderHeight,
            padding: const EdgeInsetsDirectional.only(start: 8),
            child: Row(
              children: [
                AnimatedRotation(
                  turns: widget.collapsed ? 0 : 0.25, // : 0,
                  duration: DesignTokens.sidebarCollapseDuration,
                  child: Icon(
                    Icons.chevron_right,
                    size: 16,
                    color: isHovered
                        ? widget.theme.sidebarText
                        : widget.theme.sidebarText.withValues(alpha: 0.64),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    widget.title.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isHovered
                          ? widget.theme.sidebarText
                          : widget.theme.sidebarText.withValues(alpha: 0.64),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.05 * 16,
                    ),
                  ),
                ),
                // if (showNewDirectButton)
                //   _CategoryIconButton(
                //     icon: Icons.edit_outlined,
                //     tooltip: l10n.newDirectMessage,
                //     onTap: () {},
                //   ),
                if (isHovered)
                  CategoryMenu(
                    l10n: widget.l10n,
                    theme: widget.theme,
                    category: ChannelCategoryEntity(
                      id: widget.categoryId,
                      teamId: widget.teamId,
                      userId: widget.userId,
                      displayName: widget.title,
                      channelIds: widget.channels.map((e) => e.id).toList(),
                    ),
                    userId: widget.userId,
                    teamId: widget.teamId,
                    unreadCounts: widget.unreadCounts,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
