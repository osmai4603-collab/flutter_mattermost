sealed class SharedChannelsEndPoint {
  SharedChannelsEndPoint._();

  static const String base = '/sharedchannels';
  static const String root = base;
  static const String remotesRoot = '$base/remotes';
  static String remotesByRemoteId(String remoteId) => '$base/remotes/$remoteId';
  static String remoteInfo(String remoteId) => '$base/remote_info/$remoteId';
  static String usersCanDm(String userId, String otherUserId) =>
      '$base/users/$userId/can_dm/$otherUserId';
  static String remotes(String channelId) => '$base/$channelId/remotes';
  static String byTeamId(String teamId) => '$base/$teamId';
}
