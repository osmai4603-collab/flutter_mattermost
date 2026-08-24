import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/core/enums/channel_category_type.dart';
import 'package:flutter_mattermost/core/enums/channel_type.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/modals/modal_identifiers.dart';
import 'package:flutter_mattermost/core/modals/modal_registry.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/design_tokens.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:flutter_mattermost/features/auth/data/models/user_model.dart';
import 'package:flutter_mattermost/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_mattermost/features/auth/domain/entities/user_status_entity.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_category_entity.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_entity.dart';
import 'package:flutter_mattermost/features/channels/domain/repositories/channel_repository.dart';
import 'package:flutter_mattermost/features/channels/presentation/bloc/channel_bloc.dart';
import 'package:flutter_mattermost/features/channels/presentation/widgets/channel_sidebar/channel_category_row.dart';
import 'package:flutter_mattermost/features/channels/presentation/widgets/channel_sidebar/channel_sidebar.dart';
import 'package:flutter_mattermost/features/channels/presentation/widgets/channel_sidebar/direction_message_item_widget.dart';
import 'package:flutter_mattermost/features/channels/presentation/widgets/channel_sidebar/sidebar_channel_item.dart';
import 'package:flutter_mattermost/features/chat/presentation/bloc/lhs_bloc.dart';
import 'package:flutter_mattermost/features/users/presentation/bloc/user_profile_bloc.dart';
import 'package:flutter_mattermost/features/users/presentation/bloc/user_status_bloc.dart';

/// نوع القناة المجرورة — مطابق DraggingStateTypes (DM/CHANNEL) في webapp:
/// يُستخدم لمنع الإفلات غير المسموح به (DM لا تُفلت في فئة القنوات والعكس).
enum DraggingChannelType {
  /// رسالة مباشرة أو محادثة جماعية (D/G).
  directMessage,

  /// قناة عامة أو خاصة (O/P).
  channel,
}

/// كائن يُرافَق أثناء السحب (LongPressDraggable) لنقل قناة بين الفئات.
class SidebarCategoryDragData {
  final String channelId;
  final String fromCategoryId;
  final DraggingChannelType channelType;

  const SidebarCategoryDragData({
    required this.channelId,
    required this.fromCategoryId,
    this.channelType = DraggingChannelType.channel,
  });
}

/// يقرر إن كان الإفلات على فئة [targetType] مرفوضاً لنوع السحب [draggedType] —
/// مطابق isDropDisabled في sidebar_category.tsx:
/// - الفئة المُدارة (managed): رفض دائم.
/// - فئة الرسائل المباشرة: رفض عند سحب قناة عادية/خاصة.
/// - فئة القنوات: رفض عند سحب DM/GM.
bool isSidebarDropDisabled(
  ChannelCategoryType? targetType,
  DraggingChannelType draggedType,
) {
  switch (targetType) {
    case ChannelCategoryType.managed:
      return true;
    case ChannelCategoryType.directMessages:
      return draggedType == DraggingChannelType.channel;
    case ChannelCategoryType.channels:
      return draggedType == DraggingChannelType.directMessage;
    case null:
      // الفئة الافتراضية (غير المهرّسة) تُعامل كفئة القنوات.
      return draggedType == DraggingChannelType.directMessage;
    case ChannelCategoryType.favorites:
    case ChannelCategoryType.custom:
      return false;
  }
}

/// فئة قابلة للطي — مطابق sidebar_category.tsx في webapp:
/// رأس 32px UPPERCASE 12px + طي بأنيميشن 180ms (height transition 0.18s).
/// تدعم سحب القنوات (long-press) نحو فئات أخرى عبر [onMoveChannel]،
/// وقائمة فئة (إعادة تسمية/كتم/حذف/إنشاء) عبر [category].
class SidebarCategory extends StatefulWidget {
  final String categoryId;
  final String title;
  final List<ChannelEntity> channels;
  final Map<String, ChannelUnreadCounts> unreadCounts;
  final bool isCollapsed;
  final String? selectedChannelId;
  final bool showNewDirectButton;
  final void Function(ChannelEntity) onChannelTap;

  /// كيان الفئة الحقيقية — null للقسم الافتراضي (غير مفهرسة في فئة).
  final ChannelCategoryEntity? category;
  final String userId;
  final String teamId;

  /// قنوات مكتومة (نصوصها تُعتَّم) — مطابق .muted في SidebarLink.
  final Set<String> mutedChannelIds;

  /// استدعاء عند إفلات قناة على هذه الفئة — يُمكّن السحب والإفلات.
  final void Function(String channelId, String fromCategoryId)? onMoveChannel;
  final void Function(bool) onToggleChanged;

