import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';

/// اختصارات لوحة المفاتيح — مطابق KeyboardShortcutsModal في webapp.
class KeyboardShortcutsModal extends StatelessWidget {
  const KeyboardShortcutsModal({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);

    final shortcuts = <(String, String)>[
      (l10n.keyboardShortcutsJumpToChannel, 'Ctrl/Cmd + K'),
      (l10n.keyboardShortcutsSearch, 'Ctrl/Cmd + F'),
      ('Search files', 'Ctrl/Cmd + Shift + F'),
      (l10n.draftsHeading, 'Ctrl/Cmd + Shift + D'),
      ('Integrations', 'Ctrl/Cmd + Shift + I'),
      ('System Console', 'Ctrl/Cmd + Shift + A'),
      (l10n.keyboardShortcutsClose, 'Esc'),
    ];

    return Dialog(
      backgroundColor: theme.centerChannelBg,
      insetPadding: const EdgeInsets.symmetric(horizontal: 48, vertical: 64),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420, maxHeight: 480),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.keyboardShortcutsTitle,
                      style: TextStyle(
                        color: theme.centerChannelColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      size: 20,
                      color: theme.centerChannelColor.withValues(alpha: 0.7),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Flexible(
              child: ListView.separated(
                padding: const EdgeInsets.all(8),
                itemCount: shortcuts.length,
                separatorBuilder: (_, _) =>
                    const Divider(height: 1, indent: 16, endIndent: 16),
                itemBuilder: (context, index) {
                  final (label, keys) = shortcuts[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            label,
                            style: TextStyle(
                              color: theme.centerChannelColor,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        _keyBadge(theme, keys),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _keyBadge(MattermostColors theme, String keys) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: theme.centerChannelColor.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: theme.centerChannelColor.withValues(alpha: 0.14),
        ),
      ),
      child: Text(
        keys,
        style: TextStyle(
          color: theme.centerChannelColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
