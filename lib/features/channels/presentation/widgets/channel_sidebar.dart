import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_mattermost/core/enums/channel_category_type.dart';
import 'package:flutter_mattermost/core/enums/channel_type.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:flutter_mattermost/features/auth/domain/entities/user_status_entity.dart';
import 'package:flutter_mattermost/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_category_entity.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_entity.dart';
import 'package:flutter_mattermost/features/channels/domain/repositories/channel_repository.dart';
import 'package:flutter_mattermost/features/channels/presentation/bloc/channel_bloc.dart';
import 'package:flutter_mattermost/features/channels/presentation/widgets/channel_context_menu.dart';
import 'package:flutter_mattermost/features/channels/presentation/widgets/channel_navigator.dart';
import 'package:flutter_mattermost/features/channels/presentation/widgets/sidebar_category.dart';
import 'package:flutter_mattermost/features/channels/presentation/widgets/sidebar_header.dart';
import 'package:flutter_mattermost/features/chat/presentation/bloc/lhs_bloc.dart';
import 'package:flutter_mattermost/features/teams/presentation/bloc/team_bloc.dart';
import 'package:flutter_mattermost/features/users/presentation/bloc/user_profile_bloc.dart';
import 'package:flutter_mattermost/features/users/presentation/bloc/user_status_bloc.dart';

/// الشريط الجانبي للقنوات (LHS) — مطابق channel_sidebar.tsx في webapp:
/// SidebarHeader + ChannelNavigator + فئات قابلة للطي (channels/DMs) +
/// شريط تكاملات سفلي (Playbooks/Boards).
class ChannelSidebar extends StatelessWidget {
  const ChannelSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LhsBloc, LhsState>(
      builder: (context, lhsState) {
        final lhs = lhsState is LhsSearchState
            ? lhsState
            : const LhsSearchState();
        return BlocBuilder<ChannelBloc, ChannelState>(
          builder: (context, channelState) {
            final loaded = channelState is ChannelsLoadedState
                ? channelState
                : null;
            return _ChannelSidebarBody(
              channels: loaded?.channels ?? const [],
              categories: loaded?.categories ?? const [],
              unreadCounts: loaded?.unreadCounts ?? const {},
              selectedChannelId: loaded?.selectedChannel?.id,
              currentUserId: loaded?.userId ?? '',
              lhs: lhs,
            );
          },
        );
      },
    );
  }
}

class _ChannelSidebarBody extends StatelessWidget {
  final List<ChannelEntity> channels;
  final List<ChannelCategoryEntity> categories;
  final Map<String, ChannelUnreadCounts> unreadCounts;
  final String? selectedChannelId;
  final String currentUserId;
  final LhsSearchState lhs;

  const _ChannelSidebarBody({
    required this.channels,
    required this.categories,
    required this.unreadCounts,
    required this.selectedChannelId,
    required this.currentUserId,
    required this.lhs,
  });

  void _openChannel(BuildContext context, ChannelEntity channel) {
    context.read<ChannelBloc>().add(SelectChannelEvent(channel));
    context.read<LhsBloc>().add(ClearLhsSearchEvent());
    final teamName = _teamName(context);
    if (teamName != null) {
      context.go('/$teamName/channels/${channel.name}');
    }
  }

  void _moveChannel(
    BuildContext context,
    String channelId,
    String fromCategoryId,
    String toCategoryId,
  ) {
    if (fromCategoryId == toCategoryId) return;
    final teamState = context.read<TeamBloc>().state;
    final teamId = teamState is TeamsLoadedState ? teamState.selectedTeam?.id : null;
    if (teamId == null) return;
    context.read<ChannelBloc>().add(
          MoveChannelToCategoryEvent(
            channelId: channelId,
            targetCategoryId: toCategoryId,
            userId: currentUserId,
            teamId: teamId,
          ),
        );
  }

  String? _teamName(BuildContext context) {
    final state = context.read<TeamBloc>().state;
    return state is TeamsLoadedState ? state.selectedTeam?.name : null;
  }

