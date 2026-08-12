import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';

class MatterMenuItem {
  final String id;
  final Widget? icon;
  final String label;
  final TextSpan? richText;
  final String? subtitle;
  final VoidCallback? onTap;
  final bool danger;
  final bool separatorBefore;
  final bool isDivider;

  const MatterMenuItem({
    required this.id,
    required this.label,
    this.icon,
    this.richText,
    this.subtitle,
    this.onTap,
    this.danger = false,
    this.separatorBefore = false,
    this.isDivider = false,
  });

  const MatterMenuItem.divider()
      : id = '',
        label = '',
        icon = null,
        richText = null,
        subtitle = null,
        onTap = null,
        danger = false,
        separatorBefore = false,
        isDivider = true;

  const MatterMenuItem.richText({
    required this.id,
    required this.richText,
    this.icon,
    this.subtitle,
    this.onTap,
    this.danger = false,
    this.separatorBefore = false,
  })  : label = '',
        isDivider = false;
}

/// قائمة منبثقة مطابقة لـ MenuWrapper + Floating UI في webapp.
/// تفتح فوق/أسفل الزر وتُغلق عند النقر خارجها أو Escape.
class MatterMenu extends StatefulWidget {
  final Widget child;
  final List<MatterMenuItem> items;
  final bool openUp;
  final bool openLeft;

  const MatterMenu({
    super.key,
    required this.child,
    required this.items,
    this.openUp = false,
    this.openLeft = false,
  });

  @override
  State<MatterMenu> createState() => _MatterMenuState();
}

class _MatterMenuState extends State<MatterMenu> {
  final GlobalKey _anchorKey = GlobalKey();
  OverlayEntry? _entry;
  bool _opened = false;

  @override
  void dispose() {
    _close();
    super.dispose();
  }

  void _open() {
    if (_opened) {
      setState(() => _opened = false);
      return;
    }
    final box = _anchorKey.currentContext!.findRenderObject()! as RenderBox;
    final overlay =
        Overlay.of(context).context.findRenderObject()! as RenderBox;
    final offset = box.localToGlobal(Offset.zero, ancestor: overlay);

    final overlaySize = overlay.size;
    final menuWidth = 264.0;
    final menuHeight = widget.items.length * 40.0 + 8;

    var dx = offset.dx;
    if (widget.openLeft) {
      dx = dx + box.size.width - menuWidth;
    }
    dx = dx.clamp(8.0, overlaySize.width - menuWidth - 8);

    var dy = widget.openUp
        ? offset.dy - menuHeight - 4
        : offset.dy + box.size.height + 4;
    if (dy < 8) dy = 8;
    if (dy + menuHeight > overlaySize.height - 8) {
      dy = overlaySize.height - menuHeight - 8;
    }

    _entry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _close,
              child: const SizedBox.expand(),
            ),
          ),
          _MenuOverlay(
            left: dx,
            top: dy,
            width: menuWidth,
            items: widget.items,
            onClose: _close,
          ),
        ],
      ),
    );
    Overlay.of(context).insert(_entry!);
    setState(() => _opened = true);
  }

  void _close() {
    _entry?.remove();
    _entry = null;
    if (_opened) setState(() => _opened = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(key: _anchorKey, onTap: _open, child: widget.child);
  }
}

class _MenuOverlay extends StatelessWidget {
  final double left;
  final double top;
  final double width;
  final List<MatterMenuItem> items;
  final VoidCallback onClose;

  const _MenuOverlay({
    required this.left,
    required this.top,
    required this.width,
    required this.items,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Positioned(
      left: left,
      top: top,
      width: width,
      child: Material(
        color: theme.centerChannelBg,
        elevation: 4,
        borderRadius: BorderRadius.circular(4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final item in items) ...[
              if (item.separatorBefore || item.isDivider)
                Container(
                  height: 1,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  color: theme.centerChannelColor.withValues(alpha: 0.16),
                ),
              if (!item.isDivider)
                InkWell(
                  onTap: () {
                    onClose();
                    item.onTap?.call();
                  },
                  child: Container(
                    height: item.subtitle != null ? 52 : 40,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        if (item.icon != null) ...[
                          item.icon!,
                          const SizedBox(width: 8),
                        ],
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (item.richText != null)
                                Text.rich(
                                  item.richText!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: item.danger
                                        ? theme.errorTextColor
                                        : theme.centerChannelColor,
                                  ),
                                )
                              else
                                Text(
                                  item.label,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: item.danger
                                        ? theme.errorTextColor
                                        : theme.centerChannelColor,
                                  ),
                                ),
                              if (item.subtitle != null)
                                Text(
                                  item.subtitle!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: theme.centerChannelColor
                                        .withValues(alpha: 0.72),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

/// يفتح قائمة مؤقتة فوق عنصر محدد (بدون امتلاك الزر).
class MatterMenuScope extends StatelessWidget {
  final Widget child;
  final List<MatterMenuItem> items;
  final bool openUp;
  final BorderRadius? borderRadius;
  final Color? hoverColor;

  const MatterMenuScope({
    super.key,
    required this.child,
    required this.items,
    this.openUp = false,
    this.borderRadius,
    this.hoverColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        hoverColor:
            hoverColor ?? AppTheme.of(context).mentionBg.withValues(alpha: 0.15),
        borderRadius: borderRadius ?? BorderRadius.circular(4.0),
        onTap: () {},
        child: MatterMenu(items: items, openUp: openUp, child: child),
      ),
    );
  }
}
