import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/app/routes/admin_console_route.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/permissions/enums/mattermost_permission.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/design_tokens.dart';
import 'package:flutter_mattermost/core/widgets/hover_widget.dart';
import 'package:flutter_mattermost/core/widgets/matter_menu.dart';
import 'package:flutter_mattermost/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_mattermost/features/teams/presentation/bloc/team_bloc.dart';
import 'package:go_router/go_router.dart';

/// زر منتج Channels (أيقونة + اسم المنتج) — منتجات webapp.
class ProductMenuButton extends StatelessWidget {
  final AppLocalizations l10n;
  const ProductMenuButton({super.key, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = theme.sidebarText.withValues(alpha: 0.64);
    final authBloc = context.read<AuthBloc>();
    if (authBloc.state is! AuthenticatedState) {
      return Container();
    }
    final currentUser = (authBloc.state as AuthenticatedState).user;
    return Tooltip(
      message: l10n.global_headerProductSwitchMenu,
      child: MatterMenuScope(
        borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
        hoverColor: theme.sidebarText.withValues(alpha: 0.08),
        items: [
          MatterMenuItem(
            id: 'channels',
            label: '',
            icon: HoverWidget(
              builder: (context, isHovered) {
                return Container(
                  padding: .symmetric(vertical: 12),
                  width: 220,
                  child: Row(
                    spacing: 10,
                    children: [
                      Icon(
                        Icons.chat_outlined,
                        size: 18,
                        color: theme.linkColor,
                      ),
                      Text(
                        'Channels',
                        style: TextStyle(
                          fontWeight: .bold,
                          color: isHovered ? theme.linkColor : null,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            onTap: () {
              final teamState = context.read<TeamBloc>().state;
              final teamName = teamState is TeamsLoadedState
                  ? teamState.selectedTeam?.name
                  : null;
              if (teamName != null) {
                context.go('/$teamName');
              } else {
                context.go('/');
              }
            },
          ),
          MatterMenuItem(
            id: 'agents',
            label: '',
            icon: HoverWidget(
              builder: (context, isHovered) {
                return Container(
                  padding: .symmetric(vertical: 12),
                  width: 220,
                  child: Row(
                    spacing: 10,
                    children: [
                      Icon(
                        Icons.support_agent,
                        size: 18,
                        color: theme.linkColor,
                      ),
                      Text(
                        'Agents',
                        style: TextStyle(
                          fontWeight: .bold,
                          color: isHovered ? theme.linkColor : null,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            onTap: () {
              final teamState = context.read<TeamBloc>().state;
              final teamName = teamState is TeamsLoadedState
                  ? teamState.selectedTeam?.name
                  : null;
              if (teamName != null) {
                context.go('/$teamName');
              } else {
                context.go('/');
              }
            },
          ),
          MatterMenuItem(
            id: 'playbooks',
            label: '',
            icon: HoverWidget(
              builder: (context, isHovered) {
                return Container(
                  padding: .symmetric(vertical: 12),
                  width: 220,
                  child: Row(
                    spacing: 10,
                    children: [
                      Icon(
                        Icons.book_outlined,
                        size: 18,
                        color: theme.linkColor,
                      ),
                      Text(
                        'Playbooks',
                        style: TextStyle(
                          fontWeight: .bold,
                          color: isHovered ? theme.linkColor : null,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            onTap: () {
              final teamState = context.read<TeamBloc>().state;
              final teamName = teamState is TeamsLoadedState
                  ? teamState.selectedTeam?.name
                  : null;
              if (teamName != null) {
                context.go('/$teamName');
              } else {
                context.go('/');
              }
            },
          ),
          MatterMenuItem.divider(),
          if (currentUser.hasPermission(MMPermission.manageSystem))
            MatterMenuItem(
              id: 'system_console',
              label: 'Admin Console',
              icon: const Icon(Icons.admin_panel_settings_outlined, size: 18),
              onTap: () => context.go(AdminConsoleRoutes.home),
            ),
          if (currentUser.hasPermission(MMPermission.manageWebhooks))
            MatterMenuItem(
              id: 'integrations',
              label: 'Integrations',
              icon: const Icon(
                Icons.integration_instructions_rounded,
                size: 18,
              ),
              onTap: () {
                final teamState = context.read<TeamBloc>().state;
                final teamName = teamState is TeamsLoadedState
                    ? teamState.selectedTeam?.name
                    : null;
                context.go(
                  teamName != null ? '/$teamName/integrations' : '/home',
                );
              },
            ),
          MatterMenuItem(
            id: 'user_groups',
            label: '',
            icon: SizedBox(
              width: 220,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Row(
                  spacing: 10,
                  children: [
                    const Icon(Icons.groups_outlined, size: 18),
                    Text('User Groups', style: TextStyle(fontSize: 15.50)),
                  ],
                ),
              ),
            ),
            onTap: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('App Marketplace')));
            },
          ),
          if (currentUser.hasPermission(
            MMPermission.manageElasticsearchPostAggregationJob,
          ))
            MatterMenuItem(
              id: 'app_marketplace',
              label: '',
              icon: SizedBox(
                width: 220,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    spacing: 10,
                    children: [
                      const Icon(Icons.app_blocking_outlined, size: 18),
                      Text(
                        'App Marketplace',
                        style: TextStyle(fontSize: 15.50),
                      ),
                    ],
                  ),
                ),
              ),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('App Marketplace')),
                );
              },
            ),
          MatterMenuItem(
            id: 'download_apps',
            label: '',
            icon: SizedBox(
              width: 220,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  spacing: 10,
                  children: [
                    const Icon(Icons.download_outlined, size: 18),
                    Text('Download Apps', style: TextStyle(fontSize: 15.50)),
                  ],
                ),
              ),
            ),
            onTap: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Download Apps')));
            },
          ),
          MatterMenuItem(
            id: 'about_mattermost',
            label: '',
            icon: SizedBox(
              width: 220,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  spacing: 10,
                  children: [
                    const Icon(Icons.info_outline, size: 18),
                    Text('About Mattermost', style: TextStyle(fontSize: 15.50)),
                  ],
                ),
              ),
            ),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Mattermost Desktop',
                applicationVersion: '1.0.0',
                applicationLegalese: '© Mattermost, Inc.',
              );
            },
          ),
          MatterMenuItem.divider(),
          MatterMenuItem.richText(
            id: 'info',
            richText: TextSpan(
              text: 'This is the free unsupported ',
              style: TextStyle(color: theme.sidebarBg),
              children: [
                TextSpan(
                  text: 'unsupported',
                  style: TextStyle(color: theme.buttonBg),
                ),
                TextSpan(text: ' edition of Mattermost.'),
              ],
            ),
          ),
        ],
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5, 3, 6, 3),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.dashboard_customize_rounded,
                size: 20,
                color: textColor,
              ),
              const SizedBox(width: 8),
              Image.asset(
                'assets/images/logo.png',
                height: 20,
                colorBlendMode: BlendMode.srcIn,
                // colorBlendMode: BlendMode.saturation,
                color: isDark
                    ? theme.centerChannelColor
                    : theme.centerChannelBg,
              ),

              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  color: isDark
                      ? theme.mentionColor.withValues(alpha: 0.20)
                      : theme.mentionColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Team Edition'.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: isDark
                        ? theme.mentionColor
                        : theme.mentionBg.withValues(alpha: 0.60),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
