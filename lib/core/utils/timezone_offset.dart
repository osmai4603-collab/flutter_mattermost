import 'package:flutter_mattermost/features/auth/domain/entities/timezone_entity.dart';

/// إزاحة المنطقة الزمنية المستخدمة في payload البحث —
/// مطابق لـ webapp `getUtcOffsetForTimeZone`/`getBrowserUtcOffset` في
/// `channels/src/utils/timezone.ts` (الدقائق × 60 → ثوانٍ).
///
/// ملاحظة: بدون قاعدة بيانات IANA (حزمة timezone) نستخدم إزاحة جهاز المستخدم
/// نفس قيمة getBrowserUtcOffset في webapp — وهي صحيحة لأن جهاز المستخدم
/// يقع عادةً في منطقته الزمنية نفسها.
class TimeZoneOffset {
  /// إزاحة الجهاز بالثواني (موجبة شرق UTC، سالبة غربها) —
  /// تساوي `moment().utcOffset() * 60`.
  static int deviceOffsetSeconds({DateTime? now}) {
    return (now ?? DateTime.now()).timeZoneOffset.inSeconds;
  }

  /// الإزاحة بالثواني مع احترام تفضيلات المستخدم إن وُجدت —
  /// يفضّل automaticTimezone ثم manualTimezone (مطابق getUserCurrentTimezone).
  /// نظرًا لعدم توفر قاعدة IANA نعيد إزاحة الجهاز دائمًا.
  static int offsetForSearch({TimezoneEntity? userTimezone, DateTime? now}) {
    final tz = userTimezone;
    if (tz != null) {
      final zone = tz.useAutomaticTimezone == 'true'
          ? tz.automaticTimezone
          : tz.manualTimezone;
      if ((zone ?? '').isNotEmpty) {
        // TODO: دعم حساب إزاحة المناطق الزمنية غير المحلية عند إضافة حزمة timezone.
        return deviceOffsetSeconds(now: now);
      }
    }
    return deviceOffsetSeconds(now: now);
  }
}
