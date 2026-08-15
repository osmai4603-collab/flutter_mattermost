import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/design_tokens.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:flutter_mattermost/core/widgets/profile_picture.dart';
import 'package:flutter_mattermost/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_mattermost/features/auth/domain/entities/user_status_entity.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_entity.dart';
import 'package:flutter_mattermost/features/channels/domain/repositories/channel_repository.dart';
import 'package:flutter_mattermost/features/channels/presentation/widgets/channel_context_menu.dart';
import 'package:flutter_mattermost/features/channels/presentation/widgets/channel_sidebar/sidebar_category.dart';

/// صف DM مع حالة المستخدم — مطابق sidebar_channel.tsx مع status indicator،
/// وقائمة قناة (⋯ عند التمرير أو النقر اليميني) مثل بقية القنوات.
class DirectionMessageItemWidget extends StatefulWidget {
  final ChannelEntity channel;
  final UserStatus? status;

  /// المستخدم المقابل لحل اسم المحادثة (الخادم يترك display_name فارغاً).
  final UserEntity? user;
  final ChannelUnreadCounts? unread;
  final bool isSelected;
  final bool isMuted;
  final Key? rowKey;
  final VoidCallback onTap;
  final String draggableFrom;

  const DirectionMessageItemWidget({
    super.key,
    required this.channel,
    required this.status,
    required this.user,
    required this.unread,
    required this.isSelected,
    this.isMuted = false,
    this.rowKey,
    required this.onTap,
    required this.draggableFrom,
  });

  @override
  State<DirectionMessageItemWidget> createState() =>
      _DirectionMessageItemWidgetState();
}

class _DirectionMessageItemWidgetState
    extends State<DirectionMessageItemWidget> {
  bool isHovered = false;

  /// اسم المحادثة: displayName من الخادم (GM) أو اسم المستخدم المقابل (DM)
  /// بالصيغة المتبعة في الواجهة: الاسم الكامل ثم @username عند غيابه.
  String get _label {
    final channel = widget.channel;
    if (channel.displayName.isNotEmpty) return channel.displayName;
    final u = widget.user;
    if (u != null) {
      final full = '${u.firstName} ${u.lastName}'.trim();
      if (full.isNotEmpty) return full;
      return u.username;
    }
    return channel.name;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final hasUnreads = widget.unread?.hasUnreads ?? false;
    final hasMentions = (widget.unread?.mentions ?? 0) > 0;

    // نفس نوع بيانات السحب المستخدم في SidebarCategory ليعمل الإفلات
    // المتبادل بين قسم DM والفئات الأخرى (النقل يحدث عند DragTarget.onAccept).
    return LongPressDraggable<SidebarCategoryDragData>(
      data: SidebarCategoryDragData(
        channelId: widget.channel.id,
        fromCategoryId: widget.draggableFrom,
      ),
      key: widget.rowKey,
      feedback: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsetsDirectional.only(start: 16),
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
            _label,
            style: TextStyle(
              color: theme.sidebarText.withValues(alpha: 0.65),
              fontSize: 14,
            ),
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
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        onSecondaryTapDown: (details) {
          showChannelContextMenu(context, channel, details.globalPosition);
        },
        child: Container(
          height: DesignTokens.sidebarRowHeight,
          color: widget.isSelected
              ? theme.sidebarText.withValues(alpha: 0.08)
              : isHovered
              ? theme.sidebarTextHoverBg
              : Colors.transparent,
          child: Stack(
            alignment: AlignmentDirectional.centerStart,
            children: [
              if (widget.isSelected)
                PositionedDirectional(
                  start: 0,
                  top: 0,
                  bottom: 0,
                  child: VerticalDivider(
                    width: 0,
                    thickness: 1.50,
                    color: theme.sidebarTextActiveBorder,
                  ),
                ),
              Opacity(
                opacity: widget.isMuted ? 0.5 : 1,
                child: Row(
                  children: [
                    const SizedBox(width: 20),

                    Stack(
                      alignment: AlignmentGeometry.bottomEnd,
                      children: [
                        ProfilePicture.sm(
                          username:
                              widget.user?.firstName ??
                              widget.user?.lastName ??
                              '',
                        ),
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _statusColor(theme),
                            border: Border.all(
                              color: theme.sidebarBg,
                              width: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Container(
                    //   width: 14,
                    //   height: 14,
                    //   decoration: BoxDecoration(
                    //     shape: BoxShape.circle,
                    //     color: hasUnreads
                    //         ? theme.sidebarUnreadText
                    //         : theme.sidebarText.withValues(alpha: 0.7),
                    //   ),
                    //   child: Center(
                    //     child: Container(
                    //       width: 8,
                    //       height: 8,
                    //       decoration: BoxDecoration(
                    //         shape: BoxShape.circle,
                    //         color: _statusColor(theme),
                    //         border: Border.all(
                    //           color: theme.sidebarBg,
                    //           width: 1,
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // const SizedBox(width: 8),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsetsDirectional.only(
                          top: 4.0,
                          start: 8,
                        ),
                        child: Text(
                          _label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.sidebarText.withValues(alpha: 0.65),
                            fontWeight: hasUnreads || widget.isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
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
                    if (isHovered)
                      ChannelRowMenu(channel: channel, iconSize: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _statusColor(MattermostColors theme) {
    switch (widget.status) {
      case UserStatus.online:
        return theme.onlineIndicator;
      case UserStatus.away:
        return theme.awayIndicator;
      case UserStatus.dnd:
        return theme.dndIndicator;
      case UserStatus.offline:
        return theme.sidebarText.withValues(alpha: 0.3);
      case null:
        return theme.sidebarText.withValues(alpha: 0.7);
    }
  }
}
