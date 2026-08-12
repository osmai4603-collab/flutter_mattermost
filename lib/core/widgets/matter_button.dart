import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/design_tokens.dart';

enum MatterButtonSize { standard, large, icon, small }

class MatterButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final MatterButtonSize size;
  final bool transparent;
  final bool danger;
  final String? tooltip;
  final EdgeInsetsGeometry? padding;

  const MatterButton({
    super.key,
    required this.child,
    this.onPressed,
    this.size = MatterButtonSize.standard,
    this.transparent = false,
    this.danger = false,
    this.tooltip,
    this.padding,
  });

  EdgeInsetsGeometry _defaultPadding(MatterButtonSize size) {
    switch (size) {
      case MatterButtonSize.standard:
        return EdgeInsets.symmetric(
          horizontal: transparent ? 4 : 10,
          vertical: transparent ? 4 : 6,
        );
      case MatterButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 14, vertical: 9);
      case MatterButtonSize.icon:
        return const EdgeInsets.all(7);
      case MatterButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 8, vertical: 4);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final enabled = onPressed != null;
    final radius = BorderRadius.circular(DesignTokens.radiusSm);

    final Widget inner = _MatterButtonSurface(
      hoveredBuilder: (hovered) {
        final Color? bg;
        if (!enabled) {
          bg = null;
        } else if (transparent) {
          bg = hovered
              ? theme.centerChannelColor.withValues(alpha: 0.08)
              : Colors.transparent;
        } else {
          bg = hovered ? theme.buttonBg.withValues(alpha: 0.9) : theme.buttonBg;
        }

        final color = !enabled
            ? theme.centerChannelColor.withValues(alpha: 0.4)
            : danger
            ? theme.errorTextColor
            : transparent
            ? theme.centerChannelColor.withValues(alpha: 0.75)
            : theme.buttonColor;

        return InkWell(
          onTap: onPressed,
          borderRadius: radius,
          child: Container(
            padding: padding ?? _defaultPadding(size),
            decoration: BoxDecoration(color: bg, borderRadius: radius),
            child: DefaultTextStyle.merge(
              style: TextStyle(
                color: color,
                fontSize: size == MatterButtonSize.small ? 12 : 14,
                fontWeight: FontWeight.w600,
              ),
              child: child,
            ),
          ),
        );
      },
    );

    if (tooltip == null) return inner;
    return Tooltip(message: tooltip!, child: inner);
  }
}

class _MatterButtonSurface extends StatefulWidget {
  final Widget Function(bool hovered) hoveredBuilder;

  const _MatterButtonSurface({required this.hoveredBuilder});

  @override
  State<_MatterButtonSurface> createState() => _MatterButtonSurfaceState();
}

class _MatterButtonSurfaceState extends State<_MatterButtonSurface> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: widget.hoveredBuilder(_hovered),
    );
  }
}
