import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_mattermost/core/enums/category_sorting.dart';
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
import 'package:flutter_mattermost/features/channels/presentation/widgets/unread_channel_indicator.dart';
import 'package:flutter_mattermost/features/chat/presentation/bloc/lhs_bloc.dart';
import 'package:flutter_mattermost/features/teams/presentation/bloc/team_bloc.dart';
import 'package:flutter_mattermost/features/users/presentation/bloc/user_profile_bloc.dart';
import 'package:flutter_mattermost/features/users/presentation/bloc/user_status_bloc.dart';

/// الشريط الجانبي للقنوات (LHS) — مطابق channel_sidebar.tsx في webapp:
/// SidebarHeader + ChannelNavigator + فئات قابلة للطي (channels/DMs).
class ChannelSidebar extends StatelessWidget {
  const ChannelSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return _FailureToaster(
      child: BlocBuilder<LhsBloc, LhsState>(
        builder: (context, lhsState) {
          final lhs = lhsState is LhsSearchState
              ? lhsState
              : const LhsSearchState();
          return BlocBuilder<ChannelBloc, ChannelState>(
            builder: (context, channelState) {
              if (channelState is ChannelLoadingState) {
                return const _SidebarLoading();
              }
              if (channelState is ChannelErrorState) {
                final teamId = channelState.teamId;
                return _SidebarError(
                  onRetry: () {
                    if (teamId != null && teamId.isNotEmpty) {
                      context.read<ChannelBloc>().add(
                        LoadChannelsForTeamEvent(teamId),
                      );
                    }
                  },
                );
              }
              final loaded = channelState is ChannelsLoadedState
                  ? channelState
                  : null;
              return _ChannelSidebarBody(
                channels: loaded?.channels ?? const [],
                categories: loaded?.categories ?? const [],
                unreadCounts: loaded?.unreadCounts ?? const {},
                selectedChannelId: loaded?.selectedChannel?.id,
                currentUserId: loaded?.userId ?? '',
                // القنوات المكتومة: notify_props.mark_unread == 'mention'.
                mutedChannelIds: {
                  for (final entry in (loaded?.members ?? const {}).entries)
                    if (entry.value.notifyProps['mark_unread'] == 'mention')
                      entry.key,
                },
                lhs: lhs,
              );
            },
          );
        },
      ),
    );
  }
}

/// يستمع لفشل عمليات الـ ChannelBloc ويعرض SnackBar عند حدوثه.
class _FailureToaster extends StatefulWidget {
  final Widget child;

  const _FailureToaster({required this.child});

  @override
  State<_FailureToaster> createState() => _FailureToasterState();
}

class _FailureToasterState extends State<_FailureToaster> {
  StreamSubscription<String>? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = context.read<ChannelBloc>().failures.listen((message) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

/// حالة تحميل القنوات — مؤشر دوران في أعلى الشريط بدلاً من ظهوره فارغاً.
class _SidebarLoading extends StatelessWidget {
  const _SidebarLoading();

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Container(
      color: theme.sidebarBg,
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.only(top: 48),
      child: const CircularProgressIndicator(strokeWidth: 2),
    );
  }
}

/// فشل تحميل القنوات — رسالة مع زر إعادة المحاولة.
class _SidebarError extends StatelessWidget {
  final VoidCallback onRetry;

  const _SidebarError({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);
    return Container(
      color: theme.sidebarBg,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.error_modalTitle,
            style: TextStyle(
              color: theme.sidebarText,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh, size: 16),
            label: Text(l10n.error_modalTry_again),
            style: TextButton.styleFrom(foregroundColor: theme.linkColor),
          ),
        ],
      ),
    );
  }
}

/// فتح قناة من الشريط الجانبي مع التوجيه المطابق لـ webapp:
/// DM → /:team/messages/@username، GM → /:team/messages/:channel،
/// والقنوات العادية/الخاصة → /:team/channels/:channel.
void openChannelIn(BuildContext context, ChannelEntity channel) {
  context.read<ChannelBloc>().add(SelectChannelEvent(channel));
  context.read<LhsBloc>().add(ClearLhsSearchEvent());
  final teamState = context.read<TeamBloc>().state;
  final teamName = teamState is TeamsLoadedState
      ? teamState.selectedTeam?.name
      : null;
  if (teamName == null) return;
  final channelState = context.read<ChannelBloc>().state;
  final currentUserId = channelState is ChannelsLoadedState
      ? channelState.userId
      : '';

  switch (channel.type) {
    case ChannelType.direct:
      // الرسائل المباشرة: رابط @username (مطابق sidebar_direct_channel.tsx).
      final username = dmUsernameFor(context, channel, currentUserId);
      if (username != null) {
        context.go('/$teamName/messages/@$username');
        return;
      }
      context.go('/$teamName/channels/${channel.name}');
    case ChannelType.group:
      // المحادثات الجماعية: رابط /messages/channelName.
      context.go('/$teamName/messages/${channel.name}');
    default:
      context.go('/$teamName/channels/${channel.name}');
  }
}

