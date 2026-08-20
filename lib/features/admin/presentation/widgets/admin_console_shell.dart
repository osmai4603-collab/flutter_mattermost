import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/app/routes/admin_console_route.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/admin_section.dart';
import 'package:flutter_mattermost/features/admin/presentation/widgets/admin_sidebar.dart';
import 'package:flutter_mattermost/features/teams/presentation/bloc/team_bloc.dart';
import 'package:go_router/go_router.dart';

class AdminConsoleShell extends StatefulWidget {
  final GoRouterState state;
  final Widget child;

  const AdminConsoleShell({
    super.key,
    required this.state,
    required this.child,
  });

  @override
  State<AdminConsoleShell> createState() => _AdminConsoleShellState();
}

class _AdminConsoleShellState extends State<AdminConsoleShell> {
  final ValueNotifier<Widget> bodyNotifier = ValueNotifier(Container());

  AdminConsoleSection _determineSelectedSection(String path) {
    for (final section in AdminConsoleSection.values) {
      final sectionPath = '${AdminConsoleRoutes.home}/${section.name}';
      if (path == sectionPath || path.startsWith('$sectionPath/')) {
        return section;
      }
    }
    return AdminConsoleSection.editionAndLicense;
  }

  void _onBack(BuildContext context) {
    final teamState = context.read<TeamBloc>().state;
    final teamName = teamState is TeamsLoadedState
        ? teamState.selectedTeam?.name
        : null;
    if (teamName != null) {
      context.go('/$teamName');
    } else {
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.of(context);
    final selectedSection = _determineSelectedSection(
      widget.state.matchedLocation,
    );
    final isMobile = MediaQuery.of(context).size.width < 768;

    if (isMobile) {
      return Scaffold(
        backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
        appBar: AppBar(
          backgroundColor: colors.mentionHighlightBg,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: colors.centerChannelColor),
            tooltip: 'Back',
            onPressed: () => _onBack(context),
          ),
          title: Text(
            selectedSection.name,
            style: TextStyle(color: colors.centerChannelColor, fontSize: 16),
          ),
        ),
        drawer: Drawer(
          width: 260,
          backgroundColor: colors.centerChannelBg,
          child: AdminConsoleSideBar(
            selected: selectedSection,
            onBodyChange: (value) => bodyNotifier.value = value,
          ),
        ),
        body: ValueListenableBuilder<Widget>(
          builder: (_, value, widget) {
            return value;
          },
          valueListenable: bodyNotifier,
        ),
      );
    }

    return Scaffold(
      body: Row(
        children: [
          AdminConsoleSideBar(
            selected: selectedSection,
            onBodyChange: (widget) => bodyNotifier.value = widget,
          ),
          Expanded(
            child: Container(
              color: const Color.fromRGBO(245, 245, 245, 1),
              child: ValueListenableBuilder<Widget>(
                builder: (_, value, widget) {
                  return value;
                },
                valueListenable: bodyNotifier,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
