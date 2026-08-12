/// نوع المسودة (Draft.type) — وفقًا لتعريف الخادم الرسمي
/// `server/public/model/draft.go`.
///
/// ملاحظة: حقل `type` في المسودة ليس `channel`/`thread` (تلك قيم خاصة
/// بتخزين الويب المحلي فقط ولا تُرسل للخادم)؛ القيمة الحرفية تُعامَل
/// كنوع منشور (PostType) والقيمة الوحيدة غير الفارغة المستخدمة فعليًا
/// هي [burnOnRead].
enum DraftType {
  /// `` — المسودة الافتراضية: مسودة عادية لنص رسالة (دون مميزات خاصة).
  defaultType(''),

  /// `burn_on_read` — رسالة تحترق عند القراءة: مسودة لرسالة تُحذف
  /// تلقائيًا بعد قراءتها من قِبل المستلم.
  burnOnRead('burn_on_read');

  /// القيمة الحرفية المرسلة عبر الـ API والمخزنة في قاعدة البيانات.
  final String value;

  const DraftType(this.value);

  /// يحوّل القيمة الحرفية القادمة من الخادم إلى [DraftType].
  ///
  /// إن لم تُطابق أي نوع أو كانت فارغة يُرجع [defaultType] باعتباره
  /// النوع الافتراضي.
  static DraftType fromValue(String? value) {
    for (final type in DraftType.values) {
      if (type.value == value) {
        return type;
      }
    }
    return DraftType.defaultType;
  }
}