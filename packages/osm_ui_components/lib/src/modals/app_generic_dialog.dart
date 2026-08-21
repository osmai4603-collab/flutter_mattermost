import 'package:flutter/material.dart';

/// ============================================================================
/// [أداة #2]: هيكل النوافذ المنبثقة الموحد (AppGenericDialog)
/// ============================================================================
/// المقابل لـ `generic_modal/generic_modal.tsx` في Mattermost Webapp.
/// 
/// توفر هذه الأداة ويدجت حوار منبثق معيارياً ينظم الواجهة إلى 3 أجزاء رئيسية:
/// ترويسة مع زر إغلاق، جسم قابل للتمرير يحوي نموذج البيانات، وشريط أزرار الإجراءات
/// في الأسفل مع دعم التأكيد والتأخير ودعم التنسيق التدميري (Destructive Action).
class AppGenericDialog extends StatelessWidget {
  /// [title]: عنوان المودال الظاهر في الترويسة العلوية.
  /// الغرض: تعريف المستخدم بنوع العملية (مثل: "إنشاء قناة جديدة" أو "حذف المشاركة").
  final String title;

  /// [child]: المحتوى الرئيسي والنموذج الداخلي للمودال.
  /// الغرض: استقبال حقول الإدخال، النصوص، أو القوائم الخاصة بالنظارات المنبثقة.
  final Widget child;

  /// [confirmText]: نص زر الإجراء الرئيسي للتأكيد (مثل "حفظ" أو "حذف").
  /// الغرض: تحديد الإجراء الإيجابي أو النهائي في المودال (إذا كان null لا يظهر الزر).
  final String? confirmText;

  /// [cancelText]: نص زر الإلغاء في الأسفل (الافتراضي: "إلغاء").
  /// الغرض: التراجع وإغلاق المودال دون اتخاذ أي إجراء.
  final String cancelText;

  /// [onConfirm]: الدالة المطلوبة عند الضغط على زر التأكيد [confirmText].
  /// الغرض: تنفيذ استدعاء API أو حفظ التغييرات عند النقر.
  final VoidCallback? onConfirm;

  /// [onCancel]: الدالة المطلوبة عند الضغط على زر الإلغاء أو زر X.
  /// الغرض: تنظيف الحالة وإغلاق المودال (إذا تركت null تقوم بإغلاق النمطي تلقائياً).
  final VoidCallback? onCancel;

  /// [isDestructive]: هل العملية تدميرية/خطيرة (مثل الحذف)؟
  /// الغرض: تلوين زر التأكيد باللون الأحمر لتنبيه المستخدم قبل التنفيذ.
  final bool isDestructive;

  /// [isLoading]: هل العملية قيد التنفيذ حالياً؟
  /// الغرض: تعطيل الأزرار وعرض مؤشر تحميل دائري لمنع الضغط المزدوج.
  final bool isLoading;

  /// [maxWidth]: الحد الأقصى لعرض المودال (الافتراضي: 540).
  /// الغرض: التكيف مع الشاشات العريضة وسطح المكتب دون أن يتطاط المودال بشاعة.
  final double maxWidth;

  const AppGenericDialog({
    super.key,
    required this.title,
    required this.child,
    this.confirmText,
    this.cancelText = 'إلغاء',
    this.onConfirm,
    this.onCancel,
    this.isDestructive = false,
    this.isLoading = false,
    this.maxWidth = 540,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth, maxHeight: 680),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () {
                      if (onCancel != null) {
                        onCancel!();
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1),
            // Body Section
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: child,
              ),
            ),
            const Divider(height: 1, thickness: 1),
            // Footer Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            if (onCancel != null) {
                              onCancel!();
                            } else {
                              Navigator.of(context).pop();
                            }
                          },
                    child: Text(cancelText),
                  ),
                  if (confirmText != null) ...[
                    const SizedBox(width: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDestructive ? Colors.red : Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: isLoading ? null : onConfirm,
                      child: isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(confirmText!),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
