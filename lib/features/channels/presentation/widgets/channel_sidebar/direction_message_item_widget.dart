import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/storage/draft_storage_service.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/design_tokens.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:flutter_mattermost/core/widgets/hover_widget.dart';
import 'package:flutter_mattermost/core/widgets/profile_picture.dart';
import 'package:flutter_mattermost/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_mattermost/features/auth/domain/entities/user_status_entity.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_entity.dart';
import 'package:flutter_mattermost/features/channels/domain/repositories/channel_repository.dart';
import 'package:flutter_mattermost/features/channels/presentation/bloc/channel_bloc.dart';
import 'package:flutter_mattermost/features/channels/presentation/widgets/channel_context_menu.dart';
import 'package:flutter_mattermost/features/channels/presentation/widgets/channel_sidebar/sidebar_category.dart';

/// صف DM مع حالة المستخدم — مطابق sidebar_channel.tsx مع status indicator،
/// وقائمة قناة (⋯ عند التمرير أو النقر اليميني) مثل بقية القنوات.
class DirectionMessageItemWidget extends StatelessWidget {
  final ChannelEntity channel;
  final UserStatus? status;

  /// المستخدم المقابل لحل اسم المحادثة (الخادم يترك display_name فارغاً).
  final UserEntity user;
  final ChannelUnreadCounts? unread;
  final bool isSelected;
  final bool isMuted;
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
    required this.onTap,
    required this.draggableFrom,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final hasUnreads = unread?.hasUnreads ?? false;
    final hasMentions = (unread?.mentions ?? 0) > 0;

    String label() {
      if (channel.displayName.isNotEmpty) return channel.displayName;
      final u = user;
      final full = '${u.firstName} ${u.lastName}'.trim();
      if (full.isNotEmpty) return full;
      return u.username;
    }

    // نفس نوع بيانات السحب المستخدم في SidebarCategory ليعمل الإفلات
    // المتبادل بين قسم DM والفئات الأخرى (النقل يحدث عند DragTarget.onAccept).
    return LongPressDraggable<SidebarCategoryDragData>(
      data: SidebarCategoryDragData(
        channelId: channel.id,
        fromCategoryId: draggableFrom,
      ),
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
            label(),
            style: TextStyle(
              color: theme.sidebarText.withValues(alpha: 0.65),
              fontSize: 14,
            ),
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: _content(context, theme, hasUnreads, hasMentions, label()),
      ),
      child: _content(context, theme, hasUnreads, hasMentions, label()),
    );
  }

  Widget _content(
    BuildContext context,
    MattermostColors theme,
    bool hasUnreads,
    bool hasMentions,
    String label,
  ) {
    return HoverWidget(
      cursor: SystemMouseCursors.click,
      builder: (_, isHovered) => GestureDetector(
        onTap: onTap,
        onSecondaryTapDown: (details) {
          showChannelContextMenu(context, channel, details.globalPosition);
        },
        child: Container(
          height: DesignTokens.sidebarRowHeight,
          color: isSelected
              ? theme.sidebarText.withValues(alpha: 0.08)
              : isHovered
              ? theme.sidebarTextHoverBg
              : Colors.transparent,
          child: Stack(
            alignment: AlignmentDirectional.centerStart,
            children: [
              if (isSelected)
                PositionedDirectional(
                  start: 0,
                  top: 0,
                  bottom: 0,
                  child: VerticalDivider(
                    width: 0,
                    thickness: 2.00,
                    color: theme.sidebarTextActiveBorder,
                  ),
                ),
              Opacity(
                opacity: isMuted ? 0.5 : 1,
                child: Row(
                  children: [
                    const SizedBox(width: 20),

                    if (channel.displayName.split(', ').length < 3)
                      Stack(
                        alignment: AlignmentGeometry.bottomEnd,
                        children: [
                          ProfilePicture.sm(
                            userId: user.id,
                            username: user.username,
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
                      )
                    else
                      Container(
                        width: 25,
                        height: 22,
                        alignment: .center,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.10),
                        ),
                        child: Text(
                          '${channel.displayName.split(', ').length - 1}',
                          style: TextStyle(color: theme.centerChannelBg),
                        ),
                      ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsetsDirectional.only(
                          top: 4.0,
                          start: 8,
                        ),
                        child: Text(
                          channel.displayName.isEmpty
                              ? user.username
                              : channel.displayName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.sidebarText.withValues(alpha: 0.65),
                            fontWeight: hasUnreads || isSelected
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
                          '${unread!.mentions}',
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
                    // مؤشر المسودة ✏️ — نفس سلوك صف القنوات العادية.
                    ListenableBuilder(
                      listenable: getIt<DraftStorageService>(),
                      builder: (context, _) {
                        final hasDraft = getIt<DraftStorageService>().hasDraft(
                          channel.id,
                        );
                        if (!hasDraft) return const SizedBox.shrink();
                        return Padding(
                          padding: const EdgeInsetsDirectional.only(end: 4),
                          child: Icon(
                            Icons.edit_outlined,
                            size: 12,
                            color: theme.sidebarText.withValues(alpha: 0.6),
                          ),
                        );
                      },
                    ),

                    // زر الإغلاق السريع X + قائمة القناة عند التمرير فقط.
                    AnimatedOpacity(
                      opacity: isHovered ? 1 : 0.0,
                      duration: const Duration(milliseconds: 100),
                      child: ChannelRowItemMenu(channel: channel, iconSize: 16),
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

  Color _statusColor(MattermostColors theme) {
    switch (status) {
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

/// زر الإغلاق السريع للمحادثة المباشرة (X) — يظهر عند التمرير على الصف
/// ويُزيل المحادثة من القائمة (مطابق closeDirectMessage في webapp).
class _CloseDmButton extends StatelessWidget {
  final ChannelEntity channel;
  final MattermostColors theme;

  const _CloseDmButton({required this.channel, required this.theme});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Tooltip(
      message: l10n.center_panelDirectCloseDirectMessage,
      child: InkWell(
        onTap: () {
          final state = context.read<ChannelBloc>().state;
          final userId = state is ChannelsLoadedState ? state.userId : '';
          context.read<ChannelBloc>().add(
            LeaveChannelEvent(channelId: channel.id, userId: userId),
          );
        },
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Icon(
            Icons.close,
            size: 14,
            color: theme.sidebarText.withValues(alpha: 0.64),
          ),
        ),
      ),
    );
  }
}
