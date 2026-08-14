import 'package:flutter/material.dart';
import 'package:flutter_mattermost/features/admin/domain/entities/resource_keys.dart';

/// أقسام Admin Console.
enum AdminConsoleSection {
  overview(
    'Site Overview',
    Icons.insights_outlined,
    ResourceKeys.siteStatistics,
    'overview',
  ),
  logs('Server Logs', Icons.article_outlined, ResourceKeys.serverLogs, 'logs'),
  analytics(
    'System Analytics',
    Icons.bar_chart_outlined,
    ResourceKeys.siteStatistics,
    'analytics',
  ),
  usersManagement(
    'User Management',
    Icons.people_outline,
    ResourceKeys.users,
    'users',
  ),
  generalSettings(
    'General Settings',
    Icons.tune,
    ResourceKeys.customization,
    'general',
  ),
  webServer(
    'Web Server',
    Icons.dns_outlined,
    ResourceKeys.webServer,
    'web_server',
  ),
  database(
    'Database',
    Icons.storage_outlined,
    ResourceKeys.database,
    'database',
  ),
  fileStorage(
    'File Storage',
    Icons.folder_outlined,
    ResourceKeys.fileStorage,
    'file_storage',
  ),
  smtp('SMTP Email', Icons.email_outlined, ResourceKeys.smtp, 'smtp'),
  authentication(
    'Authentication Settings',
    Icons.lock_outline,
    ResourceKeys.signup,
    'authentication',
  ),
  authSignup(
    'Signup',
    Icons.person_add_outlined,
    ResourceKeys.signup,
    'authentication/signup',
  ),
  authEmail(
    'Email',
    Icons.alternate_email_rounded,
    ResourceKeys.signup,
    'authentication/email',
  ),
  authPassword(
    'Password',
    Icons.password_rounded,
    ResourceKeys.password,
    'authentication/password',
  ),
  authMfa(
    'MFA',
    Icons.vibration_rounded,
    ResourceKeys.signup,
    'authentication/mfa',
  ),
  authLdap(
    'AD/LDAP',
    Icons.badge_outlined,
    ResourceKeys.signup,
    'authentication/ldap',
    isEnterprise: true,
  ),
  authSaml(
    'SAML 2.0',
    Icons.key_outlined,
    ResourceKeys.signup,
    'authentication/saml',
    isEnterprise: true,
  ),
  authOpenId(
    'OpenID Connect / OAuth 2.0',
    Icons.integration_instructions_outlined,
    ResourceKeys.signup,
    'authentication/openid',
    isEnterprise: true,
  ),
  authGuestAccess(
    'Guest Access',
    Icons.people_outline_rounded,
    ResourceKeys.signup,
    'authentication/guest_access',
    isEnterprise: true,
  ),
  notifications(
    'Notifications Settings',
    Icons.notifications_outlined,
    ResourceKeys.notifications,
    'notifications',
  ),
  security(
    'Security Settings',
    Icons.security_outlined,
    ResourceKeys.password,
    'security',
  ),
  compliance(
    'Compliance',
    Icons.policy_outlined,
    ResourceKeys.complianceExport,
    'compliance',
  ),
  jobs('Jobs', Icons.schedule_outlined, ResourceKeys.serverLogs, 'jobs'),
  rolesSchemes(
    'Roles & Schemes',
    Icons.admin_panel_settings_outlined,
    ResourceKeys.permissions,
    'roles',
  ),
  groups(
    'Groups',
    Icons.groups_outlined,
    ResourceKeys.groups,
    'groups',
    isEnterprise: true,
  ),
  license(
    'License',
    Icons.workspace_premium_outlined,
    ResourceKeys.editionAndLicense,
    'license',
  ),
  pluginsManagement(
    'Plugins Management',
    Icons.extension_outlined,
    ResourceKeys.pluginManagement,
    'plugins',
  ),
  dataRetention(
    'Data Retention',
    Icons.history_outlined,
    ResourceKeys.dataRetentionPolicy,
    'data_retention',
    isEnterprise: true,
  ),
  contentFlagging(
    'Content Flagging',
    Icons.flag_outlined,
    ResourceKeys.complianceExport,
    'content_flagging',
    isEnterprise: true,
  ),
  accessControl(
    'Access Control',
    Icons.admin_panel_settings_outlined,
    ResourceKeys.permissions,
    'access_control',
    isEnterprise: true,
  ),
  sharedChannels(
    'Shared Channels',
    Icons.swap_horiz,
    ResourceKeys.channels,
    'shared_channels',
    isEnterprise: true,
  ),
  teamsManagement(
    'Teams',
    Icons.groups_2_outlined,
    ResourceKeys.teams,
    'teams',
  ),
  channelsManagement(
    'Channels',
    Icons.forum_outlined,
    ResourceKeys.channels,
    'channels',
  ),
  delegatedAdmin(
    'Delegated Granular Administration',
    Icons.admin_panel_settings_outlined,
    ResourceKeys.permissions,
    'delegated_admin',
    isEnterprise: true,
  );