  bool _matchesQuery(ChannelEntity ch) {
    final q = lhs.query.toLowerCase();
    return q.isEmpty ||
        ch.displayName.toLowerCase().contains(q) ||
        ch.name.toLowerCase().contains(q);
  }

  bool _hiddenByUnreads(ChannelEntity ch) =>
      lhs.unreadsOnly && !(unreadCounts[ch.id]?.hasUnreads ?? false);

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);

    // الفئة "المفضلة" تظهر أولاً (نجمة) ثم باقي الفئات بترتيب الخادم.
    final sections = channelSectionsFor(
      categories,
      channels,
      lhs.query,
      lhs.unreadsOnly,
      unreadCounts,
      l10n.sidebarChannels,
      l10n.sidebarCategoryFavorites,
    );

    // قنوات DM/GM غير المفهرسة في أي فئة مخصصة (القسم الافتراضي).
    final inCategories = categories.expand((c) => c.channelIds).toSet();
    final dmChannels = [
      for (final ch in channels)
        if (ch.type == ChannelType.direct &&
            !inCategories.contains(ch.id) &&
            _matchesQuery(ch) &&
            !_hiddenByUnreads(ch)) ch,
    ];

    return Container(
      color: theme.sidebarBg,
      child: Column(
        children: [
          const SidebarHeader(),
          const ChannelNavigator(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                for (final (categoryId, title, list) in sections)
                  if (list.isNotEmpty)
                    _buildCategory(
                      context,
                      categoryId: categoryId,
                      title: title,
                      rows: list,
                    ),
                if (dmChannels.isNotEmpty)
                  _DmCategory(
                    categoryId: 'direct_messages',
                    channels: dmChannels,
                    unreadCounts: unreadCounts,
                    selectedChannelId: selectedChannelId,
                    currentUserId: currentUserId,
                    onChannelTap: (ch) => _openChannel(context, ch),
                    onMoveChannel: (channelId, fromId) =>
                        _moveChannel(context, channelId, fromId, 'direct_messages'),
                  ),
              ],
            ),
          ),
          const _SidebarIntegrationsBar(),
        ],
      ),
    );
  }

  Widget _buildCategory(
    BuildContext context, {
    required String categoryId,
    required String title,
    required List<ChannelEntity> rows,
  }) {
    final teamState = context.read<TeamBloc>().state;
    final teamId = teamState is TeamsLoadedState ? teamState.selectedTeam?.id : null;
    return SidebarCategory(
      categoryId: categoryId,
      title: title,
      channels: rows,
      unreadCounts: unreadCounts,
      selectedChannelId: selectedChannelId,
      onChannelTap: (ch) => _openChannel(context, ch),
      category: categories.where((c) => c.id == categoryId).firstOrNull,
      userId: currentUserId,
      teamId: teamId ?? '',
      onMoveChannel: (channelId, fromId) =>
          _moveChannel(context, channelId, fromId, categoryId),
    );
  }
}

/// فئة الرسائل المباشرة — صفوف بأفاتار/حالة المستخدم (متصل/غائب/عدم إزعاج/غير متصل)
/// وتحميل الحالات عبر UserStatusBloc.
class _DmCategory extends StatefulWidget {
  final String categoryId;
  final List<ChannelEntity> channels;
  final Map<String, ChannelUnreadCounts> unreadCounts;
  final String? selectedChannelId;
  final String currentUserId;
  final void Function(ChannelEntity) onChannelTap;
  final void Function(String channelId, String fromCategoryId) onMoveChannel;

  const _DmCategory({
    required this.categoryId,
    required this.channels,
    required this.unreadCounts,
    required this.selectedChannelId,
    required this.currentUserId,
    required this.onChannelTap,
    required this.onMoveChannel,
  });

  @override
  State<_DmCategory> createState() => _DmCategoryState();
}