  const SidebarCategory({
    super.key,
    required this.categoryId,
    required this.isCollapsed,
    required this.title,
    required this.channels,
    required this.unreadCounts,
    required this.selectedChannelId,
    required this.onChannelTap,
    required this.userId,
    required this.teamId,
    this.showNewDirectButton = true,
    this.category,
    this.mutedChannelIds = const {},
    this.onMoveChannel,
    required this.onToggleChanged,
  });

  @override
  State<SidebarCategory> createState() => _SidebarCategoryState();
}

class _SidebarCategoryState extends State<SidebarCategory> {
  bool isCollapsed = false;

  @override
  void initState() {
    super.initState();
    isCollapsed = widget.isCollapsed;
  }

  @override
  void didUpdateWidget(covariant SidebarCategory oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isCollapsed != widget.isCollapsed) {
      isCollapsed = widget.isCollapsed;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);
    final targetType = widget.category?.type;

    return DragTarget<SidebarCategoryDragData>(
      onWillAcceptWithDetails: (details) {
        if (details.data.fromCategoryId == widget.categoryId) return false;
        return !isSidebarDropDisabled(targetType, details.data.channelType);
      },
      onAcceptWithDetails: (details) {
        widget.onMoveChannel?.call(
          details.data.channelId,
          details.data.fromCategoryId,
        );
      },
      builder: (context, candidateData, rejectedData) {
        final isDropTarget = candidateData.isNotEmpty;
        return Container(
          decoration: isDropTarget
              ? BoxDecoration(
                  border: Border.all(
                    color: theme.sidebarTextActiveBorder,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(4),
                )
              : null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ChannelCategoryRow(
                categoryId: widget.categoryId,
                category: widget.category,
                userId: widget.userId,
                teamId: widget.teamId,
                title: widget.title,
                channels: widget.channels,
                unreadCounts: widget.unreadCounts,
                context: context,
                collapsed: isCollapsed,
                theme: theme,
                l10n: l10n,
                onToggleChanged: (value) {
                  setState(() => isCollapsed = value);
                  widget.onToggleChanged(value);
                },
              ),
              if (!isCollapsed)
                BlocBuilder<UserProfileBloc, UserProfileState>(
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
                    return BlocBuilder<UserStatusBloc, UserStatusState>(
                      builder: (context, statusState) {
                        final statuses = statusState is UserStatusesLoadedState
                            ? statusState.statuses
                            : const <String, UserStatus>{};

                        return Column(
                          children: [
                            for (final channel in widget.channels)
                              if (channel.type == ChannelType.direct ||
                                  channel.type == ChannelType.group)
                                _buildDirectChannelRow(
                                  context,
                                  channel,
                                  profiles,
                                  statuses,
                                )
                              else
                                SidebarChannelItem(
                                  channel: channel,
                                  unread: widget.unreadCounts[channel.id],
                                  isSelected:
                                      channel.id == widget.selectedChannelId,
                                  isMuted: widget.mutedChannelIds.contains(
                                    channel.id,
                                  ),
                                  onTap: () {
                                    widget.onChannelTap(channel);
                                  },
                                ),
                          ],
                        );
                      },
                    );
                  },
                ),
              InkWell(
                onTap: () {
                  final modalId =
                      widget.category?.type ==
                          ChannelCategoryType.directMessages
                      ? ModalIdentifiers.moreDirectChannels
                      : ModalIdentifiers.newChannel;
                  ModalRegistry.open(context, id: modalId);
                },
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: 24,
                    top: 4,
                    bottom: 4,
                  ),
                  child: Row(
                    spacing: 8,
                    children: [
                      Icon(
                        Icons.add_box_rounded,
                        size: 18,
                        color: theme.sidebarText.withValues(alpha: 0.70),
                      ),
                      Text(
                        widget.category?.type ==
                                ChannelCategoryType.directMessages
                            ? l10n.sidebarDirectMessages
                            : 'Add channel',
                        style: TextStyle(
                          color: theme.sidebarText.withValues(alpha: 0.70),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDirectChannelRow(
    BuildContext context,
    ChannelEntity channel,
    Map<String, UserEntity> profiles,
    Map<String, UserStatus> statuses,
  ) {
    final ids = dmCounterpartIds(channel, widget.userId);
    final partnerId = ids.firstOrNull ?? widget.userId;
    final user =
        profiles[partnerId] ??
        UserEntity(
          id: partnerId,
          username: dmUsernameFor(context, channel, widget.userId) ?? '',
        );
    final status = statuses[user.id];

    return DirectionMessageItemWidget(
      channel: channel,
      status: status,
      user: user,
      unread: widget.unreadCounts[channel.id],
      isSelected: channel.id == widget.selectedChannelId,
      isMuted: widget.mutedChannelIds.contains(channel.id),
      onTap: () => widget.onChannelTap(channel),
      draggableFrom: widget.categoryId,
    );
  }
}
