/// حالة تقرير الامتثال (ComplianceReport.status) — وفقًا لتعريف الخادم
/// الرسمي `server/public/model/compliance.go` (يُجعل الافتراضي
/// `created` في `PreSave` سطر 74–76).
enum ComplianceReportStatus {
  /// `created` — أُنشئ: التقرير مسجّل في قاعدة البيانات ولم يبدأ
  /// تنفيذه بعد (الحالة الافتراضية عند الإنشاء).
  created('created'),

  /// `running` — قيد التنفيذ: وظيفة التصدير تعمل حاليًا على جمع
  /// الأحداث.
  running('running'),

  /// `finished` — اكتمل: انتهى التصدير بنجاح والملف جاهز للتنزيل.
  finished('finished'),

  /// `failed` — فشل: انتهى التصدير بخطأ (لا يُنتج ملفًا صالحًا).
  failed('failed'),

  /// `removed` — أُزيل: حُذف التقرير (وقد يُحذف ملفه أيضًا).
  removed('removed');

  /// القيمة الحرفية المرسلة عبر الـ API والمخزنة في قاعدة البيانات.
  final String value;

  const ComplianceReportStatus(this.value);

  /// يحوّل القيمة الحرفية القادمة من الخادم إلى [ComplianceReportStatus].
  ///
  /// إن لم تُطابق أي حالة أو كانت فارغة يُرجع [created] (الحالة
  /// الافتراضية عند الإنشاء).
  static ComplianceReportStatus fromValue(String? value) {
    for (final status in ComplianceReportStatus.values) {
      if (status.value == value) {
        return status;
      }
    }
    return ComplianceReportStatus.created;
  }
}