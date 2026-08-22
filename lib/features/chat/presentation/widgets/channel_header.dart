import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/enums/channel_category_type.dart';
import 'package:flutter_mattermost/core/enums/channel_type.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/modals/modal_identifiers.dart';
import 'package:flutter_mattermost/core/modals/modal_registry.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:flutter_mattermost/core/utils/mention_utils.dart';
import 'package:flutter_mattermost/core/utils/time_format.dart';
import 'package:flutter_mattermost/core/widgets/matter_button.dart';
import 'package:flutter_mattermost/core/widgets/matter_menu.dart';
import 'package:flutter_mattermost/features/auth/domain/entities/user_status_entity.dart';
import 'package:flutter_mattermost/features/channels/presentation/bloc/channel_bloc.dart';
import 'package:flutter_mattermost/features/channels/presentation/modals/channel_notifications_modal.dart';
import 'package:flutter_mattermost/features/chat/presentation/bloc/calls_bloc.dart'
    hide ToggleMuteEvent;
import 'package:flutter_mattermost/features/chat/presentation/bloc/rhs_bloc.dart';
import 'package:flutter_mattermost/features/chat/presentation/widgets/channel_header_text_popover.dart';
import 'package:flutter_mattermost/features/chat/presentation/widgets/pluggable_channel_header_slots.dart';
import 'package:flutter_mattermost/features/teams/presentation/bloc/team_bloc.dart';
import 'package:flutter_mattermost/features/users/domain/repositories/user_repository.dart';

/// رأس القناة — مطابق channel_header.tsx في webapp:
/// ارتفاع 56px، اسم القناة + نجمة المفضلة + وصف (مع Popover Markdown)،
/// شارة الضيوف، سطر آخر ظهور في الـ DM، وأزرار: الأعضاء (عدد حي) →
/// مكالمة → التنبيهات → المثبتات → بحث → معلومات → قائمة ⋮.
class ChannelHeader extends StatelessWidget {
  const ChannelHeader({super.key});

