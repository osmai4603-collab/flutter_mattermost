import 'package:flutter/material.dart' hide LicensePage;
import 'package:flutter_mattermost/features/admin/presentation/pages/access_control_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/admin_section.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/authentication/auth_email_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/authentication/auth_guest_access_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/authentication/auth_ldap_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/authentication/auth_mfa_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/authentication/auth_openid_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/authentication/auth_password_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/authentication/auth_saml_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/authentication/auth_signup_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/authentication_settings_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/users_management/channels_management_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/compliance_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/content_flagging_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/data_retention_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/delegated_admin_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/environment_settings_page.dart';
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
import 'package:flutter_mattermost/features/admin/presentation/pages/site_overview_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/system_analytics_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/users_management/teams_management_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/users_management/users_management_page.dart';
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
                const AdminConsoleSiteOverviewPage(),
                const AdminConsoleServerLogsPage(),
                const AdminConsoleSystemAnalyticsPage(),
                const AdminConsoleUsersManagementPage(),
                const AdminConsoleGeneralSettingsPage(),
                const AdminConsoleEnvironmentSettingsPage(subTab: 'web_server'),
                const AdminConsoleEnvironmentSettingsPage(subTab: 'database'),
                const AdminConsoleEnvironmentSettingsPage(
                  subTab: 'file_storage',
                ),
                const AdminConsoleEnvironmentSettingsPage(subTab: 'smtp'),
                const AdminConsoleAuthenticationSettingsPage(),
                const AdminConsoleAuthSignupPage(),
                const AdminConsoleAuthEmailPage(),
                const AdminConsoleAuthPasswordPage(),
                const AdminConsoleAuthMfaPage(),
                const AdminConsoleAuthLdapPage(),
                const AdminConsoleAuthSamlPage(),
                const AdminConsoleAuthOpenIdPage(),
                const AdminConsoleAuthGuestAccessPage(),
                const AdminConsoleNotificationsSettingsPage(),
                AdminConsoleSecuritySettingsPage(),
                AdminConsoleCompliancePage(),
                AdminConsoleJobsPage(),
                const AdminConsoleRolesSchemesPage(),
                const AdminConsoleGroupsPage(),
                const AdminConsoleLicensePage(),
                const AdminConsolePluginsManagementPage(),
                const AdminConsoleDataRetentionPage(),
                const AdminConsoleContentFlaggingPage(),
                const AdminConsoleAccessControlPage(),
                const AdminConsoleSharedChannelsPage(),
                const AdminConsoleTeamsManagementPage(),
                const AdminConsoleChannelsManagementPage(),
                const AdminConsoleDelegatedAdminPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
