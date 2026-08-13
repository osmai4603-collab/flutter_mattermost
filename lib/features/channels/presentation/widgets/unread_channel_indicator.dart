import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';

/// شريط مؤشر «قنوات غير مقروءة خارج منطقة الرؤية» — مطابق
/// unread_channel_indicator.tsx في webapp: يظهر أعلى أو أسفل القائمة
/// عند وجود قنوات غير مقروءة فوق/تحت مجال الرؤية، وينقل التمرير إليها عند النقر.
class UnreadChannelIndicator extends StatelessWidget {
  /// ما إذا كان الشريط للقنوات أعلى منطقة الرؤية (Top) أم أسفلها (Bottom).
  final bool isTop;
  final bool show;
  final int count;
  final VoidCallback onClick;

  const UnreadChannelIndicator({
    super.key,
    required this.isTop,
    required this.show,
    required this.count,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return AnimatedOpacity(
      opacity: show ? 1 : 0,
      duration: const Duration(milliseconds: 150),
      child: IgnorePointer(
        ignoring: !show,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: show ? onClick : null,
            child: Container(
              margin: EdgeInsets.only(top: isTop ? 8 : 0, bottom: isTop ? 0 : 8),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: theme.sidebarText.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.centerChannelBg.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isTop ? Icons.arrow_upward : Icons.arrow_downward,
                    size: 13,
                    color: theme.sidebarUnreadText,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    count > 0 ? '$count' : '',
                    style: TextStyle(
                      color: theme.sidebarUnreadText,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}