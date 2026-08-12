/// أسماء الصلاحيات القياسية في Mattermost (من Server model/permissions).
abstract final class Permissions {
  Permissions._();

  // ==== Channel permissions ====
  static const String createPublicChannel = 'create_public_channel';
  static const String createPrivateChannel = 'create_private_channel';
  static const String deletePublicChannel = 'delete_public_channel';
  static const String deletePrivateChannel = 'delete_private_channel';
  static const String managePublicChannelMembers =
      'manage_public_channel_members';
  static const String managePrivateChannelMembers =
      'manage_private_channel_members';
  static const String managePublicChannelProperties =
      'manage_public_channel_properties';
  static const String managePrivateChannelProperties =
      'manage_private_channel_properties';
  static const String readPublicChannel = 'read_public_channel';
  static const String readPrivateChannel = 'read_private_channel';
  static const String assignPublicChannelRoles = 'assign_public_channel_roles';
  static const String assignPrivateChannelRoles =
      'assign_private_channel_roles';
  static const String convertPublicChannelToPrivate =
      'convert_public_channel_to_private';
  static const String convertPrivateChannelToPublic =
      'convert_private_channel_to_public';
  static const String archiveChannel = 'archive_channel';
  static const String unarchiveChannel = 'unarchive_channel';
  static const String createDirectChannel = 'create_direct_channel';
  static const String createGroupChannel = 'create_group_channel';
  static const String useChannelMentions = 'use_channel_mentions';
  static const String useGroupMentions = 'use_group_mentions';
  static const String manageChannelRoles = 'manage_channel_roles';
  static const String playbookPublicCreate = 'playbook_public_create';
  static const String playbookPublicManageProperties =
      'playbook_public_manage_properties';
  static const String playbookPublicManageMembers =
      'playbook_public_manage_members';
  static const String playbookPublicExport = 'playbook_public_export';
  static const String playbookPublicDelete = 'playbook_public_delete';
  static const String playbookPrivateCreate = 'playbook_private_create';
  static const String playbookPrivateManageProperties =
      'playbook_private_manage_properties';
  static const String playbookPrivateManageMembers =
      'playbook_private_manage_members';
  static const String playbookPrivateExport = 'playbook_private_export';
  static const String playbookPrivateDelete = 'playbook_private_delete';

  // ==== Team permissions ====
  static const String createTeam = 'create_team';
  static const String deletePublicTeam = 'delete_public_team';
  static const String deletePrivateTeam = 'delete_private_team';
  static const String listPublicTeams = 'list_public_teams';
  static const String listPrivateTeams = 'list_private_teams';
  static const String joinPublicTeams = 'join_public_teams';
  static const String joinPrivateTeams = 'join_private_teams';
  static const String leavePrivateTeams = 'leave_private_teams';
  static const String addUserToTeam = 'add_user_to_team';
  static const String inviteUser = 'invite_user';
  static const String inviteGuest = 'invite_guest';
  static const String promoteGuest = 'promote_guest';
  static const String demoteToGuest = 'demote_to_guest';
  static const String useCustomSlashCommands = 'use_custom_slash_commands';
  static const String manageTeam = 'manage_team';
  static const String manageTeamRoles = 'manage_team_roles';
  static const String manageOtherMembers = 'manage_other_members';
  static const String removeUserFromTeam = 'remove_user_from_team';
  static const String viewTeam = 'view_team';
  static const String viewMembers = 'view_members';
  static const String manageBots = 'manage_bots';
  static const String readBots = 'read_bots';
  static const String manageOthersBots = 'manage_others_bots';

  // ==== Post permissions ====
  static const String createPost = 'create_post';
  static const String createPostEphemeral = 'create_post_ephemeral';
  static const String editPost = 'edit_post';
  static const String deletePost = 'delete_post';
  static const String deleteOthersPosts = 'delete_others_posts';
  static const String removeOthersReactions = 'remove_others_reactions';
  static const String addReaction = 'add_reaction';
  static const String removeReaction = 'remove_reaction';
  static const String useSlashCommands = 'use_slash_commands';
  static const String createBookmark = 'create_bookmark';
  static const String editBookmark = 'edit_bookmark';
  static const String deleteBookmark = 'delete_bookmark';
  static const String viewBookmarks = 'view_bookmarks';
  static const String viewArchiveChannel = 'view_archive_channel';
  static const String restoreArchivedPosts = 'restore_archived_posts';
  static const String createScheduledPost = 'create_scheduled_post';
  static const String editScheduledPost = 'edit_scheduled_post';
  static const String deleteScheduledPost = 'delete_scheduled_post';
  static const String manageScheduledPosts = 'manage_scheduled_posts';
  static const String manageOthersScheduledPosts =
      'manage_others_scheduled_posts';

