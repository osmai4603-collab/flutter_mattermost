/// System Console Resource Keys definition for RBAC & granular admin control.
class ResourceKeys {
  ResourceKeys._();

  static const String about = 'about';
  static const String reporting = 'reporting';
  static const String userManagement = 'user_management';
  static const String environment = 'environment';
  static const String site = 'site';
  static const String authentication = 'authentication';
  static const String plugins = 'plugins';
  static const String integrations = 'integrations';
  static const String compliance = 'compliance';
  static const String experimental = 'experimental';
  static const String billing = 'billing';

  // Subsections
  static const String editionAndLicense = 'about.edition_and_license';
  static const String siteStatistics = 'reporting.site_statistics';
  static const String teamStatistics = 'reporting.team_statistics';
  static const String serverLogs = 'reporting.server_logs';

  static const String users = 'user_management.users';
  static const String groups = 'user_management.groups';
  static const String teams = 'user_management.teams';
  static const String channels = 'user_management.channels';
  static const String permissions = 'user_management.permissions';
  static const String systemRoles = 'user_management.system_roles';

  static const String webServer = 'environment.web_server';
  static const String database = 'environment.database';
  static const String elasticsearch = 'environment.elasticsearch';
  static const String fileStorage = 'environment.file_storage';
  static const String imageProxy = 'environment.image_proxy';
  static const String smtp = 'environment.smtp';
  static const String pushNotifications = 'environment.push_notifications';
  static const String highAvailability = 'environment.high_availability';
  static const String rateLimiting = 'environment.rate_limiting';
  static const String logging = 'environment.logging';
  static const String sessionLengths = 'environment.session_lengths';
  static const String performanceMonitoring = 'environment.performance_monitoring';
  static const String developer = 'environment.developer';

  static const String customization = 'site.customization';
  static const String localization = 'site.localization';
  static const String usersAndTeams = 'site.users_and_teams';
  static const String notifications = 'site.notifications';
  static const String announcement = 'site.announcement';
  static const String emoji = 'site.emoji';
  static const String posts = 'site.posts';
  static const String fileSharing = 'site.file_sharing';

  static const String signup = 'authentication.signup';
  static const String email = 'authentication.email';
  static const String password = 'authentication.password';
  static const String mfa = 'authentication.mfa';
  static const String ldap = 'authentication.ldap';
  static const String saml = 'authentication.saml';
  static const String oauth = 'authentication.oauth';
  static const String openid = 'authentication.openid';
  static const String guestAccess = 'authentication.guest_access';

  static const String pluginManagement = 'plugins.plugin_management';
  static const String integrationManagement = 'integrations.integration_management';
  static const String botAccounts = 'integrations.bot_accounts';
  static const String gif = 'integrations.gif';
  static const String cors = 'integrations.cors';

  static const String dataRetentionPolicy = 'compliance.data_retention_policy';
  static const String complianceExport = 'compliance.compliance_export';
  static const String complianceMonitoring = 'compliance.compliance_monitoring';
  static const String customTermsOfService = 'compliance.custom_terms_of_service';

  static const String experimentalFeatures = 'experimental.features';
}
