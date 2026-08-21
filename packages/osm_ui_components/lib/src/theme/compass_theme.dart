import 'package:flutter/material.dart';

/// ============================================================================
/// [أداة #1]: نظام الألوان والثيمات المشترك (CompassTheme)
/// ============================================================================
/// المقابل لـ `compass_design_provider` و `theme_provider` في Mattermost Webapp.
/// 
/// توفر هذه الأداة ملحق ثيم مخصص (ThemeExtension) لتمرير متغيرات الألوان والتصميم
/// الخاصة بجميع أجزاء التطبيق، مما يسمح بالتبديل السلس بين الوضع الليلي والنهاري
/// وتأمين التناسق البصري عبر كل المكونات المشتركة.
@immutable
class CompassTheme extends ThemeExtension<CompassTheme> {
  /// [centerChannelBg]: لون خلفية القناة الرئيسية أو منطقة محتوى الرابط الأساسية.
  /// الغرض: تحديد لون خلفية شاشة المحادثة والقوائم المركزية.
  final Color centerChannelBg;

  /// [centerChannelColor]: لون النص الأساسي المكتوب داخل منطقة المحتوى المركزية.
  /// الغرض: ضمان قراءة النصوص والرسائل بتباين عالٍ ضد خلفية القناة.
  final Color centerChannelColor;

  /// [sidebarBg]: لون خلفية الشريط الجانبي (Sidebar) الذي يحوي القنوات والفرق.
  /// الغرض: إعطاء هوية بصرية تميز شريط التنقل عن منطقة الرسائل الرئيسية.
  final Color sidebarBg;

  /// [sidebarText]: لون النصوص والأيقونات داخل الشريط الجانبي.
  /// الغرض: قراءة أسماء القنوات والرسائل غير المقروءة في الشريط الجانبي.
  final Color sidebarText;

  /// [sidebarUnreadText]: لون النص أو الشارات الخاصة بالقنوات التي تحوي رسائل غير مقروءة.
  /// الغرض: تمييز القنوات النشطة التي تحتاج انتباه المستخدم.
  final Color sidebarUnreadText;

  /// [mentionHighlightBg]: لون خلفية تمييز الإشارات (@mention) والكلمات المفتاحية.
  /// الغرض: تسليط الضوء على الرسائل التي أشار فيها شخص ما إلى المستخدم.
  final Color mentionHighlightBg;

  /// [buttonBg]: لون خلفية الأزرار الرئيسية في النظام (Primary Buttons).
  /// الغرض: توحيد مظهر أزرار الإجراءات مثل الحفظ والتأكيد.
  final Color buttonBg;

  /// [buttonColor]: لون النص والأيقونات المكتوبة فوق الأزرار الرئيسية.
  /// الغرض: ضمان التباين ومقروئية زر الإجراء الرئيسي.
  final Color buttonColor;

  /// [errorTextColor]: لون نصوص ورسائل الأخطاء في التنبيهات والمدخلات.
  /// الغرض: لفت الانتباه الفوري للتنبيهات والأخطاء.
  final Color errorTextColor;

  /// [onlineIndicator]: لون مؤشر حالة الاتصال "متصل" (Online).
  /// الغرض: تمييز المستخدم المتصل بنقطة خضراء زاهية.
  final Color onlineIndicator;

  /// [awayIndicator]: لون مؤشر حالة الاتصال "غائب" (Away).
  /// الغرض: تمييز المستخدم الخامل أو الغائب برمز برتقالي/أصفر.
  final Color awayIndicator;

  /// [dndIndicator]: لون مؤشر حالة الاتصال "ممنوع الإزعاج" (Do Not Disturb).
  /// الغرض: تمييز المستخدم المشغول بنقطة حمراء.
  final Color dndIndicator;

  /// [offlineIndicator]: لون مؤشر حالة الاتصال "غير متصل" (Offline).
  /// الغرض: تمييز المستخدم غير المتصل بلون رمادي مفرغ.
  final Color offlineIndicator;

  const CompassTheme({
    required this.centerChannelBg,
    required this.centerChannelColor,
    required this.sidebarBg,
    required this.sidebarText,
    required this.sidebarUnreadText,
    required this.mentionHighlightBg,
    required this.buttonBg,
    required this.buttonColor,
    required this.errorTextColor,
    required this.onlineIndicator,
    required this.awayIndicator,
    required this.dndIndicator,
    required this.offlineIndicator,
  });

