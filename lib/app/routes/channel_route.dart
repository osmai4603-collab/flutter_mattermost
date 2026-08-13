import 'package:flutter_mattermost/features/channels/presentation/widgets/channel_shell.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_mattermost/features/chat/presentation/channel_screen.dart';
import 'package:flutter_mattermost/features/chat/presentation/pages/threads_page.dart';
import 'package:flutter_mattermost/features/chat/presentation/pages/saved_messages_page.dart';

abstract class ChatRoutes {
  static const String home = '/home';
  static const String team = '/:team';
  static const String channel = '/:team/channels/:channel';
  static const String globalThreads = '/:team/threads';
  static const String globalThreadsThread = '/:team/threads/:threadId';
  static const String savedMessages = '/:team/saved';
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
    path: ChatRoutes.savedMessages,
    builder: (context, state) => SavedMessagesPage(
      teamName: state.pathParameters['team'],
    ),
  ),
  GoRoute(
    path: ChatRoutes.team,
    builder: (context, state) =>
        ChannelPage(teamName: state.pathParameters['team']),
  ),
];
