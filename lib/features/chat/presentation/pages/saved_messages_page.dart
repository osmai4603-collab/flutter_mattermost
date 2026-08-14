import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/design_tokens.dart';
import 'package:flutter_mattermost/features/chat/presentation/rhs/saved_pinned_panel.dart';

/// صفحة الرسائل المحفوظة — مطابقة flagged_posts في webapp مع
/// التبديل بين "الرسائل" و "الملفات" (messages_or_files_selector)
/// وشريط بحث داخلي.
class SavedMessagesPage extends StatefulWidget {
  final String? teamName;

  const SavedMessagesPage({super.key, this.teamName});

  @override
  State<SavedMessagesPage> createState() => _SavedMessagesPageState();
}

class _SavedMessagesPageState extends State<SavedMessagesPage> {
  int _count = 0;
  SavedContentFilter _filter = SavedContentFilter.messages;
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
        // التبديل بين الرسائل/الملفات + شريط البحث الداخلي.
        Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          decoration: BoxDecoration(
            color: theme.centerChannelBg,
            border: Border(
              bottom: BorderSide(
                color: theme.centerChannelColor.withValues(alpha: 0.08),
                width: 1,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  _FilterChip(
                    label: l10n.flaggedMessagesTabMessages,
                    selected: _filter == SavedContentFilter.messages,
                    onTap: () =>
                        setState(() => _filter = SavedContentFilter.messages),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: l10n.flaggedMessagesTabFiles,
                    selected: _filter == SavedContentFilter.files,
                    onTap: () =>
                        setState(() => _filter = SavedContentFilter.files),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _searchController,
                onChanged: (value) => setState(() => _query = value),
                style: TextStyle(
                  color: theme.centerChannelColor,
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  hintText: l10n.search_barSearch_messages,
                  hintStyle: TextStyle(
                    color: theme.centerChannelColor.withValues(alpha: 0.5),
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    size: 18,
                    color: theme.centerChannelColor.withValues(alpha: 0.6),
                  ),
                  suffixIcon: _query.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.close, size: 18),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _query = '');
                          },
                        ),
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SavedPinnedPanel(
            isPinned: false,
            contentFilter: _filter,
            searchQuery: _query,
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

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(DesignTokens.radiusPill),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
        decoration: BoxDecoration(
          color: selected
              ? theme.centerChannelColor.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(DesignTokens.radiusPill),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected
                ? theme.centerChannelColor
                : theme.centerChannelColor.withValues(alpha: 0.6),
            fontSize: 13,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
