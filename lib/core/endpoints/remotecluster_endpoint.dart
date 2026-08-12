sealed class RemoteClusterEndPoint {
  RemoteClusterEndPoint._();

  static const String base = '/remotecluster';
  static const String root = base;
  static const String acceptInvite = '$base/accept_invite';
  static const String confirmInvite = '$base/confirm_invite';
  static const String msg = '$base/msg';
  static const String ping = '$base/ping';
  static String upload(String uploadId) => '$base/upload/$uploadId';
  static String byRemoteId(String remoteId) => '$base/$remoteId';
  static String channelsInvite(String remoteId, String channelId) =>
      '$base/$remoteId/channels/$channelId/invite';
  static String channelsUninvite(String remoteId, String channelId) =>
      '$base/$remoteId/channels/$channelId/uninvite';
  static String generateInvite(String remoteId) =>
      '$base/$remoteId/generate_invite';
  static String sharedchannelremotes(String remoteId) =>
      '$base/$remoteId/sharedchannelremotes';
  static String image(String userId) => '$base/$userId/image';
}
