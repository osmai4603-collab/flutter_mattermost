import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';

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

  /// بنود قائمة فرعية (submenu) تُفتح بجانب البند عند التمرير أو النقر.
  final List<MatterMenuItem>? submenu;

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
    this.submenu,
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
      isDivider = true,
      submenu = null;

  const MatterMenuItem.richText({
    required this.id,
    required this.richText,
    this.icon,
    this.subtitle,
    this.onTap,
    this.danger = false,
    this.separatorBefore = false,
    this.submenu,
  }) : label = '',
       isDivider = false;
}

const double _kMenuWidth = 264.0;

/// ارتفاع القائمة المحسوب من بنودها (نفس قواعد التصيير في [_MenuOverlayPanel]).
double _menuHeight(List<MatterMenuItem> items) {
  var h = 0.0;
  for (final item in items) {
    if (item.isDivider || item.separatorBefore) {
      h += 17;
    } else {
      h += item.subtitle != null ? 52.0 : 40.0;
    }
  }
  return h + 8;
}

/// يفتح قائمة سياقية عند موضع مؤشر معيّن (يُستخدم للنقر اليميني على الصفوف).
///
/// تُوضع القائمة بحيث تبقى داخل حدود الشاشة، وتُغلق عند النقر خارجها
/// أو عند اختيار بند.
void showContextMenuAt(
  BuildContext context, {
  required Offset position,
  required List<MatterMenuItem> items,
}) {
  final overlay = Overlay.of(context).context.findRenderObject()! as RenderBox;
  final overlaySize = overlay.size;
  final height = _menuHeight(items);

  var dx = position.dx;
  if (dx + _kMenuWidth > overlaySize.width - 8) {
    dx = position.dx - _kMenuWidth - 4;
  }
  dx = dx.clamp(8.0, overlaySize.width - _kMenuWidth - 8);

  var dy = position.dy;
  if (dy + height > overlaySize.height - 8) {
    dy = overlaySize.height - height - 8;
  }
  dy = dy.clamp(8.0, overlaySize.height - height - 8);

  late final OverlayEntry entry;
  entry = OverlayEntry(
    builder: (context) => Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => entry.remove(),
            child: const SizedBox.expand(),
          ),
        ),
        _MenuOverlayPanel(
          left: dx,
          top: dy,
          width: _kMenuWidth,
          items: items,
          onCloseSelf: () => entry.remove(),
          onCloseAll: () => entry.remove(),
        ),
      ],
    ),
  );
  Overlay.of(context).insert(entry);
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
    final menuWidth = _kMenuWidth;
    final menuHeight = _menuHeight(widget.items);

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

    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _close,
              child: const SizedBox.expand(),
            ),
          ),
          _MenuOverlayPanel(
            left: dx,
            top: dy,
            width: menuWidth,
            items: widget.items,
            onCloseSelf: _close,
            onCloseAll: _close,
          ),
        ],
      ),
    );
    _entry = entry;
    Overlay.of(context).insert(entry);
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

/// لوحة قائمة تُدار بنفسها: تدعم فتح قائمة فرعية (submenu) إلى جانب أي بند
/// يحتوي [MatterMenuItem.submenu] عند التمرير فوقه أو النقر عليه.
class _MenuOverlayPanel extends StatefulWidget {
  final double left;
  final double top;
  final double width;
  final List<MatterMenuItem> items;

  /// إغلاق هذه اللوحة فقط (تبقى اللوحات الأم مفتوحة).
  final VoidCallback onCloseSelf;

  /// إغلاق سلسلة القوائم بالكامل (الأم + الفرعية) عند اختيار بند.
  final VoidCallback onCloseAll;

  const _MenuOverlayPanel({
    required this.left,
    required this.top,
    required this.width,
    required this.items,
    required this.onCloseSelf,
    required this.onCloseAll,
  });

  @override
  State<_MenuOverlayPanel> createState() => _MenuOverlayPanelState();
}

class _MenuOverlayPanelState extends State<_MenuOverlayPanel> {
  OverlayEntry? _submenuEntry;
  int? _openSubmenuFor;

