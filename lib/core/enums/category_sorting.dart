/// طريقة ترتيب القنوات داخل فئة الشريط الجانبي (ChannelCategory.sorting)
/// — وفقًا لتعريف الخادم الرسمي `server/public/model/channel_sidebar.go`.
enum CategorySorting {
  /// `''` — الفرز الافتراضي: القيمة فارغة، ويقرر الخادم السلوك تلقائيًا
  /// (الأداء اليدوي للفئات المخصصة، والأحدث نشاطًا لفئة الرسائل المباشرة).
  defaultSorting(''),

  /// `manual` — ترتيب يدوي: يعرض القنوات بالترتيب الذي رتّبها به
  /// المستخدم (السحب والإفلات).
  manual('manual'),

  /// `recent` — الأحدث نشاطًا: يعرض القنوات مرتبة حسب آخر رسالة
  /// واردة (القيمة الافتراضية لفئة الرسائل المباشرة).
  recent('recent'),

  /// `alpha` — أبجدي: يعرض القنوات مرتبة أبجديًا حسب الاسم المعروض.
  alpha('alpha');

  /// القيمة الحرفية المرسلة عبر الـ API والمخزنة في قاعدة البيانات.
  final String value;

  const CategorySorting(this.value);

  /// يحوّل القيمة الحرفية القادمة من الخادم إلى [CategorySorting].
  ///
  /// إن لم تُطابق أي نوع أو كانت غير معروفة يُرجع [defaultSorting]
  /// (السلوك الافتراضي للخادم).
  static CategorySorting fromValue(String? value) {
    for (final sorting in CategorySorting.values) {
      if (sorting.value == value) {
        return sorting;
      }
    }
    return CategorySorting.defaultSorting;
  }
}