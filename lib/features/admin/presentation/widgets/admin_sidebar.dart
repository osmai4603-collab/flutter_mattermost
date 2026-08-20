import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:flutter_mattermost/features/admin/domain/entities/console_access_entity.dart';
import 'package:flutter_mattermost/features/admin/domain/entities/resource_keys.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/admin_section.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/authentication/auth_email_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/compliance/data_retention_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/plugins/plugins_management_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/reporting/notifications_settings_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/reporting/server_logs_page.dart';
import 'package:flutter_mattermost/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_mattermost/features/auth/presentation/pages/signup_page.dart';
import 'package:flutter_mattermost/features/teams/presentation/bloc/team_bloc.dart';
import 'package:go_router/go_router.dart';

/// القائمة الجانبية المحدثة للوحة التحكم (Admin Console Sidebar)
/// مصممة وفقاً لهيكل وتصميم Mattermost System Console في webapp.
class AdminConsoleSideBar extends StatefulWidget {
  const AdminConsoleSideBar({
    super.key,
    required this.selected,
    required this.onBodyChange,
  });

  final AdminConsoleSection selected;
  final ValueChanged<Widget> onBodyChange;

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
    // final groups = AdminConsoleSection.sectionsGroup;
    final authState = context.watch<AuthBloc>().state;
    final currentUser = authState is AuthenticatedState ? authState.user : null;
    // final access = ConsoleAccessEntity.fromUserAndRoles(currentUser, []);
    final colors = AppTheme.of(context);

