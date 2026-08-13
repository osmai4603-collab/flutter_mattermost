import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/features/chat/presentation/rhs/saved_pinned_panel.dart';

class SavedMessagesPage extends StatefulWidget {
  final String? teamName;

  const SavedMessagesPage({super.key, this.teamName});

  @override
  State<SavedMessagesPage> createState() => _SavedMessagesPageState();
}

class _SavedMessagesPageState extends State<SavedMessagesPage> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);

    return Column(
      children: [
        Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: theme.centerChannelBg,
            border: Border(
              bottom: BorderSide(
                color: theme.centerChannelColor.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.bookmark, // Shaded icon as per spec
                size: 20,
                color: theme.linkColor, // Colored as per spec
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Row(
                  children: [
                    Text(
                      l10n.sidebar_right_menuFlagged,
                      style: TextStyle(
                        color: theme.centerChannelColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (_count > 0) ...[
                      const SizedBox(width: 8),
                      Text(
                        '($_count)',
                        style: TextStyle(
                          color: theme.centerChannelColor.withValues(alpha: 0.5),
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SavedPinnedPanel(
            isPinned: false,
            onLoad: (count) {
              if (mounted && _count != count) {
                setState(() => _count = count);
              }
            },
          ),
        ),
      ],
    );
  }
}
