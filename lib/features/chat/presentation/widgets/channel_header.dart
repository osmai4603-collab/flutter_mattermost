import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/enums/channel_category_type.dart';
import 'package:flutter_mattermost/core/enums/channel_type.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/widgets/matter_button.dart';
import 'package:flutter_mattermost/core/widgets/matter_menu.dart';
import 'package:flutter_mattermost/features/channels/domain/repositories/channel_repository.dart';
import 'package:flutter_mattermost/features/channels/presentation/bloc/channel_bloc.dart';
import 'package:flutter_mattermost/features/channels/presentation/modals/channel_notifications_modal.dart';
import 'package:flutter_mattermost/features/chat/presentation/bloc/calls_bloc.dart';
import 'package:flutter_mattermost/features/chat/presentation/bloc/rhs_bloc.dart';
import 'package:flutter_mattermost/features/teams/presentation/bloc/team_bloc.dart';

/// رأس القناة — مطابق channel_header.tsx في webapp:
/// ارتفاع 56px، اسم القناة + نجمة المفضلة + وصف، وأزرار: الأعضاء (مع العدد) →
/// مكالمة → التنبيهات → بحث → معلومات القناة → قائمة ⋮
/// (نسخ الرابط، معلومات القناة، الرسائل المثبتة).
class ChannelHeader extends StatelessWidget {
  const ChannelHeader({super.key});

  /// ذاكرة مؤقتة لعدد أعضاء القناة (لتجنب إعادة الاتصال عند كل إعادة بناء).
  static final Map<String, int> _memberCountCache = {};

