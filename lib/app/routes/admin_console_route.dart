import 'package:flutter/material.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/access_control_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/authentication_settings_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/compliance_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/content_flagging_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/data_retention_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/general_settings_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/jobs_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/license_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/notifications_settings_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/plugins_management_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/roles_schemes_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/security_settings_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/server_logs_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/shared_channels_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/users_management_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/widgets/admin_console_shell.dart';
import 'package:flutter_mattermost/features/groups/presentation/pages/groups_page.dart';
import 'package:go_router/go_router.dart';

sealed class AdminConsoleRoutes {
  static const String root = '/admin_console';
  static const logs = '$root/logs';
  static const users = '$root/users';
  static const general = '$root/general';
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
final adminRoute = StatefulShellRoute.indexedStack(
  key: _key,
  builder: (context, state, navigationShell) {
    return AdminConsoleShell(navigationShell: navigationShell);
  },
  
  branches: [
    StatefulShellBranch(routes: _routes),
  ],
);

final List<RouteBase> _routes = [
  GoRoute(
    path: AdminConsoleRoutes.root,
    builder: (context, state) => const AdminConsoleServerLogsPage(),
  ),
  GoRoute(
    path: AdminConsoleRoutes.logs,
    builder: (context, state) => const AdminConsoleServerLogsPage(),
  ),
  GoRoute(
    path: AdminConsoleRoutes.users,
    builder: (context, state) => const AdminConsoleUsersManagementPage(),
  ),
  GoRoute(
    path: AdminConsoleRoutes.general,
    builder: (context, state) => const AdminConsoleGeneralSettingsPage(),
  ),
  GoRoute(
    path: AdminConsoleRoutes.authentication,
    builder: (context, state) => const AdminConsoleAuthenticationSettingsPage(),
  ),
  GoRoute(
    path: AdminConsoleRoutes.notifications,
    builder: (context, state) => const AdminConsoleNotificationsSettingsPage(),
  ),
  GoRoute(
    path: AdminConsoleRoutes.security,
    builder: (context, state) => const AdminConsoleSecuritySettingsPage(),
  ),
  GoRoute(
    path: AdminConsoleRoutes.compliance,
    builder: (context, state) => const AdminConsoleCompliancePage(),
  ),
  GoRoute(
    path: AdminConsoleRoutes.jobs,
    builder: (context, state) => const AdminConsoleJobsPage(),
  ),
  GoRoute(
    path: AdminConsoleRoutes.roles,
    builder: (context, state) => const AdminConsoleRolesSchemesPage(),
  ),
  GoRoute(
    path: AdminConsoleRoutes.groups,
    builder: (context, state) => const AdminConsoleGroupsPage(),
  ),
  GoRoute(
    path: AdminConsoleRoutes.plugins,
    builder: (context, state) => const AdminConsolePluginsManagementPage(),
  ),
  GoRoute(
    path: AdminConsoleRoutes.license,
    builder: (context, state) => const AdminConsoleLicensePage(),
  ),
  GoRoute(
    path: AdminConsoleRoutes.dataRetention,
    builder: (context, state) => const AdminConsoleDataRetentionPage(),
  ),
  GoRoute(
    path: AdminConsoleRoutes.contentFlagging,
    builder: (context, state) => const AdminConsoleContentFlaggingPage(),
  ),
  GoRoute(
    path: AdminConsoleRoutes.accessControl,
    builder: (context, state) => const AdminConsoleAccessControlPage(),
  ),
  GoRoute(
    path: AdminConsoleRoutes.sharedChannels,
    builder: (context, state) => const AdminConsoleSharedChannelsPage(),
  ),
];