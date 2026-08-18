import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';

/// رموز شائعة لانتقاء سريع (بديل عن emoji picker الكامل).
const List<String> kQuickEmojis = [
  '👍',
  '❤️',
  '😂',
  '🎉',
  '😮',
  '😢',
  '🙏',
  '👏',
  '🔥',
  '💯',
  '😄',
  '😆',
  '😅',
  '🤣',
  '😊',
  '😍',
  '🥰',
  '😘',
  '😎',
  '🤔',
  '🤗',
  '😭',
  '😡',
  '😱',
  '🤯',
  '🥳',
  '😇',
  '🤠',
  '🤝',
  '✌️',
  '🤞',
  '👌',
  '👍🏽',
  '👎',
  '👊',
  '💪',
  '🙌',
  '✨',
  '🎈',
  '🎁',
];

/// نافذة انتقاء رد فعل — ترجع emoji أو null عند الإلغاء.
Future<String?> showReactionPicker(BuildContext context) {
  final theme = AppTheme.of(context);
  final l10n = AppLocalizations.of(context);

  return showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        l10n.reactionPickerTitle,
        style: const TextStyle(fontSize: 16),
      ),
      contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      content: SizedBox(
        width: 360,
        child: Wrap(
          spacing: 4,
          runSpacing: 4,
          children: [
            for (final emoji in kQuickEmojis)
              InkWell(
                onTap: () => Navigator.of(context).pop(emoji),
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  width: 38,
                  height: 38,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(emoji, style: const TextStyle(fontSize: 20)),
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            l10n.postEditCancel,
            style: TextStyle(color: theme.centerChannelColor),
          ),
        ),
      ],
    ),
  );
}
