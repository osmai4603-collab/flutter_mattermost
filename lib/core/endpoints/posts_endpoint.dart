sealed class PostsEndPoint {
  PostsEndPoint._();

  static const String base = '/posts';
  static const String root = base;
  static const String ephemeral = '$base/ephemeral';
  static const String ids = '$base/ids';
  static const String idsReactions = '$base/ids/reactions';
  static const String rewrite = '$base/rewrite';
  static const String schedule = '$base/schedule';
  static String schedule2(String scheduledPostId) =>
      '$base/schedule/$scheduledPostId';
  static String scheduledTeam(String teamId) => '$base/scheduled/team/$teamId';
  static const String search = '$base/search';
  static String byPostId(String postId) => '$base/$postId';
  static String actions(String postId, String actionId) =>
      '$base/$postId/actions/$actionId';
  static String ancillaryPermissions(String postId) =>
      '$base/$postId/ancillary_permissions';
  static String burn(String postId) => '$base/$postId/burn';
  static String editHistory(String postId) => '$base/$postId/edit_history';
  static String filesInfo(String postId) => '$base/$postId/files/info';
  static String info(String postId) => '$base/$postId/info';
  static String move(String postId) => '$base/$postId/move';
  static String patch(String postId) => '$base/$postId/patch';
  static String pin(String postId) => '$base/$postId/pin';
  static String reactions(String postId) => '$base/$postId/reactions';
  static String restore(String postId, String restoreVersionId) =>
      '$base/$postId/restore/$restoreVersionId';
  static String reveal(String postId) => '$base/$postId/reveal';
  static String thread(String postId) => '$base/$postId/thread';
  static String unpin(String postId) => '$base/$postId/unpin';
}
