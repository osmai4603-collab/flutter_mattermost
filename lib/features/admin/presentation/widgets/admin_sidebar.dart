import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/features/admin/domain/entities/console_access_entity.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/admin_section.dart';
import 'package:flutter_mattermost/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_mattermost/features/teams/presentation/bloc/team_bloc.dart';
import 'package:go_router/go_router.dart';

/// القائمة الجانبية المحدثة للوحة التحكم (Admin Console Sidebar)
/// مصممة وفقاً لهيكل وتصميم Mattermost System Console في webapp.
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
  final Set<String> _collapsedCategories = {};

  @override
  void initState() {
    super.initState();
    _ensureSelectedCategoryExpanded();
  }

  @override
  void didUpdateWidget(covariant AdminConsoleSideBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selected != widget.selected) {
      _ensureSelectedCategoryExpanded();
    }
  }

  void _ensureSelectedCategoryExpanded() {
    for (final group in AdminConsoleSection.sectionsGroup) {
      final categoryTitle = group.$1;
      final sections = group.$3;
      if (sections.contains(widget.selected)) {
        _collapsedCategories.remove(categoryTitle);
        break;
      }
    }
  }

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

  void _toggleCategory(String title) {
    setState(() {
      if (_collapsedCategories.contains(title)) {
        _collapsedCategories.remove(title);
      } else {
        _collapsedCategories.add(title);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final groups = AdminConsoleSection.sectionsGroup;
    final authState = context.watch<AuthBloc>().state;
    final currentUser = authState is AuthenticatedState ? authState.user : null;
    final access = ConsoleAccessEntity.fromUserAndRoles(currentUser, []);

    const sidebarBg = Color(0xFF161922);
    const headerBg = Color(0xFF1B1E2B);
    const cardBg = Color(0xFF212433);

    return Container(
      width: 260,
      decoration: const BoxDecoration(
        color: sidebarBg,
        border: Border(
          right: BorderSide(color: Colors.white10, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header (User profile & System Console Title)
          _buildHeader(context, currentUser, headerBg),

          // 2. Search Field
          _buildSearchBar(cardBg),

          // 3. Main Sections List with Collapsible Categories
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
              children: [
                for (final group in groups) ...[
                  if (_hasMatchingSections(group.$3, currentUser, access))
                    _buildCategoryGroup(
                      title: group.$1,
                      categoryIcon: group.$2,
                      sections: group.$3,
                      currentUser: currentUser,
                      access: access,
                      cardBg: cardBg,
                    ),
                ],
              ],
            ),
          ),

          // 4. Footer Exit Button
          _buildFooter(context),
        ],
      ),
    );
  }

  /// رأس القائمة الجانبية بمظهر كروت المستخدم والتحكم
  Widget _buildHeader(
    BuildContext context,
    dynamic currentUser,
    Color headerBg,
  ) {
    final username = currentUser?.username ?? 'admin';
    final initial = username.isNotEmpty ? username[0].toUpperCase() : 'A';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 10, 14),
      decoration: BoxDecoration(
        color: headerBg,
        border: const Border(bottom: BorderSide(color: Colors.white10)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 17,
            backgroundColor: Colors.blueAccent.withValues(alpha: 0.25),
            child: Text(
              initial,
              style: const TextStyle(
                color: Colors.blueAccent,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'System Console',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '@$username',
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 11,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.close_rounded,
              color: Colors.white54,
              size: 20,
            ),
            tooltip: 'Exit System Console',
            onPressed: () => _onBack(context),
          ),
        ],
      ),
    );
  }

  /// شريط البحث "Find settings..."
  Widget _buildSearchBar(Color cardBg) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 6),
      child: TextField(
        controller: _searchController,
        onChanged: (val) =>
            setState(() => _searchQuery = val.trim().toLowerCase()),
        style: const TextStyle(color: Colors.white, fontSize: 12),
        decoration: InputDecoration(
          hintText: 'Find settings...',
          hintStyle: const TextStyle(color: Colors.white38, fontSize: 12),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: Colors.white38,
            size: 16,
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    Icons.clear,
                    color: Colors.white38,
                    size: 14,
                  ),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                )
              : null,
          filled: true,
          fillColor: cardBg,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 9,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.blueAccent, width: 1),
          ),
        ),
      ),
    );
  }

  /// مجموعة التصنيفات القابلة للطي والفتح (Accordion Category)
  Widget _buildCategoryGroup({
    required String title,
    required IconData categoryIcon,
    required List<AdminConsoleSection> sections,
    required dynamic currentUser,
    required ConsoleAccessEntity access,
    required Color cardBg,
  }) {
    final visibleSections = sections
        .where((s) => _isSectionVisible(s, currentUser, access))
        .toList();

    if (visibleSections.isEmpty) return const SizedBox.shrink();

    final isSearching = _searchQuery.isNotEmpty;
    final isExpanded = isSearching || !_collapsedCategories.contains(title);
    final hasSelectedSection = visibleSections.contains(widget.selected);

    return MarginPaddingContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: isSearching ? null : () => _toggleCategory(title),
            borderRadius: BorderRadius.circular(6),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: [
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_down_rounded
                        : Icons.keyboard_arrow_right_rounded,
                    color: hasSelectedSection
                        ? Colors.blueAccent
                        : Colors.white38,
                    size: 18,
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    categoryIcon,
                    color: hasSelectedSection
                        ? Colors.blueAccent
                        : Colors.white54,
                    size: 15,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: hasSelectedSection
                            ? Colors.white
                            : Colors.white60,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.7,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${visibleSections.length}',
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // العناصر الفرعية
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.only(top: 2, bottom: 4),
              child: Column(
                children: visibleSections
                    .map((section) => _buildItem(section))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }

  /// عنصر قسم فردي داخل التصنيف
  Widget _buildItem(AdminConsoleSection section) {
    final isSelected = widget.selected == section;

    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        child: InkWell(
          onTap: () => widget.onSelected(section),
          borderRadius: BorderRadius.circular(6),
          hoverColor: Colors.white.withValues(alpha: 0.04),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.blueAccent.withValues(alpha: 0.15)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                // الشريط النشط الأزرق الجانبي
                AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 3.5,
                  height: 16,
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blueAccent : Colors.transparent,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  section.icon,
                  color: isSelected ? Colors.blueAccent : Colors.white54,
                  size: 16,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    section.title,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white70,
                      fontSize: 12.5,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (section.isEnterprise)
                  Container(
                    margin: const EdgeInsets.only(left: 4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 1.5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.purpleAccent.withValues(alpha: 0.18),
                      border: Border.all(
                        color: Colors.purpleAccent.withValues(alpha: 0.4),
                        width: 0.8,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'ENT',
                      style: TextStyle(
                        color: Colors.purpleAccent,
                        fontSize: 8.5,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// زر الفوتر السفلي للعودة للورشة / الفريق
  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.white10)),
      ),
      child: InkWell(
        onTap: () => _onBack(context),
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          child: Row(
            children: const [
              Icon(
                Icons.arrow_back_rounded,
                color: Colors.blueAccent,
                size: 16,
              ),
              SizedBox(width: 8),
              Text(
                'Back to Workspace',
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isSectionVisible(
    AdminConsoleSection section,
    dynamic currentUser,
    ConsoleAccessEntity access,
  ) {
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

  bool _hasMatchingSections(
    List<AdminConsoleSection> sections,
    dynamic currentUser,
    ConsoleAccessEntity access,
  ) {
    return sections.any((s) => _isSectionVisible(s, currentUser, access));
  }
}

/// ويدجت تغليف الهامش والحاوية
class MarginPaddingContainer extends StatelessWidget {
  final Widget child;

  const MarginPaddingContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: child,
    );
  }
}
