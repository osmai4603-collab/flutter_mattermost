/// نوع القناة (Channel.type) — وفقًا لتعريف الخادم الرسمي
/// `server/public/model/channel.go`.
///
/// القيمة الافتراضية عند الإنشاء: [open] (`'O'`)، وهي نفسها قيمة حقل
/// `type` الافتراضية في `ChannelEntity`.
enum ChannelType {
  /// `O` — قناة عامة (Open Channel): مرئية لجميع أعضاء الفريق، ويمكن لأي
  /// عضو الانضمام إليها مباشرة دون دعوة. النوع الأكثر انتشارًا للقنوات.
  open('O'),

  /// `P` — قناة خاصة (Private Channel): مرئية فقط للأعضاء المدعوين،
  /// ولا يمكن اكتشافها أو الانضمام إليها إلا بدعوة من عضو حالي.
  private('P'),

  /// `D` — محادثة مباشرة (Direct Message 1:1): خاصة بين مستخدمين اثنين،
  /// ولا تنتمي لأي فريق (حقل `teamId` فارغ دائمًا لهذا النوع).
  direct('D'),

  /// `G` — قناة مجموعة (Group Message): محادثة جماعية مغلقة تضم من 3
  /// إلى 8 أعضاء كحد أقصى، مثل المحادثة المباشرة لا تنتمي لأي فريق.
  group('G'),

  /// `S` — مساحة (Space): نوع قناة جديد يستخدمه نظام المساحات
  /// (Spaces) في الإصدارات الحديثة من الخادم.
  space('S'),

  /// `BO` — لوحة عامة (Board Open): قناة مرتبطة بلوحة عامة من نظام
  /// التخطيط واللوحات (Boards).
  boardOpen('BO'),

  /// `BP` — لوحة خاصة (Board Private): قناة مرتبطة بلوحة خاصة من نظام
  /// التخطيط واللوحات (Boards).
  boardPrivate('BP');

  /// القيمة الحرفية المرسلة عبر الـ API والمخزنة في قاعدة البيانات.
  final String value;

  const ChannelType(this.value);

  /// يحوّل القيمة الحرفية القادمة من الخادم إلى [ChannelType].
  ///
  /// المطابقة بحالة حروف كبيرة (UPPERCASE) لأن أنواع القنوات تُرسل
  /// دائمًا بأحرف كبيرة؛ إن لم تُطابق أي نوع أو كانت فارغة يُرجع
  /// [open] باعتباره النوع الافتراضي.
  static ChannelType fromValue(String? value) {
    final normalized = (value ?? '').toUpperCase();
    for (final type in ChannelType.values) {
      if (type.value == normalized) {
        return type;
      }
    }
    return ChannelType.open;
  }
}