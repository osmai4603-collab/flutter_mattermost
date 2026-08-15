import 'package:flutter_mattermost/features/channels/presentation/widgets/channel_shell_layout.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_mattermost/features/channels/presentation/pages/channel_page.dart';
import 'package:flutter_mattermost/features/chat/presentation/pages/threads_page.dart';
import 'package:flutter_mattermost/features/chat/presentation/pages/saved_messages_page.dart';

abstract class ChatRoutes {
  static const String home = '/home';
  static const String team = '/:team';
  static const String channel = '/:team/channels/:channel';

  /// رسالة مباشرة: /:team/messages/@username — يطابق رابط
  /// sidebar_direct_channel.tsx في webapp.
  static const String directMessage = '/:team/messages/@:username';

  /// محادثة جماعية (GM): /:team/messages/:channel (اسم قناة GM هو معرف المجموعة).
  static const String groupMessage = '/:team/messages/:channel';

  static const String globalThreads = '/:team/threads';
  static const String globalThreadsThread = '/:team/threads/:threadId';
  static const String savedMessages = '/:team/saved';
}

final channelRoute = StatefulShellRoute.indexedStack(
  builder: (context, state, navigationShell) {
    return ChannelShellLayout(navigationShell: navigationShell);
  },
  branches: [StatefulShellBranch(routes: _routes)],
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
    path: ChatRoutes.directMessage,
    builder: (context, state) => ChannelPage(
      teamName: state.pathParameters['team'],
      dmUsername: state.pathParameters['username'],
    ),
  ),
  GoRoute(
    path: ChatRoutes.groupMessage,
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
    builder: (context, state) =>
        SavedMessagesPage(teamName: state.pathParameters['team']),
  ),
  GoRoute(
    path: ChatRoutes.team,
    builder: (context, state) =>
        ChannelPage(teamName: state.pathParameters['team']),
  ),
];
