import 'package:flutter/material.dart';
import 'package:highlight/highlight.dart' as hl;

/// تنسيقات ألوان لعلامات التلوين (كلاسيك highlight.js).
@immutable
class SyntaxTheme {
  final Color keyword;
  final Color string;
  final Color comment;
  final Color number;
  final Color meta;
  final Color title;
  final Color type;
  final Color builtIn;
  final Color literal;
  final Color attr;
  final Color plain;

  const SyntaxTheme({
    required this.keyword,
    required this.string,
    required this.comment,
    required this.number,
    required this.meta,
    required this.title,
    required this.type,
    required this.builtIn,
    required this.literal,
    required this.attr,
    required this.plain,
  });

  /// GitHub Dark (يتناسب مع خلفية كتلة الكود الداكنة).
  factory SyntaxTheme.githubDark() => const SyntaxTheme(
    keyword: Color(0xFFFF7B72),
    string: Color(0xFFA5D6FF),
    comment: Color(0xFF8B949E),
    number: Color(0xFF79C0FF),
    meta: Color(0xFFFFA657),
    title: Color(0xFFD2A8FF),
    type: Color(0xFFFFA657),
    builtIn: Color(0xFFFFA657),
    literal: Color(0xFF79C0FF),
    attr: Color(0xFF79C0FF),
    plain: Color(0xFFE6EDF3),
  );

  /// Monokai.
  factory SyntaxTheme.monokai() => const SyntaxTheme(
    keyword: Color(0xFFF92672),
    string: Color(0xFFE6DB74),
    comment: Color(0xFF75715E),
    number: Color(0xFFAE81FF),
    meta: Color(0xFFA6E22E),
    title: Color(0xFFA6E22E),
    type: Color(0xFFA6E22E),
    builtIn: Color(0xFF66D9EF),
    literal: Color(0xFFAE81FF),
    attr: Color(0xFF66D9EF),
    plain: Color(0xFFF8F8F2),
  );

  /// Solarized Dark.
  factory SyntaxTheme.solarizedDark() => const SyntaxTheme(
    keyword: Color(0xFF859900),
    string: Color(0xFF2AA198),
    comment: Color(0xFF586E75),
    number: Color(0xFFD33682),
    meta: Color(0xFFB58900),
    title: Color(0xFF268BD2),
    type: Color(0xFFB58900),
    builtIn: Color(0xFFD33682),
    literal: Color(0xFFCB4B16),
    attr: Color(0xFFB58900),
    plain: Color(0xFF93A1A1),
  );
}

/// **مُنشئ تلوين الأكواد البرمجية** — يستخدم حزمة `highlight` (190+ لغة)
/// ويحوّل شجرة النتائج (Nodes) إلى `InlineSpan` ملونة للعرض في
/// `flutter_markdown` أو `RichText`.
class SyntaxHighlightBuilder {
  SyntaxHighlightBuilder._();

  /// مزامنة أسماء اللغات الشائعة مع أسماء حزمة highlight.
  static const Map<String, String> _aliases = {
    'js': 'javascript',
    'jsx': 'javascript',
    'ts': 'typescript',
    'tsx': 'typescript',
    'py': 'python',
    'sh': 'bash',
    'shell': 'bash',
    'zsh': 'bash',
    'c++': 'cpp',
    'c#': 'cs',
    'csharp': 'cs',
    'yml': 'yaml',
    'docker': 'dockerfile',
    'text': 'plaintext',
    'txt': 'plaintext',
    'none': 'plaintext',
  };

  /// اللغات المدعومة المعروفة (أسماء standard).
  static const List<String> supportedLanguages = [
    'python', 'dart', 'go', 'javascript', 'typescript', 'sql', 'yaml',
    'json', 'bash', 'shell', 'cpp', 'c', 'csharp', 'java', 'kotlin',
    'swift', 'ruby', 'php', 'rust', 'html', 'css', 'xml', 'objectivec',
    'scala', 'perl', 'lua', 'r', 'matlab', 'groovy', 'haskell', 'elixir',
    'erlang', 'clojure', 'd', 'fortran', 'vbnet', 'powershell', 'dockerfile',
    'nginx', 'gradle', 'ini', 'plaintext', 'markdown', 'diff',
  ];

  static String normalizeLanguage(String? language) {
    if (language == null) return 'plaintext';
    final lang = language.trim().toLowerCase();
    return _aliases[lang] ?? lang;
  }

  /// يبني سبانز ملونة من نص كود بلغة معينة.
  static List<InlineSpan> buildSpans({
    required String code,
    required String? language,
    required SyntaxTheme syntaxTheme,
  }) {
    final lang = normalizeLanguage(language);
    if (lang == 'plaintext') return [TextSpan(text: code)];

    try {
      final result = hl.highlight.parse(code, language: lang);
      final nodes = result.nodes;
      if (nodes == null || nodes.isEmpty) return [TextSpan(text: code)];

      final spans = <InlineSpan>[];
      for (final node in nodes) {
        _visit(node, syntaxTheme, spans);
      }
      return spans.isEmpty ? [TextSpan(text: code)] : spans;
    } catch (_) {
      return [TextSpan(text: code)];
    }
  }

  static void _visit(
    hl.Node node,
    SyntaxTheme theme,
    List<InlineSpan> out,
  ) {
    final text = node.value;
    if (text != null) {
      out.add(
        TextSpan(text: text, style: TextStyle(color: _colorFor(node.className, theme))),
      );
      return;
    }
    if (node.children != null) {
      for (final child in node.children!) {
        _visit(child, theme, out);
      }
    }
  }

  static Color _colorFor(String? className, SyntaxTheme theme) {
    switch (className) {
      case 'hljs-keyword':
      case 'hljs-selector-tag':
        return theme.keyword;
      case 'hljs-string':
      case 'hljs-regexp':
      case 'hljs-addition':
        return theme.string;
      case 'hljs-comment':
      case 'hljs-quote':
      case 'hljs-deletion':
        return theme.comment;
      case 'hljs-number':
        return theme.number;
      case 'hljs-meta':
        return theme.meta;
      case 'hljs-title':
      case 'hljs-function':
      case 'hljs-section':
        return theme.title;
      case 'hljs-type':
      case 'hljs-class':
        return theme.type;
      case 'hljs-built_in':
        return theme.builtIn;
      case 'hljs-literal':
        return theme.literal;
      case 'hljs-attr':
        return theme.attr;
      default:
        return theme.plain;
    }
  }
}