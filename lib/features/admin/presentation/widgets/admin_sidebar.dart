import 'package:flutter/material.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/admin_section.dart';

class AdminConsoleSideBar extends StatelessWidget {
  const AdminConsoleSideBar({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final AdminConsoleSection selected;
  final ValueChanged<AdminConsoleSection> onSelected;

  @override
  Widget build(BuildContext context) {
    final groups = AdminConsoleSection.sectionsGroup;
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
            child: const Row(
              children: [
                Icon(
                  Icons.settings_outlined,
                  color: Colors.blueAccent,
                  size: 18,
                ),
                SizedBox(width: 8),
                Text(
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
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                for (final group in groups) ...[
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
                  for (final section in group.$2) _buildItem(section),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(AdminConsoleSection section) {
    final isSelected = selected == section;
    return InkWell(
      onTap: () => onSelected(section),
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
            Text(
              section.title,
              style: TextStyle(
                color: isSelected ? Colors.blueAccent : Colors.white70,
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
