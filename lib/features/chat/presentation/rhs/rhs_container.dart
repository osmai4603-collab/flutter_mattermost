import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/design_tokens.dart';
import 'package:flutter_mattermost/features/chat/presentation/bloc/rhs_bloc.dart';
import 'package:flutter_mattermost/features/chat/presentation/rhs/channel_files_panel.dart';
import 'package:flutter_mattermost/features/chat/presentation/rhs/channel_info_panel.dart';
import 'package:flutter_mattermost/features/chat/presentation/rhs/channel_members_panel.dart';
import 'package:flutter_mattermost/features/chat/presentation/rhs/mentions_panel.dart';
import 'package:flutter_mattermost/features/chat/presentation/rhs/saved_pinned_panel.dart';
import 'package:flutter_mattermost/features/chat/presentation/rhs/thread_panel_body.dart';

/// حاوية RHS الرئيسية — مطابقة RHSContainer.tsx في webapp:
/// عرض قابل للسحب (304–776) + توسعة overlay + رأس موحد (رجوع/عنوان/توسعة/إغلاق)
/// + جسم حسب اللوحة (thread/search/mentions/pinned/flagged/files/info/members).
class RhsContainer extends StatefulWidget {
  final bool overlay;

  const RhsContainer({super.key, this.overlay = false});

  @override
  State<RhsContainer> createState() => _RhsContainerState();
}

class _RhsContainerState extends State<RhsContainer> {
  double _width = DesignTokens.rhsDefaultWidth;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return BlocBuilder<RhsBloc, RhsState>(
      builder: (context, state) {
        if (state is! RhsPanelState) return const SizedBox.shrink();

        final content = Column(
          children: [
            _RhsHeader(state: state),
            Expanded(child: _RhsBody(state: state)),
          ],
        );

        if (widget.overlay) {
          return Container(
            color: theme.centerChannelBg,
            child: content,
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _RhsResizer(
              onDrag: (dx) => setState(() {
                _width =
                    (_width - dx)
                        .clamp(
                          DesignTokens.rhsMinWidth,
                          DesignTokens.rhsMaxWidth,
                        )
                        .toDouble();
              }),
            ),
            AnimatedContainer(
              duration: DesignTokens.rhsSlideDuration,
              curve: Curves.easeInOut,
              width: _width,
              decoration: BoxDecoration(
                color: theme.centerChannelBg,
                border: Border(
                  left: BorderSide(
                    color: theme.centerChannelColor.withValues(alpha: 0.1),
                  ),
                ),
              ),
              child: content,
            ),
          ],
        );
      },
    );
  }
}

/// مقبض السحب على الحافة اليسرى للـ RHS (تغيير العرض).
class _RhsResizer extends StatelessWidget {
  final ValueChanged<double> onDrag;
  const _RhsResizer({required this.onDrag});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.resizeLeftRight,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onHorizontalDragUpdate: (details) => onDrag(details.delta.dx),
        child: const SizedBox(width: 3),
      ),
    );
  }
}

