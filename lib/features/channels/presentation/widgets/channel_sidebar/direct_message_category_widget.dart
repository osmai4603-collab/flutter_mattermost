import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/core/enums/category_sorting.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/modals/modal_identifiers.dart';
import 'package:flutter_mattermost/core/modals/modal_registry.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/design_tokens.dart';
import 'package:flutter_mattermost/core/widgets/hover_widget.dart';
import 'package:flutter_mattermost/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_mattermost/features/auth/domain/entities/user_status_entity.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_category_entity.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_entity.dart';
import 'package:flutter_mattermost/features/channels/domain/repositories/channel_repository.dart';
import 'package:flutter_mattermost/features/channels/presentation/widgets/channel_sidebar/channel_sidebar.dart';
import 'package:flutter_mattermost/features/channels/presentation/widgets/channel_sidebar/direction_message_item_widget.dart';
import 'package:flutter_mattermost/features/channels/presentation/widgets/channel_sidebar/sidebar_category.dart';
import 'package:flutter_mattermost/features/chat/presentation/bloc/lhs_bloc.dart';
import 'package:flutter_mattermost/features/users/presentation/bloc/user_profile_bloc.dart';
import 'package:flutter_mattermost/features/users/presentation/bloc/user_status_bloc.dart';

/// فئة الرسائل المباشرة — صفوف بأفاتار/حالة المستخدم (متصل/غائب/عدم إزعاج/غير متصل)
/// وتحميل الحالات عبر UserStatusBloc.
class DirectMessageCategoryWidget extends StatefulWidget {
  final String categoryId;

  /// فئة الرسائل المباشرة من الخادم (قد تكون غائبة عند عدم وجودها).
  final ChannelCategoryEntity? dmCategory;
  final List<ChannelEntity> channels;
  final Map<String, ChannelUnreadCounts> unreadCounts;
  final String? selectedChannelId;
  final String currentUserId;
  final Set<String> mutedChannelIds;
  final void Function(ChannelEntity) onChannelTap;
  final void Function(String channelId, String fromCategoryId) onMoveChannel;

  const DirectMessageCategoryWidget({
    super.key,
    required this.categoryId,
    this.dmCategory,
    required this.channels,
    required this.unreadCounts,
    required this.selectedChannelId,
    required this.currentUserId,
    this.mutedChannelIds = const {},
    required this.onChannelTap,
    required this.onMoveChannel,
  });

  @override
  State<DirectMessageCategoryWidget> createState() =>
      _DirectMessageCategoryWidgetState();
}

class _DirectMessageCategoryWidgetState
    extends State<DirectMessageCategoryWidget> {
  @override
  void initState() {
    super.initState();
    _requestStatuses();
    _requestProfiles();
  }

  @override
  void didUpdateWidget(covariant DirectMessageCategoryWidget oldWidget) {
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
    if (widget.currentUserId.isNotEmpty) {
      context.read<UserStatusBloc>().add(
        LoadMyStatusEvent(widget.currentUserId),
      );
    }
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
                          child: HoverWidget(
                            builder: (context, isHovered) {
                              return Container(
                                height: 32,
                                padding: const EdgeInsetsDirectional.only(
                                  start: 8,
                                ),
                                child: Row(
                                  children: [
                                    AnimatedRotation(
                                      turns: collapsed ? 0 : 0.25, // -0.25 : 0,
                                      duration: const Duration(
                                        milliseconds: 180,
                                      ),
                                      child: Icon(
                                        Icons.chevron_right,
                                        size: 16,
                                        color: isHovered
                                            ? theme.sidebarText
                                            : theme.sidebarText.withValues(
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
                                          color: isHovered
                                              ? theme.sidebarText
                                              : theme.sidebarText.withValues(
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
                              );
                            },
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
                                        DirectionMessageItemWidget(
                                          channel: channel,
                                          isMuted: widget.mutedChannelIds
                                              .contains(channel.id),

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
                                      Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () => ModalRegistry.open(
                                            context,
                                            id: ModalIdentifiers
                                                .moreDirectChannels,
                                          ),
                                          child: SizedBox(
                                            height: DesignTokens
                                                .sidebarCategoryHeaderHeight,
                                            child: Row(
                                              children: [
                                                const SizedBox(width: 24),
                                                Icon(
                                                  Icons.add_box_rounded,
                                                  size: 18,
                                                  color: theme.sidebarText
                                                      .withValues(alpha: 0.65),
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  'Add Direct Message',
                                                  style: TextStyle(
                                                    color: theme.sidebarText
                                                        .withValues(
                                                          alpha: 0.65,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () => ModalRegistry.open(
                                            context,
                                            id: ModalIdentifiers
                                                .invitePeopleInTeam,
                                          ),
                                          child: SizedBox(
                                            height: DesignTokens
                                                .sidebarCategoryHeaderHeight,
                                            child: Row(
                                              children: [
                                                const SizedBox(width: 24),
                                                Icon(
                                                  Icons.person_add_outlined,
                                                  size: 18,
                                                  color: theme.sidebarText
                                                      .withValues(alpha: 0.65),
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  'Invite Members',
                                                  style: TextStyle(
                                                    color: theme.sidebarText
                                                        .withValues(
                                                          alpha: 0.65,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
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
