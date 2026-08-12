import 'package:flutter_mattermost/core/entities/entity.dart';

class ClientConfigEntity extends Entity {
  final String buildNumber;
  final String buildDate;
  final String buildHash;
  final String buildEnterpriseReady;
  final String version;
  final String siteUrl;
  final String serverName;
  final String teamSettingsSiteName;
  final String supportEmail;
  final String defaultLocale;
  final String termsOfServiceLink;
  final String privacyPolicyLink;
  final String maxFileSize;
  final String maxPostSize;
  final String enablePublicLink;
  final String enableLinkPreviews;
  final String enableInlineImagePreview;
  final String enablePreviewFeatures;
  final String featureScheduledPosts;
  final String featureOAuth2;
  final String featureGuestAccounts;
  final String enableCustomEmoji;
  final String enableEmojiPicker;
  final String enableIncomingWebhooks;
  final String enableOutgoingWebhooks;
  final String enableCommands;
  final String enableOnlyAdminIntegrations;
  final String enableOAuthServiceProvider;
  final String googleDeveloperKey;
  final String enableUserCreation;
  final String enableTeamCreation;
  final String enableGuestAccounts;
  final String enableChannelCreation;
  final String enableUserDeactivation;
  final String allowEditPost;
  final String enablePostUsernameOverride;
  final String enablePostIconOverride;
  final String enablePostSearch;
  final String enableLatex;
  final String enableUserStatuses;
  final String enableUserTypingMessages;
  final String enableEmailNotifications;
  final String sendEmailNotifications;
  final String emailNotificationContentsType;
  final String enableEmailBatching;
  final String pushNotificationContents;
  final String enableAutoResponder;
  final String enablePersistentNotifications;
  final String enableTutorial;
  final String experimentalTimezone;
  final String clusterName;
  final String enableWebSocket;
  final String enableCustomBrand;
  final String customBrandText;
  final String customDescriptionText;
  final String enableCustomTermsOfService;
  final String enableManagedResourceBoard;
  final String timeBetweenUserTypingUpdatesMilliseconds;
  final String enableSecurityFixAlert;

  const ClientConfigEntity({
    this.buildNumber = '',
    this.buildDate = '',
    this.buildHash = '',
    this.buildEnterpriseReady = 'false',
    this.version = '',
    this.siteUrl = '',
    this.serverName = '',
    this.teamSettingsSiteName = '',
    this.supportEmail = '',
    this.defaultLocale = '',
    this.termsOfServiceLink = '',
    this.privacyPolicyLink = '',
    this.maxFileSize = '52428800',
    this.maxPostSize = '4000',
    this.enablePublicLink = 'false',
    this.enableLinkPreviews = 'false',
    this.enableInlineImagePreview = 'false',
    this.enablePreviewFeatures = 'false',
    this.featureScheduledPosts = 'false',
    this.featureOAuth2 = 'false',
    this.featureGuestAccounts = 'false',
    this.enableCustomEmoji = 'false',
    this.enableEmojiPicker = 'false',
    this.enableIncomingWebhooks = 'false',
    this.enableOutgoingWebhooks = 'false',
    this.enableCommands = 'false',
    this.enableOnlyAdminIntegrations = 'false',
    this.enableOAuthServiceProvider = 'false',
    this.googleDeveloperKey = '',
    this.enableUserCreation = 'false',
    this.enableTeamCreation = 'false',
    this.enableGuestAccounts = 'false',
    this.enableChannelCreation = 'false',
    this.enableUserDeactivation = 'false',
    this.allowEditPost = 'false',
    this.enablePostUsernameOverride = 'false',
    this.enablePostIconOverride = 'false',
    this.enablePostSearch = 'false',
    this.enableLatex = 'false',
    this.enableUserStatuses = 'false',
    this.enableUserTypingMessages = 'false',
    this.enableEmailNotifications = 'false',
    this.sendEmailNotifications = 'false',
    this.emailNotificationContentsType = '',
    this.enableEmailBatching = 'false',
    this.pushNotificationContents = '',
    this.enableAutoResponder = 'false',
    this.enablePersistentNotifications = 'false',
    this.enableTutorial = 'false',
    this.experimentalTimezone = 'false',
    this.clusterName = '',
    this.enableWebSocket = 'false',
    this.enableCustomBrand = 'false',
    this.customBrandText = '',
    this.customDescriptionText = '',
    this.enableCustomTermsOfService = 'false',
    this.enableManagedResourceBoard = 'false',
    this.timeBetweenUserTypingUpdatesMilliseconds = '2000',
    this.enableSecurityFixAlert = 'false',
  });

