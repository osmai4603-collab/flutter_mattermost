import 'package:flutter/material.dart';

/// ============================================================================
/// [أداة #11]: محرر وشريط تنسيق النصوص الغنية (AppRichTextEditor)
/// ============================================================================
/// المقابل لـ `advanced_text_editor/advanced_text_editor.tsx` في Mattermost Webapp.
/// 
/// يوفر محرر نصوص مدعماً بشريط أدوات التنسيق العلوي/السفلي لتنسيق الخطوط (غامق، مائل،
/// قائمة نقاط، اقتباس كود، إضافة رابط، وإضافة الإيموجي)، مع الاستجابة لزر الإرسال.
class AppRichTextEditor extends StatefulWidget {
  /// [hint]: النص التوضيحي الباهت داخل المحرر قبل الكتابة.
  /// الغرض: توجيه المستخدم لكتابة المنشور والتفاعل.
  final String hint;

  /// [controller]: المتحكم في نص الإدخال المكتوب.
  /// الغرض: قراءة النص واسترجاعه للتخزين أو الإرسال.
  final TextEditingController? controller;

  /// [onSend]: الدالة التنفيذية عند الضغط على زر الإرسال.
  /// الغرض: إرسال الرسالة النصية المنسقة للشبكة أو المحادثة.
  final ValueChanged<String>? onSend;

  /// [onEmojiTap]: الدالة التنفيذية عند النقر على أيقونة الإيموجي.
  /// الغرض: فتح منتقي الرموز التعبيرية (Emoji Picker).
  final VoidCallback? onEmojiTap;

  /// [onAttachmentTap]: الدالة التنفيذية عند النقر على أيقونة المرفقات.
  /// الغرض: فتح منتقي الملفات والصور لإرفاقها مع الرسالة.
  final VoidCallback? onAttachmentTap;

  const AppRichTextEditor({
    super.key,
    this.hint = 'اكتب رسالة منسقة...',
    this.controller,
    this.onSend,
    this.onEmojiTap,
    this.onAttachmentTap,
  });

  @override
  State<AppRichTextEditor> createState() => _AppRichTextEditorState();
}

class _AppRichTextEditorState extends State<AppRichTextEditor> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = widget.controller ?? TextEditingController();
  }

  void _insertFormatting(String prefix, String suffix) {
    final text = _textController.text;
    final selection = _textController.selection;
    if (!selection.isValid) {
      _textController.text = '$text$prefix$suffix';
      return;
    }
    final selectedText = selection.textInside(text);
    final newText = text.replaceRange(selection.start, selection.end, '$prefix$selectedText$suffix');
    _textController.text = newText;
    _textController.selection = TextSelection.collapsed(offset: selection.start + prefix.length + selectedText.length);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFD6D8DC)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Formatting Toolbar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: const BoxDecoration(
              color: Color(0xFFF5F6F8),
              borderRadius: BorderRadius.vertical(top: Radius.circular(9)),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.format_bold, size: 20),
                  tooltip: 'نص غامق',
                  onPressed: () => _insertFormatting('**', '**'),
                ),
                IconButton(
                  icon: const Icon(Icons.format_italic, size: 20),
                  tooltip: 'نص مائل',
                  onPressed: () => _insertFormatting('*', '*'),
                ),
                IconButton(
                  icon: const Icon(Icons.code, size: 20),
                  tooltip: 'رمز كود',
                  onPressed: () => _insertFormatting('`', '`'),
                ),
                IconButton(
                  icon: const Icon(Icons.link, size: 20),
                  tooltip: 'إضافة رابط',
                  onPressed: () => _insertFormatting('[', '](https://)'),
                ),
                const Spacer(),
                if (widget.onAttachmentTap != null)
                  IconButton(
                    icon: const Icon(Icons.attach_file, size: 20),
                    tooltip: 'إرفاق ملف',
                    onPressed: widget.onAttachmentTap,
                  ),
                if (widget.onEmojiTap != null)
                  IconButton(
                    icon: const Icon(Icons.emoji_emotions_outlined, size: 20),
                    tooltip: 'إيموجي',
                    onPressed: widget.onEmojiTap,
                  ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1),
          // Input Area & Send Button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    minLines: 2,
                    maxLines: 6,
                    decoration: InputDecoration.collapsed(hintText: widget.hint),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send_rounded, color: Color(0xFF1C68D4)),
                  onPressed: () {
                    final text = _textController.text.trim();
                    if (text.isNotEmpty && widget.onSend != null) {
                      widget.onSend!(text);
                      _textController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
