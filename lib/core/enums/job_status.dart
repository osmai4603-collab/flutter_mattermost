/// حالة الوظيفة الخلفية (Job.status) — وفقًا لتعريف الخادم الرسمي
/// `server/public/model/job.go` (`IsValidJobStatus` 219–233).
///
/// الانتقالات القانونية بين الحالات (`IsValidStatusChange`):
/// `in_progress → pending | cancel_requested`،
/// `pending → cancel_requested`،
/// `cancel_requested → canceled`.
enum JobStatus {
  /// `pending` — معلّقة: الوظيفة في قائمة الانتظار بانتظار عامل
  /// (Worker) متاح لتنفيذها (الحالة الافتراضية عند الإنشاء).
  pending('pending'),

  /// `in_progress` — قيد التنفيذ: عامل يباشر الوظيفة حاليًا.
  inProgress('in_progress'),

  /// `success` — نجحت: اكتمل تنفيذ الوظيفة بنجاح.
  success('success'),

  /// `error` — فشلت: انتهى التنفيذ بخطأ (يُخزَّن وصفه في مفتاح
  /// `error` داخل خريطة البيانات `data`).
  error('error'),

  /// `cancel_requested` — طُلب الإلغاء: طُلبت إيقاف الوظيفة وسيُنفَّذ
  /// الإلغاء عند أقرب نقطة توقف آمنة.
  cancelRequested('cancel_requested'),

  /// `canceled` — أُلغيَت: أُوقفت الوظيفة ولم يكتمل تنفيذها.
  canceled('canceled'),

  /// `warning` — تحذير: اكتمل التنفيذ مع تحذيرات (لم يُعامل كفشل تام).
  warning('warning');

  /// القيمة الحرفية المرسلة عبر الـ API والمخزنة في قاعدة البيانات.
  final String value;

  const JobStatus(this.value);

  /// يحوّل القيمة الحرفية القادمة من الخادم إلى [JobStatus].
  ///
  /// إن لم تُطابق أي حالة أو كانت فارغة يُرجع [pending] (الحالة
  /// الافتراضية عند الإنشاء).
  static JobStatus fromValue(String? value) {
    for (final status in JobStatus.values) {
      if (status.value == value) {
        return status;
      }
    }
    return JobStatus.pending;
  }
}