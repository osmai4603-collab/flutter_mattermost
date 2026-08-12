// Copyright (c) 2015-present Mattermost, Inc. All Rights Reserved.
// See LICENSE.txt for license information.

// All image asset names are mirrored from webapp/channels/src/images
// (excluding the individual emoji folder, which is served at runtime).

/// Central registry of every image asset bundled with the app.
/// Paths are usable directly with [Image.asset], [AssetImage] or
/// [SvgPicture.asset].
sealed class ImageAssets {
  ImageAssets._();

  static const String _base = 'assets/images/';

  static const String customizeYourExperience =
      '${_base}Customize-Your-Experience.gif';
  static const String adminOnboardingBackground =
      '${_base}admin-onboarding-background.jpg';
  static const String airGappedContactUsImage =
      '${_base}air_gapped_contact_us_image.png';
  static const String alert = '${_base}alert.svg';
  static const String appIcons = '${_base}appIcons.png';
  static const String botDefaultIcon = '${_base}bot_default_icon.png';
  static const String cAvatar = '${_base}c_avatar.png';
  static const String cDownload = '${_base}c_download.png';
  static const String cSocket = '${_base}c_socket.png';
  static const String channelIcon = '${_base}channel_icon.png';
  static const String channelsAndDirectTourTip =
      '${_base}channels_and_direct_tour_tip.svg';
  static const String cloudLaptopError = '${_base}cloud-laptop-error.png';
  static const String cloudLaptopWarning = '${_base}cloud-laptop-warning.png';
  static const String cloudLaptop = '${_base}cloud-laptop.png';
  static const String cloudUpgradePersonHandToFace =
      '${_base}cloud-upgrade-person-hand-to-face.png';
  static const String completed = '${_base}completed.svg';
  static const String fileOverlay = '${_base}fileOverlay.svg';
  static const String forgotPasswordIllustration =
      '${_base}forgot_password_illustration.png';
  static const String groupsAvatar = '${_base}groups-avatar.png';
  static const String icon50x50 = '${_base}icon50x50.png';
  static const String icon64x64 = '${_base}icon64x64.png';
  static const String imgTrans = '${_base}img_trans.gif';
  static const String incomingWebhook = '${_base}incoming_webhook.jpg';
  static const String inviteIllustration = '${_base}invite_illustration.png';
  static const String licenseIllustration = '${_base}license_illustration.png';
  static const String logoEmail = '${_base}logo-email.png';
  static const String logo = '${_base}logo.png';
  static const String logoSvg = '${_base}logo.svg';
  static const String logoWhite = '${_base}logoWhite.png';
  static const String logoEmailBlue = '${_base}logo_email_blue.png';
  static const String logoEmailDark = '${_base}logo_email_dark.png';
  static const String logoEmailGray = '${_base}logo_email_gray.png';
  static const String marketplaceNoticeBackground =
      '${_base}marketplace-notice-background.jpg';
  static const String oauthIcon = '${_base}oauth_icon.png';
  static const String outgoingOauthConnection =
      '${_base}outgoing_oauth_connection.png';
  static const String outgoingWebhook = '${_base}outgoing_webhook.jpg';
  static const String paymentProcessing = '${_base}payment_processing.png';
  static const String privateCloudImage = '${_base}private-cloud-image.svg';
  static const String purchaseAlert = '${_base}purchase_alert.png';
  static const String slashCommandIcon = '${_base}slash_command_icon.jpg';
  static const String spinner48x48Blue = '${_base}spinner-48x48-blue.apng';
  static const String statusGreen = '${_base}status_green.png';
  static const String statusRed = '${_base}status_red.png';
  static const String statusYellow = '${_base}status_yellow.png';
  static const String webhookIcon = '${_base}webhook_icon.jpg';
  static const String welcomeIllustrationNew =
      '${_base}welcome_illustration_new.png';
  static const String iconsAudio = '${_base}icons/audio.svg';
  static const String iconsBrokenImage = '${_base}icons/brokenimage.png';
  static const String iconsCheckCircleOutline =
      '${_base}icons/check-circle-outline.svg';
  static const String iconsCode = '${_base}icons/code.svg';
  static const String iconsConfluence = '${_base}icons/confluence.svg';
  static const String iconsExcel = '${_base}icons/excel.svg';
  static const String iconsGeneric = '${_base}icons/generic.svg';
  static const String iconsGiphy = '${_base}icons/giphy.svg';
  static const String iconsImage = '${_base}icons/image.svg';
  static const String iconsPagerDuty = '${_base}icons/pager-duty.svg';
  static const String iconsPatch = '${_base}icons/patch.svg';
  static const String iconsPdf = '${_base}icons/pdf.svg';
  static const String iconsPpt = '${_base}icons/ppt.svg';
  static const String iconsRoundWhiteInfoIcon =
      '${_base}icons/round-white-info-icon.svg';
  static const String iconsText = '${_base}icons/text.svg';
  static const String iconsVideo = '${_base}icons/video.svg';
  static const String iconsWarningIcon = '${_base}icons/warning-icon.svg';
  static const String iconsWord = '${_base}icons/word.svg';
  static const String cloudCardsAmex = '${_base}cloud/cards/amex.png';
  static const String cloudCardsDinersClub =
      '${_base}cloud/cards/dinersclub.png';
  static const String cloudCardsDiscover = '${_base}cloud/cards/discover.jpg';
  static const String cloudCardsJcb = '${_base}cloud/cards/jcb.png';
  static const String cloudCardsMastercard =
      '${_base}cloud/cards/mastercard.png';
  static const String cloudCardsVisa = '${_base}cloud/cards/visa.jpg';
  static const String faviconAndroidChrome192x192 =
      '${_base}favicon/android-chrome-192x192.png';
  static const String faviconAppleTouchIcon120x120 =
      '${_base}favicon/apple-touch-icon-120x120.png';
  static const String faviconAppleTouchIcon144x144 =
      '${_base}favicon/apple-touch-icon-144x144.png';
  static const String faviconAppleTouchIcon152x152 =
      '${_base}favicon/apple-touch-icon-152x152.png';
  static const String faviconAppleTouchIcon57x57 =
      '${_base}favicon/apple-touch-icon-57x57.png';
  static const String faviconAppleTouchIcon60x60 =
      '${_base}favicon/apple-touch-icon-60x60.png';
  static const String faviconAppleTouchIcon72x72 =
      '${_base}favicon/apple-touch-icon-72x72.png';
  static const String faviconAppleTouchIcon76x76 =
      '${_base}favicon/apple-touch-icon-76x76.png';
  static const String favicon16x16 = '${_base}favicon/favicon-16x16.png';
  static const String favicon32x32 = '${_base}favicon/favicon-32x32.png';
  static const String favicon96x96 = '${_base}favicon/favicon-96x96.png';
  static const String faviconDefault16x16 =
      '${_base}favicon/favicon-default-16x16.png';
  static const String faviconDefault24x24 =
      '${_base}favicon/favicon-default-24x24.png';
  static const String faviconDefault32x32 =
      '${_base}favicon/favicon-default-32x32.png';
  static const String faviconDefault64x64 =
      '${_base}favicon/favicon-default-64x64.png';
  static const String faviconDefault96x96 =
      '${_base}favicon/favicon-default-96x96.png';
  static const String faviconMentions16x16 =
      '${_base}favicon/favicon-mentions-16x16.png';
  static const String faviconMentions24x24 =
      '${_base}favicon/favicon-mentions-24x24.png';
  static const String faviconMentions32x32 =
      '${_base}favicon/favicon-mentions-32x32.png';
  static const String faviconMentions64x64 =
      '${_base}favicon/favicon-mentions-64x64.png';
  static const String faviconMentions96x96 =
      '${_base}favicon/favicon-mentions-96x96.png';
  static const String faviconUnread16x16 =
      '${_base}favicon/favicon-unread-16x16.png';
  static const String faviconUnread24x24 =
      '${_base}favicon/favicon-unread-24x24.png';
  static const String faviconUnread32x32 =
      '${_base}favicon/favicon-unread-32x32.png';
  static const String faviconUnread64x64 =
      '${_base}favicon/favicon-unread-64x64.png';
  static const String faviconUnread96x96 =
      '${_base}favicon/favicon-unread-96x96.png';
  static const String emojiSheetsAppleSheet =
      '${_base}emoji-sheets/apple-sheet.png';
  static const String themesCodeThemesGithub =
      '${_base}themes/code_themes/github.png';
  static const String themesCodeThemesMonokai =
      '${_base}themes/code_themes/monokai.png';
  static const String themesCodeThemesSolarizedDark =
      '${_base}themes/code_themes/solarized-dark.png';
  static const String themesCodeThemesSolarizedLight =
      '${_base}themes/code_themes/solarized-light.png';
  static const String deepLinkingDesktopImg =
      '${_base}deep-linking/deeplinking-desktop-img.png';
  static const String deepLinkingMobileImg =
      '${_base}deep-linking/deeplinking-mobile-img.png';
  static const String gifPickerPoweredByGiphyBlack =
      '${_base}gif_picker/powered-by-giphy-black.png';
  static const String gifPickerPoweredByGiphyWhite =
      '${_base}gif_picker/powered-by-giphy-white.png';
  static const String browserIconsChrome = '${_base}browser-icons/chrome.svg';
  static const String browserIconsEdge = '${_base}browser-icons/edge.svg';
  static const String browserIconsFirefox = '${_base}browser-icons/firefox.svg';
  static const String browserIconsMac = '${_base}browser-icons/mac.png';
  static const String browserIconsSafari = '${_base}browser-icons/safari.svg';
  static const String browserIconsWindows = '${_base}browser-icons/windows.svg';
  static const String openidConvertEmoticonOutline =
      '${_base}openid-convert/emoticon-outline.svg';
}
