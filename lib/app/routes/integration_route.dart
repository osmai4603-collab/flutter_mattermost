import 'package:flutter/material.dart';
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
}

final integrationRoute = StatefulShellRoute.indexedStack(
  builder: (context, state, navigationShell) {
    // تحديد القسم الحالي بناءً على المسار
    final section = _getSectionFromPath(state.matchedLocation);
    return IntegrationsPage(
      teamId: state.pathParameters['team'],
      currentSection: section,
      child: navigationShell,
    );
  },
  branches: [
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: IntegrationRoutes.root,
          builder: (context, state) => IncomingWebhooksPage(
            teamId: state.pathParameters['team'],
          ),
        ),
      ],
    ),
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: IntegrationRoutes.incoming,
          builder: (context, state) => IncomingWebhooksPage(
            teamId: state.pathParameters['team'],
          ),
        ),
      ],
    ),
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: IntegrationRoutes.outgoing,
          builder: (context, state) => OutgoingWebhooksPage(
            teamId: state.pathParameters['team'],
          ),
        ),
      ],
    ),
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: IntegrationRoutes.commands,
          builder: (context, state) => SlashCommandsPage(
            teamId: state.pathParameters['team'] ?? '',
          ),
        ),
      ],
    ),
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: IntegrationRoutes.bots,
          builder: (context, state) => const BotsPage(),
        ),
      ],
    ),
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: IntegrationRoutes.oauth,
          builder: (context, state) => const OAuthAppsPage(),
        ),
      ],
    ),
  ],
);

IntegrationSection _getSectionFromPath(String path) {
  if (path.contains('/incoming')) return IntegrationSection.incomingWebhooks;
  if (path.contains('/outgoing')) return IntegrationSection.outgoingWebhooks;
  if (path.contains('/commands')) return IntegrationSection.slashCommands;
  if (path.contains('/bots')) return IntegrationSection.bots;
  if (path.contains('/oauth')) return IntegrationSection.oauthApps;
  return IntegrationSection.incomingWebhooks;
}
