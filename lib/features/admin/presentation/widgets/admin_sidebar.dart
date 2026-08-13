import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/features/admin/domain/entities/console_access_entity.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/admin_section.dart';
import 'package:flutter_mattermost/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_mattermost/features/teams/presentation/bloc/team_bloc.dart';
import 'package:go_router/go_router.dart';

class AdminConsoleSideBar extends StatefulWidget {
  const AdminConsoleSideBar({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final AdminConsoleSection selected;
  final ValueChanged<AdminConsoleSection> onSelected;

  @override
  State<AdminConsoleSideBar> createState() => _AdminConsoleSideBarState();
}

class _AdminConsoleSideBarState extends State<AdminConsoleSideBar> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
    final groups = AdminConsoleSection.sectionsGroup;
    final authState = context.watch<AuthBloc>().state;
    final currentUser = authState is AuthenticatedState ? authState.user : null;
    final access = ConsoleAccessEntity.fromUserAndRoles(currentUser, []);

    return Container(
      width: 250,
      color: const Color(0xFF181825),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.white12)),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white70, size: 20),
                  tooltip: 'Back',
                  onPressed: () => _onBack(context),
                ),
                const Icon(
                  Icons.settings_outlined,
                  color: Colors.blueAccent,
                  size: 18,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Admin Console',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val.trim().toLowerCase()),
              style: const TextStyle(color: Colors.white, fontSize: 12),
              decoration: InputDecoration(
                hintText: 'Find settings...',
                hintStyle: const TextStyle(color: Colors.white38, fontSize: 12),
                prefixIcon: const Icon(Icons.search, color: Colors.white38, size: 16),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white38, size: 14),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                filled: true,
                fillColor: const Color(0xFF1E1E2E),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(color: Colors.white12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(color: Colors.white12),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 4),
              children: [
                for (final group in groups) ...[
                  if (_hasMatchingSections(group.$2, currentUser, access)) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
                      child: Text(
                        group.$1,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    for (final section in group.$2)
                      if (_isSectionVisible(section, currentUser, access))
                        _buildItem(section),
                  ],
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _isSectionVisible(AdminConsoleSection section, dynamic currentUser, ConsoleAccessEntity access) {
    if (AdminAccessGuard.isSectionHidden(
      resourceKey: section.resourceKey,
      currentUser: currentUser,
      access: access,
      requiresEnterprise: section.isEnterprise,
    )) {
      return false;
    }
    if (_searchQuery.isEmpty) return true;
    return section.title.toLowerCase().contains(_searchQuery);
  }

  bool _hasMatchingSections(List<AdminConsoleSection> sections, dynamic currentUser, ConsoleAccessEntity access) {
    return sections.any((s) => _isSectionVisible(s, currentUser, access));
  }

  Widget _buildItem(AdminConsoleSection section) {
    final isSelected = widget.selected == section;
    return InkWell(
      onTap: () => widget.onSelected(section),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        color: isSelected
            ? Colors.blueAccent.withValues(alpha: 0.15)
            : Colors.transparent,
        child: Row(
          children: [
            if (isSelected)
              const Icon(
                Icons.chevron_right,
                color: Colors.blueAccent,
                size: 16,
              ),
            if (!isSelected) const SizedBox(width: 16),
            Expanded(
              child: Text(
                section.title,
                style: TextStyle(
                  color: isSelected ? Colors.blueAccent : Colors.white70,
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
            if (section.isEnterprise)
              Container(
                margin: const EdgeInsets.only(left: 4),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  color: Colors.purpleAccent.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'ENT',
                  style: TextStyle(
                    color: Colors.purpleAccent,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