/// اسم مستخدم الطرف المقابل في محادثة DM من الملفات المحمّلة مسبقاً
/// (يعيد null إن لم تُحمَّل الملفات بعد).
String? dmUsernameFor(
  BuildContext context,
  ChannelEntity channel,
  String currentUserId,
) {
  final profileState = context.read<UserProfileBloc>().state;
  if (profileState is! UserProfileLoadedState) return null;
  final profiles = <String, UserEntity>{
    for (final user in profileState.profiles) user.id: user,
    if (profileState.myProfile != null) 'me': profileState.myProfile!,
  };
  final ids = dmCounterpartIds(channel, currentUserId);
  for (final id in ids) {
    final user = profiles[id];
    if (user != null && user.username.isNotEmpty) return user.username;
  }
  if (ids.isEmpty) {
    final me = profiles['me'];
    if (me != null && me.username.isNotEmpty) return me.username;
  }
  return null;
}

class _ChannelSidebarBody extends StatefulWidget {
  final List<ChannelEntity> channels;
  final List<ChannelCategoryEntity> categories;
  final Map<String, ChannelUnreadCounts> unreadCounts;
  final String? selectedChannelId;
  final String currentUserId;
  final Set<String> mutedChannelIds;
  final LhsSearchState lhs;

  const _ChannelSidebarBody({
    required this.channels,
    required this.categories,
    required this.unreadCounts,
    required this.selectedChannelId,
    required this.currentUserId,
    required this.mutedChannelIds,
    required this.lhs,
  });

  @override
  State<_ChannelSidebarBody> createState() => _ChannelSidebarBodyState();
}

