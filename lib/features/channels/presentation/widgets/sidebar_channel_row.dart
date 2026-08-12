import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/enums/channel_type.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/design_tokens.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_entity.dart';
import 'package:flutter_mattermost/features/channels/domain/repositories/channel_repository.dart';
import 'package:flutter_mattermost/features/channels/presentation/bloc/channel_bloc.dart';

/// صف قناة في LHS — مطابق sidebar_channel.tsx + sidebar_channel_link.tsx:
/// ارتفاع 32px، padding 7px 16px 7px 19px، نشط = bg rgba(text,0.08)
/// + خط عمودي 4px بعرض 4px، unread = نص عريض sidebar-unread-text،
/// شارة إشارات pill، hover = sidebar-text-hover-bg.
class SidebarChannelRow extends StatefulWidget {
  final ChannelEntity channel;
  final ChannelUnreadCounts? unread;
  final bool isSelected;
  final VoidCallback onTap;

  const SidebarChannelRow({
    super.key,
    required this.channel,
    required this.unread,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<SidebarChannelRow> createState() => _SidebarChannelRowState();
}

class _SidebarChannelRowState extends State<SidebarChannelRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final channel = widget.channel;
    final hasUnreads = widget.unread?.hasUnreads ?? false;
    final hasMentions = (widget.unread?.mentions ?? 0) > 0;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: DesignTokens.sidebarRowHeight,
          padding: DesignTokens.sidebarRowPadding,
          color: widget.isSelected
              ? theme.sidebarText.withValues(alpha: 0.08)
              : _hovered
              ? theme.sidebarTextHoverBg
              : Colors.transparent,
          child: Stack(
            children: [
              // خط نشط عمودي 4px (SidebarLink.active::before)
              if (widget.isSelected)
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: 4,
                    decoration: BoxDecoration(
                      color: theme.sidebarTextActiveBorder,
                      borderRadius: BorderRadius.circular(
                        DesignTokens.radiusSm,
                      ),
                    ),
                  ),
                ),
              Row(
                children: [
                  _ChannelIcon(
                    type: channel.type,
                    active: hasUnreads || widget.isSelected,
                    theme: theme,
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
                  if (hasMentions)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: theme.mentionBg ?? theme.errorTextColor,
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
                ],
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
  final MattermostColors theme;

  const _ChannelIcon({
    required this.type,
    required this.active,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final color = active
        ? theme.sidebarUnreadText
        : theme.sidebarText.withValues(alpha: 0.7);
    if (type == ChannelType.direct) {
      return Icon(Icons.circle, size: 8, color: color);
    }
    return Icon(
      type == ChannelType.private ? Icons.lock_outline : Icons.tag,
      size: 15,
      color: color,
    );
  }
}