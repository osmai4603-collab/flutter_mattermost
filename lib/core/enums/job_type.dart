/// نوع الوظيفة الخلفية (Job.type) — وفقًا لتعريف الخادم الرسمي
/// `server/public/model/job.go` (الثوابت `JobType*` 13–54 والقائمة
/// المعتمدة `AllJobTypes` 65–90).
///
/// ملاحظة: عند الإنشاء يجب أن يكون النوع مسجّلًا لدى عامل (Worker)
/// نشط في `server/channels/jobs/jobs.go` وإلا رفض الخادم الطلب.
/// القيمة [unknown] ملاذ آمن للقيم القادمة من إصدارات خادم أحدث.
enum JobType {
  /// `` — غير معروف/غير صالح: ملاذ آمن عندما يرسل الخادم قيمة غير
  /// متوقعة (عادةً من إصدار أحدث) أو عندما تكون القيمة فارغة.
  unknown(''),

  /// `data_retention` — الاحتفاظ بالبيانات: وظيفة دورية تحذف الرسائل
  /// والملفات وفقًا لسياسات الاحتفاظ بالبيانات (Data Retention).
  dataRetention('data_retention'),

  /// `message_export` — تصدير الرسائل: تصدير الرسائل بتنسيق موجَّه
  /// (بتنسيقات مثل CSV) لأغراض الامتثال — يُشغَّل من وحدة التحكم.
  messageExport('message_export'),

  /// `cli_message_export` — تصدير رسائل CLI: تصدير الرسائل لأغراض
  /// الامتثال مع تشغيل مُخصَّص لواجهة الأوامر (CLI).
  cliMessageExport('cli_message_export'),

  /// `elasticsearch_post_indexing` — فهرسة منشورات Elasticsearch:
  /// فهرسة المنشورات في محرك البحث (Elasticsearch) على دفعات.
  elasticsearchPostIndexing('elasticsearch_post_indexing'),

  /// `elasticsearch_post_aggregation` — تجميع منشورات Elasticsearch:
  /// إعادة تجميع/تدقيق بيانات منشورات Elasticsearch.
  elasticsearchPostAggregation('elasticsearch_post_aggregation'),

  /// `ldap_sync` — مزامنة LDAP: مزامنة دورية للمستخدمين والمجموعات من
  /// خادم LDAP/AD إلى Mattermost.
  ldapSync('ldap_sync'),

  /// `migrations` — الترحيلات: تنفيذ ترحيلات قاعدة البيانات المعلّقة.
  migrations('migrations'),

  /// `plugins` — الإضافات: تركيب/إزالة/تفعيل الإضافات (Plugins).
  plugins('plugins'),

  /// `expiry_notify` — إشعار انتهاء الحساب: إرسال إشعارات للمستخدمين
  /// قبل انتهاء صلاحية حساباتهم.
  expiryNotify('expiry_notify'),

  /// `product_notices` — إشعارات المنتج: توزيع إشعارات المنتج المجدولة
  /// على المستخدمين.
  productNotices('product_notices'),

  /// `active_users` — المستخدمون النشطون: حساب/تحديث عدّاد المستخدمين
  /// النشطين للفوترة.
  activeUsers('active_users'),

  /// `import_process` — عملية استيراد: معالجة ملف استيراد (Import) تم
  /// رفعه.
  importProcess('import_process'),

  /// `import_delete` — حذف الاستيراد: حذف ملفات الاستيراد المؤقتة.
  importDelete('import_delete'),

  /// `export_process` — عملية تصدير: تنفيذ تصدير كامل (Export) لقاعدة
  /// البيانات (سرد الخوادم والتقارير).
  exportProcess('export_process'),

  /// `export_delete` — حذف التصدير: حذف ملفات التصدير المؤقتة.
  exportDelete('export_delete'),

  /// `cloud` — السحابة: مهام المتجر السحابي (Cloud) مثل الفوترة
  /// والتراخيص.
  cloud('cloud'),

  /// `resend_invitation_email` — إعادة إرسال الدعوات: إعادة إرسال
  /// رسائل الدعوة عبر البريد للمستخدمين المعلّقين.
  resendInvitationEmail('resend_invitation_email'),

  /// `extract_content` — استخراج المحتوى: استخراج محتوى الملفات
  /// المرفوعة (النصوص والبيانات الوصفية) للبحث — تُشغَّل مع
  /// `EnableFileContentExtraction`.
  extractContent('extract_content'),

  /// `last_accessible_post` — آخر منشور قابل للوصول: حساب آخر منشور
  /// يمكن للمستخدمين الوصول إليه (في سياق الاحتفاظ بالبيانات).
  lastAccessiblePost('last_accessible_post'),

  /// `last_accessible_file` — آخر ملف قابل للوصول: حساب آخر ملف يمكن
  /// للمستخدمين الوصول إليه (في سياق الاحتفاظ بالبيانات).
  lastAccessibleFile('last_accessible_file'),

  /// `upgrade_notify_admin` — إشعار ترقية المسؤول: إرسال إشعارات
  /// بوجود ترقية متاحة إلى المسؤولين.
  upgradeNotifyAdmin('upgrade_notify_admin'),

