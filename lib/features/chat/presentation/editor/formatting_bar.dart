import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/utils/markdown_apply.dart';

/// شريط التنسيق — نظير formatting_bar في webapp
/// (webapp/channels/src/components/advanced_text_editor/formatting_bar).
///
/// يدعم:
/// - عناوين H1/H2/H3 عبر قائمة منسدلة
/// - جدول، خط فاصل، قائمة مهام
/// - فواصل بين المجموعات
/// - حالة active حسب موقع المؤشر في النص
class FormattingBar extends StatelessWidget {
  final void Function(MarkdownMode mode) onFormat;
  final bool showPreview;
  final VoidCallback? onTogglePreview;

  /// النص الحالي في المحرر (للحالة النشطة للأزرار).
  final String message;

  /// موضع المؤشر/التحديد.
  final int selectionStart;
  final int selectionEnd;

  const FormattingBar({
    super.key,
    required this.onFormat,
    this.showPreview = false,
    this.onTogglePreview,
    this.message = '',
    this.selectionStart = 0,
    this.selectionEnd = 0,
  });

  int get _safeSelectionStart {
    if (message.isEmpty) return 0;
    return selectionStart.clamp(0, message.length);
  }

  String get _lineAtCaret {
    final caret = _safeSelectionStart;
    if (message.isEmpty || caret <= 0) return '';
    final upToCaret = message.substring(0, caret);
    final index = upToCaret.lastIndexOf('\n');
    return index == -1 ? upToCaret : upToCaret.substring(index + 1);
  }

  bool _isActive(MarkdownMode mode) {
    final caret = _safeSelectionStart;
    if (message.isEmpty || caret <= 0) return false;
    final before = message.substring(0, caret);
    final line = _lineAtCaret.trimLeft();

    switch (mode) {
      case MarkdownMode.bold:
        return before.endsWith('**');
      case MarkdownMode.italic:
        return before.endsWith('*') && !before.endsWith('**');
      case MarkdownMode.strike:
        return before.endsWith('~~');
      case MarkdownMode.code:
        return before.endsWith('`');
      case MarkdownMode.heading1:
        return line.startsWith('# ');
      case MarkdownMode.heading2:
        return line.startsWith('## ');
      case MarkdownMode.heading3:
        return line.startsWith('### ');
      case MarkdownMode.quote:
        return line.startsWith('> ');
      case MarkdownMode.ul:
        return line.startsWith('- ') || line.startsWith('* ');
      case MarkdownMode.ol:
        return RegExp(r'^\d+\. ').hasMatch(line);
      case MarkdownMode.taskList:
        return line.startsWith('- [ ] ') || line.startsWith('- [x] ');
      case MarkdownMode.link:
      case MarkdownMode.heading:
      case MarkdownMode.horizontalRule:
      case MarkdownMode.table:
        return false;
    }
  }