  final String title;
  final IconData icon;
  final String resourceKey;
  final bool isEnterprise;
  final String routeName;

  const AdminConsoleSection(
    this.title,
    this.icon,
    this.resourceKey,
    this.routeName, {
    this.isEnterprise = false,
  });

  /// مجموعة الأقسام والـ Categories كما تظهر في القائمة الجانبية في Mattermost.
  static const List<(String, IconData, List<AdminConsoleSection>)> sectionsGroup = [
    (
      'REPORTING',
      Icons.bar_chart_rounded,
      [
        AdminConsoleSection.overview,
        AdminConsoleSection.analytics,
        AdminConsoleSection.logs,
      ],
    ),
    (
      'USER MANAGEMENT',
      Icons.people_alt_outlined,
      [
        AdminConsoleSection.usersManagement,
        AdminConsoleSection.groups,
        AdminConsoleSection.teamsManagement,
        AdminConsoleSection.channelsManagement,
        AdminConsoleSection.rolesSchemes,
        AdminConsoleSection.delegatedAdmin,
      ],
    ),
    (
      'AUTHENTICATION',
      Icons.lock_person_outlined,
      [
        AdminConsoleSection.authSignup,
        AdminConsoleSection.authEmail,
        AdminConsoleSection.authPassword,
        AdminConsoleSection.authMfa,
        AdminConsoleSection.authLdap,
        AdminConsoleSection.authSaml,
        AdminConsoleSection.authOpenId,
        AdminConsoleSection.authGuestAccess,
      ],
    ),
    (
      'SITE CONFIGURATION',
      Icons.settings_applications_outlined,
      [
        AdminConsoleSection.generalSettings,
        AdminConsoleSection.authentication,
        AdminConsoleSection.notifications,
        AdminConsoleSection.security,
      ],
    ),
    (
      'ENVIRONMENT',
      Icons.dns_outlined,
      [
        AdminConsoleSection.webServer,
        AdminConsoleSection.database,
        AdminConsoleSection.fileStorage,
        AdminConsoleSection.smtp,
      ],
    ),
    (
      'COMPLIANCE & SECURITY',
      Icons.shield_outlined,
      [
        AdminConsoleSection.compliance,
        AdminConsoleSection.jobs,
        AdminConsoleSection.accessControl,
      ],
    ),
    (
      'PLUGINS',
      Icons.extension_outlined,
      [
        AdminConsoleSection.pluginsManagement,
      ],
    ),
    (
      'ENTERPRISE',
      Icons.workspace_premium_outlined,
      [
        AdminConsoleSection.license,
        AdminConsoleSection.dataRetention,
        AdminConsoleSection.contentFlagging,
        AdminConsoleSection.sharedChannels,
      ],
    ),
  ];
}
