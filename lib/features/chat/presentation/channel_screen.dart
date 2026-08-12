import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/features/channels/presentation/bloc/channel_bloc.dart';
import 'package:flutter_mattermost/features/chat/presentation/editor/message_editor.dart';
import 'package:flutter_mattermost/features/chat/presentation/widgets/channel_header.dart';
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
    return const Column(
      children: [
        ChannelHeader(),
        Expanded(child: PostList()),
        MessageEditor(),
      ],
    );
  }
}
