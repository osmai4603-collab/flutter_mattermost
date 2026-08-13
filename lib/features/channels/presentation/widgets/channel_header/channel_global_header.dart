import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/modals/modal_identifiers.dart';
import 'package:flutter_mattermost/core/modals/modal_registry.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/design_tokens.dart';
import 'package:flutter_mattermost/features/channels/presentation/widgets/channel_header/channel_global_search_nav.dart';
import 'package:flutter_mattermost/features/channels/presentation/widgets/channel_header/product_menu_button.dart';
import 'package:flutter_mattermost/features/channels/presentation/widgets/channel_header/right_icon_button.dart';
import 'package:flutter_mattermost/features/channels/presentation/widgets/channel_header/user_account_menu_button.dart';
import 'package:flutter_mattermost/features/chat/presentation/bloc/rhs_bloc.dart';

/// الشريط العلوي العام — مطابق components/global_header في webapp:
/// ارتفاع 44px، خلفية --sidebar-teambar-bg، نص rgba(sidebar-text, 0.64).
class ChannelGlobalHeader extends StatelessWidget {
  const ChannelGlobalHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);

    return Container(
      height: DesignTokens.globalHeaderHeight,
      padding: const EdgeInsets.only(left: 8, right: 4),
      color: theme.sidebarTeamBarBg,
      child: Row(
        children: [
          ProductMenuButton(l10n: l10n),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: Align(child: ChannelGlobalSearchNav(l10n: l10n)),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 1,
            child: Row(
              spacing: 8,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                RightIconButton(
                  icon: Icons.alternate_email,
                  tooltip: l10n.sidebar_right_menuRecentMentions,
                  toggled: false,
                  onTap: () {
                    context.read<RhsBloc>().add(ShowMentionsEvent());
                  },
                ),
                RightIconButton(
                  icon: Icons.bookmark_border,
                  tooltip: 'Saved messages',
                  toggled: false,
                  onTap: () {
                    context.read<RhsBloc>().add(ShowFlaggedPostsEvent());
                  },
                ),
                RightIconButton(
                  icon: Icons.settings_outlined,
                  tooltip: l10n.global_headerProductSettings,
                  toggled: false,
                  onTap: () {
                    ModalRegistry.open(
                      context,
                      id: ModalIdentifiers.appSettings,
                    );
                  },
                ),
                const UserAccountMenuButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
