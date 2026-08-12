import 'package:flutter/material.dart' hide LicensePage;
import 'package:flutter_mattermost/features/admin/presentation/pages/access_control_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/admin_section.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/authentication_settings_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/compliance_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/content_flagging_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/data_retention_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/general_settings_page.dart';
import 'package:flutter_mattermost/features/groups/presentation/pages/groups_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/jobs_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/license_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/notifications_settings_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/plugins_management_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/roles_schemes_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/security_settings_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/server_logs_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/shared_channels_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/system_analytics_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/users_management_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/widgets/admin_sidebar.dart';

/// AdminConsolePage: وحدة تحكم إدارية كاملة (System Console).
class AdminConsolePage extends StatefulWidget {
  const AdminConsolePage({
    super.key,
    this.initialSection = AdminConsoleSection.overview,
  });

  final AdminConsoleSection initialSection;

  @override
  State<AdminConsolePage> createState() => _AdminConsolePageState();
}

class _AdminConsolePageState extends State<AdminConsolePage> {
  late AdminConsoleSection _selectedSection;

  @override
  void initState() {
    super.initState();
    _selectedSection = widget.initialSection;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2E),
      body: Row(
        children: [
          AdminConsoleSideBar(
            selected: _selectedSection,
            onSelected: (section) => setState(() => _selectedSection = section),
          ),
          const VerticalDivider(width: 1, color: Colors.white12),
          Expanded(
            child: IndexedStack(
              index: _selectedSection.index,
              children: [
                const AdminConsoleSystemAnalyticsPage(),
                const AdminConsoleServerLogsPage(),
                const AdminConsoleSystemAnalyticsPage(),
                const AdminConsoleUsersManagementPage(),
                const AdminConsoleGeneralSettingsPage(),
                const AdminConsoleAuthenticationSettingsPage(),
                const AdminConsoleNotificationsSettingsPage(),
                AdminConsoleSecuritySettingsPage(),
                AdminConsoleCompliancePage(),
                AdminConsoleJobsPage(),
                const AdminConsoleRolesSchemesPage(),
                const AdminConsoleGroupsPage(),
                const AdminConsolePluginsManagementPage(),
                const AdminConsoleLicensePage(),
                const AdminConsoleDataRetentionPage(),
                const AdminConsoleContentFlaggingPage(),
                const AdminConsoleAccessControlPage(),
                const AdminConsoleSharedChannelsPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
