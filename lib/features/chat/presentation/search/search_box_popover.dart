import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/design_tokens.dart';
import 'package:flutter_mattermost/features/chat/presentation/bloc/rhs_bloc.dart';
import 'package:flutter_mattermost/features/chat/presentation/bloc/search_bloc.dart';
import 'package:flutter_mattermost/features/teams/presentation/bloc/team_bloc.dart';

/// فتح نافذة البحث العائمة — مطابقة NewSearch في webapp:
/// popover بعرض 600px يظهر أسفل الـ global header مع
/// محدد النوع (الكل/الرسائل/الملفات) + حقل بحث + تلميحات.
Future<void> showSearchBox(
  BuildContext context, {
  SearchResultType initialType = SearchResultType.messages,
}) {
  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'search_box',
    barrierColor: Colors.transparent,
    pageBuilder: (ctx, _, _) => SearchBoxPopover(initialType: initialType),
    transitionBuilder: (ctx, anim, _, child) => FadeTransition(
      opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
      child: child,
    ),
    transitionDuration: const Duration(milliseconds: 120),
  );
}

/// شريحة تلميحات البحث (webapp search_hint_options).
class _SearchHintChip {
  final String key;
  final String label;
  const _SearchHintChip(this.key, this.label);
}

class SearchBoxPopover extends StatefulWidget {
  final SearchResultType initialType;
  const SearchBoxPopover({
    super.key,
    this.initialType = SearchResultType.messages,
  });

  @override
  State<SearchBoxPopover> createState() => _SearchBoxPopoverState();
}

class _SearchBoxPopoverState extends State<SearchBoxPopover> {
  final TextEditingController _controller = TextEditingController();
  late SearchResultType _type = widget.initialType;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);

    final hints = _type == SearchResultType.files
        ? [
            _SearchHintChip('from:', l10n.searchHintFrom),
            _SearchHintChip('in:', l10n.searchHintIn),
            _SearchHintChip('extension:', l10n.searchHintExtension),
          ]
        : [
            _SearchHintChip('from:', l10n.searchHintFrom),
            _SearchHintChip('in:', l10n.searchHintIn),
            _SearchHintChip('on:', l10n.searchHintOn),
            _SearchHintChip('before:', l10n.searchHintBefore),
            _SearchHintChip('after:', l10n.searchHintAfter),
          ];

    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 52),
        child: Material(
          color: theme.centerChannelBg,
          elevation: 12,
          borderRadius: BorderRadius.circular(DesignTokens.radiusL),
          clipBehavior: Clip.antiAlias,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: 600,
              maxWidth: 700,
              maxHeight: 480,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 8, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: _SearchTypeSelector(
                          type: _type,
                          onChanged: (t) => setState(() => _type = t),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          size: 20,
                          color: theme.centerChannelColor.withValues(
                            alpha: 0.7,
                          ),
                        ),
                        tooltip: l10n.generic_modalCancel,
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(58, 12, 20, 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          autofocus: true,
                          onSubmitted: (value) => _submit(value),
                          style: TextStyle(
                            color: theme.centerChannelColor,
                            fontSize: 18,
                          ),
                          decoration: InputDecoration(
                            hintText: l10n.search_barSearch,
                            hintStyle: TextStyle(
                              color: theme.centerChannelColor.withValues(
                                alpha: 0.5,
                              ),
                              fontSize: 18,
                            ),
                            isDense: true,
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      if (_controller.text.isNotEmpty)
                        IconButton(
                          icon: Icon(
                            Icons.cancel,
                            size: 18,
                            color: theme.centerChannelColor.withValues(
                              alpha: 0.5,
                            ),
                          ),
                          onPressed: () => setState(_controller.clear),
                        ),
                    ],
                  ),
                ),
                Divider(
                  height: 1,
                  color: theme.centerChannelColor.withValues(alpha: 0.1),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.searchHintsTitle,
                        style: TextStyle(
                          color: theme.centerChannelColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final chip in hints)
                            _HintChip(
                              label: chip.key,
                              tooltip: chip.label,
                              onTap: () {
                                setState(() {
                                  final current = _controller.text;
                                  _controller.text = current.isEmpty
                                      ? chip.key
                                      : '$current ${chip.key}';
                                  _controller.selection =
                                      TextSelection.fromPosition(
                                        TextPosition(
                                          offset: _controller.text.length,
                                        ),
                                      );
                                });
                              },
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submit(String terms) {
    final trimmed = terms.trim();
    if (trimmed.isEmpty) {
      Navigator.of(context).pop();
      return;
    }
    final teamState = context.read<TeamBloc>().state;
    final teamId = teamState is TeamsLoadedState
        ? teamState.selectedTeam?.id ?? ''
        : '';
    context.read<SearchBloc>().add(
      PerformSearchEvent(terms: trimmed, teamId: teamId, type: _type),
    );
    context.read<RhsBloc>().add(ShowSearchResultsEvent(trimmed));
    Navigator.of(context).pop();
  }
}

/// محدد النوع — مطابق search_box_type_selector (segmented control).
class _SearchTypeSelector extends StatelessWidget {
  final SearchResultType type;
  final ValueChanged<SearchResultType> onChanged;

  const _SearchTypeSelector({required this.type, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);

    final options = <(SearchResultType, String)>[
      (SearchResultType.messages, l10n.searchTypeAll),
      (SearchResultType.messages, l10n.searchTypeMessages),
      (SearchResultType.files, l10n.searchTypeFiles),
    ];

    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.centerChannelColor.withValues(alpha: 0.16),
        ),
        borderRadius: BorderRadius.circular(DesignTokens.radiusM),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final (optionType, label) in options)
            InkWell(
              onTap: () => onChanged(optionType),
              borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: optionType == type
                      ? theme.buttonBg.withValues(alpha: 0.08)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: optionType == type
                        ? theme.buttonBg
                        : theme.centerChannelColor.withValues(alpha: 0.75),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// شريحة تلميح قابلة للنقر — مطابقة search_hint chip:
/// padding 4px 10px، radius 12، خط 10px w600.
class _HintChip extends StatelessWidget {
  final String label;
  final String tooltip;
  final VoidCallback onTap;

  const _HintChip({
    required this.label,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(DesignTokens.radiusL),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: theme.centerChannelColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(DesignTokens.radiusL),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: theme.centerChannelColor.withValues(alpha: 0.75),
            ),
          ),
        ),
      ),
    );
  }
}
