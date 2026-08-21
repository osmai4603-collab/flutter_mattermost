import 'package:flutter/material.dart';

/// ============================================================================
/// [أداة #5]: مُدخل النصوص المتمدد تلقائياً (AppAutosizeTextArea)
/// ============================================================================
/// المقابل لـ `autosize_textarea/autosize_textarea.tsx` في Mattermost Webapp.
/// 
/// مخصص لكتابة الرسائل المتعددة الأسطر والمنشورات، حيث يتمدد ارتفاع الحقل ديناميكياً
/// مع إضافة أسطر جديدة حتى يصل للحد الأقصى المسموح به من الأسطر، مما يوفر بيئة كتابة
/// سلسة دون اقتطاع النصوص أو التمرير المزعج.
class AppAutosizeTextArea extends StatelessWidget {
  /// [hint]: النص التوضيحي الباهت الظاهر داخل المنطقة قبل الكتابة.
  /// الغرض: توجيه المستخدم لكتابة رسالة أو مشاركة (مثل "اكتب رسالة...").
  final String hint;

  /// [controller]: المتحكم في نص الإدخال.
  /// الغرض: الوصول للنص المكتوب وتحديثه برمجياً.
  final TextEditingController? controller;

  /// [minLines]: الحد الأدنى لعدد الأسطر المعروضة ابتدائياً (الافتراضي: 1).
  /// الغرض: تحديد الارتفاع الأولي للمُدخل قبل البدء في كتابة أسطر جديدة.
  final int minLines;

  /// [maxLines]: الحد الأقصى المتمدد لعدد الأسطر (الافتراضي: 5).
  /// الغرض: حصر تمدد الحقل حتى لا يغطي الشاشة بأكملها، والتحول للتمرير بعد هذا الحد.
  final int maxLines;

  /// [onSubmitted]: دالة تنفذ عند النقر على إرسال أو إدخال (Enter).
  /// الغرض: إرسال الرسالة فورياً عند الضغط على زر الإدخال.
  final ValueChanged<String>? onSubmitted;

  /// [onChanged]: دالة تنفذ فور تغير محتوى النص المكتوب.
  /// الغرض: تحديث حالة الأزرار واكتشاف كتابة الإشارات (@mention).
  final ValueChanged<String>? onChanged;

  const AppAutosizeTextArea({
    super.key,
    required this.hint,
    this.controller,
    this.minLines = 1,
    this.maxLines = 5,
    this.onSubmitted,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      minLines: minLines,
      maxLines: maxLines,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      style: const TextStyle(fontSize: 14, height: 1.4),
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFD6D8DC)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFD6D8DC)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.5),
        ),
      ),
    );
  }
}
