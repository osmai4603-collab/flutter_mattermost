import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/features/chat/presentation/widgets/markdown_message.dart';

/// نافذة منبثقة للوصف الكامل لقناة (Header/Purpose) — يطابق
/// channel_header_text_popover.tsx في webapp: تعرض الـ Markdown كاملاً
/// مع أزرار نسخ النص وتحرير رأس القناة.
///
/// تُفتح بجوار مشغّل النص (مثل بقية [OverlayEntry] في المشروع) وتُغلق
/// عند النقر خارجها.
class ChannelHeaderTextPopover extends StatefulWidget {
  /// اسم القناة لعرضه أعلى النافذة.
  final String title;

  /// نص الوصف (header أو purpose).
  final String text;

  /// تنفيذ عند طلب تحرير رأس القناة (يفتح مودال التحرير المسجل).
  final VoidCallback? onEdit;

  /// الطفل الذي يتلقى النقر لفتح النافذة.
  final Widget child;

  /// يُفعَّل المنبثق فقط عند وجود وصف (لا يُفتح فارغاً).
  final bool enabled;

  const ChannelHeaderTextPopover({
    super.key,
    required this.title,
    required this.text,
    this.onEdit,
    required this.child,
    this.enabled = true,
  });

  @override
  State<ChannelHeaderTextPopover> createState() =>
      _ChannelHeaderTextPopoverState();
}

class _ChannelHeaderTextPopoverState extends State<ChannelHeaderTextPopover> {
  final GlobalKey _anchorKey = GlobalKey();
  OverlayEntry? _entry;

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void _removeOverlay() {
    _entry?.remove();
    _entry = null;
  }

  void _toggle() {
    if (_entry != null) {
      _removeOverlay();
      return;
    }
    if (!widget.enabled || widget.text.trim().isEmpty) return;
    final overlay = Overlay.of(context);
    final overlayBox = overlay.context.findRenderObject()! as RenderBox;
    final anchorBox =
        _anchorKey.currentContext?.findRenderObject() as RenderBox?;
    if (anchorBox == null || !anchorBox.hasSize) return;

    final screenSize = MediaQuery.sizeOf(context);
    const panelWidth = 400.0;
    final panelHeight = (screenSize.height - 140).clamp(200.0, 360.0);
    final anchorPos = anchorBox.localToGlobal(
      Offset.zero,
      ancestor: overlayBox,
    );

    var dx = anchorPos.dx;
    if (dx + panelWidth > overlayBox.size.width - 8) {
      dx = overlayBox.size.width - panelWidth - 8;
    }
    if (dx < 8) dx = 8;
    var dy = anchorPos.dy + anchorBox.size.height + 8;
    if (dy + panelHeight > overlayBox.size.height - 8) {
      dy = (anchorPos.dy - panelHeight - 8)
          .clamp(8.0, overlayBox.size.height - panelHeight - 8);
    }

    final l10n = AppLocalizations.of(context);
    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => Stack(
        children: [
          // حاجز شفاف يغلق النافذة عند النقر خارجه (تحت اللوحة في z-order).
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _removeOverlay,
              child: const SizedBox.expand(),
            ),
          ),
          Positioned(
            left: dx,
            top: dy,
            width: panelWidth,
            child: _ChannelHeaderTextPanel(
              title: widget.title,
              text: widget.text,
              copyLabel: l10n.channel_headerCopyHeaderText,
              editLabel: l10n.channel_headerSetConversationHeader,
              onCopy: () {
                Clipboard.setData(ClipboardData(text: widget.text));
                _removeOverlay();
              },
              onEdit: widget.onEdit == null
                  ? null
                  : () {
                      _removeOverlay();
                      widget.onEdit!();
                    },
              onClose: _removeOverlay,
            ),
          ),
        ],
      ),
    );
    _entry = entry;
    overlay.insert(entry);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: _anchorKey,
      onTap: _toggle,
      child: widget.child,
    );
  }
}

/// لوحة الوصف: رأس باسم القناة + محتوى Markdown قابل للتمرير + أزرار.
class _ChannelHeaderTextPanel extends StatelessWidget {
  final String title;
  final String text;
  final String copyLabel;
  final String editLabel;
  final VoidCallback onCopy;
  final VoidCallback? onEdit;
  final VoidCallback onClose;

  const _ChannelHeaderTextPanel({
    required this.title,
    required this.text,
    required this.copyLabel,
    required this.editLabel,
    required this.onCopy,
    required this.onEdit,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.centerChannelBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.centerChannelColor.withValues(alpha: 0.15),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      constraints: const BoxConstraints(maxHeight: 360),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: theme.centerChannelColor.withValues(alpha: 0.04),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: theme.centerChannelColor,
                    ),
                  ),
                ),
                IconButton(
                  iconSize: 16,
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                  onPressed: onClose,
                  icon: Icon(
                    Icons.close,
                    size: 16,
                    color: theme.centerChannelColor.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: MarkdownMessage(text: text),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Wrap(
                spacing: 8,
                alignment: WrapAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: onCopy,
                    icon: const Icon(Icons.copy, size: 16),
                    label: Text(copyLabel),
                  ),
                  if (onEdit != null)
                    TextButton.icon(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit_outlined, size: 16),
                      label: Text(editLabel),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}