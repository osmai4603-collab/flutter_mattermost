import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_mattermost/core/enums/channel_category_type.dart';
import 'package:flutter_mattermost/core/enums/channel_type.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_category_entity.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_entity.dart';
import 'package:flutter_mattermost/features/channels/domain/repositories/channel_repository.dart';
import 'package:flutter_mattermost/features/channels/presentation/bloc/channel_bloc.dart';
import 'package:flutter_mattermost/features/channels/presentation/widgets/channel_navigator.dart';
import 'package:flutter_mattermost/features/channels/presentation/widgets/sidebar_category.dart';
import 'package:flutter_mattermost/features/channels/presentation/widgets/sidebar_header.dart';
import 'package:flutter_mattermost/features/chat/presentation/bloc/lhs_bloc.dart';
import 'package:flutter_mattermost/features/teams/presentation/bloc/team_bloc.dart';

/// الشريط الجانبي للقنوات (LHS) — مطابق channel_sidebar.tsx في webapp:
/// SidebarHeader + ChannelNavigator + فئات قابلة للطي (channels/DMs).
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
  final LhsSearchState lhs;

  const _ChannelSidebarBody({
    required this.channels,
    required this.categories,
    required this.unreadCounts,
    required this.selectedChannelId,
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

    final sections = channelSectionsFor(
      categories,
      channels,
      lhs.query,
      lhs.unreadsOnly,
      unreadCounts,
      l10n.sidebarChannels,
    );
    final dmChannels = [
      for (final ch in channels)
        if (ch.type == ChannelType.direct &&
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
                for (final (title, list) in sections)
                  if (list.isNotEmpty)
                    _buildCategory(
                      context,
                      categoryId: _categoryIdFor(title),
                      title: title,
                      rows: list,
                    ),
                if (dmChannels.isNotEmpty)
                  _buildCategory(
                    context,
                    categoryId: 'direct_messages',
                    title: l10n.sidebarDirectMessages,
                    rows: dmChannels,
                    showNewDirectButton: true,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategory(
    BuildContext context, {
    required String categoryId,
    required String title,
    required List<ChannelEntity> rows,
    bool showNewDirectButton = false,
  }) {
    final matching = [
      for (final c in categories)
        if (c.displayName == title &&
            c.type != ChannelCategoryType.directMessages) c.id,
    ];
    final resolvedId = matching.isNotEmpty ? matching.first : categoryId;
    return SidebarCategory(
      categoryId: resolvedId,
      title: title,
      channels: rows,
      unreadCounts: unreadCounts,
      selectedChannelId: selectedChannelId,
      showNewDirectButton: showNewDirectButton,
      onChannelTap: (ch) => _openChannel(context, ch),
    );
  }

  String _categoryIdFor(String title) {
    for (final c in categories) {
      if (c.displayName == title) {
        return c.id;
      }
    }
    return title;
  }
}

/// يبني أقسام الفئات + القنوات غير المفهرسة، مع تطبيق البحث/فلتر غير المقروء.
List<(String, List<ChannelEntity>)> channelSectionsFor(
  List<ChannelCategoryEntity> categories,
  List<ChannelEntity> channels,
  String query,
  bool unreadsOnly,
  Map<String, ChannelUnreadCounts> unreadCounts,
  String uncategorizedTitle,
) {
  final q = query.toLowerCase();
  bool matches(ChannelEntity ch) =>
      q.isEmpty ||
      ch.displayName.toLowerCase().contains(q) ||
      ch.name.toLowerCase().contains(q);
  bool hiddenByUnreads(ChannelEntity ch) =>
      unreadsOnly && !(unreadCounts[ch.id]?.hasUnreads ?? false);

  final cats = <(String, List<ChannelEntity>)>[
    for (final category in categories)
      if (category.type == ChannelCategoryType.custom ||
                  category.type == ChannelCategoryType.managed)
        (
          category.displayName,
          channels
              .where(
                (ch) =>
                    ch.type != ChannelType.direct &&
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
    cats.add((uncategorizedTitle, uncategorized));
  }
  return cats;
}