  @override
  void dispose() {
    _submenuEntry?.remove();
    super.dispose();
  }

  /// إحداثي y لبداية بند [index] داخل اللوحة (نفس قواعد التصيير).
  double _itemOffset(int index) {
    var y = 0.0;
    for (var i = 0; i < index; i++) {
      final item = widget.items[i];
      if (item.isDivider || item.separatorBefore) {
        y += 17;
      } else {
        y += item.subtitle != null ? 52.0 : 40.0;
      }
    }
    return y;
  }

  void _closeSubmenu() {
    _submenuEntry?.remove();
    _submenuEntry = null;
    _openSubmenuFor = null;
  }

  void _toggleSubmenu(int index, MatterMenuItem item) {
    if (_openSubmenuFor == index && _submenuEntry != null) {
      setState(_closeSubmenu);
    } else {
      _openSubmenu(index, item);
    }
  }

  void _openSubmenu(int index, MatterMenuItem item) {
    final subItems = item.submenu;
    if (subItems == null || subItems.isEmpty) return;
    if (_openSubmenuFor == index && _submenuEntry != null) return;

    _closeSubmenu();
    final overlay =
        Overlay.of(context).context.findRenderObject()! as RenderBox;
    final height = _menuHeight(subItems);

    var sx = widget.left + widget.width - 4;
    if (sx + _kMenuWidth > overlay.size.width - 8) {
      sx = widget.left - _kMenuWidth + 4;
    }
    var sy = widget.top + _itemOffset(index);
    if (sy + height > overlay.size.height - 8) {
      sy = overlay.size.height - height - 8;
    }
    sy = sy.clamp(8.0, overlay.size.height - height - 8);

    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => entry.remove(),
              child: const SizedBox.expand(),
            ),
          ),
          _MenuOverlayPanel(
            left: sx,
            top: sy,
            width: _kMenuWidth,
            items: subItems,
            onCloseSelf: () => entry.remove(),
            onCloseAll: () {
              entry.remove();
              widget.onCloseAll();
            },
          ),
        ],
      ),
    );
    _openSubmenuFor = index;
    _submenuEntry = entry;
    Overlay.of(context).insert(entry);
  }

  void _onItemTap(int index, MatterMenuItem item) {
    if (item.submenu != null && item.submenu!.isNotEmpty) {
      _toggleSubmenu(index, item);
      return;
    }
    _closeSubmenu();
    widget.onCloseAll();
    item.onTap?.call();
  }

  Widget _buildItem(MattermostColors theme, MatterMenuItem item) {
    return Container(
      height: item.subtitle != null ? 52 : 40,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          if (item.icon != null) ...[item.icon!, const SizedBox(width: 8)],
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item.richText != null)
                  Text.rich(
                    maxLines: 3,
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
                      fontWeight: FontWeight.w400,
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
                      color: theme.centerChannelColor.withValues(alpha: 0.72),
                    ),
                  ),
              ],
            ),
          ),
          if (item.submenu != null) ...[
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right,
              size: 18,
              color: theme.centerChannelColor.withValues(alpha: 0.5),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Positioned(
      left: widget.left,
      top: widget.top,
      width: widget.width,
      child: Material(
        color: theme.centerChannelBg,
        elevation: 4,
        borderRadius: BorderRadius.circular(4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var index = 0; index < widget.items.length; index++) ...[
              if (widget.items[index].separatorBefore ||
                  widget.items[index].isDivider)
                Container(
                  height: 1,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  color: theme.centerChannelColor.withValues(alpha: 0.16),
                ),
              if (!widget.items[index].isDivider)
                MouseRegion(
                  onEnter: (_) => _openSubmenu(index, widget.items[index]),
                  child: InkWell(
                    onTap: () => _onItemTap(index, widget.items[index]),
                    child: _buildItem(theme, widget.items[index]),
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
            hoverColor ??
            AppTheme.of(context).mentionBg.withValues(alpha: 0.15),
        borderRadius: borderRadius ?? BorderRadius.circular(4.0),
        onTap: () {},
        child: MatterMenu(items: items, openUp: openUp, child: child),
      ),
    );
  }
}
