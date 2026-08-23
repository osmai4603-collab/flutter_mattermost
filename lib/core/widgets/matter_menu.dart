import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';

class MatterMenuItem {
  final String id;
  final Widget? icon;
  final Widget? trailingIcon;
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
    this.trailingIcon,
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
      trailingIcon = null,
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
    this.trailingIcon,
    this.subtitle,
    this.onTap,
    this.danger = false,
    this.separatorBefore = false,
    this.submenu,
  }) : label = '',
       isDivider = false;
}

/// تنسيق لوحة القائمة (مطابق لمظهر الويب: خلفية القناة، ظل، زوايا دائرية).
MenuStyle _menuStyle(MattermostColors theme) => MenuStyle(
  backgroundColor: WidgetStatePropertyAll(theme.centerChannelBg),
  elevation: const WidgetStatePropertyAll(4),
  shape: WidgetStatePropertyAll(
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
  ),
  minimumSize: const WidgetStatePropertyAll(Size(264, 0)),
  maximumSize: const WidgetStatePropertyAll(Size(264, double.infinity)),
);

/// تنسيق بند القائمة: لون النص/الأيقونة (أحمر للبنود الحسّاسة) مع تمييز عند
/// التمرير.
ButtonStyle _itemStyle(MattermostColors theme, bool danger) {
  final fg = danger ? theme.errorTextColor : theme.centerChannelColor;
  final base = MenuItemButton.styleFrom(
    foregroundColor: fg,
    iconColor: fg,
    iconSize: 18,
    textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    minimumSize: const Size(0, 40),
  );
  return base.copyWith(
    overlayColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.hovered)) {
        return theme.centerChannelColor.withValues(alpha: 0.06);
      }
      if (states.contains(WidgetState.pressed)) {
        return theme.centerChannelColor.withValues(alpha: 0.10);
      }
      if (states.contains(WidgetState.focused)) {
        return theme.centerChannelColor.withValues(alpha: 0.10);
      }
      return null;
    }),
  );
}

/// نص البند: سطر واحد، أو سطران عند وجود [MatterMenuItem.subtitle]، أو
/// [MatterMenuItem.richText] عند وجوده.
Widget _itemLabel(MattermostColors theme, MatterMenuItem item) {
  final color = item.danger ? theme.errorTextColor : theme.centerChannelColor;

  if (item.richText != null) {
    return Text.rich(
      item.richText!,
      maxLines: 3,
      style: TextStyle(fontSize: 14, color: color),
    );
  }

  final label = Text(
    item.label,
    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: color),
  );

  if (item.subtitle == null) return label;

  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      label,
      Text(
        item.subtitle!,
        style: TextStyle(
          fontSize: 12,
          color: theme.centerChannelColor.withValues(alpha: 0.72),
        ),
      ),
    ],
  );
}

/// يحوّل قائمة [MatterMenuItem] إلى widgets متوافقة مع [MenuAnchor]
/// ([MenuItemButton] / [SubmenuButton] / [Divider]).
List<Widget> _buildMenuChildren(
  BuildContext context,
  List<MatterMenuItem> items,
) {
  final theme = AppTheme.of(context);
  final widgets = <Widget>[];

  for (final item in items) {
    // فاصل
    if (item.isDivider || item.separatorBefore) {
      widgets.add(
        Divider(
          height: 17,
          thickness: 1,
          color: theme.centerChannelColor.withValues(alpha: 0.16),
        ),
      );
      if (item.isDivider) continue;
    }

    // بند مع قائمة فرعية
    if (item.submenu != null && item.submenu!.isNotEmpty) {
      widgets.add(
        SubmenuButton(
          menuStyle: _menuStyle(theme),
          style: _itemStyle(theme, item.danger),
          menuChildren: _buildMenuChildren(context, item.submenu!),
          leadingIcon: item.icon,
          trailingIcon: item.trailingIcon,
          submenuIcon: WidgetStatePropertyAll(
            Icon(
              Icons.chevron_right,
              size: 18,
              color: theme.centerChannelColor.withValues(alpha: 0.5),
            ),
          ),
          child: _itemLabel(theme, item),
        ),
      );
      continue;
    }

    // بند عادي
    widgets.add(
      MenuItemButton(
        style: _itemStyle(theme, item.danger),
        leadingIcon: item.icon,
        trailingIcon: item.trailingIcon,
        onPressed: () => item.onTap?.call(),
        child: _itemLabel(theme, item),
      ),
    );
  }
  return widgets;
}

/// يفتح قائمة سياقية عند موضع مؤشر معيّن (يُستخدم للنقر اليميني على الصفوف).
///
/// تُوضع القائمة تلقائياً داخل حدود الشاشة (تقلب للأعلى/للأيسر عند الحاجة)،
/// وتُغلق عند النقر خارجها أو Escape أو اختيار بند.
void showContextMenuAt(
  BuildContext context, {
  required Offset position,
  required List<MatterMenuItem> items,
}) {
  final overlay = Overlay.of(context);
  final controller = MenuController();

  late final OverlayEntry entry;
  entry = OverlayEntry(
    builder: (context) {
      final theme = AppTheme.of(context);
      return Stack(
        children: [
          Positioned(
            left: position.dx,
            top: position.dy,
            child: MenuAnchor(
              controller: controller,
              onClose: () => entry.remove(),
              style: _menuStyle(theme),
              menuChildren: _buildMenuChildren(context, items),
              child: const SizedBox.shrink(),
            ),
          ),
        ],
      );
    },
  );

  overlay.insert(entry);
  // يفتح القائمة بعد بناء الـ anchor في الطبقة (الـ controller يجب أن يكون
  // مرتبطاً قبل استدعاء open).
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (!controller.isOpen) controller.open();
  });
}

/// قائمة منبثقة مطابقة لـ MenuWrapper + Floating UI في webapp.
/// تفتح حول الزر وتُغلق عند النقر خارجها أو Escape.
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
  final MenuController _controller = MenuController();

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return SizedBox(
      child: MenuAnchor(
        controller: _controller,
        style: _menuStyle(theme),
        menuChildren: _buildMenuChildren(context, widget.items),
        builder: (context, controller, _) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () =>
                controller.isOpen ? controller.close() : controller.open(),
            child: widget.child,
          );
        },
      ),
    );
  }
}

/// يفتح قائمة مؤقتة فوق عنصر محدد (بدون امتلاك الزر) مع تأثير hover وتمرير
/// للفتح/الإغلاق.
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
    final theme = AppTheme.of(context);
    return SizedBox(
      child: MenuAnchor(
        style: _menuStyle(theme),
        menuChildren: _buildMenuChildren(context, items),
        builder: (context, controller, _) {
          return Material(
            color: Colors.transparent,
            child: InkWell(
              hoverColor: hoverColor ?? theme.mentionBg.withValues(alpha: 0.15),
              borderRadius: borderRadius ?? BorderRadius.circular(4.0),
              onTap: () =>
                  controller.isOpen ? controller.close() : controller.open(),
              child: child,
            ),
          );
        },
      ),
    );
  }
}
