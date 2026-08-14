import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/design_tokens.dart';
import 'package:intl/intl.dart';

/// نافذة إعادة جدولة رسالة (Reschedule Post Modal) — مطابقة
/// scheduled_post_custom_time في webapp: اختيار تاريخ ووقت مستقبلي
/// لإعادة إرسال الرسالة المجدولة لاحقاً.
Future<int?> showReschedulePostModal(
  BuildContext context, {
  required int currentScheduledAt,
}) {
  return showDialog<int>(
    context: context,
    builder: (dialogContext) => _ReschedulePostModal(
      currentScheduledAt: currentScheduledAt,
    ),
  );
}

class _ReschedulePostModal extends StatefulWidget {
  final int currentScheduledAt;

  const _ReschedulePostModal({required this.currentScheduledAt});

  @override
  State<_ReschedulePostModal> createState() => _ReschedulePostModalState();
}

class _ReschedulePostModalState extends State<_ReschedulePostModal> {
  late DateTime _date;
  late TimeOfDay _time;

  @override
  void initState() {
    super.initState();
    final current = DateTime.fromMillisecondsSinceEpoch(
      widget.currentScheduledAt,
    );
    _date = DateTime(current.year, current.month, current.day);
    _time = TimeOfDay.fromDateTime(current);
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (picked != null) setState(() => _time = picked);
  }

  void _confirm() {
    final scheduled = DateTime(
      _date.year,
      _date.month,
      _date.day,
      _time.hour,
      _time.minute,
    );
    // يمنع الجدولة في الماضي — webapp يتحقق من المستقبل.
    if (scheduled.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please choose a future time')),
      );
      return;
    }
    Navigator.of(context).pop(scheduled.millisecondsSinceEpoch);
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);

    return Dialog(
      backgroundColor: theme.centerChannelBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.dialogRadius),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: theme.centerChannelColor.withValues(alpha: 0.1),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.scheduled_postActionReschedule,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: theme.centerChannelColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Icon(
                        Icons.close,
                        size: 20,
                        color: theme.centerChannelColor.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      Icons.calendar_today_outlined,
                      size: 20,
                      color: theme.centerChannelColor.withValues(alpha: 0.7),
                    ),
                    title: Text(
                      DateFormat.yMMMd().format(_date),
                      style: TextStyle(
                        color: theme.centerChannelColor,
                        fontSize: 14,
                      ),
                    ),
                    trailing: TextButton(
                      onPressed: _pickDate,
                      child: Text(l10n.generic_modalConfirm),
                    ),
                    onTap: _pickDate,
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      Icons.access_time,
                      size: 20,
                      color: theme.centerChannelColor.withValues(alpha: 0.7),
                    ),
                    title: Text(
                      _time.format(context),
                      style: TextStyle(
                        color: theme.centerChannelColor,
                        fontSize: 14,
                      ),
                    ),
                    trailing: TextButton(
                      onPressed: _pickTime,
                      child: Text(l10n.generic_modalConfirm),
                    ),
                    onTap: _pickTime,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(l10n.scheduledPostsCancel),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: theme.buttonBg,
                      foregroundColor: theme.buttonColor,
                    ),
                    onPressed: _confirm,
                    child: Text(l10n.scheduledPostsSave),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}