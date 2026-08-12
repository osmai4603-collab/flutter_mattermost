/// نوع الإشارة المرجعية في القناة (ChannelBookmark.type) — وفقًا لتعريف
/// الخادم الرسمي `server/public/model/channel_bookmark.go`.
///
/// القيمة الافتراضية عند الإنشاء: [link] (`'link'`)، وهي نفسها قيمة حقل
/// `type` الافتراضية في `ChannelBookmarkEntity`.
enum ChannelBookmarkType {
  /// `link` — رابط خارجي: يحفظ رابط HTTP(S) صالحًا في [ChannelBookmarkEntity.linkUrl]
  /// مع صورة مصغرة اختيارية في `imageUrl`. هذا النوع يمنع وجود `fileId`.
  link('link'),

  /// `file` — ملف مرفوع: يحفظ معرّف ملف مرفوع في [ChannelBookmarkEntity.fileId]
  /// (الملف مملوك لصاحب الإشارة). هذا النوع يجعل `linkUrl` فارغًا إلزاميًا.
  file('file'),

  /// `board` — لوحة (Board): إشارة إلى كيان لوحة يُدار خارجيًا، يخزّن
  /// معرف اللوحة في `targetId` وعنوانًا نسبيًا يبدأ بـ `/` في `linkUrl`
  /// (لا يمكن أن يحتوي على `://`).
  board('board');

  /// القيمة الحرفية المرسلة عبر الـ API والمخزنة في قاعدة البيانات.
  final String value;

  const ChannelBookmarkType(this.value);

  /// يحوّل القيمة الحرفية القادمة من الخادم إلى [ChannelBookmarkType].
  ///
  /// إن لم تُطابق أي نوع أو كانت فارغة يُرجع [link] باعتباره النوع
  /// الافتراضي.
  static ChannelBookmarkType fromValue(String? value) {
    for (final type in ChannelBookmarkType.values) {
      if (type.value == value) {
        return type;
      }
    }
    return ChannelBookmarkType.link;
  }
}