  /// النسخة الفاتحة الافتراضية (Light Theme)
  static const light = CompassTheme(
    centerChannelBg: Color(0xFFFFFFFF),
    centerChannelColor: Color(0xFF3F4350),
    sidebarBg: Color(0xFF1E2638),
    sidebarText: Color(0xCCFFFFFF),
    sidebarUnreadText: Color(0xFFFFFFFF),
    mentionHighlightBg: Color(0xFFFFEB3B),
    buttonBg: Color(0xFF1C68D4),
    buttonColor: Color(0xFFFFFFFF),
    errorTextColor: Color(0xFFD24B4E),
    onlineIndicator: Color(0xFF3DB887),
    awayIndicator: Color(0xFFFFBC1F),
    dndIndicator: Color(0xFFD24B4E),
    offlineIndicator: Color(0xFF8C93A0),
  );

  /// النسخة الداكنة الافتراضية (Dark Theme)
  static const dark = CompassTheme(
    centerChannelBg: Color(0xFF1B2432),
    centerChannelColor: Color(0xFFD6D8DC),
    sidebarBg: Color(0xFF111823),
    sidebarText: Color(0xCCFFFFFF),
    sidebarUnreadText: Color(0xFFFFFFFF),
    mentionHighlightBg: Color(0xFF5A4D00),
    buttonBg: Color(0xFF1C68D4),
    buttonColor: Color(0xFFFFFFFF),
    errorTextColor: Color(0xFFFF6B6B),
    onlineIndicator: Color(0xFF3DB887),
    awayIndicator: Color(0xFFFFBC1F),
    dndIndicator: Color(0xFFD24B4E),
    offlineIndicator: Color(0xFF636975),
  );

  @override
  CompassTheme copyWith({
    Color? centerChannelBg,
    Color? centerChannelColor,
    Color? sidebarBg,
    Color? sidebarText,
    Color? sidebarUnreadText,
    Color? mentionHighlightBg,
    Color? buttonBg,
    Color? buttonColor,
    Color? errorTextColor,
    Color? onlineIndicator,
    Color? awayIndicator,
    Color? dndIndicator,
    Color? offlineIndicator,
  }) {
    return CompassTheme(
      centerChannelBg: centerChannelBg ?? this.centerChannelBg,
      centerChannelColor: centerChannelColor ?? this.centerChannelColor,
      sidebarBg: sidebarBg ?? this.sidebarBg,
      sidebarText: sidebarText ?? this.sidebarText,
      sidebarUnreadText: sidebarUnreadText ?? this.sidebarUnreadText,
      mentionHighlightBg: mentionHighlightBg ?? this.mentionHighlightBg,
      buttonBg: buttonBg ?? this.buttonBg,
      buttonColor: buttonColor ?? this.buttonColor,
      errorTextColor: errorTextColor ?? this.errorTextColor,
      onlineIndicator: onlineIndicator ?? this.onlineIndicator,
      awayIndicator: awayIndicator ?? this.awayIndicator,
      dndIndicator: dndIndicator ?? this.dndIndicator,
      offlineIndicator: offlineIndicator ?? this.offlineIndicator,
    );
  }

  @override
  CompassTheme lerp(ThemeExtension<CompassTheme>? other, double t) {
    if (other is! CompassTheme) return this;
    return CompassTheme(
      centerChannelBg: Color.lerp(centerChannelBg, other.centerChannelBg, t)!,
      centerChannelColor: Color.lerp(centerChannelColor, other.centerChannelColor, t)!,
      sidebarBg: Color.lerp(sidebarBg, other.sidebarBg, t)!,
      sidebarText: Color.lerp(sidebarText, other.sidebarText, t)!,
      sidebarUnreadText: Color.lerp(sidebarUnreadText, other.sidebarUnreadText, t)!,
      mentionHighlightBg: Color.lerp(mentionHighlightBg, other.mentionHighlightBg, t)!,
      buttonBg: Color.lerp(buttonBg, other.buttonBg, t)!,
      buttonColor: Color.lerp(buttonColor, other.buttonColor, t)!,
      errorTextColor: Color.lerp(errorTextColor, other.errorTextColor, t)!,
      onlineIndicator: Color.lerp(onlineIndicator, other.onlineIndicator, t)!,
      awayIndicator: Color.lerp(awayIndicator, other.awayIndicator, t)!,
      dndIndicator: Color.lerp(dndIndicator, other.dndIndicator, t)!,
      offlineIndicator: Color.lerp(offlineIndicator, other.offlineIndicator, t)!,
    );
  }
}
