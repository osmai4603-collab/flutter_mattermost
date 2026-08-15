import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_mattermost/features/channels/presentation/widgets/channel_global_header/channel_global_header.dart';
import 'package:flutter_mattermost/core/shortcuts/app_shortcuts.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/design_tokens.dart';
import 'package:flutter_mattermost/features/channels/presentation/widgets/channel_sidebar/channel_sidebar.dart';
import 'package:flutter_mattermost/features/chat/presentation/widgets/call_widget.dart';
import 'package:flutter_mattermost/features/chat/presentation/widgets/incoming_call_banner.dart';
import 'package:flutter_mattermost/features/channels/presentation/widgets/quick_switcher.dart';
import 'package:flutter_mattermost/features/channels/presentation/widgets/team_switcher.dart';
import 'package:flutter_mattermost/features/chat/presentation/bloc/rhs_bloc.dart';
import 'package:flutter_mattermost/features/chat/presentation/rhs/rhs_container.dart';

import 'package:flutter_mattermost/app/routes/integration_route.dart';
import 'package:flutter_mattermost/features/teams/presentation/bloc/team_bloc.dart';

/// الهيكل العام — مطابق grid الـ webapp (sass/base/_structure.scss):
/// "header" → GlobalHeader (44px)
/// "team-sidebar main app-sidebar" → TeamSwitcher | LHS+center+RHS.
/// عند توسعة RHS (overlay) يغطي منطقة المحتوى كاملة فوق المركز.
/// يستضيف (في Stack يغطي الجسم كاملاً) بطاقة المكالمة النشطة القابلة
/// للتحريك CallWidgetOverlay — عرضها يتبع عرض الـ LHS عبر ValueNotifier.
class ChannelShellLayout extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const ChannelShellLayout({super.key, required this.navigationShell});

  @override
  State<ChannelShellLayout> createState() => _ChannelShellLayoutState();
}

class _ChannelShellLayoutState extends State<ChannelShellLayout> {
  final ValueNotifier<double> _lhsWidth = ValueNotifier(
    DesignTokens.lhsDefaultWidth,
  );

  @override
  void dispose() {
    _lhsWidth.dispose();
    super.dispose();
  }

  void _goToTeamPage(BuildContext context, String path) {
    final teamState = context.read<TeamBloc>().state;
    final teamName = teamState is TeamsLoadedState
        ? teamState.selectedTeam?.name
        : null;
    if (teamName != null) {
      context.go(path.replaceAll(':team', teamName));
    } else {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return AppShortcuts(
      onQuickSwitch: () => showQuickSwitcher(context),
      // onSearch: () => showSearchBox(context),
      // onSearchFiles: () => showSearchBox(
      //   context,
      //   initialType: SearchResultType.files,
      // ),
      // onDrafts: () => _goToTeamPage(context, '/drafts'),
      onIntegrations: () => _goToTeamPage(context, IntegrationRoutes.root),
      onAdminConsole: () => context.go('/admin_console'),
      // onShortcuts: () => ModalRegistry.open(
      //   context,
      //   id: ModalIdentifiers.keyboardShortcuts,
      // ),
      child: Scaffold(
        backgroundColor: theme.sidebarBg,
        body: Stack(
          children: [
            Column(
              children: [
                const ChannelGlobalHeader(),
                Expanded(
                  child: BlocBuilder<RhsBloc, RhsState>(
                    builder: (context, rhsState) {
                      final expanded =
                          rhsState is RhsPanelState && rhsState.isExpanded;
                      return Container(
                        color: theme.sidebarBg,
                        margin: EdgeInsetsDirectional.only(end: 4, bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const TeamSwitcher(),
                            _ResizableLhs(widthNotifier: _lhsWidth),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsetsDirectional.only(
                                  start: 8,
                                ),
                                padding: .all(4),
                                decoration: BoxDecoration(
                                  color: theme.centerChannelBg,
                                  borderRadius: .circular(8),
                                ),
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: widget.navigationShell,
                                    ),
                                    if (expanded)
                                      Positioned.fill(
                                        child: const RhsContainer(
                                          overlay: true,
                                        ),
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
            // بطاقة المكالمة النشطة فوق كل شيء — قابلة للتحريك داخل
            // نافذة التطبيق، افتراضياً أسفل-يسار فوق منطقة الـ sidebar
            // (بنفس عرضه). تختفي تلقائياً عند انتهاء المكالمة.
            Positioned.fill(child: CallWidgetOverlay(lhsWidth: _lhsWidth)),
          ],
        ),
      ),
    );
  }
}

/// لوحة LHS بعرض قابل للتحجيم — مطابق ResizableLhs في webapp:
/// افتراضي 264، min 200 / max 304، سحب من الحافة اليمنى،
/// نقرة مزدوجة على المقبض تعيد العرض الافتراضي.
/// العرض يمرر لأعلى عبر widthNotifier ليستخدمه CallWidgetOverlay.
class _ResizableLhs extends StatefulWidget {
  final ValueNotifier<double> widthNotifier;

  const _ResizableLhs({required this.widthNotifier});

  @override
  State<_ResizableLhs> createState() => _ResizableLhsState();
}

class _ResizableLhsState extends State<_ResizableLhs> {
  late double _width = widget.widthNotifier.value;

  void _updateWidth(double newWidth) {
    setState(() {
      _width = newWidth;
      widget.widthNotifier.value = newWidth;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return SizedBox(
      width: _width,
      child: Row(
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                const ChannelSidebar(),
                // بطاقة المكالمة الواردة أسفل يسار الشاشة — بنفس عرض
                // الشريط الجانبي (مطابقة call widget في webapp: fixed
                // bottom-left فوق الـ sidebar). العرض يتبع تحجيم الـ LHS
                // تلقائياً لأنه داخل نفس الـ SizedBox.
                const Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: IncomingCallBanner(),
                ),
              ],
            ),
          ),
          MouseRegion(
            cursor: SystemMouseCursors.resizeColumn,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onHorizontalDragUpdate: (details) {
                _updateWidth(
                  (_width + details.delta.dx)
                      .clamp(DesignTokens.lhsMinWidth, DesignTokens.lhsMaxWidth)
                      .toDouble(),
                );
              },
              onDoubleTap: () {
                _updateWidth(DesignTokens.lhsDefaultWidth);
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