  @override
  List<Object?> get props => [
        buildNumber,
        buildDate,
        buildHash,
        buildEnterpriseReady,
        version,
        siteUrl,
        serverName,
        teamSettingsSiteName,
        supportEmail,
        defaultLocale,
        termsOfServiceLink,
        privacyPolicyLink,
        maxFileSize,
        maxPostSize,
        enablePublicLink,
        enableLinkPreviews,
        enableInlineImagePreview,
        enablePreviewFeatures,
        featureScheduledPosts,
        featureOAuth2,
        featureGuestAccounts,
        enableCustomEmoji,
        enableEmojiPicker,
        enableIncomingWebhooks,
        enableOutgoingWebhooks,
        enableCommands,
        enableOnlyAdminIntegrations,
        enableOAuthServiceProvider,
        googleDeveloperKey,
        enableUserCreation,
        enableTeamCreation,
        enableGuestAccounts,
        enableChannelCreation,
        enableUserDeactivation,
        allowEditPost,
        enablePostUsernameOverride,
        enablePostIconOverride,
        enablePostSearch,
        enableLatex,
        enableUserStatuses,
        enableUserTypingMessages,
        enableEmailNotifications,
        sendEmailNotifications,
        emailNotificationContentsType,
        enableEmailBatching,
        pushNotificationContents,
        enableAutoResponder,
        enablePersistentNotifications,
        enableTutorial,
        experimentalTimezone,
        clusterName,
        enableWebSocket,
        enableCustomBrand,
        customBrandText,
        customDescriptionText,
        enableCustomTermsOfService,
        enableManagedResourceBoard,
        timeBetweenUserTypingUpdatesMilliseconds,
        enableSecurityFixAlert,
      ];

