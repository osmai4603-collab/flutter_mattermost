import 'package:flutter/material.dart';
import '../theme/compass_theme.dart';

/// حالة اتصال المستخدم (User Presence Status)
enum UserStatus { online, away, dnd, offline }

/// ============================================================================
/// [أداة #6]: شارة أيقونة حالة الاتصال المستقلة (AppUserStatusBadge)
/// ============================================================================
/// المقابل لـ `status_icon/status_icon.tsx` في Mattermost Webapp.
/// 
/// تعرض دبابيس وشارات ملونة تعبر عن حالة الاتصال اللحظية للمستخدم:
/// - الأخضر: متصل (Online)
/// - البرتقالي: غائب/خامل (Away)
/// - الأحمر: ممنوع الإزعاج (Do Not Disturb)
/// - الرمادي: غير متصل (Offline)
class AppUserStatusBadge extends StatelessWidget {
  /// [status]: حالة الاتصال الحالية للمستخدم (online, away, dnd, offline).
  /// الغرض: تحديد الأيقونة واللون المتوافق مع الحالة الحالية.
  final UserStatus status;

  /// [size]: قطر أو حجم أيقونة شارة الحالة بالبكسل (الافتراضي: 12.0).
  /// الغرض: ملاءمة الحجم مع المكان المعروض فيه (سواء كان صغيراً في قائمة أو كبيراً في الملف الشخصي).
  final double size;

  const AppUserStatusBadge({
    super.key,
    required this.status,
    this.size = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<CompassTheme>() ?? CompassTheme.light;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: _getStatusColor(theme),
        shape: BoxShape.circle,
      ),
      child: _getStatusIcon(),
    );
  }

  Color _getStatusColor(CompassTheme theme) {
    switch (status) {
      case UserStatus.online:
        return theme.onlineIndicator;
      case UserStatus.away:
        return theme.awayIndicator;
      case UserStatus.dnd:
        return theme.dndIndicator;
      case UserStatus.offline:
        return theme.offlineIndicator;
    }
  }

  Widget? _getStatusIcon() {
    if (status == UserStatus.dnd) {
      return Center(
        child: Container(
          width: size * 0.5,
          height: 2,
          color: Colors.white,
        ),
      );
    }
    return null;
  }
}
