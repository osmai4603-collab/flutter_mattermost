import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_mattermost/app/layout/global_header.dart';
import 'package:flutter_mattermost/core/shortcuts/app_shortcuts.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/design_tokens.dart';
import 'package:flutter_mattermost/features/channels/presentation/widgets/channel_sidebar.dart';
import 'package:flutter_mattermost/features/channels/presentation/widgets/quick_switcher.dart';
import 'package:flutter_mattermost/features/chat/presentation/bloc/rhs_bloc.dart';
import 'package:flutter_mattermost/features/chat/presentation/rhs/rhs_container.dart';
import 'package:flutter_mattermost/features/teams/presentation/widgets/team_sidebar.dart';

/// الهيكل العام — مطابق grid الـ webapp (sass/base/_structure.scss):
/// "header" → GlobalHeader (44px)
/// "team-sidebar main app-sidebar" → TeamSidebar | LHS+center+RHS.
/// عند توسعة RHS (overlay) يغطي منطقة المحتوى كاملة فوق المركز.
class ChannelShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ChannelShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return AppShortcuts(
      onQuickSwitch: () => showQuickSwitcher(context),
      child: Scaffold(
        backgroundColor: theme.centerChannelBg,
        body: Column(
          children: [
            const GlobalHeader(),
            Expanded(
              child: BlocBuilder<RhsBloc, RhsState>(
                builder: (context, rhsState) {
                  final expanded =
                      rhsState is RhsPanelState && rhsState.isExpanded;
                  return Container(
                    color: theme.sidebarBg,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const TeamSidebar(),
                        const _ResizableLhs(),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsetsDirectional.only(
                              start: 8,
                              end: 4,
                              bottom: 8,
                            ),
                            padding: .all(4),
                            decoration: BoxDecoration(
                              color: theme.centerChannelBg,
                              borderRadius: .circular(8),
                            ),
                            child: Stack(
                              children: [
                                Positioned.fill(child: navigationShell),
                                if (expanded)
                                  Positioned.fill(
                                    child: const RhsContainer(overlay: true),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        if (!expanded) const RhsContainer(),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// لوحة LHS بعرض قابل للتحجيم — مطابق ResizableLhs في webapp:
/// افتراضي 264، min 200 / max 304، سحب من الحافة اليمنى،
/// نقرة مزدوجة على المقبض تعيد العرض الافتراضي.
class _ResizableLhs extends StatefulWidget {
  const _ResizableLhs();

  @override
  State<_ResizableLhs> createState() => _ResizableLhsState();
}

class _ResizableLhsState extends State<_ResizableLhs> {
  double _width = DesignTokens.lhsDefaultWidth;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return SizedBox(
      width: _width,
      child: Row(
        children: [
          Expanded(child: ChannelSidebar()),
          MouseRegion(
            cursor: SystemMouseCursors.resizeColumn,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onHorizontalDragUpdate: (details) {
                setState(() {
                  _width = (_width + details.delta.dx)
                      .clamp(DesignTokens.lhsMinWidth, DesignTokens.lhsMaxWidth)
                      .toDouble();
                });
              },
              onDoubleTap: () {
                setState(() {
                  _width = DesignTokens.lhsDefaultWidth;
                });
              },
              child: Container(
                width: 12,
                color: Colors.transparent,
                child: Center(
                  child: Container(
                    width: 2,
                    height: 32,
                    decoration: BoxDecoration(
                      color: theme.sidebarText.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
