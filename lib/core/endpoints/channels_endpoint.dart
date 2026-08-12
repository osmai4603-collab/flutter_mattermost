sealed class ChannelsEndPoint {
  ChannelsEndPoint._();

  static const String base = '/channels';
  static const String root = base;
  static const String direct = '$base/direct';
  static const String group = '$base/group';
  static const String groupSearch = '$base/group/search';
  static const String statsMemberCountBatch = '$base/stats/member_count';
  static String membersDirectRead(String userId) =>
      '$base/members/$userId/direct/read';
  static String membersMarkRead(String userId) =>
      '$base/members/$userId/mark_read';
  static String membersView(String userId) => '$base/members/$userId/view';
  static const String search = '$base/search';
  static String statsMemberCount(String channelId) =>
      '$base/$channelId/stats/member_count';
  static String byChannelId(String channelId) => '$base/$channelId';
  static String accessControlAttributes(String channelId) =>
      '$base/$channelId/access_control/attributes';
  static String bookmarks(String channelId) => '$base/$channelId/bookmarks';
  static String bookmarks2(String channelId, String bookmarkId) =>
      '$base/$channelId/bookmarks/$bookmarkId';
  static String bookmarksSortOrder(String channelId, String bookmarkId) =>
      '$base/$channelId/bookmarks/$bookmarkId/sort_order';
  static String commonTeams(String channelId) =>
      '$base/$channelId/common_teams';
  static String convertToChannel(String channelId) =>
      '$base/$channelId/convert_to_channel';
  static String groups(String channelId) => '$base/$channelId/groups';
  static String joinRequest(String channelId) =>
      '$base/$channelId/join_request';
  static String joinRequests(String channelId) =>
      '$base/$channelId/join_requests';
  static String joinRequestsCount(String channelId) =>
      '$base/$channelId/join_requests/count';
  static String joinRequests2(String channelId, String requestId) =>
      '$base/$channelId/join_requests/$requestId';
  static String memberCountsByGroup(String channelId) =>
      '$base/$channelId/member_counts_by_group';
  static String members(String channelId) => '$base/$channelId/members';
  static String membersIds(String channelId) => '$base/$channelId/members/ids';
  static String members2(String channelId, String userId) =>
      '$base/$channelId/members/$userId';
  static String membersAutotranslation(String channelId, String userId) =>
      '$base/$channelId/members/$userId/autotranslation';
  static String membersNotifyProps(String channelId, String userId) =>
      '$base/$channelId/members/$userId/notify_props';
  static String membersRoles(String channelId, String userId) =>
      '$base/$channelId/members/$userId/roles';
  static String membersSchemeRoles(String channelId, String userId) =>
      '$base/$channelId/members/$userId/schemeRoles';
  static String membersMinusGroupMembers(String channelId) =>
      '$base/$channelId/members_minus_group_members';
  static String moderations(String channelId) => '$base/$channelId/moderations';
  static String moderationsPatch(String channelId) =>
      '$base/$channelId/moderations/patch';
  static String move(String channelId) => '$base/$channelId/move';
  static String patch(String channelId) => '$base/$channelId/patch';
  static String pinned(String channelId) => '$base/$channelId/pinned';
  static String posts(String channelId) => '$base/$channelId/posts';
  static String typing(String channelId) => '$base/$channelId/typing';
  static String privacy(String channelId) => '$base/$channelId/privacy';
  static String restore(String channelId) => '$base/$channelId/restore';
  static String scheme(String channelId) => '$base/$channelId/scheme';
  static String stats(String channelId) => '$base/$channelId/stats';
  static String timezones(String channelId) => '$base/$channelId/timezones';
  static const String viewsBatch = '$base/views';
  static String views(String channelId) => '$base/$channelId/views';
  static String views2(String channelId, String viewId) =>
      '$base/$channelId/views/$viewId';
  static String viewsPosts(String channelId, String viewId) =>
      '$base/$channelId/views/$viewId/posts';
  static String viewsSortOrder(String channelId, String viewId) =>
      '$base/$channelId/views/$viewId/sort_order';
}
