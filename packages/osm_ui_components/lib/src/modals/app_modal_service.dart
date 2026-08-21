import 'package:flutter/material.dart';
import 'app_generic_dialog.dart';

/// ============================================================================
/// [أداة #3]: الخدمة المركزية لإدارة النوافذ المنبثقة برمجياً (AppModalService)
/// ============================================================================
/// المقابل لـ `modal_controller` في Mattermost Webapp.
/// 
/// توفر هذه الخدمة وسيلة مركزية وموحدة يستطيع أي جزء في تطبيق Flutter استدعائها
/// لفتح النوافذ المنبثقة، حوارات التأكيد، أو الرسائل التحذيرية دون الحاجة لإعادة كتابة
/// كود `showDialog` وتكرار مظهر النوافذ الموحدة.
class AppModalService {
  /// [showGenericModal]: فتح نافذة منبثقة معيارية مخصصة.
  /// 
  /// المعاملات:
  /// - [context]: سياق الشجرة الحالي لفتح النافذة فوقه.
  /// - [title]: عنوان الترويسة.
  /// - [content]: المكون الداخلي أو نموذج البيانات.
  /// - [confirmText]: نص زر التأكيد (اختياري).
  /// - [cancelText]: نص زر التراجع (افتراضي: "إلغاء").
  /// - [onConfirm]: الدالة المفتوحة للتأكيد.
  /// - [isDestructive]: تمييز الزر باللون الأحمر للحذف أو العمليات الخطيرة.
  static Future<T?> showGenericModal<T>({
    required BuildContext context,
    required String title,
    required Widget content,
    String? confirmText,
    String cancelText = 'إلغاء',
    VoidCallback? onConfirm,
    bool isDestructive = false,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => AppGenericDialog(
        title: title,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: () {
          if (onConfirm != null) onConfirm();
          Navigator.of(ctx).pop();
        },
        isDestructive: isDestructive,
        child: content,
      ),
    );
  }

  /// [showConfirmModal]: فتح حوار تأكيد تدميري أو حاسمي سريع.
  /// 
  /// المعاملات:
  /// - [context]: سياق الواجهة.
  /// - [title]: عنوان العملية الحاسمة (مثل "تأكيد حذف القناة").
  /// - [message]: الرسالة النصية التوضيحية للمستخدم.
  /// - [confirmText]: نص زر التأكيد (الافتراضي: "تأكيد").
  /// - [isDestructive]: جعل زر التأكيد أحمر للتنبيه (الافتراضي: true).
  static Future<bool> showConfirmModal({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'تأكيد',
    String cancelText = 'إلغاء',
    bool isDestructive = true,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => AppGenericDialog(
        title: title,
        confirmText: confirmText,
        cancelText: cancelText,
        isDestructive: isDestructive,
        onConfirm: () => Navigator.of(ctx).pop(true),
        onCancel: () => Navigator.of(ctx).pop(false),
        child: Text(
          message,
          style: const TextStyle(fontSize: 15, height: 1.4),
        ),
      ),
    );
    return result ?? false;
  }
}
