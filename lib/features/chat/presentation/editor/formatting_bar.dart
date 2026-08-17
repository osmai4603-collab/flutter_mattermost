import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/utils/markdown_apply.dart';
import 'package:flutter_mattermost/features/chat/presentation/editor/composer_controller.dart';

/// شريط التنسيق — نظير formatting_bar في webapp
/// (webapp/channels/src/components/advanced_text_editor/formatting_bar).
///
/// يدعم:
/// - عناوين H1/H2/H3 عبر قائمة منسدلة
/// - جدول، خط فاصل، قائمة مهام
/// - فواصل بين المجموعات
/// - حالة active حسب موقع المؤشر في النص
class FormattingBar extends StatefulWidget {
  final void Function(MarkdownMode mode) onFormat;
  final bool showPreview;
  final VoidCallback? onTogglePreview;
  final ComposerController composer;

  /// النص الحالي في المحرر (للحالة النشطة للأزرار).
  final String message;

  /// موضع المؤشر/التحديد.
  final int selectionStart;
  final int selectionEnd;
  final void Function()? onPickFile;
  final GlobalKey? emojiButtonKey;

  const FormattingBar({
    super.key,
    required this.onFormat,
    this.showPreview = false,
    this.onTogglePreview,
    this.message = '',
    this.selectionStart = 0,
    this.selectionEnd = 0,
    required this.composer,
    required this.onPickFile,
    this.emojiButtonKey,
  });

  @override
  State<FormattingBar> createState() => _FormattingBarState();
}

class _FormattingBarState extends State<FormattingBar> {
  bool hideFormatting = false;
  int get _safeSelectionStart {
    if (widget.message.isEmpty) return 0;
    return widget.selectionStart.clamp(0, widget.message.length);
  }

  String get _lineAtCaret {
    final caret = _safeSelectionStart;
    if (widget.message.isEmpty || caret <= 0) return '';
    final upToCaret = widget.message.substring(0, caret);
    final index = upToCaret.lastIndexOf('\n');
    return index == -1 ? upToCaret : upToCaret.substring(index + 1);
  }

