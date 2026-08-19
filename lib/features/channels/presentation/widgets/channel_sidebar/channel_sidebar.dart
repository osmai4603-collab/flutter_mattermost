import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/storage/draft_storage_service.dart';
import 'package:flutter_mattermost/core/widgets/hover_widget.dart';
import 'package:flutter_mattermost/features/channels/presentation/widgets/channel_sidebar/channel_navigator.dart';
import 'package:flutter_mattermost/features/channels/presentation/widgets/channel_sidebar/channel_sidebar_header.dart';
import 'package:flutter_mattermost/features/channels/presentation/widgets/channel_sidebar/direct_message_category_widget.dart';
import 'package:flutter_mattermost/features/channels/presentation/widgets/channel_sidebar/direction_message_item_widget.dart';
import 'package:flutter_mattermost/features/channels/presentation/widgets/channel_sidebar/sidebar_category.dart';
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
  bool _showTopUnread = false;
  bool _showBottomUnread = false;
  int _unreadAbove = 0;
  int _unreadBelow = 0;
  final Map<String, bool> isCollapsed = {};

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
        oldWidget.channels != widget.channels) {}
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
          const ChannelSidebarHeader(),
          const ChannelNavigator(),
          Expanded(
            child: Stack(
              children: [
                RawScrollbar(
                  interactive: false,
                  thumbVisibility: false,
                  trackVisibility: false,
                  scrollbarOrientation: .left,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        key: _listKey,
                        children: [
                          _GlobalSectionLink(
                            icon: Icons.message_outlined,
                            label: l10n.globalThreadsSidebarLink,
                            onTap: () {
                              final teamName = _teamName(context);
                              if (teamName != null) {
                                context.go('/$teamName/threads');
                              }
                            },
                          ),
                          ListenableBuilder(
                            listenable: getIt<DraftStorageService>(),
                            builder: (context, _) => _GlobalSectionLink(
                              icon: Icons.edit_outlined,
                              label: l10n.draftsSidebarLink,
                              badgeCount: getIt<DraftStorageService>()
                                  .channelsWithDrafts
                                  .length,
                              onTap: () {
                                final teamName = _teamName(context);
                                if (teamName != null) {
                                  context.go('/$teamName/drafts');
                                }
                              },
                            ),
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
                          DirectMessageCategoryWidget(
                            categoryId: dmCategoryId,
                            dmCategory: dmCategory,
                            channels: dmChannels,
                            unreadCounts: widget.unreadCounts,
                            selectedChannelId: widget.selectedChannelId,
                            currentUserId: widget.currentUserId,
                            mutedChannelIds: widget.mutedChannelIds,
                            onChannelTap: (ch) => openChannelIn(context, ch),
                            onMoveChannel: (channelId, fromId) =>
                                _moveChannel(
                                  context,
                                  channelId,
                                  fromId,
                                  dmCategoryId,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
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
      isCollapsed: isCollapsed.putIfAbsent(categoryId, () => false),
      title: title,
      channels: rows,
      unreadCounts: widget.unreadCounts,
      selectedChannelId: widget.selectedChannelId,
      onChannelTap: (ch) => openChannelIn(context, ch),
      category: widget.categories.where((c) => c.id == categoryId).firstOrNull,
      userId: widget.currentUserId,
      teamId: teamId ?? '',
      mutedChannelIds: widget.mutedChannelIds,
      onToggleChanged: (value) =>
          isCollapsed.putIfAbsent(categoryId, () => value),
      onMoveChannel: (channelId, fromId) =>
          _moveChannel(context, channelId, fromId, categoryId),
    );
  }
}

class _GlobalSectionLink extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  /// عداد يظهر يمين الرابط (مثل عدد المسودات المحفوظة محلياً).
  final int? badgeCount;

  const _GlobalSectionLink({
    required this.icon,
    required this.label,
    required this.onTap,
    this.badgeCount,
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
            if (badgeCount != null && badgeCount! > 0) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: theme.mentionBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$badgeCount',
                  style: TextStyle(
                    color: theme.mentionColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
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
