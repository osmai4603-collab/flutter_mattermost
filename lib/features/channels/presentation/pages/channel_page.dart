import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/enums/channel_type.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_entity.dart';
import 'package:flutter_mattermost/features/channels/domain/repositories/channel_repository.dart';
import 'package:flutter_mattermost/features/channels/presentation/bloc/channel_bloc.dart';
import 'package:flutter_mattermost/features/channels/presentation/bloc/channel_history_cubit.dart';
import 'package:flutter_mattermost/features/chat/presentation/editor/message_editor.dart';
import 'package:flutter_mattermost/features/chat/presentation/widgets/channel_bookmarks.dart';
import 'package:flutter_mattermost/features/chat/presentation/widgets/channel_header.dart';
import 'package:flutter_mattermost/features/chat/presentation/widgets/message_list.dart';
import 'package:flutter_mattermost/features/channels/presentation/widgets/no_channel_selected_view.dart';
import 'package:flutter_mattermost/features/teams/presentation/bloc/team_bloc.dart';
import 'package:flutter_mattermost/features/users/domain/repositories/user_repository.dart';

/// صفحة القناة: رأس + قائمة رسائل + محرر.
/// [teamName] هو اسم الفريق (slug) من المسار، و[channelName] اسم القناة الاختياري
/// (قناة عادية/خاصة أو GM)، و[dmUsername] اسم مستخدم الطرف المقابل في مسار
/// الرسائل المباشرة /:team/messages/@username.
class ChannelPage extends StatefulWidget {
  final String? teamName;
  final String? channelName;
  final String? dmUsername;

  const ChannelPage({
    super.key,
    this.teamName,
    this.channelName,
    this.dmUsername,
  });

  @override
  State<ChannelPage> createState() => _ChannelPageState();
}

class _ChannelPageState extends State<ChannelPage> {
  StreamSubscription? _channelSub;
  String? _loadedTeamId;

  /// يمنع إعادة حل نفس الـ username مراراً عند كل تغيير حالة.
  String? _resolvedDmUsername;
  final ScrollController _listScrollController = ScrollController();

  /// معرف القناة الذي أُنجز فحص قيود DM له — يمنع تكرار الفحص عند كل إعادة بناء.
  String _dmCheckedChannelId = '';

  /// محادثة مباشرة بلا فرق مشتركة (مطابق restrictDirectMessage في webapp).
  bool _isRestrictedDm = false;

  /// محادثة مباشرة مع مستخدم معطَّل (مطابق deactivatedChannel في webapp).
  bool _dmUserDeactivated = false;

  @override
  void initState() {
    super.initState();

    // فقط عند انتقال الحالة من غير محمّلة إلى محمّلة
    ChannelState? _prevChannelState;
    _channelSub = context.read<ChannelBloc>().stream.listen((newState) {
      final wasNotLoaded = _prevChannelState is! ChannelsLoadedState;
      _prevChannelState = newState;
      if (wasNotLoaded && newState is ChannelsLoadedState) {
        _syncWithRoute();
      }
    });
    _prevChannelState = context.read<ChannelBloc>().state;

    WidgetsBinding.instance.addPostFrameCallback((_) => _syncWithRoute());
  }