class _DmCategoryState extends State<_DmCategory> {
  @override
  void initState() {
    super.initState();
    _requestStatuses();
    _requestProfiles();
  }

  @override
  void didUpdateWidget(covariant _DmCategory oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.channels != oldWidget.channels) {
      _requestStatuses();
      _requestProfiles();
    }
  }

  void _requestStatuses() {
    final userIds = <String>{
      for (final ch in widget.channels) ...dmCounterpartIds(ch, widget.currentUserId),
    };
    if (userIds.isEmpty) return;
    context.read<UserStatusBloc>().add(LoadUserStatusesEvent(userIds.toList()));
  }

  /// تحميل ملفات المستخدمين المقابلين لحل أسماء قنوات DM
  /// (الخادم يعيد display_name فارغاً للرسائل المباشرة).
  void _requestProfiles() {
    final userIds = <String>{
      for (final ch in widget.channels) ...dmCounterpartIds(ch, widget.currentUserId),
    };
    if (userIds.isEmpty) return;
    context.read<UserProfileBloc>().add(LoadProfilesByIdsEvent(userIds.toList()));
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);

    return BlocBuilder<UserStatusBloc, UserStatusState>(
      builder: (context, statusState) {
        final statuses = statusState is UserStatusesLoadedState
            ? statusState.statuses
            : const <String, UserStatus>{};
        return BlocBuilder<UserProfileBloc, UserProfileState>(
          builder: (context, profileState) {
            final profiles = <String, UserEntity>{};
            if (profileState is UserProfileLoadedState) {
              for (final user in profileState.profiles) {
                profiles[user.id] = user;
              }
              if (profileState.myProfile != null) {
                profiles['me'] = profileState.myProfile!;
              }
            }
            return BlocBuilder<LhsBloc, LhsState>(
          builder: (context, lhs) {
            final collapsed = lhs is LhsSearchState &&
                lhs.collapsedCategories.contains(widget.categoryId);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () => context
                      .read<LhsBloc>()
                      .add(ToggleCategoryCollapsedEvent(widget.categoryId)),
                  child: Container(
                    height: 32,
                    padding: const EdgeInsets.only(left: 16, right: 12),
                    child: Row(
                      children: [
                        AnimatedRotation(
                          turns: collapsed ? -0.25 : 0,
                          duration: const Duration(milliseconds: 180),
                          child: Icon(
                            Icons.chevron_right,
                            size: 16,
                            color: theme.sidebarText.withValues(alpha: 0.64),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            l10n.sidebarDirectMessages,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: theme.sidebarText.withValues(
                                alpha: 0.64,
                              ),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeInOut,
                  alignment: Alignment.topCenter,
                  child: collapsed
                      ? const SizedBox(width: double.infinity)
                      : Column(
                          children: [
                            for (final channel in widget.channels)
                              _DmRow(
                                channel: channel,
                                status: _statusFor(
                                  channel,
                                  widget.currentUserId,
                                  statuses,
                                ),
                                user: _counterpartFor(
                                  channel,
                                  widget.currentUserId,
                                  profiles,
                                ),
                                unread: widget.unreadCounts[channel.id],
                                isSelected:
                                    channel.id == widget.selectedChannelId,
                                onTap: () => widget.onChannelTap(channel),
                                draggableFrom: widget.categoryId,
                                onDrag: widget.onMoveChannel,
                              ),
                          ],
                        ),
                ),
              ],
            );
          },
        );
          },
        );
      },
    );
  }

  UserStatus? _statusFor(
    ChannelEntity channel,
    String currentUserId,
    Map<String, UserStatus> statuses,
  ) {
    final ids = dmCounterpartIds(channel, currentUserId);
    for (final id in ids) {
      final status = statuses[id];
      if (status != null) return status;
    }
    // محادثة مع النفس — حالة المستخدم الحالي.
    if (ids.isEmpty) return statuses['me'];
    return null;
  }

  /// المستخدم المقابل في محادثة DM (null لمحادثة النفس/عدم التحميل بعد).
  UserEntity? _counterpartFor(
    ChannelEntity channel,
    String currentUserId,
    Map<String, UserEntity> profiles,
  ) {
    final ids = dmCounterpartIds(channel, currentUserId);
    for (final id in ids) {
      final user = profiles[id];
      if (user != null) return user;
    }
    if (ids.isEmpty) return profiles['me'];
    return null;
  }
}