class _ChannelSidebarBodyState extends State<_ChannelSidebarBody> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _listKey = GlobalKey();

  /// مفاتيح صفوف القنوات المعروضة فعلياً — تُستخدم لقياس موضعها
  /// في مؤشرات غير المقروءة (ترتيب الإدراج = الترتيب البصري).
  final Map<String, GlobalKey> _rowKeys = {};
  bool _showTopUnread = false;
  bool _showBottomUnread = false;
  int _unreadAbove = 0;
  int _unreadBelow = 0;

  /// هوامش المنطق المطابق لـ updateUnreadIndicators في sidebar_list.tsx
  /// (scrollMargin + categoryHeaderHeight للأعلى، scrollMargin للأسفل).
  static const double _topMargin = 32;
  static const double _bottomMargin = 16;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateUnreadIndicators);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateUnreadIndicators);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _ChannelSidebarBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.unreadCounts != widget.unreadCounts ||
        oldWidget.channels != widget.channels) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _pruneRowKeys();
        _updateUnreadIndicators();
      });
    }
  }

  /// يزيل مفاتيح الصفوف التي لم تعد معروضة (مطوية/مغلقة/محذوفة).
  void _pruneRowKeys() {
    final live = _rowKeys.entries
        .where((e) => e.value.currentContext != null)
        .map((e) => e.key)
        .toSet();
    _rowKeys.removeWhere((id, key) => !live.contains(id));
  }

  /// يحسب ظهور مؤشري غير المقروء أعلى/أسفل — مطابق updateUnreadIndicators
  /// في sidebar_list.tsx: أول/آخر قناة غير مقروءة مقارنة بمجال الرؤية.
  void _updateUnreadIndicators() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    final viewportHeight = position.viewportDimension;
    final listBox = _listKey.currentContext?.findRenderObject() as RenderBox?;
    if (listBox == null) return;
    final listTopLeft = listBox.localToGlobal(Offset.zero);

    var showTop = false;
    var showBottom = false;
    var aboveCount = 0;
    var belowCount = 0;

    for (final entry in _rowKeys.entries) {
      if (!(widget.unreadCounts[entry.key]?.hasUnreads ?? false)) continue;
      final ctx = entry.value.currentContext;
      if (ctx == null) continue;
      final box = ctx.findRenderObject();
      if (box is! RenderBox) continue;
      final relTop = box.localToGlobal(Offset.zero).dy - listTopLeft.dy;
      if (relTop + box.size.height - _topMargin < 0) {
        aboveCount++;
        if (aboveCount == 1) showTop = true;
      } else if (relTop + _bottomMargin > viewportHeight) {
        belowCount++;
      }
    }

    // آخر قناة غير مقروءة أسفل الرؤية — نفس قاعدة webapp للأخيرة.
    for (final entry in _rowKeys.entries.toList().reversed) {
      if (!(widget.unreadCounts[entry.key]?.hasUnreads ?? false)) continue;
      final ctx = entry.value.currentContext;
      if (ctx == null) continue;
      final box = ctx.findRenderObject();
      if (box is! RenderBox) continue;
      final relTop = box.localToGlobal(Offset.zero).dy - listTopLeft.dy;
      if (relTop + _bottomMargin > viewportHeight) {
        showBottom = true;
        break;
      }
    }

    if (showTop != _showTopUnread ||
        showBottom != _showBottomUnread ||
        aboveCount != _unreadAbove ||
        belowCount != _unreadBelow) {
      setState(() {
        _showTopUnread = showTop;
        _showBottomUnread = showBottom;
        _unreadAbove = aboveCount;
        _unreadBelow = belowCount;
      });
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
    final teamId = teamState is TeamsLoadedState
        ? teamState.selectedTeam?.id
        : null;
    if (teamId == null) return;
    context.read<ChannelBloc>().add(
      MoveChannelToCategoryEvent(
        channelId: channelId,
        targetCategoryId: toCategoryId,
        userId: widget.currentUserId,
        teamId: teamId,
      ),
    );
  }

  String? _teamName(BuildContext context) {
    final state = context.read<TeamBloc>().state;
    return state is TeamsLoadedState ? state.selectedTeam?.name : null;
  }

  bool _matchesQuery(ChannelEntity ch) {
    final q = widget.lhs.query.toLowerCase();
    return q.isEmpty ||
        ch.displayName.toLowerCase().contains(q) ||
        ch.name.toLowerCase().contains(q);
  }

  bool _hiddenByUnreads(ChannelEntity ch) =>
      widget.lhs.unreadsOnly &&
      !(widget.unreadCounts[ch.id]?.hasUnreads ?? false);

  /// باني مفاتيح صفوف القنوات — GlobalKey لكل قناة لقياس موضعها.
  Key _rowKeyFor(ChannelEntity channel) =>
      _rowKeys.putIfAbsent(channel.id, () => GlobalKey());

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);

    // الفئة "المفضلة" تظهر أولاً (نجمة) ثم باقي الفئات بترتيب الخادم.
    final sections = channelSectionsFor(
      widget.categories,
      widget.channels,
      widget.lhs.query,
      widget.lhs.unreadsOnly,
      widget.unreadCounts,
      l10n.sidebarChannels,
      l10n.sidebarCategoryFavorites,
    );

    // معرف فئة الرسائل المباشرة الحقيقي من الخادم إن وُجد
    // (القسم الافتراضي عند غيابها — لاحظ أن webapp يستخدم نفس الرموز الخاصة).
    final dmCategory = widget.categories
        .where((c) => c.type == ChannelCategoryType.directMessages)
        .firstOrNull;
    final dmCategoryId = dmCategory?.id ?? 'direct_messages';

    // قنوات DM/GM غير المفهرسة في أي فئة مخصصة (القسم الافتراضي).
    // تُستثنى فئة الرسائل المباشرة نفسها حتى لا تختفي قنواتها من هذا القسم.
    final inCategories = widget.categories
        .where((c) => c.type != ChannelCategoryType.directMessages)
        .expand((c) => c.channelIds)
        .toSet();
    final dmChannels = ([
      for (final ch in widget.channels)
        if ((ch.type == ChannelType.direct || ch.type == ChannelType.group) &&
            !inCategories.contains(ch.id) &&
            _matchesQuery(ch) &&
            !_hiddenByUnreads(ch))
          ch,
    ]..sort((a, b) => b.lastPostAt.compareTo(a.lastPostAt)));

    return Container(
      color: theme.sidebarBg,
      child: Column(
        children: [
          const SidebarHeader(),
          const ChannelNavigator(),
          Expanded(
            child: Stack(
              children: [
                ListView(
                  key: _listKey,
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  children: [
                    _GlobalSectionLink(
                      icon: Icons.forum_outlined,
                      label: l10n.globalThreadsSidebarLink,
                      onTap: () {
                        final teamName = _teamName(context);
                        if (teamName != null) {
                          context.go('/$teamName/threads');
                        }
                      },
                    ),
                    _GlobalSectionLink(
                      icon: Icons.bookmark_border,
                      label: l10n.sidebar_right_menuFlagged,
                      onTap: () {
                        final teamName = _teamName(context);
                        if (teamName != null) {
                          context.go('/$teamName/saved');
                        }
                      },
                    ),
                    const SizedBox(height: 8),
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
                        categoryId: dmCategoryId,
                        dmCategory: dmCategory,
                        channels: dmChannels,
                        unreadCounts: widget.unreadCounts,
                        selectedChannelId: widget.selectedChannelId,
                        currentUserId: widget.currentUserId,
                        mutedChannelIds: widget.mutedChannelIds,
                        onChannelTap: (ch) => openChannelIn(context, ch),
                        onMoveChannel: (channelId, fromId) => _moveChannel(
                          context,
                          channelId,
                          fromId,
                          dmCategoryId,
                        ),
                        rowKeyBuilder: _rowKeyFor,
                      ),
                  ],
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  child: Center(
                    child: UnreadChannelIndicator(
                      isTop: true,
                      show: _showTopUnread,
                      count: _unreadAbove,
                      onClick: () => _scrollToUnread(direction: -1),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Center(
                    child: UnreadChannelIndicator(
                      isTop: false,
                      show: _showBottomUnread,
                      count: _unreadBelow,
                      onClick: () => _scrollToUnread(direction: 1),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// يمرر إلى أول قناة غير مقروءة أعلى (direction -1) أو أسفل (direction 1)
  /// مجال الرؤية — مطابق scrollToFirstUnreadChannel/scrollToLastUnreadChannel.
  void _scrollToUnread({required int direction}) {
    final position = _scrollController.position;
    final viewportHeight = position.viewportDimension;
    final listBox = _listKey.currentContext?.findRenderObject() as RenderBox?;
    if (listBox == null) return;
    final listTopLeft = listBox.localToGlobal(Offset.zero);

    double? target;
    for (final entry in _rowKeys.entries) {
      if (!(widget.unreadCounts[entry.key]?.hasUnreads ?? false)) continue;
      final ctx = entry.value.currentContext;
      if (ctx == null) continue;
      final box = ctx.findRenderObject();
      if (box is! RenderBox) continue;
      final relTop = box.localToGlobal(Offset.zero).dy - listTopLeft.dy;
      final isAbove = relTop + box.size.height - _topMargin < 0;
      final isBelow = relTop + _bottomMargin > viewportHeight;
      if (direction < 0 && isAbove) target = relTop;
      if (direction > 0 && isBelow) {
        target = relTop - viewportHeight / 2;
        break;
      }
    }
    if (target != null) {
      _scrollController.animateTo(
        (position.pixels + target).clamp(0, position.maxScrollExtent),
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    }
  }

  Widget _buildCategory(
    BuildContext context, {
    required String categoryId,
    required String title,
    required List<ChannelEntity> rows,
  }) {
    final teamState = context.read<TeamBloc>().state;
    final teamId = teamState is TeamsLoadedState
        ? teamState.selectedTeam?.id
        : null;
    return SidebarCategory(
      categoryId: categoryId,
      title: title,
      channels: rows,
      unreadCounts: widget.unreadCounts,
      selectedChannelId: widget.selectedChannelId,
      onChannelTap: (ch) => openChannelIn(context, ch),
      category: widget.categories.where((c) => c.id == categoryId).firstOrNull,
      userId: widget.currentUserId,
      teamId: teamId ?? '',
      mutedChannelIds: widget.mutedChannelIds,
      rowKeyBuilder: _rowKeyFor,
      onMoveChannel: (channelId, fromId) =>
          _moveChannel(context, channelId, fromId, categoryId),
    );
  }
}

class _GlobalSectionLink extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _GlobalSectionLink({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: theme.sidebarText.withValues(alpha: 0.64),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: theme.sidebarText.withValues(alpha: 0.8),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// فئة الرسائل المباشرة — صفوف بأفاتار/حالة المستخدم (متصل/غائب/عدم إزعاج/غير متصل)
/// وتحميل الحالات عبر UserStatusBloc.
class _DmCategory extends StatefulWidget {
  final String categoryId;

  /// فئة الرسائل المباشرة من الخادم (قد تكون غائبة عند عدم وجودها).
  final ChannelCategoryEntity? dmCategory;
  final List<ChannelEntity> channels;
  final Map<String, ChannelUnreadCounts> unreadCounts;
  final String? selectedChannelId;
  final String currentUserId;
  final Set<String> mutedChannelIds;
  final Key Function(ChannelEntity)? rowKeyBuilder;
  final void Function(ChannelEntity) onChannelTap;
  final void Function(String channelId, String fromCategoryId) onMoveChannel;

  const _DmCategory({
    required this.categoryId,
    this.dmCategory,
    required this.channels,
    required this.unreadCounts,
    required this.selectedChannelId,
    required this.currentUserId,
    this.mutedChannelIds = const {},
    this.rowKeyBuilder,
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
      for (final ch in widget.channels)
        ...dmCounterpartIds(ch, widget.currentUserId),
    };
    if (userIds.isEmpty) return;
    context.read<UserStatusBloc>().add(LoadUserStatusesEvent(userIds.toList()));
  }

  /// تحميل ملفات المستخدمين المقابلين لحل أسماء قنوات DM
  /// (الخادم يعيد display_name فارغاً للرسائل المباشرة).
  void _requestProfiles() {
    final userIds = <String>{
      for (final ch in widget.channels)
        ...dmCounterpartIds(ch, widget.currentUserId),
    };
    if (userIds.isEmpty) return;
    context.read<UserProfileBloc>().add(
      LoadProfilesByIdsEvent(userIds.toList()),
    );
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
                final collapsed =
                    lhs is LhsSearchState &&
                    lhs.collapsedCategories.contains(widget.categoryId);

                // يقبل إفلات القنوات من الفئات الأخرى إلى قسم الرسائل المباشرة.
                return DragTarget<SidebarCategoryDragData>(
                  onWillAcceptWithDetails: (details) =>
                      details.data.fromCategoryId != widget.categoryId,
                  onAcceptWithDetails: (details) => widget.onMoveChannel(
                    details.data.channelId,
                    details.data.fromCategoryId,
                  ),
                  builder: (context, candidateData, rejectedData) {
                    final isDropTarget = candidateData.isNotEmpty;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () => context.read<LhsBloc>().add(
                            ToggleCategoryCollapsedEvent(widget.categoryId),
                          ),
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
                                    color: theme.sidebarText.withValues(
                                      alpha: 0.64,
                                    ),
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
                              : Container(
                                  decoration: isDropTarget
                                      ? BoxDecoration(
                                          color: theme.sidebarText.withValues(
                                            alpha: 0.06,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        )
                                      : null,
                                  child: Column(
                                    children: [
                                      for (final channel in _sortedChannels(
                                        profiles,
                                      ))
                                        _DmRow(
                                          channel: channel,
                                          isMuted: widget.mutedChannelIds
                                              .contains(channel.id),
                                          rowKey: widget.rowKeyBuilder?.call(
                                            channel,
                                          ),
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
                                          unread:
                                              widget.unreadCounts[channel.id],
                                          isSelected:
                                              channel.id ==
                                              widget.selectedChannelId,
                                          onTap: () =>
                                              widget.onChannelTap(channel),
                                          draggableFrom: widget.categoryId,
                                        ),
                                    ],
                                  ),
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
      },
    );
  }

  /// ترتيب قنوات DM وفقًا لـ [CategorySorting] لفئة الرسائل المباشرة
  /// (الافتراضي recent كالجذر في webapp — `getCurrentUserId` وحالة الافتراضي),
  /// مع حل الأسماء عبر [profiles] للترتيب الأبجدي.
  List<ChannelEntity> _sortedChannels(Map<String, UserEntity> profiles) {
    final channels = List<ChannelEntity>.of(widget.channels);
    switch (widget.dmCategory?.sorting ?? CategorySorting.recent) {
      case CategorySorting.alpha:
        channels.sort((a, b) {
          final ua = _counterpartFor(a, widget.currentUserId, profiles);
          final ub = _counterpartFor(b, widget.currentUserId, profiles);
          final na =
              (a.displayName.isNotEmpty
                      ? a.displayName
                      : (ua != null &&
                                '${ua.firstName} ${ua.lastName}'
                                    .trim()
                                    .isNotEmpty
                            ? '${ua.firstName} ${ua.lastName}'.trim()
                            : ua?.username ?? a.name))
                  .toLowerCase();
          final nb =
              (b.displayName.isNotEmpty
                      ? b.displayName
                      : (ub != null &&
                                '${ub.firstName} ${ub.lastName}'
                                    .trim()
                                    .isNotEmpty
                            ? '${ub.firstName} ${ub.lastName}'.trim()
                            : ub?.username ?? b.name))
                  .toLowerCase();
          return na.compareTo(nb);
        });
      case CategorySorting.recent:
        channels.sort((a, b) => b.lastPostAt.compareTo(a.lastPostAt));
      case CategorySorting.manual:
      case CategorySorting.defaultSorting:
        final channelIds = widget.dmCategory?.channelIds ?? const <String>[];
        channels.sort(
          (a, b) =>
              channelIds.indexOf(a.id).compareTo(channelIds.indexOf(b.id)),
        );
    }
    return channels;
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
  final bool isMuted;
  final Key? rowKey;
  final VoidCallback onTap;
  final String draggableFrom;

  const _DmRow({
    required this.channel,
    required this.status,
    required this.user,
    required this.unread,
    required this.isSelected,
    this.isMuted = false,
    this.rowKey,
    required this.onTap,
    required this.draggableFrom,
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

    // نفس نوع بيانات السحب المستخدم في SidebarCategory ليعمل الإفلات
    // المتبادل بين قسم DM والفئات الأخرى (النقل يحدث عند DragTarget.onAccept).
    return LongPressDraggable<SidebarCategoryDragData>(
      data: SidebarCategoryDragData(
        channelId: widget.channel.id,
        fromCategoryId: widget.draggableFrom,
      ),
      key: widget.rowKey,
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
          showChannelContextMenu(context, channel, details.globalPosition);
        },
        child: Opacity(
          opacity: widget.isMuted ? 0.5 : 1,
          child: Container(
            height: 32,
            padding: const EdgeInsets.only(
              left: 19,
              right: 16,
              bottom: 7,
              top: 7,
            ),
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
                    color: hasUnreads
                        ? theme.sidebarUnreadText
                        : theme.sidebarText.withValues(alpha: 0.7),
                  ),
                  child: Center(
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _statusColor(theme),
                        border: Border.all(color: theme.sidebarBg, width: 1),
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
                      color: hasUnreads
                          ? theme.sidebarUnreadText
                          : theme.sidebarText,
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

  /// قنوات كل فئة مرتبة وفقًا لـ [CategorySorting] — بنفس دلالة
  /// `sortChannelsBy` في webapp: اليدوي بترتيب channel_ids،
  /// والأحدث نشاطًا حسب آخر رسالة، والأبجدي حسب الاسم المعروض.
  final cats = <(String, String, List<ChannelEntity>)>[
    for (final category in ordered)
      (
        category.id,
        category.type == ChannelCategoryType.favorites
            ? favoritesTitle
            : category.displayName,
        (channels
            .where(
              (ch) =>
                  category.channelIds.contains(ch.id) &&
                  matches(ch) &&
                  !hiddenByUnreads(ch),
            )
            .toList()
          ..sort((a, b) {
            switch (category.sorting) {
              case CategorySorting.alpha:
                return a.displayName.compareTo(b.displayName);
              case CategorySorting.recent:
                return b.lastPostAt.compareTo(a.lastPostAt);
              case CategorySorting.manual:
              case CategorySorting.defaultSorting:
                final ia = category.channelIds.indexOf(a.id);
                final ib = category.channelIds.indexOf(b.id);
                return ia.compareTo(ib);
            }
          })),
      ),
  ];

  final inAnyCategory = categories.expand((c) => c.channelIds).toSet();
  final uncategorized =
      (channels
          .where(
            (ch) =>
                ch.type != ChannelType.direct &&
                !inAnyCategory.contains(ch.id) &&
                matches(ch) &&
                !hiddenByUnreads(ch),
          )
          .toList()
        ..sort((a, b) => b.lastPostAt.compareTo(a.lastPostAt)));
  if (uncategorized.isNotEmpty) {
    cats.add(('uncategorized', uncategorizedTitle, uncategorized));
  }
  return cats;
}
