import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/design_tokens.dart';
import 'package:flutter_mattermost/features/channels/presentation/widgets/quick_switcher.dart';
import 'package:flutter_mattermost/features/chat/presentation/bloc/lhs_bloc.dart';

/// شريط التنقل — مطابق channel_navigator.tsx في webapp:
/// زر "Find channel… Ctrl+K" + فلتر غير المقروء (28×28).
class ChannelNavigator extends StatelessWidget {
  const ChannelNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);

    return BlocBuilder<LhsBloc, LhsState>(
      builder: (context, lhsState) {
        final unreadsOnly = lhsState is LhsSearchState && lhsState.unreadsOnly;
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 11),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  context.read<LhsBloc>().add(ToggleUnreadsOnlyEvent());
                },
                borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: unreadsOnly
                        ? theme.sidebarText.withValues(alpha: 0.16)
                        : theme.sidebarText.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
                  ),
                  child: Tooltip(
                    message: unreadsOnly
                        ? l10n.sidebarLeftShowAllChannels
                        : l10n.sidebarLeftFilterByUnread,
                    child: Icon(
                      Icons.sort_rounded,
                      size: 14,
                      color: unreadsOnly
                          ? theme.sidebarTextActiveColor
                          : theme.sidebarText.withValues(alpha: 0.6),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: InkWell(
                  onTap: () => showQuickSwitcher(context),
                  borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
                  child: Container(
                    height: 28,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: theme.sidebarText.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(
                        DesignTokens.radiusSm,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search,
                          size: 14,
                          color: theme.sidebarText.withValues(alpha: 0.6),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            l10n.sidebarLeftJumpTo,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.sidebarText.withValues(alpha: 0.6),
                            ),
                          ),
                        ),
                        Text(
                          'Ctrl+K',
                          style: TextStyle(
                            fontSize: 11,
                            color: theme.sidebarText.withValues(alpha: 0.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
