/// نوع المنشور (Post.type) — وفقًا لتعريف الخادم الرسمي
/// `server/public/model/post.go` (الثوابت 28–129 وقائمة التحقق في
/// `IsValid` 538–579).
///
/// ملاحظات عامة:
/// - أي قيمة تبدأ بالبادئة `custom_` هي نوع مخصص من الإضافات/الـ plugins
///   ويقبلها الخادم تلقائيًا، ويمثلها [custom].
/// - أي قيمة تبدأ بالبادئة `system_` فهي رسالة نظام وتطغى على محتوى
///   المستخدم، وتمثلها القيم `system*` أدناه.
/// - القيمة [systemEphemeral] لا يمكن للعميل إنشاؤها — يرسلها الخادم فقط.
enum PostType {
  /// `` — النوع الافتراضي (PostTypeDefault): منشور عادي يكتبه المستخدم.
  defaultType(''),

  /// `me` — منشور "أنا / /me": تُظهر الواجهة الرسالة وكأنها وصف لحالة
  /// الكاتب في صيغة الغائب (مثل: "علي يغادر للغداء").
  me('me'),

  /// `reminder` — تذكير: منشور نظامي يُنشأ بواسطة أوامر التذكير
  /// (remind) لتنبيه المستخدم المحادثةَ في وقت لاحق.
  reminder('reminder'),

  /// `burn_on_read` — رسالة تحترق عند القراءة: تُحذف تلقائيًا بعد قراءتها
  /// (تُستخدم أيضًا كنوع المسودة الخاصة بها في `DraftType`).
  burnOnRead('burn_on_read'),

  /// `slack_attachment` — مرفق Slack: منشور يعرض مرفقات منسّقة (روابط
  /// غنية، أزرار، صور) أرسلتها التكاملات/الـ webhooks.
  slackAttachment('slack_attachment'),

  /// `card` — بطاقة: منشور يُعرض كبطاقة (Block Kit) أرسلته الإضافات.
  card('card'),

  /// `add_bot_teams_channels` — إضافة بوت لقنوات الفرق: رسالة نظام تُنشأ
  /// عند إضافة البوت تلقائيًا إلى قنوات الفريق.
  addBotTeamsChannels('add_bot_teams_channels'),

  /// `custom_` — البادئة `custom_` + أي لاحقة: نوع مخصص من الإضافات
  /// (plugins). يُمثل القيم غير المدرجة. تطابق أي قيمة تبدأ بـ `custom_`.
  custom('custom_'),

  /// `system_generic` — رسالة نظام عامة: قالب عام للرسائل النظامية
  /// غير المحددة بنوع خاص.
  systemGeneric('system_generic'),

  /// `system_join_leave` — (مهملة) انضمام/مغادرة: كانت تجمع رسائل
  /// الانضمام والمغادرة، استُبدلت بأنواع مفصلة أدناه.
  systemJoinLeave('system_join_leave'),

  /// `system_join_channel` — انضم إلى القناة: رسالة نظام عند انضمام
  /// عضو إلى قناة عامة/خاصة.
  systemJoinChannel('system_join_channel'),

  /// `system_guest_join_channel` — انضم ضيف إلى القناة: رسالة نظام عند
  /// انضمام مستخدم ضيف إلى قناة.
  systemGuestJoinChannel('system_guest_join_channel'),

  /// `system_leave_channel` — غادر القناة: رسالة نظام عند مغادرة عضو
  /// للقناة.
  systemLeaveChannel('system_leave_channel'),

  /// `system_join_team` — انضم إلى الفريق: رسالة نظام عند انضمام عضو
  /// إلى الفريق.
  systemJoinTeam('system_join_team'),

  /// `system_leave_team` — غادر الفريق: رسالة نظام عند مغادرة عضو
  /// للفريق.
  systemLeaveTeam('system_leave_team'),

  /// `system_auto_responder` — رد تلقائي: رسالة نظام تُرسل تلقائيًا
  /// كمُهلّي غياب/إجازة عند استلام رسائل جديدة.
  systemAutoResponder('system_auto_responder'),

  /// `system_autotranslation` — ترجمة تلقائية: رسالة نظام تشير إلى
  /// محتوى ناتج عن الترجمة الآلية بين لغات.
  systemAutotranslation('system_autotranslation'),

  /// `system_add_remove` — (مهملة) إضافة/إزالة: كانت تجمع رسائل إضافة
  /// وإزالة الأعضاء، استُبدلت بأنواع مفصلة أدناه.
  systemAddRemove('system_add_remove'),

  /// `system_add_to_channel` — أُضيف إلى القناة: رسالة نظام عند إضافة
  /// عضو (غير ضيف) إلى قناة بواسطة مستخدم آخر.
  systemAddToChannel('system_add_to_channel'),

  /// `system_add_guest_to_chan` — أُضيف ضيف إلى القناة: رسالة نظام عند
  /// إضافة مستخدم ضيف إلى قناة.
  systemAddGuestToChan('system_add_guest_to_chan'),