  @override
  ClientConfigEntity copyWith({
    String? buildNumber,
    String? buildDate,
    String? buildHash,
    String? buildEnterpriseReady,
    String? version,
    String? siteUrl,
    String? serverName,
    String? teamSettingsSiteName,
    String? supportEmail,
    String? defaultLocale,
    String? termsOfServiceLink,
    String? privacyPolicyLink,
    String? maxFileSize,
    String? maxPostSize,
    String? enablePublicLink,
    String? enableLinkPreviews,
    String? enableInlineImagePreview,
    String? enablePreviewFeatures,
    String? featureScheduledPosts,
    String? featureOAuth2,
    String? featureGuestAccounts,
    String? enableCustomEmoji,
    String? enableEmojiPicker,
    String? enableIncomingWebhooks,
    String? enableOutgoingWebhooks,
    String? enableCommands,
    String? enableOnlyAdminIntegrations,
    String? enableOAuthServiceProvider,
    String? googleDeveloperKey,
    String? enableUserCreation,
    String? enableTeamCreation,
    String? enableGuestAccounts,
    String? enableChannelCreation,
    String? enableUserDeactivation,
    String? allowEditPost,
    String? enablePostUsernameOverride,
    String? enablePostIconOverride,
    String? enablePostSearch,
    String? enableLatex,
    String? enableUserStatuses,
    String? enableUserTypingMessages,
    String? enableEmailNotifications,
    String? sendEmailNotifications,
    String? emailNotificationContentsType,
    String? enableEmailBatching,
    String? pushNotificationContents,
    String? enableAutoResponder,
    String? enablePersistentNotifications,
    String? enableTutorial,
    String? experimentalTimezone,
    String? clusterName,
    String? enableWebSocket,
    String? enableCustomBrand,
    String? customBrandText,
    String? customDescriptionText,
    String? enableCustomTermsOfService,
    String? enableManagedResourceBoard,
    String? timeBetweenUserTypingUpdatesMilliseconds,
    String? enableSecurityFixAlert,
  }) {
    return ClientConfigEntity(
      buildNumber: buildNumber ?? this.buildNumber,
      buildDate: buildDate ?? this.buildDate,
      buildHash: buildHash ?? this.buildHash,
      buildEnterpriseReady: buildEnterpriseReady ?? this.buildEnterpriseReady,
      version: version ?? this.version,
      siteUrl: siteUrl ?? this.siteUrl,
      serverName: serverName ?? this.serverName,
      teamSettingsSiteName: teamSettingsSiteName ?? this.teamSettingsSiteName,
      supportEmail: supportEmail ?? this.supportEmail,
      defaultLocale: defaultLocale ?? this.defaultLocale,
      termsOfServiceLink: termsOfServiceLink ?? this.termsOfServiceLink,
      privacyPolicyLink: privacyPolicyLink ?? this.privacyPolicyLink,
      maxFileSize: maxFileSize ?? this.maxFileSize,
      maxPostSize: maxPostSize ?? this.maxPostSize,
      enablePublicLink: enablePublicLink ?? this.enablePublicLink,
      enableLinkPreviews: enableLinkPreviews ?? this.enableLinkPreviews,
      enableInlineImagePreview: enableInlineImagePreview ?? this.enableInlineImagePreview,
      enablePreviewFeatures: enablePreviewFeatures ?? this.enablePreviewFeatures,
      featureScheduledPosts: featureScheduledPosts ?? this.featureScheduledPosts,
      featureOAuth2: featureOAuth2 ?? this.featureOAuth2,
      featureGuestAccounts: featureGuestAccounts ?? this.featureGuestAccounts,
      enableCustomEmoji: enableCustomEmoji ?? this.enableCustomEmoji,
      enableEmojiPicker: enableEmojiPicker ?? this.enableEmojiPicker,
      enableIncomingWebhooks: enableIncomingWebhooks ?? this.enableIncomingWebhooks,
      enableOutgoingWebhooks: enableOutgoingWebhooks ?? this.enableOutgoingWebhooks,
      enableCommands: enableCommands ?? this.enableCommands,
      enableOnlyAdminIntegrations: enableOnlyAdminIntegrations ?? this.enableOnlyAdminIntegrations,
      enableOAuthServiceProvider: enableOAuthServiceProvider ?? this.enableOAuthServiceProvider,
      googleDeveloperKey: googleDeveloperKey ?? this.googleDeveloperKey,
      enableUserCreation: enableUserCreation ?? this.enableUserCreation,
      enableTeamCreation: enableTeamCreation ?? this.enableTeamCreation,
      enableGuestAccounts: enableGuestAccounts ?? this.enableGuestAccounts,
      enableChannelCreation: enableChannelCreation ?? this.enableChannelCreation,
      enableUserDeactivation: enableUserDeactivation ?? this.enableUserDeactivation,
      allowEditPost: allowEditPost ?? this.allowEditPost,
      enablePostUsernameOverride: enablePostUsernameOverride ?? this.enablePostUsernameOverride,
      enablePostIconOverride: enablePostIconOverride ?? this.enablePostIconOverride,
      enablePostSearch: enablePostSearch ?? this.enablePostSearch,
      enableLatex: enableLatex ?? this.enableLatex,
      enableUserStatuses: enableUserStatuses ?? this.enableUserStatuses,
      enableUserTypingMessages: enableUserTypingMessages ?? this.enableUserTypingMessages,
      enableEmailNotifications: enableEmailNotifications ?? this.enableEmailNotifications,
      sendEmailNotifications: sendEmailNotifications ?? this.sendEmailNotifications,
      emailNotificationContentsType: emailNotificationContentsType ?? this.emailNotificationContentsType,
      enableEmailBatching: enableEmailBatching ?? this.enableEmailBatching,
      pushNotificationContents: pushNotificationContents ?? this.pushNotificationContents,
      enableAutoResponder: enableAutoResponder ?? this.enableAutoResponder,
      enablePersistentNotifications: enablePersistentNotifications ?? this.enablePersistentNotifications,
      enableTutorial: enableTutorial ?? this.enableTutorial,
      experimentalTimezone: experimentalTimezone ?? this.experimentalTimezone,
      clusterName: clusterName ?? this.clusterName,
      enableWebSocket: enableWebSocket ?? this.enableWebSocket,
      enableCustomBrand: enableCustomBrand ?? this.enableCustomBrand,
      customBrandText: customBrandText ?? this.customBrandText,
      customDescriptionText: customDescriptionText ?? this.customDescriptionText,
      enableCustomTermsOfService: enableCustomTermsOfService ?? this.enableCustomTermsOfService,
      enableManagedResourceBoard: enableManagedResourceBoard ?? this.enableManagedResourceBoard,
      timeBetweenUserTypingUpdatesMilliseconds: timeBetweenUserTypingUpdatesMilliseconds ?? this.timeBetweenUserTypingUpdatesMilliseconds,
      enableSecurityFixAlert: enableSecurityFixAlert ?? this.enableSecurityFixAlert,
    );
  }

  bool get isScheduledPostsEnabled => featureScheduledPosts.toLowerCase() == 'true';
  bool get isGuestAccountsEnabled => enableGuestAccounts.toLowerCase() == 'true' || featureGuestAccounts.toLowerCase() == 'true';
  int get maxFileSizeBytes => int.tryParse(maxFileSize) ?? 50 * 1024 * 1024;
}
