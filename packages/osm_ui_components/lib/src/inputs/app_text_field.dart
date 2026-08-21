import 'package:flutter/material.dart';

/// ============================================================================
/// [أداة #4]: مُدخل النصوص المؤطر المعياري (AppTextField)
/// ============================================================================
/// المقابل لـ `outlined_input/outlined_input.tsx` في Mattermost Webapp.
/// 
/// يمنح هذا المكون حقل إدخال نصوص مخصص يحتوي على تسمية (Label) علوية،
/// إطار خارجي متكيف مع التركيز (Focus)، نص توضيحي (Hint)، دعم كلمات المرور،
/// وعرض شارات الأخطاء الحجمية عند وجود إدخال غير صالح.
class AppTextField extends StatelessWidget {
  /// [label]: التسمية النصية العلوية المطلوبة التي تصف الحقل.
  /// الغرض: توضيح اسم الحقل للمستخدم (مثل "اسم المستخدم" أو "كلمة المرور").
  final String label;

  /// [hint]: النص التوضيحي الباهت داخل الحقل قبل الكتابة.
  /// الغرض: تقديم مثال أو توجيه على شكل الإدخال المتوقع ( مثل "example@domain.com").
  final String? hint;

  /// [errorText]: نص خطأ التحقق (إذا كان null لا يظهر خطأ).
  /// الغرض: تنبيه المستخدم برسم إطار أحمر وعرض سبب رفض القيمة المدخلة.
  final String? errorText;

  /// [controller]: المتحكم في نص الإدخال (TextEditingController).
  /// الغرض: التفاعل البرمجي وقراءة وتعيين القيمة النصية للحقل.
  final TextEditingController? controller;

  /// [isPassword]: هل الحقل مخصص لكلمات المرور؟ (الافتراضي: false).
  /// الغرض: إخفاء الأحرف المكتوبة على هيئة نقاط لأغراض الحماية والأمان.
  final bool isPassword;

  /// [prefixIcon]: الأيقونة البادئة في بداية الحقل (من الجهة اليسرى/اليمنى حسب الاتجاه).
  /// الغرض: إضافة دلالة بصرية مثل أيقونة القفل أو البريد الإلكتروني.
  final Widget? prefixIcon;

  /// [suffixIcon]: الأيقونة اللاحقة في نهاية الحقل.
  /// الغرض: إضافة زر التفاعل مثل إظهار/إخفاء كلمة المرور أو زر مسح النص.
  final Widget? suffixIcon;

  /// [enabled]: هل الحقل نشط ومتاح للتفاعل والتعديل؟ (الافتراضي: true).
  /// الغرض: تعطيل الحقل ومنع التعديل عليه أثناء التحميل أو عدم امتلاك صلاحية.
  final bool enabled;

  /// [onChanged]: دالة الاستجابة عند تغير قيمة النص المدخل.
  /// الغرض: متابعة المدخلات فورياً لتحديث الحالة أو تشغيل الفحص الديناميكي.
  final ValueChanged<String>? onChanged;

  const AppTextField({
    super.key,
    required this.label,
    this.hint,
    this.errorText,
    this.controller,
    this.isPassword = false,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: Color(0xFF3F4350),
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          enabled: enabled,
          onChanged: onChanged,
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            errorText: errorText,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
              borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
