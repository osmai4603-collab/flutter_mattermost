/// نوع الفريق (Team.type) — وفقًا لتعريف الخادم الرسمي
/// `server/public/model/team.go`. القيمتان فقط هما المسموحتان، وأي قيمة
/// أخرى يرفضها الخادم في `IsValid`.
enum TeamType {
  /// `O` — فريق مفتوح (Open Team): يمكن لأي مستخدم على الخادم اكتشاف
  /// الفريق والانضمام إليه مباشرة دون موافقة.
  open('O'),

  /// `I` — فريق بالدعوة فقط (Invite-Only Team): لا يمكن الانضمام إليه
  /// إلا عن طريق دعوة من فريق قائم (عبر البريد أو رابط الدعوة `inviteId`).
  inviteOnly('I');

  /// القيمة الحرفية المرسلة عبر الـ API والمخزنة في قاعدة البيانات.
  final String value;

  const TeamType(this.value);

  /// يحوّل القيمة الحرفية القادمة من الخادم إلى [TeamType].
  ///
  /// المطابقة بحالة حروف كبيرة؛ إن لم تُطابق أي نوع أو كانت فارغة
  /// يُرجع [open] باعتباره النوع الافتراضي.
  static TeamType fromValue(String? value) {
    final normalized = (value ?? '').toUpperCase();
    for (final type in TeamType.values) {
      if (type.value == normalized) {
        return type;
      }
    }
    return TeamType.open;
  }
}