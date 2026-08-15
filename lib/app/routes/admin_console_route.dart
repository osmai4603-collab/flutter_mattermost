import 'package:flutter_mattermost/features/admin/presentation/pages/access_control_page.dart';
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
import 'package:flutter_mattermost/features/admin/presentation/widgets/admin_console_shell.dart';
import 'package:flutter_mattermost/features/groups/presentation/pages/groups_page.dart';
import 'package:go_router/go_router.dart';

sealed class AdminConsoleRoutes {
  static const String home = '/admin_console';
  static const overview = '$home/overview';
  static const logs = '$home/logs';
  static const analytics = '$home/analytics';
  static const general = '$home/general';
  static const users = '$home/users';
  static const teams = '$home/teams';
  static const channels = '$home/channels';
  static const delegatedAdmin = '$home/delegated_admin';
  static const webServer = '$home/web_server';
  static const database = '$home/database';
  static const fileStorage = '$home/file_storage';
  static const smtp = '$home/smtp';
  static const authentication = '$home/authentication';
  static const authSignup = '$home/authentication/signup';
  static const authEmail = '$home/authentication/email';
  static const authPassword = '$home/authentication/password';
  static const authMfa = '$home/authentication/mfa';
  static const authLdap = '$home/authentication/ldap';
  static const authSaml = '$home/authentication/saml';
  static const authOpenId = '$home/authentication/openid';
  static const authGuestAccess = '$home/authentication/guest_access';
  static const notifications = '$home/notifications';
  static const security = '$home/security';
  static const compliance = '$home/compliance';
  static const jobs = '$home/jobs';
  static const roles = '$home/roles';
  static const groups = '$home/groups';
  static const plugins = '$home/plugins';
  static const license = '$home/license';
  static const dataRetention = '$home/data_retention';
  static const contentFlagging = '$home/content_flagging';
  static const accessControl = '$home/access_control';
  static const sharedChannels = '$home/shared_channels';
}

final adminConsoleRoute = ShellRoute(
  builder: (context, state, child) {
    return AdminConsoleShell(state: state, child: child);
  },
  routes: _routes,
);