  /// ذاكرة مؤقتة لبيانات حالة شريك المحادثة المباشرة (حصرية بالـ DM).
  static final Map<String, UserStatusEntity> _dmStatusCache = {};

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);

    return BlocBuilder<ChannelBloc, ChannelState>(
      builder: (context, state) {
        final loaded = state is ChannelsLoadedState ? state : null;
        final channel = loaded?.selectedChannel;
        final channelDisplayName = channel == null
            ? ''
            : channel.type == ChannelType.direct
            ? formatMemberName(channel.displayName)
            : channel.displayName;

        final isFavorited =
            channel != null &&
            loaded!.categories
                .where((c) => c.type == ChannelCategoryType.favorites)
                .any((c) => c.channelIds.contains(channel.id));

        final stats = channel == null ? null : loaded!.channelStats[channel.id];
        final memberCount = stats?.memberCount ?? 0;
        final hasGuests = (stats?.guestsCount ?? 0) > 0;
        final pinnedCount = stats?.pinnedPostsCount ?? 0;

        final member = channel == null ? null : loaded?.members[channel.id];
        final isMuted = member?.notifyProps?.markUnread == 'mention';

        final headerText = channel == null
            ? ''
            : channel.header.isNotEmpty
            ? channel.header
            : channel.purpose;

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
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isCompact = constraints.maxWidth < 720;
              // يختفي بعض الأزرار الثانوية في النوافذ الضيقة.
              final isVeryCompact = constraints.maxWidth < 560;
              return Row(
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
                    child: ChannelHeaderTextPopover(
                      title: channel?.displayName ?? '',
                      text: headerText,
                      enabled: headerText.trim().isNotEmpty,
                      onEdit: channel == null
                          ? null
                          : () {
                              ModalRegistry.open(
                                context,
                                id: ModalIdentifiers.editChannelHeader,
                              );
                            },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  channelDisplayName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: theme.centerChannelColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              if (hasGuests && channel != null) ...[
                                const SizedBox(width: 6),
                                GuestsBadge(
                                  isGroupMessage:
                                      channel.type == ChannelType.group,
                                ),
                              ],
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
                                    isFavorited
                                        ? Icons.star
                                        : Icons.star_border,
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
                          if (channel != null &&
                              channel.type != ChannelType.direct)
                            channelSubtitleText(channel, l10n, theme),
                          if (channel != null &&
                              channel.type == ChannelType.direct)
                            _DmLastOnline(
                              channel: channel,
                              myId: loaded!.userId,
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
                          color: theme.centerChannelColor.withValues(
                            alpha: 0.7,
                          ),
                        ),
                        if (memberCount > 0)
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Text(
                              '$memberCount',
                              style: TextStyle(
                                color: theme.centerChannelColor.withValues(
                                  alpha: 0.7,
                                ),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  // حقن الإضافات (PluggableChannelHeaderSlots) بعد زر الأعضاء.
                  ...ChannelHeaderSlots.buildIconSlots(context, channel),
                  if (!isCompact && channel != null)
                    MatterButton(
                      size: MatterButtonSize.icon,
                      transparent: true,
                      tooltip: l10n.channelHeaderStartCall,
                      onPressed: () {
                        context.read<CallsBloc>().add(
                          StartCallEvent(channel.id),
                        );
                      },
                      child: Icon(
                        Icons.phone_outlined,
                        size: 20,
                        color: theme.centerChannelColor.withValues(alpha: 0.7),
                      ),
                    ),
                  if (!isCompact && channel != null)
                    MatterButton(
                      size: MatterButtonSize.icon,
                      transparent: true,
                      tooltip: l10n.channel_headerRecentMentions,
                      onPressed: () {
                        context.read<RhsBloc>().add(ShowMentionsEvent());
                      },
                      child: Icon(
                        Icons.alternate_email,
                        size: 20,
                        color: theme.centerChannelColor.withValues(alpha: 0.7),
                      ),
                    ),
                  if (!isCompact && channel != null)
                    MatterButton(
                      size: MatterButtonSize.icon,
                      transparent: true,
                      tooltip: l10n.channel_headerChannelFiles,
                      onPressed: () {
                        context.read<RhsBloc>().add(ShowChannelFilesEvent());
                      },
                      child: Icon(
                        Icons.insert_drive_file_outlined,
                        size: 20,
                        color: theme.centerChannelColor.withValues(alpha: 0.7),
                      ),
                    ),
                  if (!isVeryCompact && channel != null)
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
                  if (!isVeryCompact)
                    MatterButton(
                      size: MatterButtonSize.icon,
                      transparent: true,
                      tooltip: l10n.channel_headerPinnedPosts,
                      onPressed: () {
                        context.read<RhsBloc>().add(ShowPinnedPostsEvent());
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.push_pin_outlined,
                            size: 18,
                            color: theme.centerChannelColor.withValues(
                              alpha: 0.7,
                            ),
                          ),
                          if (pinnedCount > 0)
                            Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: Text(
                                '$pinnedCount',
                                style: TextStyle(
                                  color: theme.centerChannelColor.withValues(
                                    alpha: 0.7,
                                  ),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
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
                        id: 'mute',
                        label: isMuted
                            ? l10n.channel_headerUnmute
                            : l10n.channel_headerMute,
                        icon: Icon(
                          isMuted
                              ? Icons.volume_up_outlined
                              : Icons.volume_off_outlined,
                          size: 18,
                        ),
                        onTap: channel == null
                            ? null
                            : () {
                                context.read<ChannelBloc>().add(
                                  ToggleMuteEvent(
                                    channelId: channel.id,
                                    userId: loaded!.userId,
                                  ),
                                );
                              },
                      ),
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
                        id: 'invite',
                        label: l10n.invite_modalInvite,
                        icon: const Icon(
                          Icons.person_add_alt_1_outlined,
                          size: 18,
                        ),
                        onTap: channel == null
                            ? null
                            : () {
                                ModalRegistry.open(
                                  context,
                                  id: ModalIdentifiers.channelInvite,
                                  args: {'channel': channel},
                                );
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
                      MatterMenuItem(
                        id: 'mentions',
                        label: l10n.channel_headerRecentMentions,
                        icon: const Icon(Icons.alternate_email, size: 18),
                        onTap: () {
                          context.read<RhsBloc>().add(ShowMentionsEvent());
                        },
                      ),
                      MatterMenuItem(
                        id: 'files',
                        label: l10n.channel_headerChannelFiles,
                        icon: const Icon(
                          Icons.insert_drive_file_outlined,
                          size: 18,
                        ),
                        onTap: () {
                          context.read<RhsBloc>().add(ShowChannelFilesEvent());
                        },
                      ),
                      MatterMenuItem(
                        id: 'leave',
                        label: l10n.channel_headerLeave,
                        icon: const Icon(
                          Icons.logout,
                          size: 18,
                          color: Colors.red,
                        ),
                        separatorBefore: true,
                        onTap: channel == null
                            ? null
                            : () {
                                context.read<ChannelBloc>().add(
                                  LeaveChannelEvent(
                                    channelId: channel.id,
                                    userId: loaded!.userId,
                                  ),
                                );
                              },
                      ),
                    ],
                    child: Tooltip(
                      message: l10n.channelHeaderMore,
                      child: Padding(
                        padding: const EdgeInsets.all(7),
                        child: Icon(
                          Icons.more_horiz,
                          size: 20,
                          color: theme.centerChannelColor.withValues(
                            alpha: 0.7,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  /// سطر الوصف (Header أو Purpose) — سطر واحد مع علامة إخفاء.
  Widget channelSubtitleText(
    dynamic channel,
    AppLocalizations l10n,
    MattermostColors theme,
  ) {
    final text = channel.header.isNotEmpty ? channel.header : channel.purpose;
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: theme.centerChannelColor.withValues(alpha: 0.6),
        fontSize: 12,
      ),
    );
  }

  void _copyChannelLink(BuildContext context, channel) {
    final teamState = context.read<TeamBloc>().state;
    final teamName = teamState is TeamsLoadedState
        ? teamState.selectedTeam?.name
        : null;
    final channelName = channel?.name;
    final link = teamName != null && channelName != null
        ? '/$teamName/channels/$channelName'
        : '';
    Clipboard.setData(ClipboardData(text: link));
  }
}

/// شارة تنبيه لوجود ضيوف في القناة — يطابق hasGuestsTag في webapp
/// (مع tooltip "Channel has guests" / "This group message has guests").
class GuestsBadge extends StatelessWidget {
  final bool isGroupMessage;
  const GuestsBadge({super.key, required this.isGroupMessage});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);
    return Tooltip(
      message: isGroupMessage
          ? l10n.channel_headerGroupMessageHasGuests
          : l10n.channel_headerChannelHasGuests,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
        decoration: BoxDecoration(
          color: theme.mentionColor.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(Icons.person_outline, size: 13, color: theme.mentionColor),
      ),
    );
  }
}

/// سطر "آخر ظهور" في المحادثات المباشرة — مطابق channel_headerLastOnline
/// في webapp: يُعرض فقط عندما يكون الطرف المقابل غير متصل ولديه نشاط سابق.
class _DmLastOnline extends StatelessWidget {
  final dynamic channel;
  final String myId;

  const _DmLastOnline({required this.channel, required this.myId});

  /// معرف الطرف المقابل من اسم قناة الـ DM ({myId}__{partnerId}).
  String? get _partnerId {
    final name = channel.name;
    final start = '${myId}__';
    if (name.startsWith(start)) return name.substring(start.length);
    final end = '__$myId';
    if (name.endsWith(end)) {
      return name.substring(0, name.length - end.length);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);
    final partnerId = _partnerId;
    if (partnerId == null || partnerId.isEmpty) {
      return const SizedBox.shrink();
    }
    final cached = ChannelHeader._dmStatusCache[partnerId];
    if (cached != null) {
      return _line(cached, theme, l10n);
    }
    return FutureBuilder<UserStatusEntity?>(
      future: getIt<UserRepository>()
          .getStatusesByIds([partnerId])
          .then((list) => list.firstOrNull),
      builder: (context, snapshot) {
        final status = snapshot.data;
        if (status == null) return const SizedBox.shrink();
        ChannelHeader._dmStatusCache[partnerId] = status;
        return _line(status, theme, l10n);
      },
    );
  }

  Widget _line(
    UserStatusEntity status,
    MattermostColors theme,
    AppLocalizations l10n,
  ) {
    if (status.status != UserStatus.offline || status.lastActivityAt <= 0) {
      return const SizedBox.shrink();
    }
    final color = theme.centerChannelColor.withValues(alpha: 0.6);
    return Text(
      l10n.channel_headerLastOnline(
        formatRelativeTime(status.lastActivityAt, l10n),
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(color: color, fontSize: 12),
    );
  }
}