/// صف DM مع حالة المستخدم — مطابق sidebar_channel.tsx مع status indicator،
/// وقائمة قناة (⋯ عند التمرير أو النقر اليميني) مثل بقية القنوات.
class _DmRow extends StatefulWidget {
  final ChannelEntity channel;
  final UserStatus? status;

  /// المستخدم المقابل لحل اسم المحادثة (الخادم يترك display_name فارغاً).
  final UserEntity? user;
  final ChannelUnreadCounts? unread;
  final bool isSelected;
  final VoidCallback onTap;
  final String draggableFrom;
  final void Function(String channelId, String fromCategoryId) onDrag;

  const _DmRow({
    required this.channel,
    required this.status,
    required this.user,
    required this.unread,
    required this.isSelected,
    required this.onTap,
    required this.draggableFrom,
    required this.onDrag,
  });

  @override
  State<_DmRow> createState() => _DmRowState();
}

class _DmRowState extends State<_DmRow> {
  bool _hovered = false;

  /// اسم المحادثة: displayName من الخادم (GM) أو اسم المستخدم المقابل (DM)
  /// بالصيغة المتبعة في الواجهة: الاسم الكامل ثم @username عند غيابه.
  String get _label {
    final channel = widget.channel;
    if (channel.displayName.isNotEmpty) return channel.displayName;
    final u = widget.user;
    if (u != null) {
      final full = '${u.firstName} ${u.lastName}'.trim();
      if (full.isNotEmpty) return full;
      return u.username;
    }
    return channel.name;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final hasUnreads = widget.unread?.hasUnreads ?? false;
    final hasMentions = (widget.unread?.mentions ?? 0) > 0;

    return LongPressDraggable<String>(
      data: widget.channel.id,
      onDragStarted: () =>
          widget.onDrag(widget.channel.id, widget.draggableFrom),
      feedback: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: theme.sidebarBg,
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 8,
              ),
            ],
          ),
          child: Text(
            _label,
            style: TextStyle(color: theme.sidebarText, fontSize: 14),
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: _content(theme, hasUnreads, hasMentions),
      ),
      child: _content(theme, hasUnreads, hasMentions),
    );
  }

  Widget _content(MattermostColors theme, bool hasUnreads, bool hasMentions) {
    final channel = widget.channel;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        onSecondaryTapDown: (details) {
          showChannelContextMenu(
            context,
            channel,
            details.globalPosition,
          );
        },
        child: Container(
          height: 32,
          padding: const EdgeInsets.only(left: 19, right: 16, bottom: 7, top: 7),
          color: widget.isSelected
              ? theme.sidebarText.withValues(alpha: 0.08)
              : _hovered
              ? theme.sidebarTextHoverBg
              : Colors.transparent,
          child: Row(
            children: [
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: hasUnreads ? theme.sidebarUnreadText : theme.sidebarText.withValues(alpha: 0.7),
                ),
                child: Center(
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _statusColor(theme),
                      border: Border.all(
                        color: theme.sidebarBg,
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: hasUnreads ? theme.sidebarUnreadText : theme.sidebarText,
                    fontWeight: hasUnreads || widget.isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ),
              if (hasMentions)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: theme.mentionBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${widget.unread!.mentions}',
                    style: TextStyle(
                      color: theme.mentionColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              else if (hasUnreads)
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: theme.sidebarUnreadText,
                    shape: BoxShape.circle,
                  ),
                ),
              const SizedBox(width: 2),
              AnimatedOpacity(
                opacity: _hovered ? 1 : 0,
                duration: const Duration(milliseconds: 100),
                child: ChannelRowMenu(channel: channel, iconSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _statusColor(MattermostColors theme) {
    switch (widget.status) {
      case UserStatus.online:
        return theme.onlineIndicator;
      case UserStatus.away:
        return theme.awayIndicator;
      case UserStatus.dnd:
        return theme.dndIndicator;
      case UserStatus.offline:
        return theme.sidebarText.withValues(alpha: 0.3);
      case null:
        return theme.sidebarText.withValues(alpha: 0.7);
    }
  }
}

/// شريط التكاملات السفلي — مطابق integrations في أسفل LHS webapp
/// (Playbooks + Boards).
class _SidebarIntegrationsBar extends StatelessWidget {
  const _SidebarIntegrationsBar();

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: theme.sidebarText.withValues(alpha: 0.1)),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _IntegrationButton(
            icon: Icons.playlist_play_rounded,
            label: 'Playbooks',
            onTap: () => _notImplemented(context, 'Playbooks'),
          ),
          _IntegrationButton(
            icon: Icons.view_kanban_outlined,
            label: 'Boards',
            onTap: () => _notImplemented(context, 'Boards'),
          ),
        ],
      ),
    );
  }

  void _notImplemented(BuildContext context, String name) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$name — قريباً')),
    );
  }
}

