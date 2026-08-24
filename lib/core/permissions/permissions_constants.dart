import 'package:flutter_mattermost/core/permissions/enums/mattermost_permission.dart';
import 'package:flutter_mattermost/core/permissions/enums/mattermost_role.dart';

export 'package:flutter_mattermost/core/permissions/enums/mattermost_permission.dart';
export 'package:flutter_mattermost/core/permissions/enums/mattermost_role.dart';

/// أسماء الصلاحيات القياسية في Mattermost (من Server model/permissions).
abstract final class Permissions {
  Permissions._();

  // ==== Channel permissions ====
  static String get createPublicChannel =>
      MMPermission.createPublicChannel.value;
  static String get createPrivateChannel =>
      MMPermission.createPrivateChannel.value;
  static String get deletePublicChannel =>
      MMPermission.deletePublicChannel.value;
  static String get deletePrivateChannel =>
      MMPermission.deletePrivateChannel.value;
  static String get managePublicChannelMembers =>
      MMPermission.managePublicChannelMembers.value;
  static String get managePrivateChannelMembers =>
      MMPermission.managePrivateChannelMembers.value;
  static String get managePublicChannelProperties =>
      MMPermission.managePublicChannelProperties.value;
  static String get managePrivateChannelProperties =>
      MMPermission.managePrivateChannelProperties.value;
  static String get readPublicChannel => MMPermission.readPublicChannel.value;
  static String get convertPublicChannelToPrivate =>
      MMPermission.convertPublicChannelToPrivate.value;
  static String get convertPrivateChannelToPublic =>
      MMPermission.convertPrivateChannelToPublic.value;
  static String get createDirectChannel =>
      MMPermission.createDirectChannel.value;
  static String get createGroupChannel => MMPermission.createGroupChannel.value;
  static String get useChannelMentions => MMPermission.useChannelMentions.value;
  static String get useGroupMentions => MMPermission.useGroupMentions.value;
  static String get manageChannelRoles => MMPermission.manageChannelRoles.value;
  static String get playbookPublicCreate =>
      MMPermission.playbookPublicCreate.value;
  static String get playbookPublicManageProperties =>
      MMPermission.playbookPublicManageProperties.value;
  static String get playbookPublicManageMembers =>
      MMPermission.playbookPublicManageMembers.value;
  static String get playbookPrivateCreate =>
      MMPermission.playbookPrivateCreate.value;
  static String get playbookPrivateManageProperties =>
      MMPermission.playbookPrivateManageProperties.value;
  static String get playbookPrivateManageMembers =>
      MMPermission.playbookPrivateManageMembers.value;

  // ==== Team permissions ====
  static String get createTeam => MMPermission.createTeam.value;
  static String get listPublicTeams => MMPermission.listPublicTeams.value;
  static String get listPrivateTeams => MMPermission.listPrivateTeams.value;
  static String get joinPublicTeams => MMPermission.joinPublicTeams.value;
  static String get joinPrivateTeams => MMPermission.joinPrivateTeams.value;
  static String get addUserToTeam => MMPermission.addUserToTeam.value;
  static String get inviteUser => MMPermission.inviteUser.value;
  static String get inviteGuest => MMPermission.inviteGuest.value;
  static String get promoteGuest => MMPermission.promoteGuest.value;
  static String get demoteToGuest => MMPermission.demoteToGuest.value;
  static String get manageTeam => MMPermission.manageTeam.value;
  static String get manageTeamRoles => MMPermission.manageTeamRoles.value;
  static String get removeUserFromTeam => MMPermission.removeUserFromTeam.value;
  static String get viewTeam => MMPermission.viewTeam.value;
  static String get viewMembers => MMPermission.viewMembers.value;
  static String get manageBots => MMPermission.manageBots.value;
  static String get readBots => MMPermission.readBots.value;
  static String get manageOthersBots => MMPermission.manageOthersBots.value;

  // ==== Post permissions ====
  static String get createPost => MMPermission.createPost.value;
  static String get createPostEphemeral =>
      MMPermission.createPostEphemeral.value;
  static String get editPost => MMPermission.editPost.value;
  static String get deletePost => MMPermission.deletePost.value;
  static String get deleteOthersPosts => MMPermission.deleteOthersPosts.value;
  static String get removeOthersReactions =>
      MMPermission.removeOthersReactions.value;
  static String get addReaction => MMPermission.addReaction.value;
  static String get removeReaction => MMPermission.removeReaction.value;
  static String get useSlashCommands => MMPermission.useSlashCommands.value;

