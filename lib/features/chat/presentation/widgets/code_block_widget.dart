import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/features/chat/presentation/widgets/syntax_highlight_builder.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:flutter_markdown/flutter_markdown.dart';

/// يبني [CodeBlockWidget] من عنصر `pre` في شجرة Markdown —
/// يستخرج اللغة من `class="language-x"` في عنصر `code`.
class CodeBlockElementBuilder extends MarkdownElementBuilder {
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
    return CodeBlockWidget(language: language, code: code);
  }
}

/// كتلة كود مخصصة للعرض في معاينة Markdown:
/// شريط علوي باسم اللغة + زر نسخ + تلوين حسب اللغة على خلفية داكنة.
class CodeBlockWidget extends StatelessWidget {
  final String code;
  final String? language;

  const CodeBlockWidget({super.key, required this.code, this.language});

  String get _languageLabel {
    final lang = SyntaxHighlightBuilder.normalizeLanguage(language);
    return lang == 'plaintext' ? 'text' : lang;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
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
            color: const Color(0xFF0D1117),
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
          // الكود الملون.
          Container(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
            decoration: const BoxDecoration(
              color: Color(0xFF0B1020),
            ),
            child: RichText(
              text: TextSpan(
                children: SyntaxHighlightBuilder.buildSpans(
                  code: code,
                  language: language,
                  syntaxTheme: SyntaxTheme.githubDark(),
                ),
                style: const TextStyle(
                  color: Color(0xFFE6EDF3),
                  fontSize: 12.5,
                  height: 1.45,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ),
        ],
      ),
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
            Icon(
              Icons.copy_rounded,
              size: 13,
              color: const Color(0xFF8B949E),
            ),
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