import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_bookmark_entity.dart';
import 'package:flutter_mattermost/features/channels/domain/repositories/channel_repository.dart';

/// نافذة إضافة/تعديل إشارة مرجعية في القناة — مطابقة
/// channel_bookmarks_modal في webapp: حقل العنوان + حقل الرابط،
/// وتعيد الإشارة المرجعية المنشأة/المعدّلة عبر pop عند الحفظ.
///
/// تُستخدم في ثلاث حالات:
/// - زر `+` في شريط الإشارات المرجعية (إضافة جديدة).
/// - قائمة سياق الشريحة (تعديل إشارة قائمة).
/// - قائمة خيارات المنشور → «إضافة كإشارة مرجعية» (بمعبّأ الرابط).
Future<ChannelBookmarkEntity?> showAddChannelBookmarkDialog(
  BuildContext context, {
  required String channelId,
  ChannelBookmarkEntity? existing,
  String? prefillLink,
  String? prefillTitle,
}) {
  return showDialog<ChannelBookmarkEntity>(
    context: context,
    builder: (dialogContext) => _AddChannelBookmarkDialog(
      channelId: channelId,
      existing: existing,
      prefillLink: prefillLink,
      prefillTitle: prefillTitle,
    ),
  );
}

class _AddChannelBookmarkDialog extends StatefulWidget {
  final String channelId;
  final ChannelBookmarkEntity? existing;
  final String? prefillLink;
  final String? prefillTitle;

  const _AddChannelBookmarkDialog({
    required this.channelId,
    this.existing,
    this.prefillLink,
    this.prefillTitle,
  });

  @override
  State<_AddChannelBookmarkDialog> createState() =>
      _AddChannelBookmarkDialogState();
}

class _AddChannelBookmarkDialogState extends State<_AddChannelBookmarkDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _linkController;
  bool _saving = false;

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _titleController = TextEditingController(
      text: existing?.displayName ?? widget.prefillTitle ?? '',
    );
    _linkController = TextEditingController(
      text: existing?.linkUrl ?? widget.prefillLink ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _linkController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);
    final l10n = AppLocalizations.of(context);
    final repository = getIt<ChannelRepository>();
    final title = _titleController.text.trim();
    final link = _linkController.text.trim();

    try {
      final saved = _isEdit
          ? await repository.updateChannelBookmark(
              widget.channelId,
              widget.existing!.id,
              label: title,
              linkUrl: link,
            )
          : await repository.createChannelBookmark(
              widget.channelId,
              label: title,
              linkUrl: link,
            );
      if (!mounted) return;
      Navigator.of(context).pop(saved);
    } catch (_) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.channel_bookmarksCreateErrorGeneric_save)),
      );
    }
  }

  String? _validateLink(String? value) {
    final link = value?.trim() ?? '';
    if (link.isEmpty) return null;
    final uri = Uri.tryParse(link);
    if (uri == null || (uri.scheme != 'http' && uri.scheme != 'https')) {
      return AppLocalizations.of(
        context,
      ).channel_bookmarksCreateErrorInvalid_url(link);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);

    return AlertDialog(
      title: Text(
        _isEdit
            ? l10n.channel_bookmarksCreateEditTitle
            : l10n.channel_bookmarksCreateTitle,
      ),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!_isEdit) ...[
                Text(
                  l10n.channel_bookmarksCreateLink_info,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: theme.centerChannelColor.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              TextFormField(
                controller: _titleController,
                autofocus: !_isEdit,
                decoration: InputDecoration(
                  labelText: l10n.channel_bookmarksCreateTitle_inputLabel,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _linkController,
                keyboardType: TextInputType.url,
                validator: _validateLink,
                decoration: InputDecoration(
                  labelText: l10n.channel_bookmarksCreateLink_placeholder,
                  hintText: 'https://example.com',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(),
          child: Text(AppLocalizations.of(context).postEditCancel),
        ),
        FilledButton(
          onPressed: _saving ? null : _save,
          child: _saving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(
                  _isEdit
                      ? l10n.channel_bookmarksCreateConfirm_saveButton
                      : l10n.channel_bookmarksCreateConfirm_addButton,
                ),
        ),
      ],
    );
  }
}