  // ==== User permissions ====
  static String get editOtherUsers => MMPermission.editOtherUsers.value;
  static String get manageSystem => MMPermission.manageSystem.value;
  static String get readOtherUsersTeams =>
      MMPermission.readOtherUsersTeams.value;
  static String get manageCustomGroupMembers =>
      MMPermission.manageCustomGroupMembers.value;
  static String get createCustomGroup => MMPermission.createCustomGroup.value;
  static String get deleteCustomGroup => MMPermission.deleteCustomGroup.value;

  // ==== Integration permissions ====
  static String get manageWebhooks => MMPermission.manageWebhooks.value;
  static String get manageOthersWebhooks =>
      MMPermission.manageOthersWebhooks.value;
  static String get manageIncomingWebhooks =>
      MMPermission.manageIncomingWebhooks.value;
  static String get manageOutgoingWebhooks =>
      MMPermission.manageOutgoingWebhooks.value;
  static String get manageSlashCommands =>
      MMPermission.manageSlashCommands.value;
  static String get manageOthersSlashCommands =>
      MMPermission.manageOthersSlashCommands.value;
  static String get createBot => MMPermission.createBot.value;

  // ==== System admin permissions ====
  static String get manageJobs => MMPermission.manageJobs.value;

  // ==== SysConsole read/write permissions ====
  static String get sysconsoleReadUserManagementUsers =>
      MMPermission.sysconsoleReadUserManagementUsers.value;
  static String get sysconsoleWriteUserManagementUsers =>
      MMPermission.sysconsoleWriteUserManagementUsers.value;
  static String get sysconsoleReadUserManagementGroups =>
      MMPermission.sysconsoleReadUserManagementGroups.value;
  static String get sysconsoleWriteUserManagementGroups =>
      MMPermission.sysconsoleWriteUserManagementGroups.value;
  static String get sysconsoleReadUserManagementTeams =>
      MMPermission.sysconsoleReadUserManagementTeams.value;
  static String get sysconsoleWriteUserManagementTeams =>
      MMPermission.sysconsoleWriteUserManagementTeams.value;
  static String get sysconsoleReadUserManagementChannels =>
      MMPermission.sysconsoleReadUserManagementChannels.value;
  static String get sysconsoleWriteUserManagementChannels =>
      MMPermission.sysconsoleWriteUserManagementChannels.value;
  static String get sysconsoleReadUserManagementPermissions =>
      MMPermission.sysconsoleReadUserManagementPermissions.value;
  static String get sysconsoleWriteUserManagementPermissions =>
      MMPermission.sysconsoleWriteUserManagementPermissions.value;
  static String get sysconsoleReadEnvironmentWebServer =>
      MMPermission.sysconsoleReadEnvironmentWebServer.value;
  static String get sysconsoleWriteEnvironmentWebServer =>
      MMPermission.sysconsoleWriteEnvironmentWebServer.value;
  static String get sysconsoleReadEnvironmentDatabase =>
      MMPermission.sysconsoleReadEnvironmentDatabase.value;
  static String get sysconsoleWriteEnvironmentDatabase =>
      MMPermission.sysconsoleWriteEnvironmentDatabase.value;
  static String get sysconsoleReadEnvironmentFileStorage =>
      MMPermission.sysconsoleReadEnvironmentFileStorage.value;
  static String get sysconsoleWriteEnvironmentFileStorage =>
      MMPermission.sysconsoleWriteEnvironmentFileStorage.value;
  static String get sysconsoleReadEnvironmentPushNotificationServer =>
      MMPermission.sysconsoleReadEnvironmentPushNotificationServer.value;
  static String get sysconsoleWriteEnvironmentPushNotificationServer =>
      MMPermission.sysconsoleWriteEnvironmentPushNotificationServer.value;
  static String get sysconsoleReadEnvironmentSessionLengths =>
      MMPermission.sysconsoleReadEnvironmentSessionLengths.value;
  static String get sysconsoleWriteEnvironmentSessionLengths =>
      MMPermission.sysconsoleWriteEnvironmentSessionLengths.value;
  static String get sysconsoleReadEnvironmentRateLimiting =>
      MMPermission.sysconsoleReadEnvironmentRateLimiting.value;
  static String get sysconsoleWriteEnvironmentRateLimiting =>
      MMPermission.sysconsoleWriteEnvironmentRateLimiting.value;
  static String get sysconsoleReadEnvironmentLogging =>
      MMPermission.sysconsoleReadEnvironmentLogging.value;
  static String get sysconsoleWriteEnvironmentLogging =>
      MMPermission.sysconsoleWriteEnvironmentLogging.value;
  static String get sysconsoleReadEnvironmentDeveloper =>
      MMPermission.sysconsoleReadEnvironmentDeveloper.value;
  static String get sysconsoleWriteEnvironmentDeveloper =>
      MMPermission.sysconsoleWriteEnvironmentDeveloper.value;
  static String get sysconsoleReadSiteCustomization =>
      MMPermission.sysconsoleReadSiteCustomization.value;
  static String get sysconsoleWriteSiteCustomization =>
      MMPermission.sysconsoleWriteSiteCustomization.value;
  static String get sysconsoleReadSiteLocalization =>
      MMPermission.sysconsoleReadSiteLocalization.value;
  static String get sysconsoleWriteSiteLocalization =>
      MMPermission.sysconsoleWriteSiteLocalization.value;
  static String get sysconsoleReadSiteUsersAndTeams =>
      MMPermission.sysconsoleReadSiteUsersAndTeams.value;
  static String get sysconsoleWriteSiteUsersAndTeams =>
      MMPermission.sysconsoleWriteSiteUsersAndTeams.value;
  static String get sysconsoleReadSiteNotifications =>
      MMPermission.sysconsoleReadSiteNotifications.value;
  static String get sysconsoleWriteSiteNotifications =>
      MMPermission.sysconsoleWriteSiteNotifications.value;
  static String get sysconsoleReadSiteAnnouncementBanner =>
      MMPermission.sysconsoleReadSiteAnnouncementBanner.value;
  static String get sysconsoleWriteSiteAnnouncementBanner =>
      MMPermission.sysconsoleWriteSiteAnnouncementBanner.value;
  static String get sysconsoleReadSiteEmoji =>
      MMPermission.sysconsoleReadSiteEmoji.value;
  static String get sysconsoleWriteSiteEmoji =>
      MMPermission.sysconsoleWriteSiteEmoji.value;
  static String get sysconsoleReadSitePosts =>
      MMPermission.sysconsoleReadSitePosts.value;
  static String get sysconsoleWriteSitePosts =>
      MMPermission.sysconsoleWriteSitePosts.value;
  static String get sysconsoleReadSitePublicLinks =>
      MMPermission.sysconsoleReadSitePublicLinks.value;
  static String get sysconsoleWriteSitePublicLinks =>
      MMPermission.sysconsoleWriteSitePublicLinks.value;
  static String get sysconsoleReadAuthenticationSignup =>
      MMPermission.sysconsoleReadAuthenticationSignup.value;
  static String get sysconsoleWriteAuthenticationSignup =>
      MMPermission.sysconsoleWriteAuthenticationSignup.value;
  static String get sysconsoleReadAuthenticationEmail =>
      MMPermission.sysconsoleReadAuthenticationEmail.value;
  static String get sysconsoleWriteAuthenticationEmail =>
      MMPermission.sysconsoleWriteAuthenticationEmail.value;
  static String get sysconsoleReadAuthenticationPassword =>
      MMPermission.sysconsoleReadAuthenticationPassword.value;
  static String get sysconsoleWriteAuthenticationPassword =>
      MMPermission.sysconsoleWriteAuthenticationPassword.value;
  static String get sysconsoleReadAuthenticationMfa =>
      MMPermission.sysconsoleReadAuthenticationMfa.value;
  static String get sysconsoleWriteAuthenticationMfa =>
      MMPermission.sysconsoleWriteAuthenticationMfa.value;
  static String get sysconsoleReadAuthenticationLdap =>
      MMPermission.sysconsoleReadAuthenticationLdap.value;
  static String get sysconsoleWriteAuthenticationLdap =>
      MMPermission.sysconsoleWriteAuthenticationLdap.value;
  static String get sysconsoleReadAuthenticationSaml =>
      MMPermission.sysconsoleReadAuthenticationSaml.value;
  static String get sysconsoleWriteAuthenticationSaml =>
      MMPermission.sysconsoleWriteAuthenticationSaml.value;
  static String get sysconsoleReadAuthenticationOpenid =>
      MMPermission.sysconsoleReadAuthenticationOpenid.value;
  static String get sysconsoleWriteAuthenticationOpenid =>
      MMPermission.sysconsoleWriteAuthenticationOpenid.value;
  static String get sysconsoleReadAuthenticationGuestAccess =>
      MMPermission.sysconsoleReadAuthenticationGuestAccess.value;
  static String get sysconsoleWriteAuthenticationGuestAccess =>
      MMPermission.sysconsoleWriteAuthenticationGuestAccess.value;
  static String get sysconsoleReadIntegrationsIntegrationManagement =>
      MMPermission.sysconsoleReadIntegrationsIntegrationManagement.value;
  static String get sysconsoleWriteIntegrationsIntegrationManagement =>
      MMPermission.sysconsoleWriteIntegrationsIntegrationManagement.value;
  static String get sysconsoleReadIntegrationsBotAccounts =>
      MMPermission.sysconsoleReadIntegrationsBotAccounts.value;
  static String get sysconsoleWriteIntegrationsBotAccounts =>
      MMPermission.sysconsoleWriteIntegrationsBotAccounts.value;
  static String get sysconsoleReadIntegrationsGif =>
      MMPermission.sysconsoleReadIntegrationsGif.value;
  static String get sysconsoleWriteIntegrationsGif =>
      MMPermission.sysconsoleWriteIntegrationsGif.value;
  static String get sysconsoleReadIntegrationsCors =>
      MMPermission.sysconsoleReadIntegrationsCors.value;
  static String get sysconsoleWriteIntegrationsCors =>
      MMPermission.sysconsoleWriteIntegrationsCors.value;
  static String get sysconsoleReadComplianceComplianceExport =>
      MMPermission.sysconsoleReadComplianceComplianceExport.value;
  static String get sysconsoleWriteComplianceComplianceExport =>
      MMPermission.sysconsoleWriteComplianceComplianceExport.value;
  static String get sysconsoleReadComplianceComplianceMonitoring =>
      MMPermission.sysconsoleReadComplianceComplianceMonitoring.value;
  static String get sysconsoleWriteComplianceComplianceMonitoring =>
      MMPermission.sysconsoleWriteComplianceComplianceMonitoring.value;
  static String get sysconsoleReadComplianceCustomTermsOfService =>
      MMPermission.sysconsoleReadComplianceCustomTermsOfService.value;
  static String get sysconsoleWriteComplianceCustomTermsOfService =>
      MMPermission.sysconsoleWriteComplianceCustomTermsOfService.value;
  static String get sysconsoleReadExperimentalFeatures =>
      MMPermission.sysconsoleReadExperimentalFeatures.value;
  static String get sysconsoleWriteExperimentalFeatures =>
      MMPermission.sysconsoleWriteExperimentalFeatures.value;
  static String get sysconsoleReadReporting =>
      MMPermission.sysconsoleReadReporting.value;
  static String get sysconsoleWriteReporting =>
      MMPermission.sysconsoleWriteReporting.value;
  static String get sysconsoleReadReportingServerLogs =>
      MMPermission.sysconsoleReadReportingServerLogs.value;
  static String get sysconsoleWriteReportingServerLogs =>
      MMPermission.sysconsoleWriteReportingServerLogs.value;
  static String get sysconsoleReadReportingSiteStatistics =>
      MMPermission.sysconsoleReadReportingSiteStatistics.value;
  static String get sysconsoleWriteReportingSiteStatistics =>
      MMPermission.sysconsoleWriteReportingSiteStatistics.value;
  static String get sysconsoleReadReportingTeamStatistics =>
      MMPermission.sysconsoleReadReportingTeamStatistics.value;
  static String get sysconsoleWriteReportingTeamStatistics =>
      MMPermission.sysconsoleWriteReportingTeamStatistics.value;

  /// الأدوار المدمجة التي تملك وصولاً إدارياً كاملاً.
  static String get systemAdminRole => MMRole.systemAdmin.value;
  static String get systemUserRole => MMRole.systemUser.value;
  static String get systemGuestRole => MMRole.systemGuest.value;
  static String get teamAdminRole => MMRole.teamAdmin.value;
  static String get teamUserRole => MMRole.teamUser.value;
  static String get teamGuestRole => MMRole.teamGuest.value;
  static String get channelAdminRole => MMRole.channelAdmin.value;
  static String get channelUserRole => MMRole.channelUser.value;
  static String get channelGuestRole => MMRole.channelGuest.value;
}