final _routes = [
  GoRoute(
    path: AdminConsoleRoutes.home,
    pageBuilder: (context, state) =>
        const NoTransitionPage(child: AdminConsoleSiteOverviewPage()),
  ),
  GoRoute(
    path: AdminConsoleRoutes.overview,
    pageBuilder: (context, state) =>
        const NoTransitionPage(child: AdminConsoleSiteOverviewPage()),
  ),
  GoRoute(
    path: AdminConsoleRoutes.logs,
    pageBuilder: (context, state) =>
        const NoTransitionPage(child: AdminConsoleServerLogsPage()),
  ),
  GoRoute(
    path: AdminConsoleRoutes.analytics,
    pageBuilder: (context, state) =>
        const NoTransitionPage(child: AdminConsoleSystemAnalyticsPage()),
  ),
  GoRoute(
    path: AdminConsoleRoutes.users,
    pageBuilder: (context, state) =>
        const NoTransitionPage(child: AdminConsoleUsersManagementPage()),
  ),
  GoRoute(
    path: AdminConsoleRoutes.teams,
    pageBuilder: (context, state) =>
        const NoTransitionPage(child: AdminConsoleTeamsManagementPage()),
  ),
  GoRoute(
    path: AdminConsoleRoutes.channels,
    pageBuilder: (context, state) =>
        const NoTransitionPage(child: AdminConsoleChannelsManagementPage()),
  ),
  GoRoute(
    path: AdminConsoleRoutes.delegatedAdmin,
    pageBuilder: (context, state) =>
        const NoTransitionPage(child: AdminConsoleDelegatedAdminPage()),
  ),
  GoRoute(
    path: AdminConsoleRoutes.general,
    pageBuilder: (context, state) =>
        const NoTransitionPage(child: AdminConsoleGeneralSettingsPage()),
  ),
  GoRoute(
    path: AdminConsoleRoutes.webServer,
    pageBuilder: (context, state) => const NoTransitionPage(
      child: AdminConsoleEnvironmentSettingsPage(subTab: 'web_server'),
    ),
  ),
  GoRoute(
    path: AdminConsoleRoutes.database,
    pageBuilder: (context, state) => const NoTransitionPage(
      child: AdminConsoleEnvironmentSettingsPage(subTab: 'database'),
    ),
  ),
  GoRoute(
    path: AdminConsoleRoutes.fileStorage,
    pageBuilder: (context, state) => const NoTransitionPage(
      child: AdminConsoleEnvironmentSettingsPage(subTab: 'file_storage'),
    ),
  ),
  GoRoute(
    path: AdminConsoleRoutes.smtp,
    pageBuilder: (context, state) => const NoTransitionPage(
      child: AdminConsoleEnvironmentSettingsPage(subTab: 'smtp'),
    ),
  ),
  GoRoute(
    path: AdminConsoleRoutes.authentication,
    pageBuilder: (context, state) =>
        const NoTransitionPage(child: AdminConsoleAuthenticationSettingsPage()),
  ),
  GoRoute(
    path: AdminConsoleRoutes.authSignup,
    pageBuilder: (context, state) =>
        const NoTransitionPage(child: AdminConsoleAuthSignupPage()),
  ),
  GoRoute(
    path: AdminConsoleRoutes.authEmail,
    pageBuilder: (context, state) =>
        const NoTransitionPage(child: AdminConsoleAuthEmailPage()),
  ),
  GoRoute(
    path: AdminConsoleRoutes.authPassword,
    pageBuilder: (context, state) =>
        const NoTransitionPage(child: AdminConsoleAuthPasswordPage()),
  ),
  GoRoute(
    path: AdminConsoleRoutes.authMfa,
    pageBuilder: (context, state) =>
        const NoTransitionPage(child: AdminConsoleAuthMfaPage()),
  ),
  GoRoute(
    path: AdminConsoleRoutes.authLdap,
    pageBuilder: (context, state) =>
        const NoTransitionPage(child: AdminConsoleAuthLdapPage()),
  ),
  GoRoute(
    path: AdminConsoleRoutes.authSaml,
    pageBuilder: (context, state) =>
        const NoTransitionPage(child: AdminConsoleAuthSamlPage()),
  ),
  GoRoute(
    path: AdminConsoleRoutes.authOpenId,
    pageBuilder: (context, state) =>
        const NoTransitionPage(child: AdminConsoleAuthOpenIdPage()),
  ),
  GoRoute(
    path: AdminConsoleRoutes.authGuestAccess,
    pageBuilder: (context, state) =>
        const NoTransitionPage(child: AdminConsoleAuthGuestAccessPage()),
  ),
  GoRoute(
    path: AdminConsoleRoutes.notifications,
    pageBuilder: (context, state) =>
        const NoTransitionPage(child: AdminConsoleNotificationsSettingsPage()),
  ),
  GoRoute(
    path: AdminConsoleRoutes.security,
    pageBuilder: (context, state) =>
        const NoTransitionPage(child: AdminConsoleSecuritySettingsPage()),
  ),
  GoRoute(
    path: AdminConsoleRoutes.compliance,
    pageBuilder: (context, state) =>
        const NoTransitionPage(child: AdminConsoleCompliancePage()),
  ),
  GoRoute(
    path: AdminConsoleRoutes.jobs,
    pageBuilder: (context, state) =>
        const NoTransitionPage(child: AdminConsoleJobsPage()),
  ),
  GoRoute(
    path: AdminConsoleRoutes.roles,
    pageBuilder: (context, state) =>
        const NoTransitionPage(child: AdminConsoleRolesSchemesPage()),
  ),
  GoRoute(
    path: AdminConsoleRoutes.groups,
    pageBuilder: (context, state) =>
        const NoTransitionPage(child: AdminConsoleGroupsPage()),
  ),
  GoRoute(
    path: AdminConsoleRoutes.plugins,
    pageBuilder: (context, state) =>
        const NoTransitionPage(child: AdminConsolePluginsManagementPage()),
  ),
  GoRoute(
    path: AdminConsoleRoutes.license,
    pageBuilder: (context, state) =>
        const NoTransitionPage(child: AdminConsoleLicensePage()),
  ),
  GoRoute(
    path: AdminConsoleRoutes.dataRetention,
    pageBuilder: (context, state) =>
        const NoTransitionPage(child: AdminConsoleDataRetentionPage()),
  ),
  GoRoute(
    path: AdminConsoleRoutes.contentFlagging,
    pageBuilder: (context, state) =>
        const NoTransitionPage(child: AdminConsoleContentFlaggingPage()),
  ),
  GoRoute(
    path: AdminConsoleRoutes.accessControl,
    pageBuilder: (context, state) =>
        const NoTransitionPage(child: AdminConsoleAccessControlPage()),
  ),
  GoRoute(
    path: AdminConsoleRoutes.sharedChannels,
    pageBuilder: (context, state) =>
        const NoTransitionPage(child: AdminConsoleSharedChannelsPage()),
  ),
];
