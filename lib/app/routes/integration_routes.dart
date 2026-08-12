import 'package:go_router/go_router.dart';
import 'package:flutter_mattermost/features/integrations/presentation/pages/integrations_page.dart';

abstract class IntegrationRoutes {
  static const String root = '/:team/integrations';
  static const String incoming = '$root/incoming';
  static const String outgoing = '$root/outgoing';
  static const String commands = '$root/commands';
  static const String bots = '$root/bots';
  static const String oauth = '$root/oauth';
}

final List<RouteBase> integrationRoutes = [
  GoRoute(
    path: IntegrationRoutes.root,
    builder: (context, state) => IntegrationsPage(
      teamId: state.pathParameters['team'],
    ),
  ),
  GoRoute(
    path: IntegrationRoutes.incoming,
    builder: (context, state) => IntegrationsPage(
      teamId: state.pathParameters['team'],
      initialSection: IntegrationSection.incomingWebhooks,
    ),
  ),
  GoRoute(
    path: IntegrationRoutes.outgoing,
    builder: (context, state) => IntegrationsPage(
      teamId: state.pathParameters['team'],
      initialSection: IntegrationSection.outgoingWebhooks,
    ),
  ),
  GoRoute(
    path: IntegrationRoutes.commands,
    builder: (context, state) => IntegrationsPage(
      teamId: state.pathParameters['team'],
      initialSection: IntegrationSection.slashCommands,
    ),
  ),
  GoRoute(
    path: IntegrationRoutes.bots,
    builder: (context, state) => IntegrationsPage(
      teamId: state.pathParameters['team'],
      initialSection: IntegrationSection.bots,
    ),
  ),
  GoRoute(
    path: IntegrationRoutes.oauth,
    builder: (context, state) => IntegrationsPage(
      teamId: state.pathParameters['team'],
      initialSection: IntegrationSection.oauthApps,
    ),
  ),
];
