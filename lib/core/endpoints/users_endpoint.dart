sealed class UsersEndPoint {
  UsersEndPoint._();

  static const String base = '/users';
  static const String root = '/';
  static String authData(String userId) => '$base/$userId/auth_data';
  static const String autocomplete = '$base/autocomplete';
  static const String byAuthData = '$base/auth_data';
  static const String emailVerify = '$base/email/verify';
  static const String emailVerifySend = '$base/email/verify/send';
  static String email(String email) => '$base/email/$email';
  static const String groupChannels = '$base/group_channels';
  static const String ids = '$base/ids';
  static const String invalidEmails = '$base/invalid_emails';
  static const String known = '$base/known';
  static const String login = '$base/login';
  static const String loginCws = '$base/login/cws';
  static const String loginDesktopToken = '$base/login/desktop_token';
  static const String loginOneTimeLink = '$base/login/one_time_link';
  static const String loginSsoCodeExchange = '$base/login/sso/code-exchange';
  static const String loginSwitch = '$base/login/switch';
  static const String loginType = '$base/login/type';
  static const String logout = '$base/logout';
  static const String mfaCheck = '$base/mfa';
  static const String migrateAuthLdap = '$base/migrate_auth/ldap';
  static const String migrateAuthSaml = '$base/migrate_auth/saml';
  static const String notifyAdmin = '$base/notify-admin';
  static const String passwordReset = '$base/password/reset';
  static const String passwordResetSend = '$base/password/reset/send';
  static const String search = '$base/search';
  static const String sessionsAttributesManifest =
      '$base/sessions/attributes/manifest';
  static const String sessionsDevice = '$base/sessions/device';
  static const String sessionsRevokeAll = '$base/sessions/revoke/all';
  static const String stats = '$base/stats';
  static const String statsFiltered = '$base/stats/filtered';
  static const String statusIds = '$base/status/ids';
  static const String tokens = '$base/tokens';
  static const String tokensDisable = '$base/tokens/disable';
  static const String tokensEnable = '$base/tokens/enable';
  static const String tokensNonCompliantCount =
      '$base/tokens/non_compliant/count';
  static const String tokensNonCompliantRevoke =
      '$base/tokens/non_compliant/revoke';
  static const String tokensRevoke = '$base/tokens/revoke';
  static const String tokensRotate = '$base/tokens/rotate';
  static const String tokensSearch = '$base/tokens/search';
  static String tokens2(String tokenId) => '$base/tokens/$tokenId';
  static const String triggerNotifyAdminPosts =
      '$base/trigger-notify-admin-posts';
  static String username(String username) => '$base/username/$username';
  static const String usernames = '$base/usernames';
  static String byUserId(String userId) => '$base/$userId';
  static String active(String userId) => '$base/$userId/active';
  static String audits(String userId) => '$base/$userId/audits';
  static String auth(String userId) => '$base/$userId/auth';
  static String channelJoinRequests(String userId) =>
      '$base/$userId/channel_join_requests';
  static String channelMembers(String userId) =>
      '$base/$userId/channel_members';
  static String channels(String userId) => '$base/$userId/channels';
  static String channelsDrafts(String userId, String channelId) =>
      '$base/$userId/channels/$channelId/drafts';
  static String channelsDrafts2(
    String userId,
    String channelId,
    String threadId,
  ) => '$base/$userId/channels/$channelId/drafts/$threadId';
  static String channelsPostsUnread(String userId, String channelId) =>
      '$base/$userId/channels/$channelId/posts/unread';
  static String channelsUnread(String userId, String channelId) =>
      '$base/$userId/channels/$channelId/unread';
  static String convertToBot(String userId) => '$base/$userId/convert_to_bot';
  static String customProfileAttributes(String userId) =>
      '$base/$userId/custom_profile_attributes';
  static String dataRetentionChannelPolicies(String userId) =>
      '$base/$userId/data_retention/channel_policies';
  static String dataRetentionTeamPolicies(String userId) =>
      '$base/$userId/data_retention/team_policies';
  static String demote(String userId) => '$base/$userId/demote';
  static String emailVerifyMember(String userId) =>
      '$base/$userId/email/verify/member';
  static String groups(String userId) => '$base/$userId/groups';
  static String image(String userId) => '$base/$userId/image';
  static String imageDefault(String userId) => '$base/$userId/image/default';
  static String mfa(String userId) => '$base/$userId/mfa';
  static String mfaGenerate(String userId) => '$base/$userId/mfa/generate';
  static String oauthAppsAuthorized(String userId) =>
      '$base/$userId/oauth/apps/authorized';
  static String password(String userId) => '$base/$userId/password';
  static String patch(String userId) => '$base/$userId/patch';
  static String postsFlagged(String userId) => '$base/$userId/posts/flagged';
  static String postFlag(String userId, String postId) =>
      '$base/$userId/posts/$postId/flag';
  static String postsAck(String userId, String postId) =>
      '$base/$userId/posts/$postId/ack';
  static String postsReactions(
    String userId,
    String postId,
    String emojiName,
  ) => '$base/$userId/posts/$postId/reactions/$emojiName';
  static String postsReminder(String userId, String postId) =>
      '$base/$userId/posts/$postId/reminder';
  static String postsSetUnread(String userId, String postId) =>
      '$base/$userId/posts/$postId/set_unread';
  static String preferences(String userId) => '$base/$userId/preferences';
  static String preferencesDelete(String userId) =>
      '$base/$userId/preferences/delete';
  static String preferences2(String userId, String category) =>
      '$base/$userId/preferences/$category';
  static String preferencesName(
    String userId,
    String category,
    String preferenceName,
  ) => '$base/$userId/preferences/$category/name/$preferenceName';
  static String promote(String userId) => '$base/$userId/promote';
  static String resetFailedAttempts(String userId) =>
      '$base/$userId/reset_failed_attempts';
  static String roles(String userId) => '$base/$userId/roles';
  static String sessions(String userId) => '$base/$userId/sessions';
  static String sessionsRevoke(String userId) =>
      '$base/$userId/sessions/revoke';
  static String sessionsRevokeAll2(String userId) =>
      '$base/$userId/sessions/revoke/all';
  static String status(String userId) => '$base/$userId/status';
  static String statusCustom(String userId) => '$base/$userId/status/custom';
  static String statusCustomRecent(String userId) =>
      '$base/$userId/status/custom/recent';
  static String statusCustomRecentDelete(String userId) =>
      '$base/$userId/status/custom/recent/delete';
  static String teams(String userId) => '$base/$userId/teams';
  static String teamsMembers(String userId) => '$base/$userId/teams/members';
  static String teamsUnread(String userId) => '$base/$userId/teams/unread';
  static String teamsChannels(String userId, String teamId) =>
      '$base/$userId/teams/$teamId/channels';
  static String teamsChannelsCategories(String userId, String teamId) =>
      '$base/$userId/teams/$teamId/channels/categories';
  static String teamsChannelsCategoriesOrder(String userId, String teamId) =>
      '$base/$userId/teams/$teamId/channels/categories/order';
  static String teamsChannelsCategories2(
    String userId,
    String teamId,
    String categoryId,
  ) => '$base/$userId/teams/$teamId/channels/categories/$categoryId';
  static String teamsChannelsMembers(String userId, String teamId) =>
      '$base/$userId/teams/$teamId/channels/members';
  static String teamsDrafts(String userId, String teamId) =>
      '$base/$userId/teams/$teamId/drafts';
  static String teamsRead(String userId, String teamId) =>
      '$base/$userId/teams/$teamId/read';
  static String teamsThreads(String userId, String teamId) =>
      '$base/$userId/teams/$teamId/threads';
  static String teamsThreadsRead(String userId, String teamId) =>
      '$base/$userId/teams/$teamId/threads/read';
  static String teamsThreads2(String userId, String teamId, String threadId) =>
      '$base/$userId/teams/$teamId/threads/$threadId';
  static String teamsThreadsFollowing(
    String userId,
    String teamId,
    String threadId,
  ) => '$base/$userId/teams/$teamId/threads/$threadId/following';
  static String teamsThreadsRead2(
    String userId,
    String teamId,
    String threadId,
    String timestamp,
  ) => '$base/$userId/teams/$teamId/threads/$threadId/read/$timestamp';
  static String teamsThreadsSetUnread(
    String userId,
    String teamId,
    String threadId,
    String postId,
  ) => '$base/$userId/teams/$teamId/threads/$threadId/set_unread/$postId';
  static String teamsUnread2(String userId, String teamId) =>
      '$base/$userId/teams/$teamId/unread';
  static String termsOfService(String userId) =>
      '$base/$userId/terms_of_service';
  static String tokens3(String userId) => '$base/$userId/tokens';
  static String typing(String userId) => '$base/$userId/typing';
  static String uploads(String userId) => '$base/$userId/uploads';
}