class _IntegrationButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _IntegrationButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: theme.sidebarText.withValues(alpha: 0.7),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: theme.sidebarText.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// معرّفات المستخدمين الآخرين في قناة DM —
/// اسم القناة بصيغة `id1__id2` (أو `d:id` لمحادثة النفس).
List<String> dmCounterpartIds(ChannelEntity channel, String currentUserId) {
  var name = channel.name;
  if (name.startsWith('d:')) name = name.substring(2);
  return name
      .split('__')
      .where((id) => id.isNotEmpty && id != currentUserId)
      .toList();
}

/// يبني أقسام الفئات: المفضلة أولاً ثم باقي الفئات بترتيب الخادم،
/// مع القنوات غير المفهرسة، مع تطبيق البحث/فلتر غير المقروء.
List<(String, String, List<ChannelEntity>)> channelSectionsFor(
  List<ChannelCategoryEntity> categories,
  List<ChannelEntity> channels,
  String query,
  bool unreadsOnly,
  Map<String, ChannelUnreadCounts> unreadCounts,
  String uncategorizedTitle,
  String favoritesTitle,
) {
  final q = query.toLowerCase();
  bool matches(ChannelEntity ch) =>
      q.isEmpty ||
      ch.displayName.toLowerCase().contains(q) ||
      ch.name.toLowerCase().contains(q);
  bool hiddenByUnreads(ChannelEntity ch) =>
      unreadsOnly && !(unreadCounts[ch.id]?.hasUnreads ?? false);

  final ordered = [
    ...categories.where((c) => c.type == ChannelCategoryType.favorites),
    ...categories.where(
      (c) =>
          c.type != ChannelCategoryType.favorites &&
          c.type != ChannelCategoryType.directMessages,
    ),
  ];

  final cats = <(String, String, List<ChannelEntity>)>[
    for (final category in ordered)
      (
        category.id,
        category.type == ChannelCategoryType.favorites
            ? favoritesTitle
            : category.displayName,
        channels
            .where(
              (ch) =>
                  category.channelIds.contains(ch.id) &&
                  matches(ch) &&
                  !hiddenByUnreads(ch),
            )
            .toList(),
      ),
  ];

  final inAnyCategory = categories.expand((c) => c.channelIds).toSet();
  final uncategorized = channels
      .where(
        (ch) =>
            ch.type != ChannelType.direct &&
            !inAnyCategory.contains(ch.id) &&
            matches(ch) &&
            !hiddenByUnreads(ch),
      )
      .toList();
  if (uncategorized.isNotEmpty) {
    cats.add(('uncategorized', uncategorizedTitle, uncategorized));
  }
  return cats;
}