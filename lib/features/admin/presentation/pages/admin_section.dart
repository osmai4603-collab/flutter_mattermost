import 'package:flutter/material.dart';

/// أقسام Admin Console.
enum AdminConsoleSection {
  overview('Site Overview', Icons.insights_outlined),
  logs('Server Logs', Icons.article_outlined),
  analytics('System Analytics', Icons.bar_chart_outlined),
  usersManagement('User Management', Icons.people_outline),
  generalSettings('General Settings', Icons.tune),
  authentication('Authentication Settings', Icons.lock_outline),
  notifications('Notifications Settings', Icons.notifications_outlined),
  security('Security Settings', Icons.security_outlined),
  compliance('Compliance', Icons.policy_outlined),
  jobs('Jobs', Icons.schedule_outlined),
  rolesSchemes('Roles & Schemes', Icons.admin_panel_settings_outlined),
  groups('Groups', Icons.groups_outlined),
  pluginsManagement('Plugins Management', Icons.extension_outlined),
  license('License', Icons.workspace_premium_outlined),
  dataRetention('Data Retention', Icons.history_outlined),
  contentFlagging('Content Flagging', Icons.flag_outlined),
  accessControl('Access Control', Icons.admin_panel_settings_outlined),
  sharedChannels('Shared Channels', Icons.swap_horiz);

  final String title;
  final IconData icon;

  const AdminConsoleSection(this.title, this.icon);

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
