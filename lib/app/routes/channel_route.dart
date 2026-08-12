import 'package:flutter_mattermost/features/channels/presentation/widgets/channel_shell.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_mattermost/features/chat/presentation/channel_screen.dart';
import 'package:flutter_mattermost/features/chat/presentation/pages/threads_page.dart';
import 'package:flutter_mattermost/features/integrations/presentation/pages/integrations_page.dart';

abstract class ChatRoutes {
  static const String home = '/home';
  static const String team = '/:team';
  static const String channel = '/:team/channels/:channel';
  static const String globalThreads = '/:team/threads';
  static const String globalThreadsThread = '/:team/threads/:threadId';
  static const String integrations = '/:team/integrations';
  static const String integrationsIncoming = '/:team/integrations/incoming';
  static const String integrationsOutgoing = '/:team/integrations/outgoing';
  static const String integrationsCommands = '/:team/integrations/commands';
  static const String integrationsBots = '/:team/integrations/bots';
  static const String integrationsOAuth = '/:team/integrations/oauth';
}

final channelRoute = StatefulShellRoute.indexedStack(
  builder: (context, state, navigationShell) {
    return ChannelShell(navigationShell: navigationShell);
  },
  branches: [
    StatefulShellBranch(routes: _routes),
  ],
);

final List<RouteBase> _routes = [
  GoRoute(
    path: ChatRoutes.home,
    builder: (context, state) => const ChannelPage(),
  ),
  GoRoute(
    path: ChatRoutes.channel,
    builder: (context, state) => ChannelPage(
      teamName: state.pathParameters['team'],
      channelName: state.pathParameters['channel'],
    ),
  ),
  GoRoute(
    path: ChatRoutes.globalThreads,
    builder: (context, state) =>
        ThreadsPage(teamName: state.pathParameters['team']),
  ),
  GoRoute(
    path: ChatRoutes.globalThreadsThread,
    builder: (context, state) => ThreadsPage(
      teamName: state.pathParameters['team'],
      threadId: state.pathParameters['threadId'],
    ),
  ),
  GoRoute(
    path: ChatRoutes.integrations,
    builder: (context, state) =>
        IntegrationsPage(teamId: state.pathParameters['team']),
  ),
  GoRoute(
    path: ChatRoutes.integrationsIncoming,
    builder: (context, state) => IntegrationsPage(
      teamId: state.pathParameters['team'],
      initialSection: IntegrationSection.incomingWebhooks,
    ),
  ),
  GoRoute(
    path: ChatRoutes.integrationsOutgoing,
    builder: (context, state) => IntegrationsPage(
      teamId: state.pathParameters['team'],
      initialSection: IntegrationSection.outgoingWebhooks,
    ),
  ),
  GoRoute(
    path: ChatRoutes.integrationsCommands,
    builder: (context, state) => IntegrationsPage(
      teamId: state.pathParameters['team'],
      initialSection: IntegrationSection.slashCommands,
    ),
  ),
  GoRoute(
    path: ChatRoutes.integrationsBots,
    builder: (context, state) => IntegrationsPage(
      teamId: state.pathParameters['team'],
      initialSection: IntegrationSection.bots,
    ),
  ),
  GoRoute(
    path: ChatRoutes.integrationsOAuth,
    builder: (context, state) => IntegrationsPage(
      teamId: state.pathParameters['team'],
      initialSection: IntegrationSection.oauthApps,
    ),
  ),
  GoRoute(
    path: ChatRoutes.team,
    builder: (context, state) =>
        ChannelPage(teamName: state.pathParameters['team']),
  ),
];
