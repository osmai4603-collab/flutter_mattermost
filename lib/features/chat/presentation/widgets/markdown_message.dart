import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:flutter_mattermost/features/chat/presentation/widgets/code_block_widget.dart';
import 'package:url_launcher/url_launcher.dart';

Widget _safeMarkdownBody({required String data, required MarkdownStyleSheet styleSheet}) {
  return MarkdownBody(
    data: data.trim().isEmpty ? ' ' : data,
    onTapLink: (text, href, title) {
      if (href == null || href.isEmpty) return;
      final uri = Uri.tryParse(href);
      if (uri != null) {
        unawaited(launchUrl(uri, mode: LaunchMode.externalApplication));
      }
    },
    builders: {'pre': CodeBlockElementBuilder()},
    styleSheet: styleSheet,
    softLineBreak: true,
    selectable: false,
  );
}

class MarkdownMessage extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const MarkdownMessage({super.key, required this.text, this.style});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<MattermostColors>();
    final textColor = theme?.centerChannelColor ?? Theme.of(context).colorScheme.onSurface;
    final linkColor = theme?.linkColor ?? Theme.of(context).colorScheme.primary;
    final mutedBackground = theme?.centerChannelColor.withValues(alpha: 0.08) ??
        Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08);
    final strongBackground = theme?.centerChannelColor.withValues(alpha: 0.12) ??
        Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.12);
    final quoteBackground = theme?.centerChannelColor.withValues(alpha: 0.05) ??
        Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.05);
    final codeBlockBackground = const Color(0xFF111827);
    if (text.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    final markdownStyleSheet = MarkdownStyleSheet(
      p: style ?? TextStyle(
        color: textColor.withValues(alpha: 0.96),
        fontSize: 14,
        height: 1.55,
      ),
      a: TextStyle(
        color: linkColor,
        fontWeight: FontWeight.w600,
        decoration: TextDecoration.underline,
        decorationColor: linkColor,
        decorationThickness: 2,
        backgroundColor: linkColor.withValues(alpha: 0.08),
      ),
      strong: TextStyle(
        fontWeight: FontWeight.w800,
        color: textColor,
      ),
      em: TextStyle(
        fontStyle: FontStyle.italic,
        color: textColor.withValues(alpha: 0.94),
      ),
      code: TextStyle(
        fontFamily: 'monospace',
        fontSize: 12.5,
        color: const Color(0xFFE2E8F0),
        backgroundColor: strongBackground,
      ),
      codeblockDecoration: BoxDecoration(
        color: codeBlockBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      blockquoteDecoration: BoxDecoration(
        color: quoteBackground,
        borderRadius: BorderRadius.circular(6),
        border: Border(
          left: BorderSide(color: linkColor, width: 3),
        ),
      ),
      h1: TextStyle(
        color: textColor,
        fontWeight: FontWeight.w800,
        fontSize: 22,
        height: 1.3,
      ),
      h2: TextStyle(
        color: textColor,
        fontWeight: FontWeight.w700,
        fontSize: 19,
        height: 1.35,
      ),
      h3: TextStyle(
        color: textColor,
        fontWeight: FontWeight.w700,
        fontSize: 17,
        height: 1.4,
      ),
      blockSpacing: 8,
      listBullet: TextStyle(color: linkColor),
      listIndent: 20,
      tableHead: TextStyle(
        color: textColor,
        fontWeight: FontWeight.w700,
        fontSize: 13,
      ),
      tableBody: TextStyle(
        color: textColor.withValues(alpha: 0.92),
        fontSize: 13,
      ),
      tableBorder: TableBorder.all(
        color: textColor.withValues(alpha: 0.18),
      ),
      horizontalRuleDecoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: textColor.withValues(alpha: 0.14), width: 1),
        ),
      ),
    );

    return _safeMarkdownBody(data: text, styleSheet: markdownStyleSheet);
  }
}
