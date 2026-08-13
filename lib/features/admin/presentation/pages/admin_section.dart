import 'package:flutter/material.dart';
import 'package:flutter_mattermost/features/admin/domain/entities/resource_keys.dart';

/// أقسام Admin Console.
enum AdminConsoleSection {
  overview(
    'Site Overview',
    Icons.insights_outlined,
    ResourceKeys.siteStatistics,
  ),
  logs('Server Logs', Icons.article_outlined, ResourceKeys.serverLogs),
  analytics(
    'System Analytics',
    Icons.bar_chart_outlined,
    ResourceKeys.siteStatistics,
  ),
  usersManagement('User Management', Icons.people_outline, ResourceKeys.users),
  generalSettings('General Settings', Icons.tune, ResourceKeys.customization),
  webServer('Web Server', Icons.dns_outlined, ResourceKeys.webServer),
  database('Database', Icons.storage_outlined, ResourceKeys.database),
  fileStorage('File Storage', Icons.folder_outlined, ResourceKeys.fileStorage),
  smtp('SMTP Email', Icons.email_outlined, ResourceKeys.smtp),
  authentication(
    'Authentication Settings',
    Icons.lock_outline,
    ResourceKeys.signup,
  ),
  notifications(
    'Notifications Settings',
    Icons.notifications_outlined,
    ResourceKeys.notifications,
  ),
  security('Security Settings', Icons.security_outlined, ResourceKeys.password),
  compliance(
    'Compliance',
    Icons.policy_outlined,
    ResourceKeys.complianceExport,
  ),
  jobs('Jobs', Icons.schedule_outlined, ResourceKeys.serverLogs),
  rolesSchemes(
    'Roles & Schemes',
    Icons.admin_panel_settings_outlined,
    ResourceKeys.permissions,
  ),
  groups(
    'Groups',
    Icons.groups_outlined,
    ResourceKeys.groups,
    isEnterprise: true,
  ),
  license(
    'License',
    Icons.workspace_premium_outlined,
    ResourceKeys.editionAndLicense,
  ),
  pluginsManagement(
    'Plugins Management',
    Icons.extension_outlined,
    ResourceKeys.pluginManagement,
  ),
  dataRetention(
    'Data Retention',
    Icons.history_outlined,
    ResourceKeys.dataRetentionPolicy,
    isEnterprise: true,
  ),
  contentFlagging(
    'Content Flagging',
    Icons.flag_outlined,
    ResourceKeys.complianceExport,
    isEnterprise: true,
  ),
  accessControl(
    'Access Control',
    Icons.admin_panel_settings_outlined,
    ResourceKeys.permissions,
    isEnterprise: true,
  ),
  sharedChannels(
    'Shared Channels',
    Icons.swap_horiz,
    ResourceKeys.channels,
    isEnterprise: true,
  );

  final String title;
  final IconData icon;
  final String resourceKey;
  final bool isEnterprise;

  const AdminConsoleSection(
    this.title,
    this.icon,
    this.resourceKey, {
    this.isEnterprise = false,
  });

  /// مجموعة الأقسام كما تظهر في القائمة الجانبية.
  static const List<(String, List<AdminConsoleSection>)> sectionsGroup = [
    (
      'Site Stats & Logs',
      [
        AdminConsoleSection.overview,
        AdminConsoleSection.logs,
        AdminConsoleSection.analytics,
        AdminConsoleSection.usersManagement,
      ],
    ),
    (
      'Site Configuration',
      [
        AdminConsoleSection.generalSettings,
        AdminConsoleSection.authentication,
        AdminConsoleSection.notifications,
      ],
    ),
    (
      'Environment',
      [
        AdminConsoleSection.webServer,
        AdminConsoleSection.database,
        AdminConsoleSection.fileStorage,
        AdminConsoleSection.smtp,
      ],
    ),
    (
      'Security & Compliance',
      [
        AdminConsoleSection.security,
        AdminConsoleSection.compliance,
        AdminConsoleSection.jobs,
        AdminConsoleSection.rolesSchemes,
      ],
    ),
    ('Plugins', [AdminConsoleSection.pluginsManagement]),
    (
      'Enterprise',
      [
        AdminConsoleSection.groups,
        AdminConsoleSection.license,
        AdminConsoleSection.dataRetention,
        AdminConsoleSection.contentFlagging,
        AdminConsoleSection.accessControl,
        AdminConsoleSection.sharedChannels,
      ],
    ),
  ];
}
