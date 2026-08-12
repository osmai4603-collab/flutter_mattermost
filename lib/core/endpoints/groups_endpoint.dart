sealed class GroupsEndPoint {
  GroupsEndPoint._();

  static const String base = '/groups';
  static const String root = base;
  static const String names = '$base/names';
  static String byGroupId(String groupId) => '$base/$groupId';
  static String members(String groupId) => '$base/$groupId/members';
  static String patch(String groupId) => '$base/$groupId/patch';
  static String restore(String groupId) => '$base/$groupId/restore';
  static String stats(String groupId) => '$base/$groupId/stats';
  static String byGroupIdSyncableType(String groupId, String syncableType) =>
      '$base/$groupId/$syncableType';
  static String syncables(String groupId, String syncableType) =>
      '$base/$groupId/${syncableType}s';
  static String byGroupIdSyncableTypeSyncableId(
    String groupId,
    String syncableType,
    String syncableId,
  ) => '$base/$groupId/${syncableType}s/$syncableId';
  static String link(String groupId, String syncableType, String syncableId) =>
      '$base/$groupId/${syncableType}s/$syncableId/link';
  static String patch2(
    String groupId,
    String syncableType,
    String syncableId,
  ) => '$base/$groupId/${syncableType}s/$syncableId/patch';
  static String channelSyncable(String groupId, String channelId) =>
      '$base/$groupId/channels/$channelId';
  static String teamSyncable(String groupId, String teamId) =>
      '$base/$groupId/teams/$teamId';
  static String channelLink(String groupId, String channelId) =>
      '$base/$groupId/channels/$channelId/link';
  static String teamLink(String groupId, String teamId) =>
      '$base/$groupId/teams/$teamId/link';
  static String channelPatch(String groupId, String channelId) =>
      '$base/$groupId/channels/$channelId/patch';
  static String teamPatch(String groupId, String teamId) =>
      '$base/$groupId/teams/$teamId/patch';
}
