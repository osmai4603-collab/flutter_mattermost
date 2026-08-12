
import 'package:flutter/material.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/admin_section.dart';
import 'package:flutter_mattermost/features/admin/presentation/widgets/admin_sidebar.dart';
import 'package:go_router/go_router.dart';


class AdminConsoleShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const AdminConsoleShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          Expanded(
            child: navigationShell,
          ),
        ],
      ),
    );
  }
}