sealed class TeamsEndPoint {
  TeamsEndPoint._();

  static const String base = '/teams';
  static const String root = base;
  static String invite(String inviteId) => '$base/invite/$inviteId';
  static const String invitesEmail = '$base/invites/email';
  static const String membersInvite = '$base/members/invite';
  static String name(String teamName) => '$base/name/$teamName';
  static String nameChannelsName(String teamName, String channelName) =>
      '$base/name/$teamName/channels/name/$channelName';
  static String nameExists(String teamName) => '$base/name/$teamName/exists';
  static const String search = '$base/search';
  static String byTeamId(String teamId) => '$base/$teamId';
  static String accessControlAttributes(String teamId) =>
      '$base/$teamId/access_control/attributes';
  static String accessControlPolicy(String teamId) =>
      '$base/$teamId/access_control/policy';
  static String channels(String teamId) => '$base/$teamId/channels';
  static String channelsAutocomplete(String teamId) =>
      '$base/$teamId/channels/autocomplete';
  static String channelsDeleted(String teamId) =>
      '$base/$teamId/channels/deleted';
  static String channelsIds(String teamId) => '$base/$teamId/channels/ids';
  static String channelsManagedCategories(String teamId) =>
      '$base/$teamId/channels/managed_categories';
  static String channelsName(String teamId, String channelName) =>
      '$base/$teamId/channels/name/$channelName';
  static String channelsPrivate(String teamId) =>
      '$base/$teamId/channels/private';
  static String channelsRecommended(String teamId) =>
      '$base/$teamId/channels/recommended';
  static String channelsSearch(String teamId) =>
      '$base/$teamId/channels/search';
  static String channelsSearchAutocomplete(String teamId) =>
      '$base/$teamId/channels/search_autocomplete';
  static String commandsAutocomplete(String teamId) =>
      '$base/$teamId/commands/autocomplete';
  static String commandsAutocompleteSuggestions(String teamId) =>
      '$base/$teamId/commands/autocomplete_suggestions';
  static String filesSearch(String teamId) => '$base/$teamId/files/search';
  static String groups(String teamId) => '$base/$teamId/groups';
  static String groupsByChannels(String teamId) =>
      '$base/$teamId/groups_by_channels';
  static String image(String teamId) => '$base/$teamId/image';
  static String import(String teamId) => '$base/$teamId/import';
  static String inviteGuestsEmail(String teamId) =>
      '$base/$teamId/invite-guests/email';
  static String inviteEmail(String teamId) => '$base/$teamId/invite/email';
  static String members(String teamId) => '$base/$teamId/members';
  static String membersBatch(String teamId) => '$base/$teamId/members/batch';
  static String membersIds(String teamId) => '$base/$teamId/members/ids';
  static String members2(String teamId, String userId) =>
      '$base/$teamId/members/$userId';
  static String membersRoles(String teamId, String userId) =>
      '$base/$teamId/members/$userId/roles';
  static String membersSchemeroles(String teamId, String userId) =>
      '$base/$teamId/members/$userId/schemeRoles';
  static String membersNotifyProps(String teamId, String userId) =>
      '$base/$teamId/members/$userId/notify_props';
  static String membersMinusGroupMembers(String teamId) =>
      '$base/$teamId/members_minus_group_members';
  static String memberCountsByGroup(String teamId) =>
      '$base/$teamId/member_counts_by_group';
  static String timezones(String teamId) => '$base/$teamId/timezones';
  static String patch(String teamId) => '$base/$teamId/patch';
  static String postsSearch(String teamId) => '$base/$teamId/posts/search';
  static String privacy(String teamId) => '$base/$teamId/privacy';
  static String regenerateInviteId(String teamId) =>
      '$base/$teamId/regenerate_invite_id';
  static String restore(String teamId) => '$base/$teamId/restore';
  static String scheme(String teamId) => '$base/$teamId/scheme';
  static String stats(String teamId) => '$base/$teamId/stats';
}
