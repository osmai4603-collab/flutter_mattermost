import 'package:flutter_mattermost/features/integrations/presentation/pages/bots_page.dart';
import 'package:flutter_mattermost/features/integrations/presentation/pages/incoming_webhooks_page.dart';
import 'package:flutter_mattermost/features/integrations/presentation/pages/integrations_page.dart';
import 'package:flutter_mattermost/features/integrations/presentation/pages/oauth_apps_page.dart';
import 'package:flutter_mattermost/features/integrations/presentation/pages/outgoing_webhooks_page.dart';
import 'package:flutter_mattermost/features/integrations/presentation/pages/slash_commands_page.dart';
import 'package:go_router/go_router.dart';

abstract class IntegrationRoutes {
  static const String root = '/:team/integrations';
  static const String incoming = '$root/incoming';
  static const String outgoing = '$root/outgoing';
  static const String commands = '$root/commands';
  static const String bots = '$root/bots';
  static const String oauth = '$root/oauth';

  static String teamIntegration(String teamName) {
    return '/$teamName/integrations';
  }
}

final integrationRoute = GoRoute(
  path: IntegrationRoutes.root,
  redirect: (context, state) {
    final team = state.pathParameters['team'];
    if (team != null && state.uri.path == '/$team/integrations') {
      return '/$team/integrations/incoming';
    }
    return null;
  },
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return IntegrationsPage(
          teamId: state.pathParameters['team'],
          navigationShell: navigationShell,
        );
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: 'incoming',
              builder: (context, state) => IncomingWebhooksPage(
                teamId: state.pathParameters['team'],
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: 'outgoing',
              builder: (context, state) => OutgoingWebhooksPage(
                teamId: state.pathParameters['team'],
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: 'commands',
              builder: (context, state) => SlashCommandsPage(
                teamId: state.pathParameters['team'] ?? '',
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: 'bots',
              builder: (context, state) => const BotsPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: 'oauth',
              builder: (context, state) => const OAuthAppsPage(),
            ),
          ],
        ),
      ],
    ),
  ],
);
