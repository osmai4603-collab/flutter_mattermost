import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/design_tokens.dart';
import 'package:flutter_mattermost/features/channels/presentation/widgets/channel_header/channel_global_header.dart';

/// زر أيقونة في الـ header (16px) — يطابق header_icon_button.scss:
/// padding 6px، radius 4، opacity النص 0.56، hover 0.08/0.72.
class RightIconButton extends StatefulWidget {
  final IconData icon;
  final String tooltip;
  final bool toggled;
  final VoidCallback onTap;

  const RightIconButton({super.key, 
    required this.icon,
    required this.tooltip,
    required this.toggled,
    required this.onTap,
  });

  @override
  State<RightIconButton> createState() => _RightIconButtonState();
}


class _RightIconButtonState extends State<RightIconButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final base = theme.sidebarText;
    final opacity = widget.toggled ? 1.0 : (_hovered ? 0.72 : 0.56);
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
          child: AnimatedContainer(
            duration: DesignTokens.hoverFadeDuration,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: widget.toggled
                  ? base.withValues(alpha: 0.8)
                  : _hovered
                  ? base.withValues(alpha: 0.08)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
            ),
            child: Icon(
              widget.icon,
              size: 19,
              color: widget.toggled
                  ? theme.sidebarTeamBarBg
                  : base.withValues(alpha: opacity),
            ),
          ),
        ),
      ),
    );
  }
}

