/// نوع تقرير الامتثال (ComplianceReport.type) — وفقًا لتعريف الخادم
/// الرسمي `server/public/model/compliance.go` (`ComplianceType*` 20–21).
enum ComplianceReportType {
  /// `daily` — يومي: تقرير امتثال مجدول يُنشأ تلقائيًا يوميًا ويصدّر
  /// أحداث اليوم السابق (يظهر في الشاشة بتنسيق الديلي).
  daily('daily'),

  /// `adhoc` — يدوي (Adhoc): تقرير امتثال يُنشأ يدويًا بواسطة مسؤول
  /// لمدة زمنية محددة (Start/End) حسب الحاجة.
  adhoc('adhoc');

  /// القيمة الحرفية المرسلة عبر الـ API والمخزنة في قاعدة البيانات.
  final String value;

  const ComplianceReportType(this.value);

  /// يحوّل القيمة الحرفية القادمة من الخادم إلى [ComplianceReportType].
  ///
  /// إن لم تُطابق أي نوع أو كانت فارغة يُرجع [daily] كنوع افتراضي.
  static ComplianceReportType fromValue(String? value) {
    for (final type in ComplianceReportType.values) {
      if (type.value == value) {
        return type;
      }
    }
    return ComplianceReportType.daily;
  }
}