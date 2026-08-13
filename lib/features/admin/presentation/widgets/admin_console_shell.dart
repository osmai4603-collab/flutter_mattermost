import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/admin_section.dart';
import 'package:flutter_mattermost/features/admin/presentation/widgets/admin_sidebar.dart';
import 'package:flutter_mattermost/features/teams/presentation/bloc/team_bloc.dart';
import 'package:go_router/go_router.dart';

class AdminConsoleShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const AdminConsoleShell({super.key, required this.navigationShell});

  void _onBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
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
  }

  @override
  Widget build(BuildContext context) {
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
          title: const Text(
            'Admin Console',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
        drawer: Drawer(
          child: AdminConsoleSideBar(
            selected: AdminConsoleSection.values[navigationShell.currentIndex],
            onSelected: (section) {
              Navigator.of(context).pop();
              navigationShell.goBranch(
                section.index,
                initialLocation: section == AdminConsoleSection.overview,
              );
            },
          ),
        ),
        body: navigationShell,
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2E),
      body: Row(
        children: [
          AdminConsoleSideBar(
            selected: AdminConsoleSection.values[navigationShell.currentIndex],
            onSelected: (section) {
              navigationShell.goBranch(
                section.index,
                initialLocation: section == AdminConsoleSection.overview,
              );
            },
          ),
          Expanded(child: navigationShell),
        ],
      ),
    );
  }
}
