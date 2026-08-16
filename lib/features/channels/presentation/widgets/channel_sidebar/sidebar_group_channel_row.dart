import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/design_tokens.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_entity.dart';
import 'package:flutter_mattermost/features/channels/domain/repositories/channel_repository.dart';
import 'package:flutter_mattermost/features/channels/presentation/widgets/channel_context_menu.dart';
import 'package:flutter_mattermost/features/channels/presentation/widgets/channel_sidebar/sidebar_category.dart';

/// صف محادثة جماعية (GM) في LHS — مطابق sidebar_group_channel.tsx في webapp:
/// أيقونة عداد الأعضاء (status--group) + اسم المجموعة من الخادم (display_name)
/// + شارة منشنات/نقطة unread + قائمة ⋯ عند التمرير أو النقر اليميني.
class SidebarGroupChannelRow extends StatefulWidget {
  final ChannelEntity channel;

  /// معرّف فئة الشريط الجانبي التي يسحب منها الصف.
  final String draggableFrom;
  final ChannelUnreadCounts? unread;
  final bool isSelected;
  final bool isMuted;
  final VoidCallback onTap;

  /// خارجي (GlobalKey) لقياس موضع الصف لمؤشرات غير المقروءة.
  final Key? rowKey;

  const SidebarGroupChannelRow({
    super.key,
    required this.channel,
    required this.draggableFrom,
    required this.unread,
    required this.isSelected,
    required this.isMuted,
    required this.onTap,
    this.rowKey,
  });

  @override
  State<SidebarGroupChannelRow> createState() => _SidebarGroupChannelRowState();
}

class _SidebarGroupChannelRowState extends State<SidebarGroupChannelRow> {
  bool _hovered = false;

  /// عدد أعضاء المجموعة — اسم قناة GM هو معرفات الأعضاء مفصولة بـ `__`.
  int get _membersCount =>
      widget.channel.name.split('__').where((s) => s.isNotEmpty).length;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final hasUnreads = widget.unread?.hasUnreads ?? false;
    final hasMentions = (widget.unread?.mentions ?? 0) > 0;

    return LongPressDraggable<SidebarCategoryDragData>(
      data: SidebarCategoryDragData(
        channelId: widget.channel.id,
        fromCategoryId: widget.draggableFrom,
        channelType: DraggingChannelType.directMessage,
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
            widget.channel.displayName,
            style: TextStyle(color: theme.sidebarText, fontSize: 14),
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: _content(theme, hasUnreads, hasMentions),
      ),
      child: _content(theme, hasUnreads, hasMentions),
    );
  }

  Widget _content(MattermostColors theme, bool hasUnreads, bool hasMentions) {
    final channel = widget.channel;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        key: widget.rowKey,
        onTap: widget.onTap,
        onSecondaryTapDown: (details) {
          showChannelContextMenu(context, channel, details.globalPosition);
        },
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: DesignTokens.sidebarRowHeight,
          color: widget.isSelected
              ? theme.sidebarText.withValues(alpha: 0.08)
              : _hovered
              ? theme.sidebarTextHoverBg
              : Colors.transparent,
          child: Stack(
            alignment: AlignmentDirectional.centerStart,
            children: [
              // خط نشط عمودي 4px (نفس SidebarChannelRow/DM rows).
              if (widget.isSelected)
                PositionedDirectional(
                  start: 0,
                  top: 0,
                  bottom: 0,
                  child: VerticalDivider(
                    thickness: 1.50,
                    width: 0,
                    color: theme.sidebarTextActiveBorder,
                  ),
                ),
              Opacity(
                opacity: widget.isMuted ? 0.5 : 1,
                child: Row(
                  children: [
                    const SizedBox(width: 24),
                    // أيقونة المجموعة: عداد أعضاء بدل الصورة الرمزية (status--group).
                    Container(
                      width: 16,
                      height: 16,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: hasUnreads
                            ? theme.sidebarUnreadText
                            : theme.sidebarText.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '$_membersCount',
                        style: TextStyle(
                          color: theme.sidebarBg,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        channel.displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          color: hasUnreads
                              ? theme.sidebarUnreadText
                              : theme.sidebarText,
                          fontWeight: hasUnreads || widget.isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    if (hasMentions)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: theme.mentionBg,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${widget.unread!.mentions}',
                          style: TextStyle(
                            color: theme.mentionColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    else if (hasUnreads)
                      Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: theme.sidebarUnreadText,
                          shape: BoxShape.circle,
                        ),
                      ),
                    const SizedBox(width: 2),
                    AnimatedOpacity(
                      opacity: _hovered ? 1 : 0,
                      duration: const Duration(milliseconds: 100),
                      child: ChannelRowMenu(channel: channel, iconSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