  static Future<int> _fetchMemberCount(String channelId) async {
    final cached = _memberCountCache[channelId];
    if (cached != null) return cached;
    try {
      final stats = await getIt<ChannelRepository>().getChannelStats(channelId);
      _memberCountCache[channelId] = stats.memberCount;
      return stats.memberCount;
    } catch (_) {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);

    return BlocBuilder<ChannelBloc, ChannelState>(
      builder: (context, state) {
        final loaded = state is ChannelsLoadedState ? state : null;
        final channel = loaded?.selectedChannel;

        final isFavorited = channel != null &&
            loaded!.categories
                .where((c) => c.type == ChannelCategoryType.favorites)
                .any((c) => c.channelIds.contains(channel.id));

        return Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: theme.centerChannelBg,
            border: Border(
              bottom: BorderSide(
                color: theme.centerChannelColor.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              Icon(
                channel == null
                    ? Icons.tag
                    : channel.type == ChannelType.direct
                    ? Icons.person_outline
                    : channel.type == ChannelType.private
                    ? Icons.lock_outline
                    : Icons.tag,
                size: 20,
                color: theme.centerChannelColor.withValues(alpha: 0.7),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: InkWell(
                  onTap: channel == null
                      ? null
                      : () {
                          context
                              .read<RhsBloc>()
                              .add(ShowChannelInfoEvent());
                        },
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            channel?.displayName ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: theme.centerChannelColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (channel != null)
                          MatterButton(
                            size: MatterButtonSize.icon,
                            transparent: true,
                            padding: const EdgeInsets.all(2),
                            tooltip: isFavorited
                                ? l10n.channel_headerUnfavorite
                                : l10n.channel_headerFavorite,
                            onPressed: () {
                              final loadedState = loaded;
                              if (loadedState == null) return;
                              context.read<ChannelBloc>().add(
                                ToggleFavoriteEvent(
                                  channelId: channel.id,
                                  userId: loadedState.userId,
                                  teamId: loadedState.teamId,
                                ),
                              );
                            },
                            child: Icon(
                              isFavorited ? Icons.star : Icons.star_border,
                              size: 18,
                              color: isFavorited
                                  ? Colors.amber
                                  : theme.centerChannelColor.withValues(
                                      alpha: 0.7,
                                    ),
                            ),
                          ),
                      ],
                    ),
                    if (channel != null && channel.type != ChannelType.direct)
                      Text(
                        channel.header.isNotEmpty
                            ? channel.header
                            : channel.purpose,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: theme.centerChannelColor.withValues(
                            alpha: 0.6,
                          ),
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
                ),
              ),
              const SizedBox(width: 8),
              MatterButton(
                size: MatterButtonSize.icon,
                transparent: true,
                tooltip: l10n.channelHeaderMembers,
                onPressed: () {
                  context.read<RhsBloc>().add(ShowChannelMembersEvent());
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.group_outlined,
                      size: 20,
                      color: theme.centerChannelColor.withValues(alpha: 0.7),
                    ),
                    if (channel != null)
                      FutureBuilder<int>(
                        future: _fetchMemberCount(channel.id),
                        builder: (context, snapshot) {
                          final count = snapshot.data;
                          if (count == null || count == 0) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Text(
                              '$count',
                              style: TextStyle(
                                color: theme.centerChannelColor.withValues(
                                  alpha: 0.7,
                                ),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
              if (channel != null)
                MatterButton(
                  size: MatterButtonSize.icon,
                  transparent: true,
                  tooltip: l10n.channelHeaderStartCall,
                  onPressed: () {
                    context.read<CallsBloc>().add(StartCallEvent(channel.id));
                  },
                  child: Icon(
                    Icons.phone_outlined,
                    size: 20,
                    color: theme.centerChannelColor.withValues(alpha: 0.7),
                  ),
                ),
              if (channel != null)
                MatterButton(
                  size: MatterButtonSize.icon,
                  transparent: true,
                  tooltip: l10n.channelHeaderNotifications,
                  onPressed: () {
                    showDialog<void>(
                      context: context,
                      builder: (_) => const ChannelNotificationsModal(),
                    );
                  },
                  child: Icon(
                    Icons.notifications_none_outlined,
                    size: 20,
                    color: theme.centerChannelColor.withValues(alpha: 0.7),
                  ),
                ),
              MatterButton(
                size: MatterButtonSize.icon,
                transparent: true,
                tooltip: l10n.channelHeaderSearch,
                onPressed: () {
                  // بدء بحث من القناة الحالية: يُضاف in:<channel> تلقائيًا
                  // (مطابق LocalSearchTerms في webapp rhs_utils).
                  final channelState = context.read<ChannelBloc>().state;
                  final channel = channelState is ChannelsLoadedState
                      ? channelState.selectedChannel
                      : null;
                  final terms = channel == null
                      ? ''
                      : 'in:${channel.name} ';
                  context.read<RhsBloc>().add(
                    ShowSearchResultsEvent(terms),
                  );
                },
                child: Icon(
                  Icons.search,
                  size: 20,
                  color: theme.centerChannelColor.withValues(alpha: 0.7),
                ),
              ),
              MatterButton(
                size: MatterButtonSize.icon,
                transparent: true,
                tooltip: l10n.channelHeaderChannelInfoTooltip,
                onPressed: channel == null
                    ? null
                    : () {
                        context.read<RhsBloc>().add(ShowChannelInfoEvent());
                      },
                child: Icon(
                  Icons.info_outline,
                  size: 20,
                  color: theme.centerChannelColor.withValues(alpha: 0.7),
                ),
              ),
              MatterMenuScope(
                openUp: true,
                items: [
                  MatterMenuItem(
                    id: 'copy_link',
                    label: l10n.channelHeaderCopyLink,
                    icon: const Icon(Icons.link, size: 18),
                    onTap: () => _copyChannelLink(context, channel),
                  ),
                  MatterMenuItem(
                    id: 'channel_info',
                    label: l10n.channelHeaderChannelInfo,
                    icon: const Icon(Icons.info_outline, size: 18),
                    onTap: () {
                      context.read<RhsBloc>().add(ShowChannelInfoEvent());
                    },
                  ),
                  MatterMenuItem(
                    id: 'pinned',
                    label: l10n.channel_headerPinnedPosts,
                    icon: const Icon(Icons.push_pin_outlined, size: 18),
                    separatorBefore: true,
                    onTap: () {
                      context.read<RhsBloc>().add(ShowPinnedPostsEvent());
                    },
                  ),
                ],
                child: MatterButton(
                  size: MatterButtonSize.icon,
                  transparent: true,
                  tooltip: l10n.channelHeaderMore,
                  onPressed: () {},
                  child: Icon(
                    Icons.more_horiz,
                    size: 20,
                    color: theme.centerChannelColor.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _copyChannelLink(BuildContext context, channel) {
    final teamState = context.read<TeamBloc>().state;
    final teamName = teamState is TeamsLoadedState
        ? teamState.selectedTeam?.name
        : null;
    final channelName = channel?.name;
    final link =
        teamName != null && channelName != null
        ? '/$teamName/channels/$channelName'
        : '';
    Clipboard.setData(ClipboardData(text: link));
  }
}