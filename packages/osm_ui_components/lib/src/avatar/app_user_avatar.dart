import 'package:flutter/material.dart';
import '../theme/compass_theme.dart';
import 'app_user_status_badge.dart';

/// ============================================================================
/// [أداة #7]: الصورة الشخصية المدمجة مع شارة الحالة (AppUserAvatar)
/// ============================================================================
/// المقابل لـ `profile_picture/profile_picture.tsx` في Mattermost Webapp.
/// 
/// تعرض صورة المستخدم دائرية الحواف مع دعم التبديل التلقائي إلى الأحرف الأولى
/// من اسم المستخدم (Initials Fallback) عند غياب الصورة، وتراكب شارة حالة الاتصال
/// اللحظية في الزاوية السفلية من الصورة.
class AppUserAvatar extends StatelessWidget {
  /// [imageUrl]: رابط صورة الملف الشخصي من الشبكة (اختياري).
  /// الغرض: عرض صورة المستخدم؛ وفي حال كان null أو حدث خطأ تحميل، تعود إلى الأحرف الأولى.
  final String? imageUrl;

  /// [username]: اسم المستخدم (مطلوب).
  /// الغرض: استخراج الحرف الأول وعرضه كبديل عند غياب الصورة، وتأمين التلميح النصي (Tooltip).
  final String username;

  /// [size]: القطر الكلي لدائرة الصورة الشخصية بالبكسل (الافتراضي: 36.0).
  /// الغرض: إتاحة أبعاد مختلفة حسب سياق الاستخدام (24px بالقوائم، 36px بالرسائل، 128px بالملف الشخصي).
  final double size;

  /// [status]: حالة الاتصال الحالية (online, away, dnd, offline).
  /// الغرض: تراكب دبابيس شارة الحالة في الزاوية السفلية (إذا كانت showStatusBadge = true).
  final UserStatus status;

  /// [showStatusBadge]: هل ترغب في إظهار شارة الاتصال العائمة فوق الصورة؟ (الافتراضي: true).
  /// الغرض: إخفاء الشارة عند استخدام الصورة في أماكن لا تتطلب إظهار الحالة (مثل الإعدادات).
  final bool showStatusBadge;

  const AppUserAvatar({
    super.key,
    this.imageUrl,
    required this.username,
    this.size = 36.0,
    this.status = UserStatus.offline,
    this.showStatusBadge = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<CompassTheme>() ?? CompassTheme.light;
    final badgeSize = size * 0.32;

    return Stack(
      children: [
        // Main Circle Avatar Image or Fallback Initials
        Container(
          width: size,
          height: size,
          decoration: const BoxDecoration(shape: BoxShape.circle),
          clipBehavior: Clip.antiAlias,
          child: imageUrl != null && imageUrl!.isNotEmpty
              ? Image.network(
                  imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => _buildInitials(),
                )
              : _buildInitials(),
        ),
        // Status Badge Overlay
        if (showStatusBadge)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(1.5),
              decoration: BoxDecoration(
                color: theme.centerChannelBg,
                shape: BoxShape.circle,
              ),
              child: AppUserStatusBadge(
                status: status,
                size: badgeSize,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildInitials() {
    final initial = username.isNotEmpty ? username[0].toUpperCase() : '?';
    return Container(
      color: const Color(0xFF636975),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: size * 0.45,
        ),
      ),
    );
  }
}