  @override
  void didUpdateWidget(covariant ChannelPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.channelName != widget.channelName ||
        oldWidget.dmUsername != widget.dmUsername ||
        oldWidget.teamName != widget.teamName) {
      _resolvedDmUsername = null;
      _dmCheckedChannelId = '';
      _syncWithRoute();
    }
  }

  @override
  void dispose() {
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

    if (team.id != teamState.selectedTeam?.id &&
        widget.teamName != null) {
      context.read<TeamBloc>().add(SelectTeamEvent(team));
    }

    final channelState = context.read<ChannelBloc>().state;
    if (channelState is ChannelsLoadedState) {
      final username = widget.dmUsername;
      if (username != null && _resolvedDmUsername != username) {
        _resolvedDmUsername = username;
        _resolveDmChannel(channelState, username);
        return;
      }
      if (widget.channelName != null) {
        final channel = channelState.channels
            .where((c) => c.name == widget.channelName)
            .firstOrNull;
        if (channel != null && channel.id != channelState.selectedChannel?.id) {
          context.read<ChannelBloc>().add(SelectChannelEvent(channel));
        }
      }
    }
  }

  /// يحل مسار الرسائل المباشرة /:team/messages/@username إلى قناة DM:
  /// البحث عن المستخدم بالاسم ثم العثور على قناته أو إنشاؤها (مطابق
  /// openDirectChannelToUserId في webapp).
  Future<void> _resolveDmChannel(
    ChannelsLoadedState channelState,
    String username,
  ) async {
    final channelBloc = context.read<ChannelBloc>();
    try {
      final user = await getIt<UserRepository>().getUserByUsername(username);
      final myId = channelState.userId;
      if (myId.isEmpty) return;
      final targetId = user.id;

      var channel = channelState.channels
          .where((c) => c.type == ChannelType.direct)
          .where(
            (c) =>
                c.name == '${myId}__$targetId' ||
                c.name == '${targetId}__$myId',
          )
          .firstOrNull;

      if (channel == null) {
        channel = await getIt<ChannelRepository>().createDirectChannel([
          targetId,
        ]);
        channelBloc.add(UpsertChannelEvent(channel));
      }
      _dmUserDeactivated = user.deleteAt > 0;
      if (channel.id != channelState.selectedChannel?.id) {
        if (!mounted) return;
        channelBloc.add(SelectChannelEvent(channel));
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تعذَّر فتح المحادثة مع @$username')),
      );
      final teamState = context.read<TeamBloc>().state;
      if (teamState is TeamsLoadedState && teamState.selectedTeam != null) {
        context.go('/${teamState.selectedTeam!.name}');
      }
    }
  }

  /// فحص قيود الرسائل المباشرة بمجرد فتح قناة D/G — مطابق
  /// fetchIsRestrictedDM + isDeactivatedDirectChannel في webapp:
  /// - Restricted DM: لا توجد فرق مشتركة بين الطرفين.
  /// - Deactivated: الطرف الآخر في المحادثة مستخدم معطَّل.
  Future<void> _checkDmRestrictions(ChannelEntity channel) async {
    if (_dmCheckedChannelId == channel.id) return;
    final channelBloc = context.read<ChannelBloc>();
    final isDm =
        channel.type == ChannelType.direct || channel.type == ChannelType.group;
    if (!isDm) {
      _dmCheckedChannelId = channel.id;
      if (_isRestrictedDm || _dmUserDeactivated) {
        setState(() {
          _isRestrictedDm = false;
          _dmUserDeactivated = false;
        });
      }
      return;
    }
    _dmCheckedChannelId = channel.id;

    var restricted = false;
    var deactivated = _dmUserDeactivated;
    try {
      final commonTeams = await getIt<ChannelRepository>()
          .getGroupMessageMembersCommonTeams(channel.id);
      restricted = commonTeams.isEmpty;
    } catch (_) {
      restricted = false;
    }

    if (channel.type == ChannelType.direct && !deactivated) {
      try {
        final channelState = channelBloc.state;
        final myId = channelState is ChannelsLoadedState
            ? channelState.userId
            : '';
        final members = await getIt<ChannelRepository>().getChannelMembers(
          channel.id,
          perPage: 60,
        );
        final others = members.where((m) => m.userId != myId).toList();
        if (others.isNotEmpty) {
          final user = await getIt<UserRepository>().getUserById(
            others.first.userId,
          );
          deactivated = user.deleteAt > 0;
        }
      } catch (_) {}
    }

    if (!mounted) return;
    setState(() {
      _isRestrictedDm = restricted;
      _dmUserDeactivated = deactivated;
    });
  }

  /// إغلاق القناة المخالفة (مطابق goToLastViewedChannel في webapp):
  /// العودة لأحدث قناة في سجل التصفح، أو للفريق إن لم يوجد سجل.
  void _closeChannel() {
    final history = context.read<ChannelHistoryCubit>();
    if (history.state.canGoBack) {
      history.goBack();
      return;
    }
    final teamState = context.read<TeamBloc>().state;
    if (teamState is TeamsLoadedState && teamState.selectedTeam != null) {
      context.go('/${teamState.selectedTeam!.name}');
    } else if (widget.teamName != null) {
      context.go('/${widget.teamName}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final channelState = context.watch<ChannelBloc>().state;
    final channel = channelState is ChannelsLoadedState
        ? channelState.selectedChannel
        : null;
    final isArchived = (channel?.deleteAt ?? 0) > 0;

    if (channel == null) {
      return const NoChannelSelectedView();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _checkDmRestrictions(channel);
    });

    final showsArchivedBar =
        isArchived || _dmUserDeactivated || _isRestrictedDm;

    return Column(
      children: [
        const ChannelHeader(),
        const ChannelBookmarks(),
        Expanded(child: PostList(scrollController: _listScrollController)),
        if (showsArchivedBar)
          _ArchivedBar(
            message: _archivedMessage(
              isArchived: isArchived,
              deactivated: _dmUserDeactivated,
              restricted: _isRestrictedDm,
            ),
            closeLabel: _isRestrictedDm
                ? AppLocalizations.of(
                    context,
                  ).center_panelNoSharedTeamCloseChannel
                : AppLocalizations.of(context).center_panelArchivedCloseChannel,
            onClose: _closeChannel,
          )
        else
          MessageEditor(
            key: ValueKey('editor_${channel.id}'),
            scrollController: _listScrollController,
          ),
      ],
    );
  }

  String _archivedMessage({
    required bool isArchived,
    required bool deactivated,
    required bool restricted,
  }) {
    final l10n = AppLocalizations.of(context);
    if (deactivated) return l10n.channelViewArchivedChannelWithDeactivatedUser;
    if (restricted) return l10n.channelViewNoSharedTeam;
    if (isArchived) return l10n.channelViewArchivedChannel;
    return '';
  }
}

/// شريط تنبيه القناة المخالفة (مؤرشفة / مستخدم معطَّل / DM مقيّد) مع زر
/// إغلاق — مطابق channel-archived__message + channel-archived__close-btn في webapp.
class _ArchivedBar extends StatelessWidget {
  final String message;
  final String closeLabel;
  final VoidCallback onClose;

  const _ArchivedBar({
    required this.message,
    required this.closeLabel,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
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
          Flexible(
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: theme.centerChannelColor.withValues(alpha: 0.6),
              ),
            ),
          ),
          const SizedBox(width: 16),
          FilledButton(
            onPressed: onClose,
            style: FilledButton.styleFrom(
              visualDensity: VisualDensity.compact,
              textStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            child: Text(closeLabel),
          ),
        ],
      ),
    );
  }
}