  String _shortcutOf(MarkdownMode mode) {
    switch (mode) {
      case MarkdownMode.bold:
        return 'Ctrl+B';
      case MarkdownMode.italic:
        return 'Ctrl+I';
      case MarkdownMode.strike:
        return 'Alt+Shift+X';
      case MarkdownMode.code:
        return 'Ctrl+Alt+C';
      case MarkdownMode.link:
        return 'Ctrl+Alt+K';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);

    Widget item(
      IconData icon,
      String tooltip,
      VoidCallback onTap, {
      bool active = false,
      String shortcut = '',
    }) {
      final tip = shortcut.isEmpty ? tooltip : '$tooltip  ($shortcut)';
      return Tooltip(
        message: tip,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(4),
          child: Container(
            width: 30,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: active
                  ? theme.centerChannelColor.withValues(alpha: 0.08)
                  : Colors.transparent,
            ),
            child: Icon(
              icon,
              size: 17,
              color: active
                  ? theme.linkColor
                  : theme.centerChannelColor.withValues(alpha: 0.65),
            ),
          ),
        ),
      );
    }

    Widget divider() {
      return Container(
        width: 1,
        height: 20,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        color: theme.centerChannelColor.withValues(alpha: 0.14),
      );
    }

    // قائمة منسدلة للعناوين H1/H2/H3.
    final heading = PopupMenuButton<MarkdownMode>(
      tooltip: l10n.formattingHeading,
      icon: Icon(
        Icons.title,
        size: 17,
        color: theme.centerChannelColor.withValues(alpha: 0.65),
      ),
      onSelected: (mode) => onFormat(mode),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: theme.centerChannelBg,
      itemBuilder: (context) => [
        PopupMenuItem(
          value: MarkdownMode.heading1,
          child: _HeadingItem(
            label: l10n.formatting_barText_styleH1,
            prefix: '# ',
            selected: _isActive(MarkdownMode.heading1),
          ),
        ),
        PopupMenuItem(
          value: MarkdownMode.heading2,
          child: _HeadingItem(
            label: l10n.formatting_barText_styleH2,
            prefix: '## ',
            selected: _isActive(MarkdownMode.heading2),
          ),
        ),
        PopupMenuItem(
          value: MarkdownMode.heading3,
          child: _HeadingItem(
            label: l10n.formatting_barText_styleH3,
            prefix: '### ',
            selected: _isActive(MarkdownMode.heading3),
          ),
        ),
      ],
    );

    final hasHeading =
        _isActive(MarkdownMode.heading1) ||
        _isActive(MarkdownMode.heading2) ||
        _isActive(MarkdownMode.heading3);

    return SizedBox(
      height: 36,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // مجموعة الأساسية.
            item(
              Icons.format_bold,
              l10n.formattingBold,
              () => onFormat(MarkdownMode.bold),
              active: _isActive(MarkdownMode.bold),
              shortcut: _shortcutOf(MarkdownMode.bold),
            ),
            item(
              Icons.format_italic,
              l10n.formattingItalic,
              () => onFormat(MarkdownMode.italic),
              active: _isActive(MarkdownMode.italic),
              shortcut: _shortcutOf(MarkdownMode.italic),
            ),
            item(
              Icons.strikethrough_s,
              l10n.formattingStrike,
              () => onFormat(MarkdownMode.strike),
              active: _isActive(MarkdownMode.strike),
              shortcut: _shortcutOf(MarkdownMode.strike),
            ),
            item(
              Icons.code,
              l10n.formattingCode,
              () => onFormat(MarkdownMode.code),
              active: _isActive(MarkdownMode.code),
              shortcut: _shortcutOf(MarkdownMode.code),
            ),
            item(
              Icons.link,
              l10n.formattingLink,
              () => onFormat(MarkdownMode.link),
              shortcut: _shortcutOf(MarkdownMode.link),
            ),
            divider(),
            // مجموعة الاقتباس والقوائم.
            item(
              Icons.format_quote,
              l10n.formattingQuote,
              () => onFormat(MarkdownMode.quote),
              active: _isActive(MarkdownMode.quote),
            ),
            item(
              Icons.format_list_bulleted,
              l10n.formattingUnorderedList,
              () => onFormat(MarkdownMode.ul),
              active: _isActive(MarkdownMode.ul),
            ),
            item(
              Icons.format_list_numbered,
              l10n.formattingOrderedList,
              () => onFormat(MarkdownMode.ol),
              active: _isActive(MarkdownMode.ol),
            ),
            item(
              Icons.check_box_outline_blank,
              l10n.formattingTaskList,
              () => onFormat(MarkdownMode.taskList),
              active: _isActive(MarkdownMode.taskList),
            ),
            divider(),
            // مجموعة العناصر المتقدمة.
            Tooltip(
              message: l10n.formattingHeading,
              child: Container(
                decoration: hasHeading
                    ? BoxDecoration(
                        color: theme.centerChannelColor.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(4),
                      )
                    : null,
                child: heading,
              ),
            ),
            item(
              Icons.table_chart_outlined,
              l10n.formattingTable,
              () => onFormat(MarkdownMode.table),
            ),
            item(
              Icons.remove,
              l10n.formattingHorizontalRule,
              () => onFormat(MarkdownMode.horizontalRule),
            ),
            divider(),
            item(
              Icons.preview,
              l10n.formattingPreview,
              onTogglePreview ?? () {},
              active: showPreview,
            ),
          ],
        ),
      ),
    );
  }
}

/// عنصر في قائمة العناوين مع معاينة التنسيق.
class _HeadingItem extends StatelessWidget {
  final String label;
  final String prefix;
  final bool selected;

  const _HeadingItem({
    required this.label,
    required this.prefix,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Row(
      children: [
        SizedBox(
          width: 34,
          child: Text(
            prefix.trim(),
            style: TextStyle(
              fontSize: 14,
              color: theme.centerChannelColor.withValues(alpha: 0.4),
            ),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 13.5,
            color: selected ? theme.linkColor : theme.centerChannelColor,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        if (selected) ...[
          const SizedBox(width: 8),
          Icon(Icons.check, size: 15, color: theme.linkColor),
        ],
      ],
    );
  }
}
