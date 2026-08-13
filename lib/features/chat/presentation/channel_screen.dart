import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/features/channels/presentation/bloc/channel_bloc.dart';
import 'package:flutter_mattermost/features/chat/presentation/editor/message_editor.dart';
import 'package:flutter_mattermost/features/chat/presentation/widgets/call_widget.dart';
import 'package:flutter_mattermost/features/chat/presentation/widgets/channel_header.dart';
import 'package:flutter_mattermost/features/chat/presentation/widgets/incoming_call_banner.dart';
import 'package:flutter_mattermost/features/chat/presentation/widgets/message_list.dart';
import 'package:flutter_mattermost/features/teams/presentation/bloc/team_bloc.dart';

/// صفحة القناة: رأس + قائمة رسائل + محرر.
/// [teamName] هو اسم الفريق (slug) من المسار، و[channelName] اسم القناة الاختياري.
class ChannelPage extends StatefulWidget {
  final String? teamName;
  final String? channelName;

  const ChannelPage({super.key, this.teamName, this.channelName});

  @override
  State<ChannelPage> createState() => _ChannelPageState();
}

class _ChannelPageState extends State<ChannelPage> {
  StreamSubscription? _teamSub;
  StreamSubscription? _channelSub;
  String? _loadedTeamId;
  final ScrollController _listScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _teamSub = context.read<TeamBloc>().stream.listen((_) => _syncWithRoute());
    _channelSub = context.read<ChannelBloc>().stream.listen(
      (_) => _syncWithRoute(),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncWithRoute());
  }

  @override
  void dispose() {
    _teamSub?.cancel();
    _channelSub?.cancel();
    _listScrollController.dispose();
    super.dispose();
  }

  void _syncWithRoute() {
    final teamState = context.read<TeamBloc>().state;
    if (teamState is! TeamsLoadedState) {
      context.read<TeamBloc>().add(LoadMyTeamsEvent());
      return;
    }

    var team = widget.teamName == null
        ? teamState.selectedTeam
        : teamState.teams.where((t) => t.name == widget.teamName).firstOrNull;
    team ??= teamState.selectedTeam;
    if (team == null || teamState.teams.isEmpty) return;

    if (_loadedTeamId != team.id) {
      _loadedTeamId = team.id;
      context.read<ChannelBloc>().add(LoadChannelsForTeamEvent(team.id));
    }

    final channelState = context.read<ChannelBloc>().state;
    if (channelState is ChannelsLoadedState && widget.channelName != null) {
      final channel = channelState.channels
          .where((c) => c.name == widget.channelName)
          .firstOrNull;
      if (channel != null && channel.id != channelState.selectedChannel?.id) {
        context.read<ChannelBloc>().add(SelectChannelEvent(channel));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final channelState = context.watch<ChannelBloc>().state;
    final isArchived = channelState is ChannelsLoadedState &&
        (channelState.selectedChannel?.deleteAt ?? 0) > 0;

    return Column(
      children: [
        const ChannelHeader(),
        const IncomingCallBanner(),
        const CallWidget(),
        Expanded(child: PostList(scrollController: _listScrollController)),
        if (isArchived)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            color: theme.centerChannelColor.withValues(alpha: 0.04),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.archive_outlined,
                  size: 20,
                  color: theme.centerChannelColor.withValues(alpha: 0.5),
                ),
                const SizedBox(width: 12),
                Text(
                  'You are viewing an archived channel. New messages cannot be posted.',
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.centerChannelColor.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          )
        else
          MessageEditor(scrollController: _listScrollController),
      ],
    );
  }
}