  bool _isActive(MarkdownMode mode) {
    final caret = _safeSelectionStart;
    if (widget.message.isEmpty || caret <= 0) return false;
    final before = widget.message.substring(0, caret);
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
      double iconSize = 17,
      Key? key,
    }) {
      final tip = shortcut.isEmpty ? tooltip : '$tooltip  ($shortcut)';
      return Tooltip(
        key: key,
        message: tip,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(4),
            child: Container(
              width: 30,
              height: 30,
              padding: .all(4),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: active
                    ? theme.centerChannelColor.withValues(alpha: 0.08)
                    : Colors.transparent,
              ),
              child: Icon(
                icon,
                size: iconSize,
                color: active
                    ? theme.linkColor
                    : theme.centerChannelColor.withValues(alpha: 0.65),
              ),
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

    // // قائمة منسدلة للعناوين H1/H2/H3.
    // final heading = PopupMenuButton<MarkdownMode>(
    //   tooltip: l10n.formattingHeading,
    //   borderRadius: .circular(4),
    //   onSelected: (mode) => widget.onFormat(mode),
    //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    //   color: theme.centerChannelBg,
    //   itemBuilder: (context) => [
    //     PopupMenuItem(
    //       value: MarkdownMode.heading1,
    //       child: _HeadingItem(
    //         label: l10n.formatting_barText_styleH1,
    //         prefix: '# ',
    //         selected: _isActive(MarkdownMode.heading1),
    //       ),
    //     ),
    //     PopupMenuItem(
    //       value: MarkdownMode.heading2,
    //       child: _HeadingItem(
    //         label: l10n.formatting_barText_styleH2,
    //         prefix: '## ',
    //         selected: _isActive(MarkdownMode.heading2),
    //       ),
    //     ),
    //     PopupMenuItem(
    //       value: MarkdownMode.heading3,
    //       child: _HeadingItem(
    //         label: l10n.formatting_barText_styleH3,
    //         prefix: '### ',
    //         selected: _isActive(MarkdownMode.heading3),
    //       ),
    //     ),
    //   ],
    //   child: Padding(
    //     padding: const EdgeInsets.all(4.0),
    //     child: Text(
    //       'H',
    //       style: TextStyle(
    //         color: theme.centerChannelColor.withValues(alpha: 0.65),
    //         fontSize: 14,
    //         fontWeight: .bold,
    //       ),
    //     ),
    //   ),
    // );

    // final hasHeading =
    //     _isActive(MarkdownMode.heading1) ||
    //     _isActive(MarkdownMode.heading2) ||
    //     _isActive(MarkdownMode.heading3);

    return SizedBox(
      height: 36,
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                spacing: 4,
                mainAxisAlignment: .start,
                children: [
                  // مجموعة الأساسية.
                  item(
                    Icons.format_bold,
                    l10n.formattingBold,
                    () => widget.onFormat(MarkdownMode.bold),
                    active: _isActive(MarkdownMode.bold),
                    shortcut: _shortcutOf(MarkdownMode.bold),
                  ),
                  item(
                    Icons.format_italic,
                    l10n.formattingItalic,
                    () => widget.onFormat(MarkdownMode.italic),
                    active: _isActive(MarkdownMode.italic),
                    shortcut: _shortcutOf(MarkdownMode.italic),
                  ),
                  item(
                    Icons.strikethrough_s,
                    l10n.formattingStrike,
                    () => widget.onFormat(MarkdownMode.strike),
                    active: _isActive(MarkdownMode.strike),
                    shortcut: _shortcutOf(MarkdownMode.strike),
                  ),
                  item(
                    Icons.h_mobiledata,
                    l10n.formattingHeading,
                    () => widget.onFormat(MarkdownMode.heading1),
                    active: _isActive(MarkdownMode.heading1),
                    shortcut: _shortcutOf(MarkdownMode.heading1),
                    iconSize: 20,
                  ),
                  divider(),
                  item(
                    Icons.link,
                    l10n.formattingLink,
                    () => widget.onFormat(MarkdownMode.link),
                    shortcut: _shortcutOf(MarkdownMode.link),
                  ),
                  item(
                    Icons.code,
                    l10n.formattingCode,
                    () => widget.onFormat(MarkdownMode.code),
                    active: _isActive(MarkdownMode.code),
                    shortcut: _shortcutOf(MarkdownMode.code),
                  ),
                  // مجموعة الاقتباس والقوائم.
                  item(
                    Icons.format_quote,
                    l10n.formattingQuote,
                    () => widget.onFormat(MarkdownMode.quote),
                    active: _isActive(MarkdownMode.quote),
                  ),
                  item(
                    Icons.format_list_bulleted,
                    l10n.formattingUnorderedList,
                    () => widget.onFormat(MarkdownMode.ul),
                    active: _isActive(MarkdownMode.ul),
                  ),
                  item(
                    Icons.format_list_numbered,
                    l10n.formattingOrderedList,
                    () => widget.onFormat(MarkdownMode.ol),
                    active: _isActive(MarkdownMode.ol),
                  ),

                  divider(),
                  item(
                    Icons.info_outline_rounded,
                    'Message Priority',
                    () => widget.onFormat(MarkdownMode.ol),
                    active: _isActive(MarkdownMode.ol),
                  ),
                ],
              ),
            ),
          ),
          Row(
            spacing: 4,
            children: [
              Tooltip(
                message: 'Hide Formatting',
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(4),
                    child: Container(
                      width: 50,
                      height: 30,
                      padding: .all(4),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: hideFormatting
                            ? theme.centerChannelColor.withValues(alpha: 0.08)
                            : Colors.transparent,
                      ),
                      child: Row(
                        children: [
                          Text('Aa'),
                          AnimatedRotation(
                            turns: hideFormatting ? 0.5 : 0,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                            child: Icon(
                              Icons.arrow_drop_down,
                              size: 20,
                              color: hideFormatting
                                  ? theme.linkColor
                                  : theme.centerChannelColor.withValues(
                                      alpha: 0.65,
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              divider(),
              item(
                Icons.link,
                'Upload File',
                () => widget.onPickFile?.call(),
                active: false,
              ),

              item(
                Icons.emoji_emotions_outlined,
                'Emoji / Gif piker',
                widget.composer.toggleEmojiPicker,
                active: false,
                key: widget.emojiButtonKey,
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: .all(4),
                ),
                onPressed: widget.composer.canSend
                    ? () => widget.composer.send()
                    : null,
                child: Icon(Icons.send_rounded, size: 19),
              ),
            ],
          ),
        ],
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
