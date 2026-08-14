import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/app/routes/admin_console_route.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/admin_section.dart';
import 'package:flutter_mattermost/features/admin/presentation/widgets/admin_sidebar.dart';
import 'package:flutter_mattermost/features/teams/presentation/bloc/team_bloc.dart';
import 'package:go_router/go_router.dart';

class AdminConsoleShell extends StatelessWidget {
  final GoRouterState state;
  final Widget child;

  const AdminConsoleShell({
    super.key,
    required this.state,
    required this.child,
  });

  AdminConsoleSection _determineSelectedSection(String path) {
    for (final section in AdminConsoleSection.values) {
      final sectionPath = '${AdminConsoleRoutes.home}/${section.routeName}';
      if (path == sectionPath || path.startsWith('$sectionPath/')) {
        return section;
      }
    }
    return AdminConsoleSection.overview;
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
    final selectedSection = _determineSelectedSection(state.matchedLocation);
    final isMobile = MediaQuery.of(context).size.width < 768;

    if (isMobile) {
      return Scaffold(
        backgroundColor: const Color(0xFF1E1E2E),
        appBar: AppBar(
          backgroundColor: const Color(0xFF181825),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            tooltip: 'Back',
            onPressed: () => _onBack(context),
          ),
          title: Text(
            selectedSection.title,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
        drawer: Drawer(
          width: 260,
          backgroundColor: const Color(0xFF161922),
          child: AdminConsoleSideBar(
            selected: selectedSection,
            onSelected: (section) {
              Navigator.of(context).pop();
              context.go('${AdminConsoleRoutes.home}/${section.routeName}');
            },
          ),
        ),
        body: child,
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2E),
      body: Row(
        children: [
          AdminConsoleSideBar(
            selected: selectedSection,
            onSelected: (section) {
              context.go('${AdminConsoleRoutes.home}/${section.routeName}');
            },
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}