  /// `system_remove_from_channel` — أُزيل من القناة: رسالة نظام عند
  /// إزالة عضو من قناة.
  systemRemoveFromChannel('system_remove_from_channel'),

  /// `system_move_channel` — نُقلت القناة: رسالة نظام عند نقل قناة من
  /// فريق إلى آخر.
  systemMoveChannel('system_move_channel'),

  /// `system_add_to_team` — أُضيف إلى الفريق: رسالة نظام عند إضافة عضو
  /// إلى فريق.
  systemAddToTeam('system_add_to_team'),

  /// `system_remove_from_team` — أُزيل من الفريق: رسالة نظام عند إزالة
  /// عضو من فريق.
  systemRemoveFromTeam('system_remove_from_team'),

  /// `system_team_abac_removal` — إزالة بسبب سياسة ABAC: رسالة نظام عند
  /// إزالة مستخدم تلقائيًا بسبب سياسة التحكم بالوصول القائمة على السمات.
  systemTeamAbacRemoval('system_team_abac_removal'),

  /// `system_team_abac_addition` — إضافة بسبب سياسة ABAC: رسالة نظام عند
  /// إضافة مستخدم تلقائيًا وفق سياسة التحكم بالوصول.
  systemTeamAbacAddition('system_team_abac_addition'),

  /// `system_header_change` — تغيّرت ترويسة القناة: رسالة نظام تُعلم
  /// بتعديل وصف/ترويسة القناة.
  systemHeaderChange('system_header_change'),

  /// `system_displayname_change` — تغيّر اسم القناة: رسالة نظام تُعلم
  /// بتغيير الاسم المعروض للقناة.
  systemDisplayNameChange('system_displayname_change'),

  /// `system_convert_channel` — تحويل القناة: رسالة نظام عند تحويل قناة
  /// من عامة إلى خاصة أو العكس.
  systemConvertChannel('system_convert_channel'),

  /// `system_purpose_change` — تغيّر الغرض: رسالة نظام تُعلم بتعديل
  /// حقل غرض القناة (Purpose).
  systemPurposeChange('system_purpose_change'),

  /// `system_channel_deleted` — حُذفت القناة: رسالة نظام تُعلم بحذف
  /// القناة.
  systemChannelDeleted('system_channel_deleted'),

  /// `system_channel_restored` — استُعيدت القناة: رسالة نظام تُعلم
  /// باستعادة قناة محذوفة.
  systemChannelRestored('system_channel_restored'),

  /// `system_change_chan_privacy` — تغيّرت خصوصية القناة: رسالة نظام عند
  /// تغيير مستوى خصوصية القناة (عمومية/خصوصية).
  systemChangeChanPrivacy('system_change_chan_privacy'),

  /// `system_wrangler` — رسالة منسّق المحادثة (Wrangler): رسالة نظام
  /// خاصة بأداة إدارة المحادثات (Call/Conversation wrangler).
  systemWrangler('system_wrangler'),

  /// `system_gm_to_channel` — تحويل المجموعة إلى قناة: رسالة نظام عند
  /// تحويل محادثة مجموعة (G) إلى قناة رسمية.
  systemGmToChannel('system_gm_to_channel'),

  /// `system_shared_chan_state` — حالة القناة المشتركة: رسالة نظام عن
  /// تحديث حالة قناة مشتركة بين خوادم (Shared Channels).
  systemSharedChanState('system_shared_chan_state'),

  /// `system_ephemeral` — رسالة مؤقتة (Ephemeral): تُعرض للعميل فقط
  /// ثم تختفي، ويُنتجها الخادم حصريًا — **غير معتمدة في قائمة التحقق
  /// ولا يمكن للعميل إنشاؤها**.
  systemEphemeral('system_ephemeral');

  /// القيمة الحرفية المرسلة عبر الـ API والمخزنة في قاعدة البيانات.
  final String value;

  const PostType(this.value);

  /// هل هذه القيمة رسالة نظام (تبدأ بالبادئة `system_`).
  bool get isSystemMessage => value.startsWith('system_');

  /// هل هذه القيمة نوع مخصص من الإضافات (بادئة `custom_`).
  bool get isCustom => this == PostType.custom;

  /// يحوّل القيمة الحرفية القادمة من الخادم إلى [PostType].
  ///
  /// - أي قيمة تبدأ بـ `custom_` → [custom].
  /// - تطابق تام مع إحدى القيم المدرجة → القيمة المقابلة.
  /// - أي قيمة أخرى غير معروفة (مثل نوع نظام مستقبلي) → [defaultType].
  static PostType fromValue(String? value) {
    if (value == null) {
      return PostType.defaultType;
    }
    if (value.startsWith('custom_')) {
      return PostType.custom;
    }
    for (final type in PostType.values) {
      if (type.value == value) {
        return type;
      }
    }
    return PostType.defaultType;
  }
}