  // ==== User permissions ====
  static const String createUser = 'create_user';
  static const String editOtherUsers = 'edit_other_users';
  static const String editOthersProfileAttributes =
      'edit_others_profile_attributes';
  static const String viewOthersProfileAttributes =
      'view_others_profile_attributes';
  static const String editOwnProfileAttributes = 'edit_own_profile_attributes';
  static const String viewOwnProfileAttributes = 'view_own_profile_attributes';
  static const String manageUsers = 'manage_users';
  static const String manageSystem = 'manage_system';
  static const String manageGuestRole = 'manage_guest_role';
  static const String manageOthersTeams = 'manage_others_teams';
  static const String readOtherUsersTeams = 'read_other_users_teams';
  static const String manageCustomGroupMembers = 'manage_custom_group_members';
  static const String createCustomGroup = 'create_custom_group';
  static const String deleteCustomGroup = 'delete_custom_group';
  static const String manageCustomGroup = 'manage_custom_group';

  // ==== Integration permissions ====
  static const String manageWebhooks = 'manage_webhooks';
  static const String manageOthersWebhooks = 'manage_others_webhooks';
  static const String manageIncomingWebhooks = 'manage_incoming_webhooks';
  static const String manageOutgoingWebhooks = 'manage_outgoing_webhooks';
  static const String manageSlashCommands = 'manage_slash_commands';
  static const String manageOthersSlashCommands =
      'manage_others_slash_commands';
  static const String manageOAuth = 'manage_oauth';
  static const String manageOthersOAuth = 'manage_others_oauth';
  static const String manageOutgoingOAuthConnections =
      'manage_outgoing_oauth_connections';
  static const String manageOthersOutgoingOAuthConnections =
      'manage_others_outgoing_oauth_connections';
  static const String createBot = 'create_bot';
  static const String convertBotToUser = 'convert_bot_to_user';
  static const String convertUserToBot = 'convert_user_to_bot';
  static const String manageIntegrations = 'manage_integrations';

  // ==== System admin permissions ====
  static const String systemAdminAccess = 'system_admin_access';
  static const String manageLdap = 'manage_ldap';
  static const String manageSaml = 'manage_saml';
  static const String manageCluster = 'manage_cluster';
  static const String manageElasticsearch = 'manage_elasticsearch';
  static const String managePlugins = 'manage_plugins';
  static const String manageJobs = 'manage_jobs';
  static const String manageChannels = 'manage_channels';
  static const String manageTeams = 'manage_teams';
  static const String manageLicense = 'manage_license';
  static const String manageSite = 'manage_site';
  static const String manageTeamSettings = 'manage_team_settings';
  static const String manageCompliance = 'manage_compliance';
  static const String manageDataRetention = 'manage_data_retention';
  static const String manageBoard = 'manage_board';
  static const String manageCalls = 'manage_calls';
  static const String viewLogs = 'view_logs';
  static const String viewWebhooksLog = 'view_webhooks_log';