    final sidebarBg = colors.centerChannelColor;
    final headerBg = colors.centerChannelColor.withValues(alpha: 0.50);
    final cardBg = colors.centerChannelColor.withValues(alpha: 70);

    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: sidebarBg,
        border: Border(right: BorderSide(color: Colors.white10, width: 1)),
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
              padding: const EdgeInsets.symmetric(vertical: 6),
              children: [
                containerGroup(
                  title: ResourceKeys.about,
                  icon: Icons.info_outline_rounded,
                ),
                ...aboutGroupList(colors),
                containerGroup(
                  title: ResourceKeys.reporting,
                  icon: Icons.info_outline_rounded,
                ),
                ...reportingGroupList(colors),

                containerGroup(
                  title: ResourceKeys.userManagement,
                  icon: Icons.group_outlined,
                ),
                ...aboutGroupList(colors),

                containerGroup(
                  title: 'SYSTEM ATTRIBUTES',
                  icon: Icons.computer,
                ),
                ...systemAttributesGroupList(colors),

                containerGroup(title: 'ENVIRONMENT', icon: Icons.anchor),
                ...environmentGroupList(colors),

                containerGroup(
                  title: 'SITE CONFIGURATION',
                  icon: Icons.settings_outlined,
                ),
                ...siteConfigurationGroupList(colors),

                containerGroup(title: 'PLUGINS', icon: Icons.female),
                ...pluginsGroupList(colors),

                containerGroup(
                  title: 'AUTHENTICATION',
                  icon: Icons.safety_check,
                ),
                ...authenticationGroupList(colors),

                containerGroup(title: 'INTEGRATIONS', icon: Icons.menu),
                ...integrationsGroupList(colors),

                containerGroup(title: 'COMPLIANCE', icon: Icons.menu),
                ...complianceGroupList(colors),

                containerGroup(title: 'INTEGRATIONS', icon: Icons.menu),
                ...experimentalGroupList(colors),
              ],
            ),
          ),

          // 4. Footer Exit Button
          _buildFooter(context),
        ],
      ),
    );
  }

  List<Widget> experimentalGroupList(MattermostColors colors) {
    return [
      groupChild(
        title: 'Features',
        section: .features,
        colors: colors,
        onTap: () => Container(),
      ),
      groupChild(
        title: 'Feature Flags',
        section: .featureFlags,
        colors: colors,
        onTap: () => Container(),
      ),
    ];
  }

  List<Widget> complianceGroupList(MattermostColors colors) {
    return [
      groupChild(
        title: 'Data Retention Policies',
        section: .dataRetention,
        colors: colors,
        onTap: () => AdminConsoleDataRetentionPage(),
      ),
      groupChild(
        title: 'Compliance Export',
        section: .complianceExport,
        colors: colors,
        onTap: () => Container(),
      ),
      groupChild(
        title: 'Compliance Monitoring',
        section: .complicanceMonitoring,
        colors: colors,
        onTap: () => Container(),
      ),
      groupChild(
        title: 'Audit Logging',
        section: .auditLogging,
        colors: colors,
        onTap: () => Container(),
      ),
      groupChild(
        title: 'Custom Terms of Service',
        section: .customTermsOfService,
        colors: colors,
        onTap: () => Container(),
      ),
    ];
  }

  List<Widget> integrationsGroupList(MattermostColors colors) {
    return [
      groupChild(
        title: 'Integration Management',
        section: .integrationManagement,
        colors: colors,
        onTap: () => Container(),
      ),
      groupChild(
        title: 'Bot Accounts',
        section: .botAccounts,
        colors: colors,
        onTap: () => Container(),
      ),
      groupChild(
        title: 'GIF',
        section: .gif,
        colors: colors,
        onTap: () => Container(),
      ),
      groupChild(
        title: 'CORS',
        section: .cors,
        colors: colors,
        onTap: () => Container(),
      ),
      groupChild(
        title: 'Embedding',
        section: .embedding,
        colors: colors,
        onTap: () => Container(),
      ),
    ];
  }

  List<Widget> pluginsGroupList(MattermostColors colors) {
    return [
      groupChild(
        title: 'Plugin Management',
        section: .pluginsManagement,
        colors: colors,
        onTap: () => AdminConsolePluginsManagementPage(),
      ),
      groupChild(
        title: 'Agents',
        section: .agents,
        colors: colors,
        onTap: () => Container(),
      ),
      groupChild(
        title: 'Calls',
        section: .calls,
        colors: colors,
        onTap: () => Container(),
      ),
      groupChild(
        title: 'Playbooks',
        section: .playbooks,
        colors: colors,
        onTap: () => Container(),
      ),
    ];
  }

  List<Widget> authenticationGroupList(MattermostColors colors) {
    return [
      groupChild(
        title: 'Signup',
        section: .signup,
        colors: colors,
        onTap: () => SignupPage(),
      ),
      groupChild(
        title: 'Email',
        section: .email,
        colors: colors,
        onTap: () => EmailPage(),
      ),
      groupChild(
        title: 'Password',
        section: .password,
        colors: colors,
        onTap: () => Container(),
      ),
      groupChild(
        title: 'MFA',
        section: .mfa,
        colors: colors,
        onTap: () => Container(),
      ),
      groupChild(
        title: 'AD/LDAP',
        section: .adALDAP,
        colors: colors,
        onTap: () => Container(),
      ),
      groupChild(
        title: 'SAML 2.0',
        section: .saml,
        colors: colors,
        onTap: () => Container(),
      ),
      groupChild(
        title: 'OpenID Connect',
        section: .openIDConnect,
        colors: colors,
        onTap: () => Container(),
      ),
      groupChild(
        title: 'Gest Access',
        section: .guestAccess,
        colors: colors,
        onTap: () => Container(),
      ),
    ];
  }

  List<Widget> siteConfigurationGroupList(MattermostColors colors) {
    return [
      groupChild(
        title: 'Custimization',
        section: .customization,
        colors: colors,
        onTap: () => Container(),
      ),
      groupChild(
        title: 'Localizaion',
        section: .localization,
        colors: colors,
        onTap: () => Container(),
      ),
      groupChild(
        title: 'Users and Teams',
        section: .usersAndTeams,
        colors: colors,
        onTap: () => Container(),
      ),
      groupChild(
        title: 'Notifications',
        section: .notifications,
        colors: colors,
        onTap: () => AdminConsoleNotificationsSettingsPage(),
      ),
      groupChild(
        title: 'Classification Markings',
        section: .classificationMarkings,
        colors: colors,
        onTap: () => Container(),
      ),
      groupChild(
        title: 'System-wide Notifications',
        section: .systemWideNotifications,
        colors: colors,
        onTap: () => Container(),
      ),
      groupChild(
        title: 'Emoji',
        section: .emoji,
        colors: colors,
        onTap: () => Container(),
      ),
      groupChild(
        title: 'Posts',
        section: .posts,
        colors: colors,
        onTap: () => Container(),
      ),
      groupChild(
        title: 'Recap',
        section: .recap,
        colors: colors,
        onTap: () => Container(),
      ),
      groupChild(
        title: 'Data Spillage Handling',
        section: .dataSpillageHandling,
        colors: colors,
        onTap: () => Container(),
      ),
      groupChild(
        title: 'File Sharing and Downlods',
        section: .fileSharingAndDownloads,
        colors: colors,
        onTap: () => Container(),
      ),
      groupChild(
        title: 'Public Links',
        section: .publicLinks,
        colors: colors,
        onTap: () => Container(),
      ),
      groupChild(
        title: 'Notices',
        section: .notices,
        colors: colors,
        onTap: () => Container(),
      ),
    ];
  }

  List<Widget> environmentGroupList(MattermostColors colors) {
    return [
      groupChild(
        title: 'Web Server',
        section: .webServer,
        colors: colors,
        onTap: () => Container(),
      ),
      groupChild(
        title: 'Database',
        section: .database,
        colors: colors,
        onTap: () => Container(),
      ),
      groupChild(
        title: 'Elasticsearch',
        section: .elasticsearch,
        colors: colors,
        onTap: () => Container(),
      ),
      groupChild(
        title: 'File Storage',
        section: .fileStorage,
        colors: colors,
        onTap: () => Container(),
      ),
      groupChild(
        title: 'Image Proxy',
        section: .imageProxy,
        colors: colors,
        onTap: () => Container(),
      ),
      groupChild(
        title: 'SMTP',
        section: .smtp,
        colors: colors,
        onTap: () => Container(),
      ),
      groupChild(
        title: 'Push Notification Server',
        section: .pushNotificationsServer,
        colors: colors,
        onTap: () => Container(),
      ),
      groupChild(
        title: 'High Avaibility',
        section: .highAvailability,
        colors: colors,
        onTap: () => Container(),
      ),
      groupChild(
        title: 'Cache Settings',
        section: .cacheSettings,
        colors: colors,
        onTap: () => Container(),
      ),
      groupChild(
        title: 'Rate Limiting',
        section: .rateLimiting,
        colors: colors,
        onTap: () => Container(),
      ),
      groupChild(
        title: 'Logging',
        section: .logging,
        colors: colors,
        onTap: () => Container(),
      ),
      groupChild(
        title: 'Sessino Lengths',
        section: .sessionLengths,
        colors: colors,
        onTap: () => Container(),
      ),
      groupChild(
        title: 'Performance Monitoring',
        section: .performanceMonitoring,
        colors: colors,
        onTap: () => Container(),
      ),
      groupChild(
        title: 'Developer',
        section: .developer,
        colors: colors,
        onTap: () => Container(),
      ),
      groupChild(
        title: 'Mobile Security',
        section: .developer,
        colors: colors,
        onTap: () => Container(),
      ),
    ];
  }

  List<Widget> systemAttributesGroupList(MattermostColors colors) {
    return [
      groupChild(
        title: 'User Attributes',
        section: .userAttributes,
        colors: colors,
        onTap: () => Container(),
      ),
      groupChild(
        title: 'Attribute-Base Access',
        section: .systemStatistics,
        colors: colors,
        onTap: () => Container(),
      ),
    ];
  }

  List<Widget> aboutGroupList(MattermostColors colors) {
    return [
      groupChild(
        title: 'Edition and License',
        section: .editionAndLicense,
        colors: colors,
        onTap: () => Container(),
      ),
    ];
  }

  List<Widget> reportingGroupList(MattermostColors colors) {
    return [
      groupChild(
        title: 'WorkSpace Optimization',
        section: .workSpaceOptimization,
        colors: colors,
        onTap: () => Container(),
      ),
      groupChild(
        title: 'System Statistics',
        section: .systemStatistics,
        colors: colors,
        onTap: () => Container(),
      ),
      groupChild(
        title: 'Team Statistics',
        section: .teamStatistics,
        colors: colors,
        onTap: () => Container(),
      ),
      groupChild(
        title: 'Server Logs',
        section: .serverLogs,
        colors: colors,
        onTap: () => AdminConsoleServerLogsPage(),
      ),
    ];
  }

  List<Widget> userManagementGroupList(MattermostColors colors) {
    return [
      groupChild(
        title: 'Users',
        section: .users,
        colors: colors,
        onTap: () => Container(),
      ),
      groupChild(
        title: 'Groups',
        section: .groups,
        colors: colors,
        onTap: () => Container(),
      ),
      groupChild(
        title: 'Teams',
        section: .teams,
        colors: colors,
        onTap: () => Container(),
      ),
      groupChild(
        title: 'Channels',
        section: .channels,
        colors: colors,
        onTap: () => AdminConsoleServerLogsPage(),
      ),
      groupChild(
        title: 'Permissions',
        section: .permissions,
        colors: colors,
        onTap: () => AdminConsoleServerLogsPage(),
      ),
      groupChild(
        title: 'Delegated Granular Administration',
        section: .delegatedGranularAdministration,
        colors: colors,
        onTap: () => AdminConsoleServerLogsPage(),
      ),
    ];
  }

  Widget containerGroup({required String title, required IconData icon}) {
    final colors = AppTheme.of(context);
    return Container(
      height: 48,
      padding: .all(16),
      decoration: BoxDecoration(
        color: colors.centerChannelColor.withValues(alpha: 0.65),
      ),
      child: Row(
        spacing: 8,
        children: [
          Icon(icon, size: 18),
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 15,
              fontWeight: .w500,
              color: colors.centerChannelBg,
            ),
          ),
        ],
      ),
    );
  }

  Widget groupChild({
    required String title,
    required AdminConsoleSection section,
    required MattermostColors colors,
    required Widget Function() onTap,
  }) {
    final isSelected = widget.selected == section;
    return Material(
      color: isSelected
          ? colors.centerChannelColor.withValues(alpha: 0.40)
          : Colors.transparent,
      child: InkWell(
        onTap: () {
          widget.onBodyChange(onTap());
          setState(() {});
        },
        child: SizedBox(
          height: 30,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Align(
              alignment: .centerStart,
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: .w400,
                  fontSize: 12,
                  color: colors.centerChannelBg,
                ),
              ),
            ),
          ),
        ),
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
                  style: const TextStyle(color: Colors.white54, fontSize: 11),
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
  // Widget _buildCategoryGroup({
  //   required String title,
  //   required IconData categoryIcon,
  //   required List<AdminConsoleSection> sections,
  //   required dynamic currentUser,
  //   required ConsoleAccessEntity access,
  //   required Color cardBg,
  // }) {
  //   final visibleSections = sections
  //       .where((s) => _isSectionVisible(s, currentUser, access))
  //       .toList();

  //   if (visibleSections.isEmpty) return const SizedBox.shrink();

  //   final isSearching = _searchQuery.isNotEmpty;
  //   final isExpanded = isSearching || !_collapsedCategories.contains(title);
  //   final hasSelectedSection = visibleSections.contains(widget.selected);

  //   return MarginPaddingContainer(
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         InkWell(
  //           onTap: isSearching ? null : () => _toggleCategory(title),
  //           borderRadius: BorderRadius.circular(6),
  //           child: Padding(
  //             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
  //             child: Row(
  //               children: [
  //                 Icon(
  //                   isExpanded
  //                       ? Icons.keyboard_arrow_down_rounded
  //                       : Icons.keyboard_arrow_right_rounded,
  //                   color: hasSelectedSection
  //                       ? Colors.blueAccent
  //                       : Colors.white38,
  //                   size: 18,
  //                 ),
  //                 const SizedBox(width: 4),
  //                 Icon(
  //                   categoryIcon,
  //                   color: hasSelectedSection
  //                       ? Colors.blueAccent
  //                       : Colors.white54,
  //                   size: 15,
  //                 ),
  //                 const SizedBox(width: 8),
  //                 Expanded(
  //                   child: Text(
  //                     title,
  //                     style: TextStyle(
  //                       color: hasSelectedSection
  //                           ? Colors.white
  //                           : Colors.white60,
  //                       fontSize: 11,
  //                       fontWeight: FontWeight.w700,
  //                       letterSpacing: 0.7,
  //                     ),
  //                   ),
  //                 ),
  //                 Container(
  //                   padding: const EdgeInsets.symmetric(
  //                     horizontal: 6,
  //                     vertical: 2,
  //                   ),
  //                   decoration: BoxDecoration(
  //                     color: Colors.white.withValues(alpha: 0.05),
  //                     borderRadius: BorderRadius.circular(10),
  //                   ),
  //                   child: Text(
  //                     '${visibleSections.length}',
  //                     style: const TextStyle(
  //                       color: Colors.white38,
  //                       fontSize: 10,
  //                       fontWeight: FontWeight.w600,
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),

  //         // العناصر الفرعية
  //         if (isExpanded)
  //           Padding(
  //             padding: const EdgeInsets.only(top: 2, bottom: 4),
  //             child: Column(
  //               children: visibleSections
  //                   .map((section) => _buildItem(section))
  //                   .toList(),
  //             ),
  //           ),
  //       ],
  //     ),
  //   );
  // }

  /// عنصر قسم فردي داخل التصنيف
  // Widget _buildItem(AdminConsoleSection section) {
  //   final isSelected = widget.selected == section;

  //   return Container(
  //     margin: const EdgeInsets.only(bottom: 2),
  //     // child: Material(
  //     //   color: Colors.transparent,
  //     //   borderRadius: BorderRadius.circular(6),
  //     //   child: InkWell(
  //     //     onTap: () => widget.onSelected(section),
  //     //     borderRadius: BorderRadius.circular(6),
  //     //     hoverColor: Colors.white.withValues(alpha: 0.04),
  //     //     child: AnimatedContainer(
  //     //       duration: const Duration(milliseconds: 150),
  //     //       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
  //     //       decoration: BoxDecoration(
  //     //         color: isSelected
  //     //             ? Colors.blueAccent.withValues(alpha: 0.15)
  //     //             : Colors.transparent,
  //     //         borderRadius: BorderRadius.circular(6),
  //     //       ),
  //     //       child: Row(
  //     //         children: [
  //     //           // الشريط النشط الأزرق الجانبي
  //     //           AnimatedContainer(
  //     //             duration: const Duration(milliseconds: 150),
  //     //             width: 3.5,
  //     //             height: 16,
  //     //             decoration: BoxDecoration(
  //     //               color: isSelected ? Colors.blueAccent : Colors.transparent,
  //     //               borderRadius: BorderRadius.circular(2),
  //     //             ),
  //     //           ),
  //     //           const SizedBox(width: 8),
  //     //           Icon(
  //     //             section.icon,
  //     //             color: isSelected ? Colors.blueAccent : Colors.white54,
  //     //             size: 16,
  //     //           ),
  //     //           const SizedBox(width: 10),
  //     //           Expanded(
  //     //             child: Text(
  //     //               section.title,
  //     //               style: TextStyle(
  //     //                 color: isSelected ? Colors.white : Colors.white70,
  //     //                 fontSize: 12.5,
  //     //                 fontWeight: isSelected
  //     //                     ? FontWeight.w600
  //     //                     : FontWeight.w400,
  //     //               ),
  //     //               overflow: TextOverflow.ellipsis,
  //     //             ),
  //     //           ),
  //     //           if (section.isEnterprise)
  //     //             Container(
  //     //               margin: const EdgeInsets.only(left: 4),
  //     //               padding: const EdgeInsets.symmetric(
  //     //                 horizontal: 5,
  //     //                 vertical: 1.5,
  //     //               ),
  //     //               decoration: BoxDecoration(
  //     //                 color: Colors.purpleAccent.withValues(alpha: 0.18),
  //     //                 border: Border.all(
  //     //                   color: Colors.purpleAccent.withValues(alpha: 0.4),
  //     //                   width: 0.8,
  //     //                 ),
  //     //                 borderRadius: BorderRadius.circular(4),
  //     //               ),
  //     //               child: const Text(
  //     //                 'ENT',
  //     //                 style: TextStyle(
  //     //                   color: Colors.purpleAccent,
  //     //                   fontSize: 8.5,
  //     //                   fontWeight: FontWeight.bold,
  //     //                   letterSpacing: 0.5,
  //     //                 ),
  //     //               ),
  //     //             ),
  //     //         ],
  //     //       ),
  //     //     ),
  //     //   ),
  //     // ),
  //   );
  // }

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

  // bool _isSectionVisible(
  //   AdminConsoleSection section,
  //   dynamic currentUser,
  //   ConsoleAccessEntity access,
  // ) {
  //   if (AdminAccessGuard.isSectionHidden(
  //     resourceKey: section.resourceKey,
  //     currentUser: currentUser,
  //     access: access,
  //     requiresEnterprise: section.isEnterprise,
  //   )) {
  //     return false;
  //   }
  //   if (_searchQuery.isEmpty) return true;
  //   return section.title.toLowerCase().contains(_searchQuery);
  // }

  // bool _hasMatchingSections(
  //   List<AdminConsoleSection> sections,
  //   dynamic currentUser,
  //   ConsoleAccessEntity access,
  // ) {
  //   return sections.any((s) => _isSectionVisible(s, currentUser, access));
  // }
}

/// ويدجت تغليف الهامش والحاوية
class MarginPaddingContainer extends StatelessWidget {
  final Widget child;

  const MarginPaddingContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.only(bottom: 6), child: child);
  }
}
