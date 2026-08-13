import 'package:flutter/material.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/access_control_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/authentication_settings_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/compliance_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/content_flagging_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/data_retention_page.dart';
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
import 'package:flutter_mattermost/features/admin/presentation/pages/system_analytics_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/users_management_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/widgets/admin_console_shell.dart';
import 'package:flutter_mattermost/features/groups/presentation/pages/groups_page.dart';
import 'package:go_router/go_router.dart';

sealed class AdminConsoleRoutes {
  static const String root = '/admin_console';
  static const overview = root;
  static const logs = '$root/logs';
  static const analytics = '$root/analytics';
  static const general = '$root/general';
  static const users = '$root/users';
  static const webServer = '$root/environment/web_server';
  static const database = '$root/environment/database';
  static const fileStorage = '$root/environment/file_storage';
  static const smtp = '$root/environment/smtp';
  static const authentication = '$root/authentication';
  static const notifications = '$root/notifications';
  static const security = '$root/security';
  static const compliance = '$root/compliance';
  static const jobs = '$root/jobs';
  static const roles = '$root/roles';
  static const groups = '$root/groups';
  static const plugins = '$root/plugins';
  static const license = '$root/license';
  static const dataRetention = '$root/data_retention';
  static const contentFlagging = '$root/content_flagging';
  static const accessControl = '$root/access_control';
  static const sharedChannels = '$root/shared_channels';
}

final _key = GlobalKey<StatefulNavigationShellState>();

/// مسار وحدة التحكم بالإدارة — هيكلية StatefulShell لتسهيل التنقل بين 18 قسماً.
final adminRoute = StatefulShellRoute.indexedStack(
  key: _key,
  builder: (context, state, navigationShell) {
    return AdminConsoleShell(navigationShell: navigationShell);
  },
  branches: [
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: AdminConsoleRoutes.overview,
          builder: (context, state) => const AdminConsoleSystemAnalyticsPage(),
        ),
      ],
    ),
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: AdminConsoleRoutes.logs,
          builder: (context, state) => const AdminConsoleServerLogsPage(),
        ),
      ],
    ),
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: AdminConsoleRoutes.analytics,
          builder: (context, state) => const AdminConsoleSystemAnalyticsPage(),
        ),
      ],
    ),
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: AdminConsoleRoutes.users,
          builder: (context, state) => const AdminConsoleUsersManagementPage(),
        ),
      ],
    ),
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: AdminConsoleRoutes.general,
          builder: (context, state) => const AdminConsoleGeneralSettingsPage(),
        ),
      ],
    ),
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: AdminConsoleRoutes.webServer,
          builder: (context, state) =>
              const AdminConsoleEnvironmentSettingsPage(subTab: 'web_server'),
        ),
      ],
    ),
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: AdminConsoleRoutes.database,
          builder: (context, state) =>
              const AdminConsoleEnvironmentSettingsPage(subTab: 'database'),
        ),
      ],
    ),
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: AdminConsoleRoutes.fileStorage,
          builder: (context, state) =>
              const AdminConsoleEnvironmentSettingsPage(subTab: 'file_storage'),
        ),
      ],
    ),
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: AdminConsoleRoutes.smtp,
          builder: (context, state) =>
              const AdminConsoleEnvironmentSettingsPage(subTab: 'smtp'),
        ),
      ],
    ),
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: AdminConsoleRoutes.authentication,
          builder: (context, state) =>
              const AdminConsoleAuthenticationSettingsPage(),
        ),
      ],
    ),
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: AdminConsoleRoutes.notifications,
          builder: (context, state) =>
              const AdminConsoleNotificationsSettingsPage(),
        ),
      ],
    ),
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: AdminConsoleRoutes.security,
          builder: (context, state) => const AdminConsoleSecuritySettingsPage(),
        ),
      ],
    ),
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: AdminConsoleRoutes.compliance,
          builder: (context, state) => const AdminConsoleCompliancePage(),
        ),
      ],
    ),
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: AdminConsoleRoutes.jobs,
          builder: (context, state) => const AdminConsoleJobsPage(),
        ),
      ],
    ),
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: AdminConsoleRoutes.roles,
          builder: (context, state) => const AdminConsoleRolesSchemesPage(),
        ),
      ],
    ),
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: AdminConsoleRoutes.groups,
          builder: (context, state) => const AdminConsoleGroupsPage(),
        ),
      ],
    ),
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: AdminConsoleRoutes.plugins,
          builder: (context, state) =>
              const AdminConsolePluginsManagementPage(),
        ),
      ],
    ),
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: AdminConsoleRoutes.license,
          builder: (context, state) => const AdminConsoleLicensePage(),
        ),
      ],
    ),
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: AdminConsoleRoutes.dataRetention,
          builder: (context, state) => const AdminConsoleDataRetentionPage(),
        ),
      ],
    ),
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: AdminConsoleRoutes.contentFlagging,
          builder: (context, state) => const AdminConsoleContentFlaggingPage(),
        ),
      ],
    ),
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: AdminConsoleRoutes.accessControl,
          builder: (context, state) => const AdminConsoleAccessControlPage(),
        ),
      ],
    ),
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: AdminConsoleRoutes.sharedChannels,
          builder: (context, state) => const AdminConsoleSharedChannelsPage(),
        ),
      ],
    ),
  ],
);
