import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/enums/channel_type.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/design_tokens.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_entity.dart';
import 'package:flutter_mattermost/features/channels/domain/repositories/channel_repository.dart';
import 'package:flutter_mattermost/features/channels/presentation/widgets/channel_context_menu.dart';

/// صف قناة في LHS — مطابق sidebar_channel.tsx + sidebar_channel_link.tsx:
/// ارتفاع 32px، padding 7px 16px 7px 19px، نشط = bg rgba(text,0.08)
/// + خط عمودي 4px، unread = نص عريض sidebar-unread-text، شارة منشنات pill،
/// hover = sidebar-text-hover-bg، وقائمة ⋯ (sidebar_channel_menu) عند التمرير
/// أو النقر اليميني: مفضلة/نقل/كتم/تفضيلات/نسخ/معلومات/إعدادات/مغادرة/أرشفة.
class SidebarChannelRow extends StatefulWidget {
  final ChannelEntity channel;
  final ChannelUnreadCounts? unread;
  final bool isSelected;

  /// قناة مكتومة — يُعتَّم نصها وأيقونتها (مطابق .muted في SidebarLink).
  final bool isMuted;
  final VoidCallback onTap;

  /// خارجي (GlobalKey) لقياس موضع الصف لمؤشرات غير المقروءة.
  final Key? rowKey;

  const SidebarChannelRow({
    super.key,
    required this.channel,
    required this.unread,
    required this.isSelected,
    this.isMuted = false,
    required this.onTap,
    this.rowKey,
  });

  @override
  State<SidebarChannelRow> createState() => _SidebarChannelRowState();
}

class _SidebarChannelRowState extends State<SidebarChannelRow> {
  bool isHovered = false;

  /// هل النص مقصوص فعلياً؟ — يُظهر tooltip بالاسم الكامل فقط عند الاقتطاع
  /// (مطابق enableToolTipIfNeeded في sidebar_channel_link.tsx).
  bool _isTruncated = false;
  final GlobalKey _textKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkTruncation());
  }

  @override
  void didUpdateWidget(covariant SidebarChannelRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkTruncation());
  }

  void _checkTruncation() {
    final context = _textKey.currentContext;
    if (context == null) return;
    final renderObject = context.findRenderObject();
    if (renderObject is! RenderBox) return;
    final size = renderObject.size;
    if (size.height == 0) return;
    final painter = TextPainter(
      text: TextSpan(
        text: widget.channel.displayName,
        style: const TextStyle(fontSize: 14),
      ),
      textDirection: Directionality.of(context),
      maxLines: 1,
      ellipsis: '…',
    )..layout(maxWidth: size.width);
    final truncated = painter.didExceedMaxLines || painter.width > size.width;
    if (truncated != _isTruncated) {
      setState(() => _isTruncated = truncated);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final channel = widget.channel;
    final hasUnreads = widget.unread?.hasUnreads ?? false;
    final hasMentions = (widget.unread?.mentions ?? 0) > 0;
    final isArchived = channel.deleteAt > 0;

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
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
              : isHovered
              ? theme.sidebarTextHoverBg
              : Colors.transparent,
          child: Stack(
            alignment: AlignmentDirectional.centerStart,
            children: [
              // خط نشط عمودي 4px (SidebarLink.active::before)
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
                        active: hasUnreads || widget.isSelected,
                        theme: theme,
                        archived: isArchived,
                      ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Tooltip(
                        message: _isTruncated ? channel.displayName : '',
                        child: Text(
                          channel.displayName,
                          key: _textKey,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            decoration: isArchived
                                ? TextDecoration.lineThrough
                                : null,
                            color: theme.sidebarText.withValues(alpha: 0.65),
                            fontWeight: hasUnreads || widget.isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
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
                    // قائمة القناة تظهر عند التمرير فقط (مثل sidebar-menu في webapp).
                    AnimatedOpacity(
                      opacity: isHovered ? 1 : 0,
                      duration: const Duration(milliseconds: 100),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: ChannelRowMenu(channel: channel),
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
