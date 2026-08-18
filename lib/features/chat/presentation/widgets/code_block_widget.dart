import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/features/chat/presentation/widgets/post_message/syntax_highlight_builder.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:flutter_markdown/flutter_markdown.dart';

/// يبني [CodeBlockWidget] من عنصر `pre` في شجرة Markdown —
/// يستخرج اللغة من `class="language-x"` في عنصر `code`.
class CodeBlockElementBuilder extends MarkdownElementBuilder {
  /// تحكم إظهار أرقام الأسطر: `null` = تلقائي (تظهر عند تعدد الأسطر).
  final bool? showLineNumbers;

  CodeBlockElementBuilder({this.showLineNumbers});

  @override
  bool isBlockElement() => true;

  /// flutter_markdown يستدعي visitText للعناصر داخل `pre`؛ والعودة بـ null
  /// تترك مكدس _inlines غير مصفَّى فتقف assertion (_inlines.isEmpty).
  /// إرجاع عنصر نائب يُصفّى المكدس، ويستبدل المحتوى في
  /// [visitElementAfterWithContext] بكتلة الكود النهائية.
  @override
  Widget? visitText(md.Text text, TextStyle? preferredStyle) => Text(text.text);

  @override
  Widget? visitElementAfterWithContext(
    BuildContext context,
    md.Element element,
    TextStyle? preferredStyle,
    TextStyle? parentStyle,
  ) {
    String? language;
    String? code;
    for (final child in element.children ?? const <md.Node>[]) {
      if (child is md.Element && child.tag == 'code') {
        final classAttr = child.attributes['class'] ?? '';
        final match = RegExp(r'language-(\S+)').firstMatch(classAttr);
        if (match != null) language = match.group(1);
        code = child.textContent;
      }
    }
    code ??= element.textContent;
    return CodeBlockWidget(
      language: language,
      code: code,
      showLineNumbers: showLineNumbers,
    );
  }
}

/// كتلة كود مخصصة للعرض في معاينة Markdown:
/// شريط علوي باسم اللغة + زر نسخ + تلوين حسب اللغة على خلفية داكنة،
/// مع أرقام أسطر اختيارية وتمرير أفقي/عمودي للكتل الطويلة.
class CodeBlockWidget extends StatelessWidget {
  final String code;
  final String? language;

  /// `null` = تلقائي: تظهر الأرقام عندما يتجاوز الكود عدد أسطر معين.
  final bool? showLineNumbers;

  const CodeBlockWidget({
    super.key,
    required this.code,
    this.language,
    this.showLineNumbers,
  });

  /// عدد الأسطر الذي يُفعّل عرض أرقام الأسطر تلقائياً.
  static const int _autoLineNumberThreshold = 6;

  /// أقصى ارتفاع لكتلة الكود قبل تفعيل التمرير العمودي.
  static const double _maxCodeHeight = 420;

  bool get _shouldShowLineNumbers {
    if (showLineNumbers != null) return showLineNumbers!;
    return code.split('\n').length > _autoLineNumberThreshold;
  }

  String get _languageLabel {
    final lang = SyntaxHighlightBuilder.normalizeLanguage(language);
    return lang == 'plaintext' ? 'text' : lang;
  }

  @override
  Widget build(BuildContext context) {
    final lines = code.split('\n');
    final showNumbers = _shouldShowLineNumbers;
    final colors = AppTheme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        // color: colors.centerChannelBg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // شريط اللغة + نسخ.
          Container(
            height: 30,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            // color: colors.centerChannelBg,
            child: Row(
              children: [
                // نقاط النوافذ (مؤشر)
                const _WindowDot(color: Color(0xFFFF5F56)),
                const SizedBox(width: 5),
                const _WindowDot(color: Color(0xFFFFBD2E)),
                const SizedBox(width: 5),
                const _WindowDot(color: Color(0xFF27C93F)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _languageLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF8B949E),
                      fontSize: 11.5,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
                _CopyButton(code: code),
              ],
            ),
          ),
          // الكود الملون — تمرير عمودي (للكتل الطويلة) وأفقي (للأسطر الطويلة).
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: _maxCodeHeight),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showNumbers) ...[
                      _LineNumbers(count: lines.length),
                      const SizedBox(width: 14),
                    ],
                    VerticalDivider(
                      width: 0,
                      thickness: 0.50,
                      color: colors.centerChannelColor.withValues(alpha: 0.40),
                    ),
                    RichText(
                      text: TextSpan(
                        children: SyntaxHighlightBuilder.buildSpans(
                          code: code,
                          language: language,
                          syntaxTheme: SyntaxTheme.githubDark(),
                        ),
                        style: TextStyle(
                          // color: Colors.black, // colors.centerChannelColor,
                          fontSize: 12.5,
                          height: 1.45,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// عمود أرقام الأسطر بمحاذاة نص الكود (نفس الخط والحجم والارتفاع).
class _LineNumbers extends StatelessWidget {
  final int count;
  const _LineNumbers({required this.count});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (var i = 1; i <= count; i++)
          Text(
            '$i',
            style: const TextStyle(
              color: Color(0xFF4B5563),
              fontSize: 12.5,
              height: 1.45,
              fontFamily: 'monospace',
            ),
          ),
      ],
    );
  }
}

class _WindowDot extends StatelessWidget {
  final Color color;
  const _WindowDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 9,
      height: 9,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _CopyButton extends StatelessWidget {
  final String code;
  const _CopyButton({required this.code});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return InkWell(
      onTap: () {
        Clipboard.setData(ClipboardData(text: code));
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(
                'Copied',
                style: TextStyle(fontSize: 13, color: theme.centerChannelColor),
              ),
              duration: const Duration(seconds: 1),
              backgroundColor: theme.centerChannelBg,
            ),
          );
      },
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.copy_rounded, size: 13, color: const Color(0xFF8B949E)),
            const SizedBox(width: 4),
            const Text(
              'Copy',
              style: TextStyle(color: Color(0xFF8B949E), fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
