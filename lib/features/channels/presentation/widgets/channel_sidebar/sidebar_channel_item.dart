import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/enums/channel_type.dart';
import 'package:flutter_mattermost/core/storage/draft_storage_service.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/design_tokens.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:flutter_mattermost/core/widgets/hover_widget.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_entity.dart';
import 'package:flutter_mattermost/features/channels/domain/repositories/channel_repository.dart';
import 'package:flutter_mattermost/features/channels/presentation/widgets/channel_context_menu.dart';

/// صف قناة في LHS — مطابق sidebar_channel.tsx + sidebar_channel_link.tsx:
/// ارتفاع 32px، padding 7px 16px 7px 19px، نشط = bg rgba(text,0.08)
/// + خط عمودي 4px، unread = نص عريض sidebar-unread-text، شارة منشنات pill،
/// hover = sidebar-text-hover-bg، وقائمة ⋯ (sidebar_channel_menu) عند التمرير
/// أو النقر اليميني: مفضلة/نقل/كتم/تفضيلات/نسخ/معلومات/إعدادات/مغادرة/أرشفة.
class SidebarChannelItem extends StatelessWidget {
  final ChannelEntity channel;
  final ChannelUnreadCounts? unread;
  final bool isSelected;

  /// قناة مكتومة — يُعتَّم نصها وأيقونتها (مطابق .muted في SidebarLink).
  final bool isMuted;
  final VoidCallback onTap;

  const SidebarChannelItem({
    super.key,
    required this.channel,
    required this.unread,
    required this.isSelected,
    this.isMuted = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final hasUnreads = unread?.hasUnreads ?? false;
    final hasMentions = (unread?.mentions ?? 0) > 0;
    final isArchived = channel.deleteAt > 0;

    return HoverWidget(
      cursor: SystemMouseCursors.click,
      builder: (_, isHovered) => GestureDetector(
        onTap: onTap,
        // onSecondaryTapDown: (details) {
        //   showChannelContextMenu(context, channel, details.globalPosition);
        // },
        behavior: HitTestBehavior.opaque,
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
                    thickness: 2,
                    width: 0,
                    color: theme.sidebarTextActiveBorder,
                  ),
                ),
              Opacity(
                opacity: isMuted ? 0.5 : 1,
                child: Row(
                  children: [
                    const SizedBox(width: 24),
                    if (channel.type == .open)
                      Image.asset(
                        'assets/images/channel_icon.png',
                        width: 16,
                        fit: .cover,
                        color: theme.sidebarText.withValues(alpha: 0.64),
                      ),
                    if (channel.type != .open)
                      _ChannelIcon(
                        type: channel.type,
                        active: hasUnreads || isSelected,
                        theme: theme,
                        archived: isArchived,
                      ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        channel.displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          decoration: isArchived
                              ? TextDecoration.lineThrough
                              : null,
                          color: theme.sidebarText.withValues(alpha: 0.65),
                          fontWeight: hasUnreads || isSelected
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
                    // مؤشر المسودة ✏️ — يظهر عندما توجد مسودة محفوظة لهذه
                    // القناة (مطابق draft_indicator في sidebar_channel_link.tsx).
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
                    // قائمة القناة تظهر عند التمرير فقط (مثل sidebar-menu في webapp).
                    AnimatedOpacity(
                      opacity: isHovered ? 1 : 0,
                      duration: const Duration(milliseconds: 100),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: ChannelRowItemMenu(channel: channel),
                      ),
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

class _ChannelIcon extends StatelessWidget {
  final ChannelType type;
  final bool active;
  final bool archived;
  final MattermostColors theme;

  const _ChannelIcon({
    required this.type,
    required this.active,
    required this.theme,
    this.archived = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = active
        ? theme.sidebarUnreadText
        : theme.sidebarText.withValues(alpha: 0.7);
    if (type == ChannelType.direct) {
      // أفاتار المستخدم في webapp — أيقونة شخص بديل حتى تُحمّل الصور.
      return Icon(Icons.person, size: 14, color: color);
    }
    return Icon(
      archived
          ? Icons.archive_outlined
          : type == ChannelType.private
          ? Icons.lock_outline
          : Icons.tag,
      size: 15,
      color: color,
    );
  }
}