  /// `trial_notify_admin` — إشعار النسخة التجريبية: تذكير المسؤولين
  /// بالنسخة التجريبية المتاحة من المزايا المدفوعة.
  trialNotifyAdmin('trial_notify_admin'),

  /// `post_persistent_notifications` — إشعارات المنشورات المستمرة:
  /// إعادة إرسال الإشعارات المستمرة (Persistent Notifications) للرسائل
  /// غير المؤكدة.
  postPersistentNotifications('post_persistent_notifications'),

  /// `install_plugin_notify_admin` — إشعار تثبيت الإضافة: إخطار المسؤول
  /// بتثبيت إضافة جديدة.
  installPluginNotifyAdmin('install_plugin_notify_admin'),

  /// `hosted_purchase_screening` — فحص المشتريات المُستضافة: فحص طلبات
  /// الشراء للخوادم المُستضافة (Cloud).
  hostedPurchaseScreening('hosted_purchase_screening'),

  /// `s3_path_migration` — ترحيل مسارات S3: ترحيل مسارات ملفات S3 إلى
  /// بنية المجلدات الجديدة.
  s3PathMigration('s3_path_migration'),

  /// `cleanup_desktop_tokens` — تنظيف رموز سطح المكتب: حذف رموز جلسات
  /// تطبيقات سطح المكتب منتهية الصلاحية.
  cleanupDesktopTokens('cleanup_desktop_tokens'),

  /// `delete_empty_drafts_migration` — حذف المسودات الفارغة: ترحيل
  /// يحذف المسودات الفارغة من قاعدة البيانات.
  deleteEmptyDraftsMigration('delete_empty_drafts_migration'),

  /// `refresh_materialized_views` — تحديث العروض المادية: تحديث دوري
  /// للعروض المادية (Materialized Views) في قاعدة البيانات.
  refreshMaterializedViews('refresh_materialized_views'),

  /// `delete_orphan_drafts_migration` — حذف المسودات اليتيمة: ترحيل
  /// يحذف المسودات التي لا تملك مالكًا صالحًا.
  deleteOrphanDraftsMigration('delete_orphan_drafts_migration'),

  /// `export_users_to_csv` — تصدير المستخدمين CSV: تصدير قائمة
  /// المستخدمين إلى ملف CSV.
  exportUsersToCsv('export_users_to_csv'),

  /// `delete_dms_preferences_migration` — حذف تفضيلات الرسائل المباشرة:
  /// ترحيل يحذف تفضيلات المحادثات المباشرة القديمة.
  deleteDmsPreferencesMigration('delete_dms_preferences_migration'),

  /// `mobile_session_metadata` — بيانات جلسات الجوال: جمع بيانات
  /// وصفية عن جلسات تطبيقات الجوال.
  mobileSessionMetadata('mobile_session_metadata'),

  /// `access_control_sync` — مزامنة التحكم بالوصول: مزامنة السياسات
  /// المرتبطة بقنوات/فرق (Access Control Policies).
  accessControlSync('access_control_sync'),

  /// `access_control_team_sync` — مزامنة فرق التحكم بالوصول: مزامنة
  /// سياسات التحكم بالوصول المرتبطة بالفرق تحديدًا.
  accessControlTeamSync('access_control_team_sync'),

  /// `push_proxy_auth` — مصادقة وكيل الدفع: تجديد مصادقة وكيل إشعارات
  /// الدفع (Push Proxy).
  pushProxyAuth('push_proxy_auth'),

  /// `recap` — الملخص الدوري: توليد ملخصات المحادثات (Recaps)
  /// المجدولة من الذكاء الاصطناعي.
  recap('recap'),

  /// `scheduled_recap` — الملخص الدوري المجدول: جدولة وإنشاء ملخصات
  /// المحادثات الدورية.
  scheduledRecap('scheduled_recap'),

  /// `delete_expired_posts` — حذف المنشورات منتهية الصلاحية: حذف
  /// المنشورات المؤقتة (Ephemeral/منتهية) بعد انتهاء صلاحيتها.
  deleteExpiredPosts('delete_expired_posts'),

  /// `autotranslation_recovery` — استرداد الترجمة التلقائية: استرداد
  /// بيانات الترجمة التلقائية المعلقة.
  autotranslationRecovery('autotranslation_recovery'),

  /// `cleanup_expired_access_tokens` — تنظيف رموز الوصول: حذف رموز
  /// الوصول الشخصية منتهية الصلاحية.
  cleanupExpiredAccessTokens('cleanup_expired_access_tokens'),

  /// `notify_expiring_access_tokens` — إشعار انتهاء رموز الوصول:
  /// إخطار المستخدمين قبل انتهاء صلاحية رموز وصولهم الشخصية.
  notifyExpiringAccessTokens('notify_expiring_access_tokens');

  /// القيمة الحرفية المرسلة عبر الـ API والمخزنة في قاعدة البيانات.
  final String value;

  const JobType(this.value);

  /// يحوّل القيمة الحرفية القادمة من الخادم إلى [JobType].
  ///
  /// إن لم تُطابق أي نوع معروف أو كانت القيمة فارغة يُرجع [unknown].
  static JobType fromValue(String? value) {
    for (final type in JobType.values) {
      if (type.value == value) {
        return type;
      }
    }
    return JobType.unknown;
  }
}