/// رأس RHS الموحد: رجوع، عنوان، توسعة/طي، إغلاق.
class _RhsHeader extends StatelessWidget {
  final RhsPanelState state;
  const _RhsHeader({required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);
    final rhsBloc = context.read<RhsBloc>();

    return Container(
      height: DesignTokens.rhsHeaderHeight,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.centerChannelColor.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          if (rhsBloc.hasPreviousPanels)
            IconButton(
              icon: Icon(
                Icons.arrow_back,
                size: 20,
                color: theme.centerChannelColor.withValues(alpha: 0.7),
              ),
              tooltip: l10n.rhs_headerBackIcon,
              onPressed: () => rhsBloc.add(GoBackRhsEvent()),
            )
          else
            const SizedBox(width: 48),
          Icon(
            _panelIcon(state.panel),
            size: 18,
            color: theme.centerChannelColor.withValues(alpha: 0.7),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _panelTitle(l10n, state.panel),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: theme.centerChannelColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (state.panel.expands)
            IconButton(
              icon: Icon(
                state.isExpanded
                    ? Icons.fullscreen_exit
                    : Icons.fullscreen,
                size: 20,
                color: theme.centerChannelColor.withValues(alpha: 0.7),
              ),
              tooltip: state.isExpanded
                  ? l10n.rhs_headerCollapseSidebarTooltip
                  : l10n.rhs_headerExpandSidebarTooltip,
              onPressed: () => rhsBloc.add(ToggleRhsExpandedEvent()),
            ),
          IconButton(
            icon: Icon(
              Icons.close,
              size: 20,
              color: theme.centerChannelColor.withValues(alpha: 0.7),
            ),
            tooltip: l10n.rhs_headerCloseSidebarTooltip,
            onPressed: () => rhsBloc.add(CloseRhsEvent()),
          ),
        ],
      ),
    );
  }

  IconData _panelIcon(RhsPanel panel) => switch (panel) {
    RhsPanel.thread => Icons.chat_bubble_outline,
    RhsPanel.search => Icons.search,
    RhsPanel.mention => Icons.alternate_email,
    RhsPanel.pinned => Icons.push_pin_outlined,
    RhsPanel.flagged => Icons.bookmark_outline,
    RhsPanel.channelFiles => Icons.folder_outlined,
    RhsPanel.channelInfo => Icons.info_outline,
    RhsPanel.channelMembers => Icons.group_outlined,
    RhsPanel.editHistory => Icons.history,
    RhsPanel.plugin => Icons.extension_outlined,
  };

  String _panelTitle(AppLocalizations l10n, RhsPanel panel) => switch (panel) {
    RhsPanel.thread => l10n.rhsThread,
    RhsPanel.search => l10n.search_headerSearch,
    RhsPanel.mention => l10n.search_headerMentions,
    RhsPanel.pinned => l10n.search_headerPinnedMessages,
    RhsPanel.flagged => l10n.search_headerSavedMessages,
    RhsPanel.channelFiles => l10n.search_headerChannelFiles,
    RhsPanel.channelInfo => l10n.channel_info_rhsHeaderTitle,
    RhsPanel.channelMembers => l10n.channelHeaderMembers,
    RhsPanel.editHistory => l10n.search_headerTitle_editHistory,
    RhsPanel.plugin => l10n.rhsPluginPanelTitle,
  };
}

/// جسم اللوحة حسب النوع.
class _RhsBody extends StatelessWidget {
  final RhsPanelState state;
  const _RhsBody({required this.state});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return switch (state.panel) {
      RhsPanel.thread => const ThreadPanelBody(),
      RhsPanel.search => _SearchBody(searchTerms: (state as RhsListState).searchTerms),
      RhsPanel.mention => const MentionsPanel(),
      RhsPanel.pinned => SavedPinnedPanel(isPinned: true),
      RhsPanel.flagged => _NoResultsBody(
        title: l10n.no_resultsFlagged_postsTitle,
        subtitle: l10n.no_resultsFlagged_postsSubtitle(l10n.postMenuFlag),
      ),
      RhsPanel.channelFiles => const ChannelFilesPanel(),
      RhsPanel.channelInfo => const ChannelInfoPanel(),
      RhsPanel.channelMembers => ChannelMembersPanel(
        channelId: (state as RhsChannelState).channelId,
      ),
      RhsPanel.editHistory => _NoResultsBody(
        title: l10n.search_headerTitle_editHistory,
        subtitle: l10n.rhsNoResultsEditHistory,
      ),
      RhsPanel.plugin => _NoResultsBody(
        title: l10n.rhsPluginPanelTitle,
        subtitle: l10n.rhsNoResultsPlugin,
      ),
    };
  }
}

/// حالة فارغة عامة (webapp no_results/*).
class _NoResultsBody extends StatelessWidget {
  final String title;
  final String subtitle;
  const _NoResultsBody({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.centerChannelColor,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.centerChannelColor.withValues(alpha: 0.6),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// لوحة البحث: حقل بحث + نتائج (إن وجدت) أو حالة فارغة.
class _SearchBody extends StatelessWidget {
  final String searchTerms;
  const _SearchBody({required this.searchTerms});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: TextField(
            autofocus: true,
            onChanged: (value) {
              context.read<RhsBloc>().add(UpdateRhsSearchTermsEvent(value));
            },
            style: TextStyle(color: theme.centerChannelColor, fontSize: 14),
            decoration: InputDecoration(
              hintText: l10n.search_barSearch_messages,
              hintStyle: TextStyle(
                color: theme.centerChannelColor.withValues(alpha: 0.5),
                fontSize: 14,
              ),
              prefixIcon: Icon(
                Icons.search,
                size: 18,
                color: theme.centerChannelColor.withValues(alpha: 0.6),
              ),
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(DesignTokens.radiusM),
              ),
            ),
          ),
        ),
        Expanded(
          child: searchTerms.trim().isEmpty
              ? _NoResultsBody(
                  title: l10n.search_headerSearch,
                  subtitle: l10n.no_resultsSearchSubtitle,
                )
              : _NoResultsBody(
                  title: l10n.search_headerResults,
                  subtitle: l10n.no_resultsSearchSubtitle,
                ),
        ),
      ],
    );
  }
}

