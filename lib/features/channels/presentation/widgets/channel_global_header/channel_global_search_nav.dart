import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/modals/modal_identifiers.dart';
import 'package:flutter_mattermost/core/modals/modal_registry.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/design_tokens.dart';
import 'package:flutter_mattermost/features/channels/presentation/widgets/channel_global_header/user_guide_dropdown.dart';
import 'package:flutter_mattermost/features/channels/presentation/widgets/quick_switcher.dart';

/// مربع البحث في منتصف الـ header (webapp NewSearch -> Quick Switch).
class ChannelGlobalSearchNav extends StatelessWidget {
  final AppLocalizations l10n;
  const ChannelGlobalSearchNav({super.key, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    const maxWidth = 432.0;
    return Align(
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: maxWidth),
        child: Row(
          spacing: 8,
          children: [
            Expanded(
              child: InkWell(
                onTap: () => showQuickSwitcher(context),
                borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
                child: Container(
                  height: 28,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: theme.sidebarText.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search,
                        size: 16,
                        color: theme.sidebarText.withValues(alpha: 0.64),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          l10n.search_barSearch,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.sidebarText.withValues(alpha: 0.64),
                          ),
                        ),
                      ),
                      Tooltip(
                        message: 'Keyboard shortcuts',
                        child: InkWell(
                          onTap: () => ModalRegistry.open(
                            context,
                            id: ModalIdentifiers.keyboardShortcuts,
                          ),
                          borderRadius: BorderRadius.circular(
                            DesignTokens.radiusSm,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Icon(
                              Icons.keyboard_alt_outlined,
                              size: 14,
                              color: theme.sidebarText.withValues(alpha: 0.64),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            UserGuideDropdown(l10n: l10n),
          ],
        ),
      ),
    );
  }
}
