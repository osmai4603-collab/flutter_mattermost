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
import 'package:flutter_mattermost/features/channels/domain/entities/channel_category_entity.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_entity.dart';
import 'package:flutter_mattermost/features/channels/domain/repositories/channel_repository.dart';
import 'package:flutter_mattermost/features/channels/presentation/widgets/channel_sidebar/channel_category_row.dart';
import 'package:flutter_mattermost/features/channels/presentation/widgets/channel_sidebar/sidebar_channel_row.dart';
import 'package:flutter_mattermost/features/chat/presentation/bloc/lhs_bloc.dart';

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
class SidebarCategory extends StatelessWidget {
  final String categoryId;
  final String title;
  final List<ChannelEntity> channels;
  final Map<String, ChannelUnreadCounts> unreadCounts;
  final String? selectedChannelId;
  final bool showNewDirectButton;
  final void Function(ChannelEntity) onChannelTap;

  /// كيان الفئة الحقيقية — null للقسم الافتراضي (غير مفهرسة في فئة).
  final ChannelCategoryEntity? category;
  final String userId;
  final String teamId;

  /// قنوات مكتومة (نصوصها تُعتَّم) — مطابق .muted في SidebarLink.
  final Set<String> mutedChannelIds;

  /// باني مفاتيح الصفوف — لقياس موضعها في مؤشرات غير المقروءة.
  final Key Function(ChannelEntity)? rowKeyBuilder;

  /// استدعاء عند إفلات قناة على هذه الفئة — يُمكّن السحب والإفلات.
  final void Function(String channelId, String fromCategoryId)? onMoveChannel;

  const SidebarCategory({
    super.key,
    required this.categoryId,
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
    this.rowKeyBuilder,
    this.onMoveChannel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);

    return MouseRegion(
      onEnter: (_) {},
      child: BlocBuilder<LhsBloc, LhsState>(
        builder: (context, lhsState) {
          final lhsCollapsed =
              lhsState is LhsSearchState &&
              lhsState.collapsedCategories.contains(categoryId);
          // حالة الطي: محلية (LhsBloc) أو محفوظة على الخادم (entity.collapsed).
          final collapsed = lhsCollapsed || (category?.collapsed ?? false);
          // القنوات مسبقة الفرز حسب ترتيب الفئة (تُفرز في channelSectionsFor
          // مرة واحدة لكل اشتقاق حالة، وليس في كل build هنا).

          return DragTarget<SidebarCategoryDragData>(
            onWillAcceptWithDetails: (details) {
              if (details.data.fromCategoryId == categoryId) return false;
              // منع الإفلات غير المسموح به (مطابق isDropDisabled في webapp).
              return !isSidebarDropDisabled(
                category?.type,
                details.data.channelType,
              );
            },
            onAcceptWithDetails: (details) {
              onMoveChannel?.call(
                details.data.channelId,
                details.data.fromCategoryId,
              );
            },
            builder: (context, candidateData, rejectedData) {
              final isDropTarget =
                  onMoveChannel != null &&
                  candidateData.isNotEmpty &&
                  !isSidebarDropDisabled(
                    category?.type,
                    candidateData.first?.channelType ??
                        DraggingChannelType.channel,
                  );

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ChannelCategoryRow(
                    categoryId: categoryId,
                    category: category,
                    userId: userId,
                    teamId: teamId,
                    title: title,
                    channels: channels,
                    unreadCounts: unreadCounts,
                    context: context,
                    collapsed: collapsed,
                    theme: theme,
                    l10n: l10n,
                  ),
                  AnimatedSize(
                    duration: DesignTokens.sidebarCollapseDuration,
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
                                    borderRadius: BorderRadius.circular(6),
                                  )
                                : null,
                            child: Column(
                              children: [
                                for (final channel in channels)
                                  _buildRow(channel, theme),
                              ],
                            ),
                          ),
                  ),
                  InkWell(
                    onTap: () => ModalRegistry.open(
                      context,
                      id: ModalIdentifiers.newChannel,
                    ),
                    child: Padding(
                      padding: EdgeInsetsDirectional.only(
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
                            'Add channel',
                            style: TextStyle(
                              color: theme.sidebarText.withValues(alpha: 0.70),
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
      ),
    );
  }

  Widget _buildRow(ChannelEntity channel, MattermostColors theme) {
    final row = SidebarChannelRow(
      channel: channel,
      unread: unreadCounts[channel.id],
      isSelected: channel.id == selectedChannelId,
      isMuted: mutedChannelIds.contains(channel.id),
      onTap: () => onChannelTap(channel),
      rowKey: rowKeyBuilder?.call(channel),
    );

    if (onMoveChannel == null) return row;

    final isDirect =
        channel.type == ChannelType.direct || channel.type == ChannelType.group;
    return LongPressDraggable<SidebarCategoryDragData>(
      data: SidebarCategoryDragData(
        channelId: channel.id,
        fromCategoryId: categoryId,
        channelType: isDirect
            ? DraggingChannelType.directMessage
            : DraggingChannelType.channel,
      ),
      feedback: Material(
        color: Colors.transparent,
        child: Container(
          // padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: theme.sidebarBg,
            // borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 8,
              ),
            ],
          ),
          child: Text(
            channel.displayName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: theme.sidebarText, fontSize: 14),
          ),
        ),
      ),
      childWhenDragging: Opacity(opacity: 0.3, child: row),
      child: row,
    );
  }
}

class _CategoryIconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  const _CategoryIconButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Tooltip(
        message: tooltip,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Icon(
            icon,
            size: 14,
            color: theme.sidebarText.withValues(alpha: 0.64),
          ),
        ),
      ),
    );
  }
}