  // ==== SysConsole read/write permissions ====
  static const String sysconsoleReadUserManagementUsers =
      'sysconsole_read_user_management_users';
  static const String sysconsoleWriteUserManagementUsers =
      'sysconsole_write_user_management_users';
  static const String sysconsoleReadUserManagementGroups =
      'sysconsole_read_user_management_groups';
  static const String sysconsoleWriteUserManagementGroups =
      'sysconsole_write_user_management_groups';
  static const String sysconsoleReadUserManagementTeams =
      'sysconsole_read_user_management_teams';
  static const String sysconsoleWriteUserManagementTeams =
      'sysconsole_write_user_management_teams';
  static const String sysconsoleReadUserManagementChannels =
      'sysconsole_read_user_management_channels';
  static const String sysconsoleWriteUserManagementChannels =
      'sysconsole_write_user_management_channels';
  static const String sysconsoleReadUserManagementPermissions =
      'sysconsole_read_user_management_permissions';
  static const String sysconsoleWriteUserManagementPermissions =
      'sysconsole_write_user_management_permissions';
  static const String sysconsoleReadEnvironmentWebServer =
      'sysconsole_read_environment_web_server';
  static const String sysconsoleWriteEnvironmentWebServer =
      'sysconsole_write_environment_web_server';
  static const String sysconsoleReadEnvironmentDatabase =
      'sysconsole_read_environment_database';
  static const String sysconsoleWriteEnvironmentDatabase =
      'sysconsole_write_environment_database';
  static const String sysconsoleReadEnvironmentFileStorage =
      'sysconsole_read_environment_file_storage';
  static const String sysconsoleWriteEnvironmentFileStorage =
      'sysconsole_write_environment_file_storage';
  static const String sysconsoleReadEnvironmentEmail =
      'sysconsole_read_environment_email';
  static const String sysconsoleWriteEnvironmentEmail =
      'sysconsole_write_environment_email';
  static const String sysconsoleReadEnvironmentPushNotificationServer =
      'sysconsole_read_environment_push_notification_server';
  static const String sysconsoleWriteEnvironmentPushNotificationServer =
      'sysconsole_write_environment_push_notification_server';
  static const String sysconsoleReadEnvironmentSessionLengths =
      'sysconsole_read_environment_session_lengths';
  static const String sysconsoleWriteEnvironmentSessionLengths =
      'sysconsole_write_environment_session_lengths';
  static const String sysconsoleReadEnvironmentRateLimiting =
      'sysconsole_read_environment_rate_limiting';
  static const String sysconsoleWriteEnvironmentRateLimiting =
      'sysconsole_write_environment_rate_limiting';
  static const String sysconsoleReadEnvironmentLogging =
      'sysconsole_read_environment_logging';
  static const String sysconsoleWriteEnvironmentLogging =
      'sysconsole_write_environment_logging';
  static const String sysconsoleReadEnvironmentDeveloper =
      'sysconsole_read_environment_developer';
  static const String sysconsoleWriteEnvironmentDeveloper =
      'sysconsole_write_environment_developer';
  static const String sysconsoleReadSiteCustomization =
      'sysconsole_read_site_customization';
  static const String sysconsoleWriteSiteCustomization =
      'sysconsole_write_site_customization';
  static const String sysconsoleReadSiteLocalization =
      'sysconsole_read_site_localization';
  static const String sysconsoleWriteSiteLocalization =
      'sysconsole_write_site_localization';
  static const String sysconsoleReadSiteUsersAndTeams =
      'sysconsole_read_site_users_and_teams';
  static const String sysconsoleWriteSiteUsersAndTeams =
      'sysconsole_write_site_users_and_teams';
  static const String sysconsoleReadSiteNotifications =
      'sysconsole_read_site_notifications';
  static const String sysconsoleWriteSiteNotifications =
      'sysconsole_write_site_notifications';
  static const String sysconsoleReadSiteAnnouncementBanner =
      'sysconsole_read_site_announcement_banner';
  static const String sysconsoleWriteSiteAnnouncementBanner =
      'sysconsole_write_site_announcement_banner';
  static const String sysconsoleReadSiteEmoji = 'sysconsole_read_site_emoji';
  static const String sysconsoleWriteSiteEmoji = 'sysconsole_write_site_emoji';
  static const String sysconsoleReadSitePosts = 'sysconsole_read_site_posts';
  static const String sysconsoleWriteSitePosts = 'sysconsole_write_site_posts';
  static const String sysconsoleReadSitePublicLinks =
      'sysconsole_read_site_public_links';
  static const String sysconsoleWriteSitePublicLinks =
      'sysconsole_write_site_public_links';
  static const String sysconsoleReadSiteNotificationsEmail =
      'sysconsole_read_site_notifications_email';
  static const String sysconsoleWriteSiteNotificationsEmail =
      'sysconsole_write_site_notifications_email';
  static const String sysconsoleReadSiteNotificationsPush =
      'sysconsole_read_site_notifications_push';
  static const String sysconsoleWriteSiteNotificationsPush =
      'sysconsole_write_site_notifications_push';
  static const String sysconsoleReadAuthenticationSignup =
      'sysconsole_read_authentication_signup';
  static const String sysconsoleWriteAuthenticationSignup =
      'sysconsole_write_authentication_signup';
  static const String sysconsoleReadAuthenticationEmail =
      'sysconsole_read_authentication_email';
  static const String sysconsoleWriteAuthenticationEmail =
      'sysconsole_write_authentication_email';
  static const String sysconsoleReadAuthenticationPassword =
      'sysconsole_read_authentication_password';
  static const String sysconsoleWriteAuthenticationPassword =
      'sysconsole_write_authentication_password';
  static const String sysconsoleReadAuthenticationMfa =
      'sysconsole_read_authentication_mfa';
  static const String sysconsoleWriteAuthenticationMfa =
      'sysconsole_write_authentication_mfa';
  static const String sysconsoleReadAuthenticationLdap =
      'sysconsole_read_authentication_ldap';
  static const String sysconsoleWriteAuthenticationLdap =
      'sysconsole_write_authentication_ldap';
  static const String sysconsoleReadAuthenticationSaml =
      'sysconsole_read_authentication_saml';
  static const String sysconsoleWriteAuthenticationSaml =
      'sysconsole_write_authentication_saml';
  static const String sysconsoleReadAuthenticationOpenid =
      'sysconsole_read_authentication_openid';
  static const String sysconsoleWriteAuthenticationOpenid =
      'sysconsole_write_authentication_openid';
  static const String sysconsoleReadAuthenticationGuestAccess =
      'sysconsole_read_authentication_guest_access';
  static const String sysconsoleWriteAuthenticationGuestAccess =
      'sysconsole_write_authentication_guest_access';
  static const String sysconsoleReadIntegrationsIntegrationManagement =
      'sysconsole_read_integrations_integration_management';
  static const String sysconsoleWriteIntegrationsIntegrationManagement =
      'sysconsole_write_integrations_integration_management';
  static const String sysconsoleReadIntegrationsBotAccounts =
      'sysconsole_read_integrations_bot_accounts';
  static const String sysconsoleWriteIntegrationsBotAccounts =
      'sysconsole_write_integrations_bot_accounts';
  static const String sysconsoleReadIntegrationsGif =
      'sysconsole_read_integrations_gif';
  static const String sysconsoleWriteIntegrationsGif =
      'sysconsole_write_integrations_gif';
  static const String sysconsoleReadIntegrationsCors =
      'sysconsole_read_integrations_cors';
  static const String sysconsoleWriteIntegrationsCors =
      'sysconsole_write_integrations_cors';
  static const String sysconsoleReadComplianceDataRetention =
      'sysconsole_read_compliance_data_retention';
  static const String sysconsoleWriteComplianceDataRetention =
      'sysconsole_write_compliance_data_retention';
  static const String sysconsoleReadComplianceComplianceExport =
      'sysconsole_read_compliance_compliance_export';
  static const String sysconsoleWriteComplianceComplianceExport =
      'sysconsole_write_compliance_compliance_export';
  static const String sysconsoleReadComplianceComplianceMonitoring =
      'sysconsole_read_compliance_compliance_monitoring';
  static const String sysconsoleWriteComplianceComplianceMonitoring =
      'sysconsole_write_compliance_compliance_monitoring';
  static const String sysconsoleReadComplianceCustomTermsOfService =
      'sysconsole_read_compliance_custom_terms_of_service';
  static const String sysconsoleWriteComplianceCustomTermsOfService =
      'sysconsole_write_compliance_custom_terms_of_service';
  static const String sysconsoleReadExperimentalFeatures =
      'sysconsole_read_experimental_features';
  static const String sysconsoleWriteExperimentalFeatures =
      'sysconsole_write_experimental_features';
  static const String sysconsoleReadAuthenticationGuestAccessSaml =
      'sysconsole_read_authentication_guest_access_saml';
  static const String sysconsoleWriteAuthenticationGuestAccessSaml =
      'sysconsole_write_authentication_guest_access_saml';
  static const String sysconsoleReadExperimentalLdapGroups =
      'sysconsole_read_experimental_ldap_groups';
  static const String sysconsoleWriteExperimentalLdapGroups =
      'sysconsole_write_experimental_ldap_groups';
  static const String sysconsoleReadExperimentalFeaturesFeatureFlags =
      'sysconsole_read_experimental_features_feature_flags';
  static const String sysconsoleWriteExperimentalFeaturesFeatureFlags =
      'sysconsole_write_experimental_features_feature_flags';
  static const String sysconsoleReadReporting = 'sysconsole_read_reporting';
  static const String sysconsoleWriteReporting = 'sysconsole_write_reporting';
  static const String sysconsoleReadReportingServerLogs =
      'sysconsole_read_reporting_server_logs';
  static const String sysconsoleWriteReportingServerLogs =
      'sysconsole_write_reporting_server_logs';
  static const String sysconsoleReadReportingSiteStatistics =
      'sysconsole_read_reporting_site_statistics';
  static const String sysconsoleWriteReportingSiteStatistics =
      'sysconsole_write_reporting_site_statistics';
  static const String sysconsoleReadReportingTeamStatistics =
      'sysconsole_read_reporting_team_statistics';
  static const String sysconsoleWriteReportingTeamStatistics =
      'sysconsole_write_reporting_team_statistics';
  static const String sysconsoleReadReportingServerInformation =
      'sysconsole_read_reporting_server_information';
  static const String sysconsoleWriteReportingServerInformation =
      'sysconsole_write_reporting_server_information';

  /// الأدوار المدمجة التي تملك وصولاً إدارياً كاملاً.
  static const String systemAdminRole = 'system_admin';
  static const String systemUserRole = 'system_user';
  static const String systemGuestRole = 'system_guest';
  static const String teamAdminRole = 'team_admin';
  static const String teamUserRole = 'team_user';
  static const String teamGuestRole = 'team_guest';
  static const String channelAdminRole = 'channel_admin';
  static const String channelUserRole = 'channel_user';
  static const String channelGuestRole = 'channel_guest';
}
