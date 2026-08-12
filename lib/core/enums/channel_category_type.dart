/// نوع فئة الشريط الجانبي (ChannelCategory.type) — وفقًا لتعريف الخادم
/// الرسمي `server/public/model/channel_sidebar.go`.
///
/// القيمة الافتراضية في `ChannelCategoryEntity`: [custom].
enum ChannelCategoryType {
  /// `favorites` — فئة "المفضلة": فئة افتراضية يتحكم فيها المستخدم يدويًا،
  /// وتظهر في أعلى الشريط الجانبي وتحتوي القنوات المفضّلة (نجمة).
  favorites('favorites'),

  /// `channels` — فئة "القنوات": فئة افتراضية تجمع القنوات العامة
  /// والخاصة التي ليس لها فئة مخصصة.
  channels('channels'),

  /// `direct_messages` — فئة "الرسائل المباشرة": فئة افتراضية تجمع
  /// المحادثات المباشرة (D) ومحادثات المجموعات (G).
  directMessages('direct_messages'),

  /// `custom` — فئة مخصصة: أي فئة ينشئها المستخدم بنفسه من واجهة
  /// الشريط الجانبي (النوع الافتراضي للفئات الجديدة).
  custom('custom'),

  /// `managed` — فئة مُدارة: فئة ينشئها ويديرها النظام/الإدارة
  /// ولا يمكن للمستخدم إعادة تسميتها أو التحكم بمحتواها.
  managed('managed');

  /// القيمة الحرفية المرسلة عبر الـ API والمخزنة في قاعدة البيانات.
  final String value;

  const ChannelCategoryType(this.value);

  /// يحوّل القيمة الحرفية القادمة من الخادم إلى [ChannelCategoryType].
  ///
  /// إن لم تُطابق أي نوع أو كانت فارغة يُرجع [custom] باعتباره النوع
  /// الافتراضي.
  static ChannelCategoryType fromValue(String? value) {
    for (final type in ChannelCategoryType.values) {
      if (type.value == value) {
        return type;
      }
    }
    return ChannelCategoryType.custom;
  }
}